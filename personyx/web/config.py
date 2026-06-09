import ast
import os
from shared.configs.config import setup_app_config

class AppConfig:
    """
    アプリ設定管理クラス（初期化は遅延させる）
    """

    def __init__(self):
        """
        コンストラクタ
        """

        # 共通設定取得（重い初期化処理が含まれる可能性あり）
        self.config = setup_app_config()

        # Discord関連の設定取得
        self.discord_client_id = self.config.config.discord.oauth2.app_id
        self.discord_secret = self.config.config.discord.oauth2.secret_key
        self.discord_redirect_uri = os.getenv("DISCORD_REDIRECT_URI")
        self.discord_auth_base = os.getenv("DISCORD_AUTH_BASE")
        self.discord_token_url = os.getenv("DISCORD_TOKEN_URL")
        self.discord_user_api = os.getenv("DISCORD_USER_API")
        self.discord_scope = ast.literal_eval(os.getenv("DISCORD_SCOPE", "[]"))

        # 生成画像ルートパス取得
        self.gen_images_root = "/app/gen_images"
        self.gen_images_dir = os.environ.get("GEN_IMAGES_DIR", self.gen_images_root)

        # DatabaseUrl取得
        self.database_url = os.environ.get(
            "DATABASE_URL",
            "postgresql+psycopg2://personyx:personyx@personyx_db:5432/personyx_pg12"
        )

        # 一度に表示する画像枚数設定取得
        self.items_per_page = int(os.getenv("ITEMS_PER_PAGE", 24))

# アプリ設定保持用変数初期化
_cached_app_config = None

def get_app_config():
    """
    遅延初期化されたアプリ設定を返す。インポート時に重い処理を行わない。
    """
    
    # アプリ設定保持用変数をグローバルスコープに変更
    global _cached_app_config
    if _cached_app_config is None:
        _cached_app_config = AppConfig()
    return _cached_app_config
