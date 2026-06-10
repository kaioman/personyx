from sqlalchemy.orm import Session
from web.models.user_accounts import UserAccounts
from web.models.users import Users

class UserService:
    def get_user_by_provider(self, db_session: Session, provider: str, provider_user_id: str) -> UserAccounts | None:
        """
        外部プロバイダIDから連携済アカウント情報を取得する
        """

        # ユーザー情報を返す
        return db_session.query(UserAccounts).filter_by(
            provider=provider,
            provider_user_id=provider_user_id
        ).one_or_none()

    def register_oauth_user(self, db_session: Session, provider: str, provider_user_id: str, username: str) -> int:
        """
        新しくユーザーと外部アカウント連携情報を登録し、ユーザーIDを返す
        """

        # ユーザー情報をUserテーブルに追加する
        user = Users(display_name=username)
        db_session.add(user)
        db_session.flush()

        # ユーザー情報(Discord認証情報)をUserAccountsテーブルに追加する
        account = UserAccounts(
            user_id=user.id,
            provider=provider,
            provider_user_id=provider_user_id
        )
        db_session.add(account)
        db_session.commit()

        return user.id
