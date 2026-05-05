import os
import re
import json
import random

class PersonaService:
    """
    Persona設定とシステム指示テンプレートを統合し、AIの人格を構築するサービス
    特定のキャラクター設定(Persona JSON)を共通のシステム指示テンプレート(Instruction JSON)のプレースホルダ―に埋め込み
    GeminiClientに引き渡す
    """
    def __init__(self, instruction_path: str, persona_path: str):
        """
        コンストラクタ

        Parameters
        ----------
        instruction_path : str
            Instruction JSONファイルのパス
        persona_path : str
            Persona JSONファイルのパス
        
        """

        self.instruction_path = instruction_path
        self.persona_path = persona_path
        self._instruction_cache = None
        self._persona_cache = None

    def get_raw_data(self, *keys: str):
        """
        スピンタックス展開をせず、指定階層のデータをそのまま(dict or list)返す
        """
        data = self._load_persona()["generation_templates"]
        for key in keys:
            data = data.get(key, {})
        return data
    
    def _parse_spintax(self, text: str) -> str:
        """
        {a|b}の形式を再帰的にランダム選択して展開する
        """

        while '{' in text:
            # 最も内側の{ }を探して置換
            text = re.sub(r'\{([^{}]+)\}', lambda m: random.choice(m.group(1).split('|')), text)
        return text
    
    def get_static_message(self, *keys: str) -> str:
        """
        Persona JSON内のSpintax Templateからセリフを生成する

        Parameters
        ----------
        category : str
            テンプレートのカテゴリ (例: "dress_up_start_messages")
        sub_key : str
            RagingLevelなどの識別子（例: "1", "2", "3", "4"）
        """

        # Personaデータ取得
        persona = self._load_persona()

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
    
    def _load_persona(self) -> dict:
        """
        Personaファイルを読み込んでキャッシュする
        """
        if self._persona_cache is None:

            # Personaファイルチェック
            if not os.path.exists(self.persona_path):
                raise FileNotFoundError(f"Persona file not found: {self.persona_path}")

            # Personaファイル読込
            with open(self.persona_path, "r", encoding="utf-8") as f:
                self._persona_cache = json.load(f)

        return self._persona_cache
    
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
    
    def build_system_instruction(self) -> str:
        """
        システムプロンプトを構築する
        """

        # Instructionファイル読込
        inst_data = self._load_instruction()

        # Personaファイル読込
        persona_data = self._load_persona()

        # template_linesを結合してBaseを作成
        template = "\n".join(inst_data["meta_instruction"]["template_lines"])

        # {persona_json} プレースホルダ―を置換
        persona_str = json.dumps(persona_data, ensure_ascii=False, indent=2)

        # Instructionデータを返す
        return template.format(persona_json=persona_str)
    