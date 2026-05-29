from sqlalchemy import Column, String, TIMESTAMP, ForeignKey, UniqueConstraint, text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from pydbx_hng.models.base.base_model import BaseModel


class UserAccounts(BaseModel):
    """
    ユーザー認証アカウント情報を管理するモデル
    
    - 認証プロバイダー（Discord、Google など）ごとのアカウント情報
    - 1つのユーザーに複数の認証アカウントを紐付け可能
    """
    
    # テーブル名指定
    __tablename__ = "user_accounts"
    # スキーマ名指定
    __table_args__ = (
        UniqueConstraint("provider", "provider_user_id", name="uq_provider_user_id"),
        {"schema": "personyx"}
    )
    
    # 主キー(UUIDはDB側で自動生成)
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        server_default=text("gen_random_uuid()")
    )
    
    # ユーザーへの外部キー
    user_id = Column(
        UUID(as_uuid=True),
        ForeignKey("personyx.users.id", ondelete="CASCADE"),
        nullable=False
    )
    
    # 認証プロバイダー名（例: 'discord', 'google'）
    provider = Column(
        String(50),
        nullable=False
    )
    
    # プロバイダー側のユーザーID
    provider_user_id = Column(
        String(255),
        nullable=False,
        index=True
    )
    
    # 生成日時
    created_at = Column(
        TIMESTAMP(timezone=True),
        nullable=False,
        server_default=text("NOW()")
    )
    
    # リレーション: 親ユーザー
    user = relationship(
        "Users",
        back_populates="user_accounts"
    )
