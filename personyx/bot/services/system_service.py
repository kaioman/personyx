import os
import libcore_hng.utils.app_logger as app_logger
import shared.configs.app_init as app
from pathlib import Path
from dotenv import load_dotenv

class SystemService:

    def __init__(self, bot):
        """
        コンストラクタ
        """
        self.bot = bot

    def setup_app(self):

        # プロジェクトルート取得
        PROJECT_ROOT = Path(__file__).resolve().parent.parent
        # 環境変数にプロジェクトルート設定
        os.environ["PROJECT_ROOT"] = str(PROJECT_ROOT)

        # .envの読み込み(既存の環境変数は上書きしない)
        env_path = PROJECT_ROOT.parent / "personyx-service" / ".env"
        load_dotenv(dotenv_path=env_path, override=False)

        # アプリ初期化
        app.init_app(
            __file__, 
            "app_config.json", 
            "gcp_config-dev.json",
            os.environ.get('CONFIG_FILE_NAME', 'personyx-dev.json.enc'),
            "comfyui_config.json"
        )

        # デバッグ実行時のみ一部設定を上書きする
        if os.getenv("COMFYUI_ENV", "prod").lower() == "debug":

            # ComfyUIエンドポイントURL
            debug_endpoint = os.getenv("COMFYUI_ENDPOINT_DEBUG")
            if debug_endpoint:
               app.core.config.comfyui.comfyui_endpoint = debug_endpoint 

    def log_boot_message(self):

        # Readyログ出力
        app_logger.info(f"[Bot] Logged in as {self.bot.user} (ID: {self.bot.user.id})")
        app_logger.info("[Bot] Ready to receive messages.")