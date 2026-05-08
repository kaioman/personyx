import os
import json
import pycorex.configs.app_init as app
from typing import Optional
from pycorex.comfyui_client import ComfyUIClient
from pycorex.gemini_client import GeminiClient
from pycorex.utils.pony_prompt_generator import PonyPromptGenerator
from pycorex.utils.workflow_editor import WorkflowEditor
from pycorex.utils.workflow_mod import WorkflowMod

class ComfyUIService:

    def __init__(
            self, 
            gemini_client:GeminiClient,
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

        # Comfyui API エンドポイントを取得
        self.comfyui_endpoint = app.core.config.comfyui.comfyui_endpoint
        # Comfyui API タイムアウト設定を取得
        self.timeout_seconds = app.core.config.comfyui.timeout_seconds
        # Comfyui API ポーリング設定を取得
        self.polling_interval = app.core.config.comfyui.polling_interval

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
        comfyui_workflow_path = app.core.config.comfyui.workflow_path
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
            rating_level=rating_level,
            #test_outfit_id="blazer_style",
            #test_scene_id_override="lv2_5_v_sit_exposure",
            #test_camera_name="ハイアングル・俯瞰"
            #test_camera_name="背面視点・バックビュー"
            #test_camera_name="広角レンズ・パース強調"
        )
        return prompt_context
    
    def _apply_comfyui_workflow(self, workflow, prompt_context):

        # ワークフロー修正定義
        modification_list = WorkflowMod.create_modifications(
            prompt_context=prompt_context, 
            mod_config=self.mod_config,
            batch_size=1
        )

        # WorkflowEditorを使用してワークフローに修正を適用
        return (modification_list, WorkflowEditor.apply_modifications(workflow, modification_list))
    
    async def run_comfyui_api(self, workflow, modification_list):
        
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
                for _, image_bytes in enumerate(response["result"]):
                    output_dir = "gen_images"
                    os.makedirs(output_dir, exist_ok=True)
                    image_path = os.path.join(output_dir, client.get_gen_filename())
                    with open(image_path, "wb") as image_file:
                        image_file.write(image_bytes)
                    print(f"Generated image saved to: {image_path}")
                    gen_image_list.append(image_bytes)
            else:
                print("No images were generated.") 

            return gen_image_list
        except Exception as e:
            print(f"Error: {e}")
    
    async def generate_images(self, rating_level):
        
        workflow = self._get_workflow()

        prompt_generator = self._get_prompt_generator()

        prompt_context = self._generate_prompt(prompt_generator, rating_level)

        modification_list, workflow = self._apply_comfyui_workflow(workflow, prompt_context)

        return await self.run_comfyui_api(workflow, modification_list)
