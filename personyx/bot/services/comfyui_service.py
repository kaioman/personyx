import os
import json
import enum
import libcore_hng.utils.app_logger as app_logger
from dataclasses import asdict
from typing import Optional
from pycorex.comfyui_client import ComfyUIClient
from pycorex.models.comfyui import ComfyUIModel
from pycorex.gemini_client import GeminiClient
from pycorex.utils.pony_prompt_generator import PonyPromptGenerator
from pycorex.utils.workflow_editor import WorkflowEditor
from pycorex.utils.workflow_mod import WorkflowMod

class ComfyUIService:

    def __init__(
            self, 
            gemini_client:GeminiClient,
            comfyui_config: ComfyUIModel,
            persona_conf_path: str,
            mod_config_path: str,
            camera_conf_path: Optional[str] = "configs/comfyui/prompt/camera_angules.json",
            wardrobe_conf_path: Optional[str] = "configs/comfyui/prompt/wardrobe.json",
            environment_conf_path: Optional[str] = "configs/comfyui/prompt/environments.json"
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
        self.camera_conf = self._load_json(camera_conf_path)
        self.wardrobe_conf = self._load_json(wardrobe_conf_path)
        self.environment_conf = self._load_json(environment_conf_path)
        self.mod_config = self._load_json(mod_config_path)

    def _get_workflow(self):
        """
        ComfyUI Workflowを取得する
        """

        # ワークフローパスを取得
        comfyui_workflow_path = self.comfyui_config.workflow_path
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
            persona_conf=self.persona_conf,
            camera_conf=self.camera_conf,
            wardrobe_conf=self.wardrobe_conf,
            environment_conf=self.environment_conf
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

    def _apply_comfyui_workflow(self, workflow, prompt_context):

        # ワークフロー修正定義
        modification_list = WorkflowMod.create_modifications(
            prompt_context=prompt_context, 
            mod_config=self.mod_config,
            batch_size=1
        )

        # WorkflowEditorを使用してワークフローに修正を適用
        return (modification_list, WorkflowEditor.apply_modifications(workflow, modification_list))
    
    async def run_comfyui_api(self, workflow, modification_list, prompt_context, rating_level):
        
        # ComfyUIクライアントを初期化する
        client = ComfyUIClient(
            base_url=self.comfyui_endpoint,
            timeout_seconds=self.timeout_seconds,
            polling_interval=self.polling_interval
        )

        try:
            # ワークフローを実行する
            response = await client.run_workflow(workflow_data=workflow, modifications=modification_list)
            
            # 生成された画像を保存する
            gen_image_list = []
            if response and response["result"]:
                for index, image_bytes in enumerate(response["result"]):
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
                        "rating_level": int(rating_level),
                        "scene_id": str(getattr(prompt_context, "scene_id", "unknown") or "unknown"),
                        "prompt_data": prompt_data
                    })
            else:
                app_logger.warning("No images were generated from ComfyUI.")

            return gen_image_list
        except Exception as e:
            app_logger.error(f"ComfyUI API Error: {e}")
            raise e
    
    async def generate_images(self, rating_level):
        
        workflow = self._get_workflow()

        prompt_generator = self._get_prompt_generator()

        prompt_context = self._generate_prompt(prompt_generator, rating_level)

        modification_list, workflow = self._apply_comfyui_workflow(workflow, prompt_context)

        return await self.run_comfyui_api(workflow, modification_list, prompt_context, rating_level)
