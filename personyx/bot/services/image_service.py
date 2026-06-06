import libcore_hng.utils.app_logger as app_logger
from typing import Any
from sqlalchemy.orm import sessionmaker, Session
from web.models.images import Images
from web.models.users import Users

class UserNotFoundError(Exception):
    """
    ユーザーが見つからない場合にraiseされる例外
    """
    pass

class ImageService:

    def __init__(self, session_factory: sessionmaker[Session]):
        self.session_factory = session_factory

    def save_generated_images(self, image_records: list[dict[str, Any]], user_name: str):
        """
        生成された画像メタデータをDBに保存する
        """
        with self.session_factory() as session:
            try:
                # user_nameからuser_idを取得する
                user = session.query(Users).filter_by(display_name=user_name).first()
                if not user:
                    app_logger.warning(f"User not found for display_name: {user_name}")
                    raise UserNotFoundError(
                        f"ユーザー '{user_name} がシステムに登録されていません"
                        f"Webサイトでログインしてユーザーアカウントを作成してください"
                    )
                else:
                    user_id = str(user.id)
                
                for record in image_records:
                    new_image = Images(
                        filename=record["filename"],
                        rating_level=record["rating_level"],
                        scene_id=record["scene_id"],
                        prompt_data=record.get("prompt_data"),
                        user_id=user_id
                    )
                    session.add(new_image)
                session.commit()

            except Exception as e:
                session.rollback()
                app_logger.error(f"Image DB Save Error: {e}")
                raise e
