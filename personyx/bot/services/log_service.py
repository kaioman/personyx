import dataclasses
import libcore_hng.utils.app_logger as app_logger
from dataclasses import dataclass
from sqlalchemy.orm import sessionmaker, Session
from web.models.logs import Logs

@dataclass(frozen=True)
class ChatLogDto:
    """
    対話ログを転送するためのデータオブジェクト
    frozen=Trueで生成後の改ざんを防止する
    """

    user_name: str
    """ Discordユーザー名 """

    message: str
    """ メッセージ内容 """

    response: str
    """ 応答結果 """

class LogService:

    def __init__(self, session_factory: sessionmaker[Session]):
        self.session_factory = session_factory

    def save_chat_log(self, dto: ChatLogDto):
        """
        Dtoを受け取ってDBに保存する
        """
        with self.session_factory() as session:
            try:
                # Dtoをdictに変換
                log_data = dataclasses.asdict(dto)

                # ログデータdictをキーワード引数として渡す
                new_log = Logs(**log_data)

                # DBに書き込み
                session.add(new_log)
                session.commit()

            except Exception as e:
                session.rollback()
                app_logger.error(f"DB Logging Error: {e}")
                raise e