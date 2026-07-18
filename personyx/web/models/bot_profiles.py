from sqlalchemy import Column, String, Integer, Boolean, TIMESTAMP, ForeignKey, UniqueConstraint, text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from pydbx_hng.models.base.base_model import BaseModel

class BotProfiles(BaseModel):
    """
    Botプロファイル管理モデル
    """
    
    # テーブル名指定
    __tablename__ = "bot_profiles"
    # スキーマ名指定
    __table_args__ = (        
        UniqueConstraint("group_id", "name", name="uq_bot_profiles_group_name"),
        {"schema": "personyx"}
    )

    # 主キー
    id = Column(
        Integer,
        primary_key=True,
        autoincrement=True
    )

    # プロファイルグループID
    group_id = Column(
        Integer,
        ForeignKey("personyx.bot_profile_groups.id", ondelete="CASCADE"),
        nullable=False,
        index=True
    )

    # プロファイル名
    name = Column(
        String(255),
        nullable=False
    )

    # 有効ペルソナID
    active_persona_id = Column(
        UUID(as_uuid=True),
        ForeignKey("personyx.personas.id", ondelete="SET NULL"),
        nullable=True,
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

    # リレーション: Botプロファイルグループ
    group = relationship(
        "BotProfileGroups",
        back_populates="bot_profiles"
    )
        
    # リレーション: ペルソナ
    persona = relationship(
        "Personas",
        back_populates="bot_profiles"
    )

    # リレーション： ユーザー別Botプロファイル
    user_assignments = relationship(
        "UserBotProfiles",
        back_populates="bot_profile",
        cascade="all, delete-orphan"
    )
