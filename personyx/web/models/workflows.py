from sqlalchemy import Column, Integer, String, TIMESTAMP, text
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.orm import relationship
from pydbx_hng.models.base.base_model import BaseModel

class Workflows(BaseModel):
    """
    画像生成ワークフロー設定管理モデル
    """
    
    # テーブル名指定
    __tablename__ = "workflows"
    # スキーマ名指定
    __table_args__ = {"schema": "personyx"}
    
    # 主キー(UUIDはDB側で自動生成)
    id = Column(
        Integer,
        primary_key=True,
        autoincrement=True
    )

    # ワークフロー名
    name = Column(
        String(255),
        nullable=False,
        index=True        
    )

    # ワークフロー設定JSON
    config = Column(
        JSONB
    )
    
    # 生成日時
    created_at = Column(
        TIMESTAMP(timezone=True),
        nullable=False,
        server_default=text("NOW()"),
        index=True
    )
    
    # リレーション: Personas(逆参照)
    personas = relationship(
        "Personas",
        back_populates="workflow"
    )
