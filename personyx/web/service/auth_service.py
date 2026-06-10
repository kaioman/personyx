from sqlalchemy.orm import Session
from requests_oauthlib import OAuth2Session
from web.config import get_app_config
from web.service.user_service import UserService

class AuthService:
    def __init__(self):
        """
        コンストラクタ
        """
        self.app_cfg = get_app_config()
        self.user_service = UserService()
    
    def get_authorization_url(self) -> tuple[str, str]:
        """
        Discord認証URLとstateを取得する
        """

        # Discord OAuth2セッションインスタンス取得
        discord = OAuth2Session(
            client_id=self.app_cfg.discord_client_id,
            redirect_uri=self.app_cfg.discord_redirect_uri,
            scope=self.app_cfg.discord_scope
        )
        # 認証用URL取得
        return discord.authorization_url(self.app_cfg.discord_auth_base)

    def process_callback(self, state: str, authorization_response_url: str, db_session: Session) -> tuple[str, str] | None:
        """
        コールバック処理を行い、ユーザー情報を返す
        """

        discord = OAuth2Session(
            client_id=self.app_cfg.discord_client_id,
            redirect_uri=self.app_cfg.discord_redirect_uri,
            state=state
        )

        try:
            discord.fetch_token(
                self.app_cfg.discord_token_url,
                client_secret=self.app_cfg.discord_secret,
                authorization_response=authorization_response_url
            )
        except Exception as e:
            print("fetch_token error:", e)
            raise
        
        # Discord認証情報取得
        discord_user = discord.get(self.app_cfg.discord_user_api).json()
        provider_user_id = str(discord_user.get("id"))
        username = discord_user.get("username")

        # 認証情報が取得できなかった場合(未ログインの場合)はトップページにリダイレクトする
        if not provider_user_id or not username:
            return None
        
        # ユーザー情報をUserServiceから取得する
        account = self.user_service.get_user_by_provider(
            db_session,
            "discord",
            provider_user_id
        )
        if account:
            user_id = account.user_id
        else:
            user_id = self.user_service.register_oauth_user(
                db_session,
                "discord",
                provider_user_id
            )
        
        return str(user_id), username