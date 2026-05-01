from sqlalchemy import Column, Integer, TIMESTAMP, Text, text
from pydbx_hng.models.base.base_model import BaseModel

class Logs(BaseModel):
    """
    Bot対話ログ記録テーブル
    
    - Botとの対話履歴を記録するログテーブル
    """
    
    # テーブル名指定
    __tablename__ = "logs"
    # スキーマ名指定
    __table_args__ = {"schema": "personyx"}
    
    # 主キー(自動連番)
    id = Column(
        Integer,
        primary_key=True,
        autoincrement=True
    )
    
    # Discordユーザー名
    user_name = Column(
        Text,
        nullable=False
    )
    
    # Discordユーザー名
    message = Column(
        Text
    )
    
    # Botの返答
    response = Column(
        Text
    )
    
    # 生成日時
    created_at = Column(
        TIMESTAMP(timezone=True),
        nullable=False,
        server_default=text("NOW()")
    )
    