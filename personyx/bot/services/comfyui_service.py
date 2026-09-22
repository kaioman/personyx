import os
import json
import enum
import libcore_hng.utils.app_logger as app_logger
from dataclasses import asdict
from typing import Union, Dict, Any, List, Optional
from sqlalchemy.orm import sessionmaker, Session
from pathlib import Path
from pycorex.comfyui_client import ComfyUIClient
from pycorex.models.comfyui import ComfyUIModel
from pycorex.models.prompt import PromptContextModel
from pycorex.gemini_client import GeminiClient
from pycorex.utils.pony_prompt_generator import PonyPromptGenerator
from pycorex.utils.workflow_editor import NodeModification, WorkflowEditor
from pycorex.utils.workflow_mod import WorkflowMod

class ComfyUIService:

    def __init__(
            self, 
            gemini_client:GeminiClient,
            comfyui_config: ComfyUIModel,
            charspec_conf_path: str = "",
            db_session_factory: Optional[sessionmaker[Session]] = None,
        ):
        """
        コンストラクタ
        """

        # GeminiClientインスタンスを取得
        self.client = gemini_client

        # ComfyUI設定取得
        self.comfyui_config = comfyui_config

        # Comfyui API エンドポイントを取得
        self.comfyui_endpoint = self.comfyui_config.comfyui_endpoint
        # Comfyui API タイムアウト設定を取得
        self.timeout_seconds = self.comfyui_config.timeout_seconds
        # Comfyui API ポーリング設定を取得
        self.polling_interval = self.comfyui_config.polling_interval

        # DBセッションファクトリを取得する
        self.db_session_factory = db_session_factory

        # キャラクター仕様JSONを取得する
        self.charspec_conf = self._load_json(charspec_conf_path)
    
    def _get_workflow(self, workflow_file: str = "", workflow_path: str = ""):
        """
        ComfyUI Workflowを取得する

        Parameters
        ----------
        workflow_file : str
            ワークフローファイル名（configs/comfyui/workflow/ 配下の json ファイル）
            未指定の場合はcomfyui_config.jsonのworkflow_pathの設定値から取得
        workflow_path : str
            ワークフローファイルの絶対パス
        """

        # ワークフローパスを取得
        if workflow_path:
            comfyui_workflow_path = Path(workflow_path)
        elif workflow_file:
            comfyui_workflow_path = Path(self.comfyui_config.workflow_path).parent / workflow_file
        else:
            comfyui_workflow_path = Path(self.comfyui_config.workflow_path)
        
        # ワークフローファイル存在チェック
        if not os.path.exists(comfyui_workflow_path):
            app_logger.error(f"Workflow file not found: {comfyui_workflow_path}")
            raise FileNotFoundError(f"ワークフローファイルが見つかりません: {comfyui_workflow_path}")

        # ワークフローを読み込む
        with open(comfyui_workflow_path, "r") as f:
            workflow = json.load(f)

        return workflow

    def _load_json(self, path):

        # 指定したJSONパスを読み込んでdictで返す
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)

    def _build_missing_persona_config_message(
        self, 
        persona_name: Optional[str] = None,
        group_name: Optional[str] = None,
        user_id: Optional[str] = None) -> str:
        persona_label = persona_name or "対象のペルソナ"
        group_label = f"(グループ: {group_name}) " if group_name else ""
        user_label = f"(user_id: {user_id}) " if user_id else ""
        return (
            f"ペルソナ設定がDBに見つかりませんでした。"
            f" {persona_label}{group_label}{user_label}\n"
            "設定画面から persona_config / character_spec / asset / workflow_overrides を登録してください。\n"
            "ファイル JSON へのフォールバックは行いません。"
        )

    def _load_persona_from_db(
        self, 
        user_id: str, 
        group_name: str | None = None
        ) -> tuple[Optional[dict], Optional[str], Optional[str], Optional[str]]:
        """
        DBからペルソナ情報を取得する

        Parameters
        ----------
        user_id : str
            ユーザーID
        group_name : str | None
            グループ名

        Returns
        -------
        tuple[Optional[dict], Optional[str], Optional[str], Optional[str]]
            (ペルソナ設定, ペルソナ名, キャラクタースペック, アセット)
        """

        from web.models.personas import Personas
        from web.models.persona_character_specs import PersonaCharacterSpecs
        from web.models.persona_assets import PersonaAssets
        from web.models.persona_asset_files import PersonaAssetFiles
        from web.models.persona_workflow_overrides import PersonaWorkflowOverrides
        from web.models.bot_profiles import BotProfiles
        from web.models.bot_profile_groups import BotProfileGroups
        from web.models.user_bot_profiles import UserBotProfiles

        with self.db_session_factory() as session:

            # ユーザーのアクティブなBotProfileを取得する
            query = (
                session.query(UserBotProfiles)
                .join(UserBotProfiles.bot_profile)
                .join(BotProfiles.group)
                .filter(
                    UserBotProfiles.user_id == user_id,
                    UserBotProfiles.is_active == True,
                    BotProfiles.is_active == True,
                    BotProfileGroups.is_active == True
                )
            )

            # group_nameが指定されている場合は、BotProfileGroups.nameでフィルタリングする
            if group_name:
                query = query.filter(BotProfileGroups.name == group_name)

            # 最初のアクティブなBotProfileを取得する
            assignment = query.first()
            if assignment is None:
                return None, None, None, None

            # BotProfileを取得する
            bot_profile = assignment.bot_profile
            if not bot_profile or not bot_profile.active_persona_id:
                return None, None, None, None

            # アクティブなPersonaを取得する
            persona = (
                session.query(Personas)
                .filter_by(id=bot_profile.active_persona_id)
                .first()
            )
            if persona is None:
                return None, None, None, None

            active_persona_id = str(persona.id)
            persona_name = persona.name

            # キャラクター仕様を取得する
            character_spec = (
                session.query(PersonaCharacterSpecs)
                .filter_by(persona_id=persona.id, is_default=True)                
                .order_by(PersonaCharacterSpecs.created_at.desc())
                .first()
            )
            if character_spec is None:
                return None, None, None, None

            # アセット、アセットファイル(参考画像)、ワークフローオーバーライドを取得する
            asset_rows = (
                session.query(PersonaAssets)
                .filter_by(persona_id=persona.id)
                .all()
            )
            asset_file_rows = (
                session.query(PersonaAssetFiles)
                .filter_by(persona_id=persona.id)
                .all()
            )
            workflow_overrides = (
                session.query(PersonaWorkflowOverrides)
                .filter_by(persona_id=persona.id)
                .all()
            )

            # ペルソナ設定を構築する
            persona_conf = dict(persona.persona_config or {})
            persona_conf["persona_id"] = active_persona_id
            persona_conf["persona_name"] = persona_name
            persona_conf["character_spec"] = character_spec.config_json
            persona_conf["assets"] = [
                {
                    "asset_type": row.asset_type,
                    "asset_key": row.asset_key,
                    "payload": row.payload
                }
                for row in asset_rows
            ]
            persona_conf["asset_files"] = [
                {
                    "asset_type": row.asset_type,
                    "asset_key": row.asset_key,
                    "file_url": row.file_url,
                    "file_name": row.file_name,
                    "mime_type": row.mime_type
                }
                for row in asset_file_rows
            ]
            persona_conf["workflow_overrides"] = [
                {
                    "workflow_kind": row.workflow_kind,
                    "workflow_name": row.workflow_name,
                    "workflow_json": row.workflow_json,
                    "is_default": row.is_default
                }
                for row in workflow_overrides
            ]
            
            return persona_conf, active_persona_id, persona_name, character_spec.config_json

    def _get_prompt_generator(self, charspec_conf: Optional[dict] = None):
        """
        プロンプトジェネレーターを取得する

        Parameters
        ----------
        charspec_conf : Optional[dict]
            キャラクター仕様の設定

        Returns
        -------
        PonyPromptGenerator
            PonyPromptGeneratorのインスタンス
        """
        # PonyPromptGeneratorのインスタンスを作成
        return PonyPromptGenerator(
            persona_conf=charspec_conf or self.charspec_conf
        )
    
    def _generate_prompt(self, pony_generator: PonyPromptGenerator, rating_level):
        """
        プロンプトを生成する

        Parameters
        ----------
        pony_generator : PonyPromptGenerator
            プロンプトジェネレーターのインスタンス
        rating_level : RatingLevel
            レーティングレベル
        
        Returns
        -------
        PromptContextModel
            生成されたプロンプトコンテキストモデル
        """
        # PromptContextを生成
        prompt_context = pony_generator.generate_prompt(
            rating_level=rating_level
        )
        return prompt_context

    def _serialize_prompt_context(self, prompt_context):
        """
        プロンプトコンテキストをシリアライズする
        
        Parameters
        ----------
        prompt_context : PromptContextModel
            プロンプトコンテキストモデルインスタンス
        """

        # プロンプトコンテキストを辞書に変換する
        if hasattr(prompt_context, "__dataclass_fields__"):
            raw_data = asdict(prompt_context)
        elif isinstance(prompt_context, dict):
            raw_data = prompt_context
        else:
            raw_data = dict(prompt_context)

        def _serialize(value):
            """
            値をシリアライズする

            Parameters
            ----------
            value : Any
                シリアライズする値
            """
            if isinstance(value, enum.Enum):
                return value.value
            if isinstance(value, dict):
                return {k: _serialize(v) for k, v in value.items()}
            if isinstance(value, list):
                return [_serialize(v) for v in value]
            return value

        return _serialize(raw_data)

    def _apply_comfyui_workflow(
            self, 
            workflow: dict[str, Any], 
            prompt_context: PromptContextModel, 
            mod_config: dict[str, Any]):
        """
        ComfyUIワークフローのパラメーターを修正する

        Parameters
        ----------
        workflow : dict[str, Any]
            ComfyUIのワークフローデータ
        prompt_context : PromptContextModel
            プロンプトコンテキストモデルインスタンス
        mod_config : dict[str, Any]
            ワークフローに適用するノード修正用データ
        """

        # ワークフロー修正定義
        modification_list = WorkflowMod.create_modifications(
            prompt_context=prompt_context, 
            mod_config=mod_config,
            batch_size=1
        )

        # WorkflowEditorを使用してワークフローに修正を適用
        return (modification_list, WorkflowEditor.apply_modifications(workflow, modification_list))
    
    def get_available_workflows(self) -> list[str]:
        """
        利用可能なワークフローファイル一覧を取得する

        Returns
        -------
        list[str]
            ワークフローファイルのリスト(拡張子が.jsonのファイルのみ)
        """

        # ワークフロー格納ディレクトリ取得
        workflow_dir = Path(self.comfyui_config.workflow_path).parent

        # ディレクトリの存在チェック
        if not os.path.exists(workflow_dir):
            return []

        # 拡張子がjsonのファイルをリスト化
        workflow = [
            f for f in os.listdir(workflow_dir)
            if f.endswith('.json') and os.path.isfile(os.path.join(workflow_dir, f))
        ]

        # リストをソートして返す
        return sorted(workflow)
    
    async def run_comfyui_api(
            self, 
            workflow_data: Union[Dict[str, Any], str], 
            modification_list: List[NodeModification], 
            prompt_context: PromptContextModel,
            active_persona_id: str):
        """
        ComfyUIのAPIを実行する

        Parameters
        ----------
        workflow_data : Union[Dict[str, Any], str]
            ComfyUIのワークフローデータ
            辞書型、またはワークフローJOSNファイルへのパスを文字列で指定            
        modifications : Optional[List[NodeModification]], optional
            ワークフローに適用するノード修正のリスト。デフォルトはNone
        prompt_context : PromptContextModel
            プロンプトコンテキストモデルインスタンス
        
        Returns
        -------
        list[dict[str, Any]]
            生成画像リスト
        
        """

        # ComfyUIクライアントを初期化する
        client = ComfyUIClient(
            base_url=self.comfyui_endpoint,
            timeout_seconds=self.timeout_seconds,
            polling_interval=self.polling_interval
        )

        try:
            # ワークフローを実行する
            response = await client.run_workflow(workflow_data=workflow_data, modifications=modification_list)
            
            # 生成された画像を保存する
            gen_image_list = []
            if response and response["result"]:
                for _, image_bytes in enumerate(response["result"]):
                    filename = client.get_gen_filename()
                    output_dir = "gen_images"
                    os.makedirs(output_dir, exist_ok=True)
                    image_path = os.path.join(output_dir, filename)
                    with open(image_path, "wb") as image_file:
                        image_file.write(image_bytes)
                    app_logger.info(f"Generated image saved to: {image_path}")
                    prompt_data = self._serialize_prompt_context(prompt_context)
                    gen_image_list.append({
                        "filename": filename,
                        "image_bytes": image_bytes,
                        "rating_level": int(prompt_context.prompt_level),
                        "scene_id": str(getattr(prompt_context, "scene_id", "unknown") or "unknown"),
                        "prompt_data": prompt_data,
                        "persona_id": active_persona_id
                    })
            else:
                app_logger.warning("No images were generated from ComfyUI.")

            return gen_image_list
        except Exception:
            raise
    
    async def generate_images(self, 
        rating_level, 
        workflow_file: str = "", 
        user_id: str | None = None, 
        group_name: str | None = None,
        discord_channel: Any = None):
        """
        画像を生成する

        Parameters
        ----------
        rating_level : RatingLevel
            レーティングレベル
        workflow_file : str
            ワークフローファイル名（configs/comfyui/workflow/ 配下の json ファイル）
            未指定の場合はcomfyui_config.jsonのworkflow_pathの設定値から取得
        user_id : str
            ユーザーID

        Returns
        -------
        list
            生成された画像情報のリスト
        """

        # プロンプトジェネレーターインスタンスを取得する
        charspec_conf = self.charspec_conf
        active_persona_id = None

        # character_secを取得
        if user_id and self.db_session_factory:
            (
                loaded_persona_conf, 
                active_persona_id, 
                persona_name, 
                character_spec_json
            ) = self._load_persona_from_db(user_id, group_name)
            if loaded_persona_conf is None:
                message = self._build_missing_persona_config_message(
                    persona_name=persona_name,
                    group_name=group_name,
                    user_id=user_id
                )
                if discord_channel is not None:
                    await discord_channel.send(message)
                app_logger.warning(message)
                return []

            charspec_conf = character_spec_json or self.charspec_conf
            app_logger.info(
                f"Loaded persona config from DB: persona_id={active_persona_id},"
                f"persona_name={persona_name}"
            )
            
        prompt_generator = self._get_prompt_generator(charspec_conf)

        # プロンプトを生成する
        prompt_context = self._generate_prompt(prompt_generator, rating_level)

        # ワークフローファイルパスを取得する
        if workflow_file:
            workflow = self._get_workflow(workflow_file=workflow_file)
        else:
            workflow = prompt_generator.workflow_data
        
        # ワークフローファイルのパラメーターを変更する
        modification_list, configured_workflow = self._apply_comfyui_workflow(workflow, prompt_context, prompt_generator.mod_config)

        # Comfyui APIに処理をリクエストする
        return await self.run_comfyui_api(configured_workflow, modification_list, prompt_context, active_persona_id)
