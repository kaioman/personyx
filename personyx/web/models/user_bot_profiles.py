from sqlalchemy import Column, String, Integer, Boolean, TIMESTAMP, ForeignKey, UniqueConstraint, text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from pydbx_hng.models.base.base_model import BaseModel

class UserBotProfiles(BaseModel):
    """
    ユーザー別にBotプロファイルを管理するモデル
    """
    
    # テーブル名指定
    __tablename__ = "user_bot_profiles"
    # スキーマ名指定
    __table_args__ = (
        UniqueConstraint("user_id", "bot_profile_id", name="uq_user_bot_profiles_user_profile"),
        UniqueConstraint("user_id", "is_active", name="uq_user_bot_profiles_user_active"),
        {"schema": "personyx"}
    )
    
    # 主キー(UUIDはDB側で自動生成)
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

    # プロファイルグループID
    group_id = Column(
        Integer,
        ForeignKey("personyx.bot_profile_groups.id", ondelete="CASCADE"),
        nullable=False,
        index=True
    )

    # BotプロファイルID
    bot_profile_id = Column(
        Integer,
        ForeignKey("personyx.bot_profiles.id", ondelete="CASCADE"),
        nullable=False,
        index=True
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
        back_populates="bot_profile_assignments"
    )

    # リレーション: Botプロファイルグループ
    group = relationship(
        "BotProfileGroups",
        back_populates="user_assignments"
    )

    # リレーション: Botプロファイル
    bot_profile = relationship(
        "BotProfiles",
        back_populates="user_assignments"
    )
