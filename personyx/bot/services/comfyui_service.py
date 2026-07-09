import os
import json
import enum
import libcore_hng.utils.app_logger as app_logger
from dataclasses import asdict
from typing import Union, Dict, Any, List
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
            persona_conf_path: str,
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

        # 設定JSONファイルを読み込む
        self.persona_conf = self._load_json(persona_conf_path)

    def _get_workflow(self, workflow_file: str = ""):
        """
        ComfyUI Workflowを取得する
        """

        # ワークフローパスを取得
        comfyui_workflow_path = Path(self.comfyui_config.workflow_path).parent / workflow_file
        
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

    def _get_prompt_generator(self):

        # PonyPromptGeneratorのインスタンスを作成
        return PonyPromptGenerator(
            persona_conf=self.persona_conf
        )
    
    def _generate_prompt(self, pony_generator: PonyPromptGenerator, rating_level):

        # PromptContextを生成
        prompt_context = pony_generator.generate_prompt(
            rating_level=rating_level
        )
        return prompt_context

    def _serialize_prompt_context(self, prompt_context):
        if hasattr(prompt_context, "__dataclass_fields__"):
            raw_data = asdict(prompt_context)
        elif isinstance(prompt_context, dict):
            raw_data = prompt_context
        else:
            raw_data = dict(prompt_context)

        def _serialize(value):
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
            prompt_context: PromptContextModel):
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
                        "prompt_data": prompt_data
                    })
            else:
                app_logger.warning("No images were generated from ComfyUI.")

            return gen_image_list
        except Exception as e:
            app_logger.error(f"ComfyUI API Error: {e}")
            raise e
    
    async def generate_images(self, rating_level, workflow_file: str = ""):
        """
        画像を生成する

        Parameters
        ----------
        rating_level : RatingLevel
            レーティングレベル
        workflow_file : str
            ワークフローファイル名（configs/comfyui/workflow/ 配下の json ファイル）
            未指定の場合はcomfyui_config.jsonのworkflow_pathの設定値から取得
        Returns
        -------
        list
            生成された画像情報のリスト
        """

        # プロンプトジェネレーターインスタンスを取得する
        prompt_generator = self._get_prompt_generator()
        # プロンプトを生成する
        prompt_context = self._generate_prompt(prompt_generator, rating_level)

        # ワークフローファイルパスを取得する
        if workflow_file == "":
            workflow = prompt_generator.workflow_path
        else:
            workflow = self._get_workflow(workflow_file)
        
        # ワークフローファイルのパラメーターを変更する
        modification_list, configured_workflow = self._apply_comfyui_workflow(workflow, prompt_context, prompt_generator.mod_config)

        # Comfyui APIに処理をリクエストする
        return await self.run_comfyui_api(configured_workflow, modification_list, prompt_context)
