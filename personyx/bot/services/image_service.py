import libcore_hng.utils.app_logger as app_logger
from typing import Any
from sqlalchemy.orm import sessionmaker, Session
from web.models.images import Images

class ImageService:

    def __init__(self, session_factory: sessionmaker[Session]):
        self.session_factory = session_factory

    def save_generated_images(self, image_records: list[dict[str, Any]], user_id: str):
        """
        生成された画像メタデータをDBに保存する
        """
        with self.session_factory() as session:
            try:
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
