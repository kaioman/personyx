from sqlalchemy import Column, String, Integer, Boolean, Text, TIMESTAMP, ForeignKey, text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from pydbx_hng.models.base.base_model import BaseModel

class BotProfileGroups(BaseModel):
    """
    Botプロファイルグループ管理モデル
    """
    
    # テーブル名指定
    __tablename__ = "bot_profile_groups"
    # スキーマ名指定
    __table_args__ = {"schema": "personyx"}
    
    # 主キー
    id = Column(
        Integer,
        primary_key=True,
        autoincrement=True
    )

    # ユーザーID
    user_id = Column(
        UUID(as_uuid=True),
        ForeignKey("personyx.users.id", ondelete="CASCADE"),
        nullable=False,
        index=True
    )

    # グループ名
    name = Column(
        String(255),
        nullable=False,
        unique=True
    )

    # 説明
    description = Column(
        Text,
        nullable=True
    )
    
    # 有効区分
    is_active = Column(
        Boolean,
        nullable=False,
        server_default=text("false"),
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
        back_populates="bot_profile_groups"
    )

    # リレーション: Botプロファイル
    bot_profiles = relationship(
        "BotProfiles",
        back_populates="group",
        cascade="all, delete-orphan"
    )

    # リレーション：ユーザー別Botプロファイル
    user_assignments = relationship(
        "UserBotProfiles",
        back_populates="group",
        cascade="all, delete-orphan"
    )