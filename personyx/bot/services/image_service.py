import discord
import libcore_hng.utils.app_logger as app_logger
from typing import Any, Optional
from sqlalchemy.orm import sessionmaker, Session
from web.models.images import Images
from web.models.users import Users
from web.models.user_accounts import UserAccounts

class UserNotFoundError(Exception):
    """
    ユーザーが見つからない場合にraiseされる例外
    """
    pass

class ImageService:

    def __init__(self, session_factory: sessionmaker[Session]):
        self.session_factory = session_factory

    def save_generated_images(self, 
        image_records: list[dict[str, Any]], 
        user_name: Optional[str] = None, 
        user_id: Optional[str] = None):
        """
        生成された画像メタデータをDBに保存する
        """
        with self.session_factory() as session:
            try:
                # ユーザー情報を取得する
                if user_id:
                    user = session.query(Users).filter_by(id=user_id).first()
                else:
                    user = session.query(Users).filter_by(display_name=user_name).first()
                
                if not user:
                    app_logger.warning(f"User not found (user_id={user_id}, display_name={user_name})")
                    raise UserNotFoundError(
                        f"ユーザー '{user_name} がシステムに登録されていません"
                        f"Webサイトでログインしてユーザーアカウントを作成してください"
                    )
                user_id = str(user.id)

                for record in image_records:
                    new_image = Images(
                        filename=record["filename"],
                        rating_level=record["rating_level"],
                        scene_id=record["scene_id"],
                        prompt_data=record.get("prompt_data"),
                        user_id=user_id,
                        persona_id=record.get("persona_id")
                    )
                    session.add(new_image)
                session.commit()

            except Exception as e:
                session.rollback()
                app_logger.error(f"Image DB Save Error: {e}")
                raise e

    def get_user_id_by_discord(self, discord_user_id: str) -> Optional[str]:
        """
        Discordのprovider_user_id -> Users.idを返す(存在しなければNone)
        """

        with self.session_factory() as session:
            account = session.query(UserAccounts).filter_by(
                provider="discord",
                provider_user_id=str(discord_user_id)
            ).first()
            return str(account.user_id) if account else None
        
    def resolve_discord_user_id(self, discord_user: discord.User) -> str | None:
            """
            Discordのユーザーオブジェクトからアプリ側の Users.idを解決して返す
            見つからなければ None を返す
            """

            try:
                return self.get_user_id_by_discord(str(discord_user.id))
            except Exception as e:
                app_logger.error(f"Failed to resolve discord user id: {e}")
                return None