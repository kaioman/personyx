import os
import json

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

    def build_system_instruction(self) -> str:
        """
        システムプロンプトを構築する
        """

        # Instructionファイルチェック
        if not os.path.exists(self.instruction_path):
            raise FileNotFoundError(f"Instruction template not found: {self.instruction_path}")
        
        # Personaファイルチェック
        if not os.path.exists(self.persona_path):
            raise FileNotFoundError(f"Persona file not found: {self.persona_path}")
        
        # Instructionファイル読込
        with open(self.instruction_path, "r", encoding="utf-8") as f:
            inst_data = json.load(f)

        # Personaファイル読込
        with open(self.persona_path, "r", encoding="utf-8") as f:
            persona_data = json.load(f)

        # template_linesを結合してBaseを作成
        template = "\n".join(inst_data["meta_instruction"]["template_lines"])

        # {persona_json} プレースホルダ―を置換
        persona_str = json.dumps(persona_data, ensure_ascii=False, indent=2)
        full_instruction = template.format(persona_json=persona_str)

        # Instructionデータを返す
        return full_instruction
    