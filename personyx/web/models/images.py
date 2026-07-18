from sqlalchemy import Column, String, Integer, Boolean, TIMESTAMP, ForeignKey, text
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.orm import relationship
from pydbx_hng.models.base.base_model import BaseModel

class Images(BaseModel):
    """
    生成画像情報を管理するモデル
    
    - アプリケーション内で生成画像情報を扱うためのORMモデル
    """
    
    # テーブル名指定
    __tablename__ = "images"
    # スキーマ名指定
    __table_args__ = {"schema": "personyx"}
    
    # 主キー(UUIDはDB側で自動生成)
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        server_default=text("gen_random_uuid()")
    )

    # ユーザーへの外部キー
    user_id = Column(
        UUID(as_uuid=True),
        ForeignKey("personyx.users.id", ondelete="SET NULL"),
        nullable=True
    )
    
    # ファイル名
    filename = Column(
        String,
        nullable=False
    )  
    
    # Rating Level
    rating_level = Column(
        Integer,
        nullable=False,
        index=True
    )
    
    # シーンID
    scene_id = Column(
        String(50),
        nullable=False,
        index=True
    )
    
    # お気に入りフラグ
    is_favorite = Column(
        Boolean,
        default=False,
        index=True
    )

    # メタデータ
    prompt_data = Column(
        JSONB
    )

    # ペルソナID
    persona_id = Column(
        UUID(as_uuid=True),
        ForeignKey("personyx.personas.id", ondelete="SET NULL"),
        nullable=True,
        index=True
    )

    # 生成日時
    created_at = Column(
        TIMESTAMP(timezone=True),
        nullable=False,
        server_default=text("NOW()"),
        index=True
    )
    
    # リレーション: ユーザー
    user = relationship(
        "Users",
        back_populates="images"
    )
    
    # リレーション: ペルソナ
    persona = relationship(
        "Personas",
        back_populates="images"
    )
