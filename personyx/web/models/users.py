from sqlalchemy import Column, String, TIMESTAMP, text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from pydbx_hng.models.base.base_model import BaseModel


class Users(BaseModel):
    """
    ユーザー情報を管理するモデル
    
    - アプリケーション内のユーザー（人）を管理するコアモデル
    - 複数の認証アカウント（UserAccounts）を1対多で保持
    """
    
    # テーブル名指定
    __tablename__ = "users"
    # スキーマ名指定
    __table_args__ = {"schema": "personyx"}
    
    # 主キー(UUIDはDB側で自動生成)
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        server_default=text("gen_random_uuid()")
    )
    
    # ユーザー表示名
    display_name = Column(
        String(100),
        nullable=False
    )
    
    # 生成日時
    created_at = Column(
        TIMESTAMP(timezone=True),
        nullable=False,
        server_default=text("NOW()"),
        index=True
    )
    
    # リレーション: 複数の認証アカウント
    user_accounts = relationship(
        "UserAccounts",
        back_populates="user",
        cascade="all, delete-orphan"
    )
    
    # リレーション: 複数の生成画像
    images = relationship(
        "Images",
        back_populates="user"
    )
