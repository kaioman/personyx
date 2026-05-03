import os
import libcore_hng.utils.app_logger as app_logger
import pycorex.configs.app_init as app
from pathlib import Path

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
        
        # アプリ初期化
        app.init_app(
            __file__, 
            "app_config.json", 
            "gcp_config-dev.json",
            os.environ.get('CONFIG_FILE_NAME', 'personyx-dev.json.enc'),
            "comfyui_config.json"
        )

    def log_boot_message(self):

        # Readyログ出力
        app_logger.info(f"[Bot] Logged in as {self.bot.user} (ID: {self.bot.user.id})")
        app_logger.info("[Bot] Ready to receive messages.")