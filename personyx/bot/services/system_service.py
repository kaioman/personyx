import os
import libcore_hng.utils.app_logger as app_logger
import shared.configs.initialize_app as app

class SystemService:

    def __init__(self, bot):
        """
        コンストラクタ
        """
        self.bot = bot

    def setup_app(self):

        # デバッグ実行時のみ一部設定を上書きする
        if os.getenv("COMFYUI_ENV", "prod").lower() == "debug":

            # ComfyUIエンドポイントURL
            debug_endpoint = os.getenv("COMFYUI_ENDPOINT_DEBUG")
            if debug_endpoint:
               app.config.comfyui.comfyui_endpoint = debug_endpoint 

    def log_boot_message(self):

        # Readyログ出力
        app_logger.info(f"[Bot] Logged in as {self.bot.user} (ID: {self.bot.user.id})")
        app_logger.info("[Bot] Ready to receive messages.")