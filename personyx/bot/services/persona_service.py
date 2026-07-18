import os
import re
import json
import random
from sqlalchemy.orm import sessionmaker, Session

class PersonaService:
    """
    Persona設定とシステム指示テンプレートを統合し、AIの人格を構築するサービス
    特定のキャラクター設定(Persona JSON)を共通のシステム指示テンプレート(Instruction JSON)のプレースホルダ―に埋め込み
    GeminiClientに引き渡す
    """
    def __init__(self, 
        instruction_path: str, 
        persona_path: str, 
        db_session_factory:sessionmaker[Session]=None):
        """
        コンストラクタ

        Parameters
        ----------
        instruction_path : str
            Instruction JSONファイルのパス
        persona_path : str
            Persona JSONファイルのパス
        db_session_factory : sessionmaker[Session]
            DBセッションファクトリ
        """

        self.instruction_path = instruction_path
        self.persona_path = persona_path
        self.db_session_factory = db_session_factory
        self._instruction_cache = None
        self._persona_cache = {}

    def _resolve_persona_from_db(self, user_id: str | None):
        """
        ペルソナ設定をDBから取得する

        Parameters
        ----------
        user_id : str
            ユーザーID
        """

        if not self.db_session_factory or not user_id:
            return None
        
        from web.models.user_bot_profiles import UserBotProfiles
        from web.models.bot_profiles import BotProfiles
        from web.models.bot_profile_groups import BotProfileGroups
        from web.models.personas import Personas

        with self.db_session_factory() as session:
            assignment = (
                session.query(UserBotProfiles)
                    .join(UserBotProfiles.bot_profile)
                    .join(BotProfiles.group)
                    .filter(
                        UserBotProfiles.user_id == user_id,
                        UserBotProfiles.is_active.is_(True),
                        BotProfiles.is_active.is_(True),
                        BotProfileGroups.is_active.is_(True),
                    )
                    .first()
            )

            if not assignment or not assignment.bot_profile or not assignment.bot_profile.active_persona_id:
                return None

            # アクティブなペルソナIDに対するペルソナJSON取得        
            persona = session.query(Personas).filter_by(id=assignment.bot_profile.active_persona_id).first()
            return dict(persona.persona_config) if persona else None

    def _load_persona(self, user_id: str | None = None):
        """
        ペルソナ設定をロードする

        Parameters
        ----------
        user_id : str
            ユーザーID

        """
        
        # キャッシュKey取得(ユーザーIDをKeyとする)
        cache_key = user_id or "__default__"
        # Personaキャッシュに対象にKeyが存在するかチェックして存在しなければ設定の取得処理を実施する
        if cache_key not in self._persona_cache:

            # Persona設定をDBから取得
            persona_data = self._resolve_persona_from_db(user_id=user_id)
            if persona_data is None:

                # Personaファイルチェック
                if not os.path.exists(self.persona_path):
                    raise FileNotFoundError(f"Persona file not found: {self.persona_path}")

                # Personaファイル読込
                with open(self.persona_path, "r", encoding="utf-8") as f:
                    persona_data = json.load(f)

            self._persona_cache[cache_key] = persona_data
        return self._persona_cache[cache_key]
    
    def get_raw_data(self, *keys: str, user_id: str | None = None):
        """
        スピンタックス展開をせず、指定階層のデータをそのまま(dict or list)返す
        """
        data = self._load_persona(user_id=user_id)["generation_templates"]
        
        for key in keys:
            data = data.get(key, {})
        return data
    
    def _parse_spintax(self, text: str) -> str:
        """
        {a|b}の形式を再帰的にランダム選択して展開する
        """

        while '{' in text:
            # 最も内側の{ }を探して置換
            new_text = re.sub(
                r'\{([^{}]*?\|[^{}]*?)\}',
                lambda m: random.choice(m.group(1).split('|')),
                text)
            if new_text == text:
                break
            text = new_text
        return text
    
    def get_static_message(self, *keys: str, user_id: str | None = None) -> str:
        """
        Persona JSON内のSpintax Templateからセリフを生成する

        Parameters
        ----------
        category : str
            テンプレートのカテゴリ (例: "dress_up_start_messages")
        sub_key : str
            RagingLevelなどの識別子（例: "1", "2", "3", "4"）
        user_id : str
            ユーザーID
        """

        # Personaデータ取得
        persona = self._load_persona(user_id=user_id)

        # generation_templateの階層を取得
        target = persona.get("generation_templates", {})
        for key in keys:
            if isinstance(target, dict):
                target = target.get(str(key), {})
            else:
                return f"[Error] Path {'/'.join(keys)} is not a dictionary."
        
        # 最終的な値が文字列でなければエラーとする
        if not isinstance(target, str):
            return f"[Error] Message not found at path: {'/'.join(keys)}"

        return self._parse_spintax(target)
    
    def _load_instruction(self) -> dict:
        """
        Instructionファイルを読み込んでキャッシュする
        """
        if self._instruction_cache is None:

            # Instructionファイルチェック
            if not os.path.exists(self.instruction_path):
                raise FileNotFoundError(f"Instruction template not found: {self.instruction_path}")
            
            # Instructionファイル読込
            with open(self.instruction_path, "r", encoding="utf-8") as f:
                self._instruction_cache = json.load(f)
        
        return self._instruction_cache
    
    def build_system_instruction(self, user_id: str | None = None) -> str:
        """
        システムプロンプトを構築する

        Parameters
        ----------
        user_id : str
            ユーザーID

        Returns
        -------
        str
            システムプロンプト
        """

        # Instructionファイル読込
        inst_data = self._load_instruction()

        # Personaファイル読込
        persona_data = self._load_persona(user_id=user_id)

        # template_linesを結合してBaseを作成
        template = "\n".join(inst_data["meta_instruction"]["template_lines"])

        # {persona_json} プレースホルダ―を置換
        persona_str = json.dumps(persona_data, ensure_ascii=False, indent=2)

        # Instructionデータを返す
        return template.format(persona_json=persona_str)
    
    def get_formatted_error_message(self, category: str, key: str, error: Exception, user_id: str | None = None):
        """
        静的メッセージを取得し、{error}プレースホルダーをエラー内容で安全に置換する
        """

        # システムメッセージを取得する
        raw_msg = self.get_static_message(category, key, user_id=user_id)

        # {error}プレースホルダーをreplaceで置換する
        return raw_msg.replace("{error}", str(error))