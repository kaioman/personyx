from sqlalchemy import Column, String, Text, Integer, TIMESTAMP, ForeignKey, text
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.orm import relationship
from pydbx_hng.models.base.base_model import BaseModel

class Personas(BaseModel):
    """
    ペルソナ定義モデル
    - id は UUID
    - user_idは必須(作成者)
    - persona_configは persona.json の中核部を保持する
    - character_spec / asset / workflow は分離テーブルに持たせる
    """
    
    # テーブル名指定
    __tablename__ = "personas"
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
        ForeignKey("personyx.users.id", ondelete="RESTRICT"),
        nullable=False
    )
    
    # ペルソナ名
    name = Column(
        String(255),
        nullable=False,
        index=True        
    )

    # アイコンURL
    icon_url = Column(
        Text
    )  
    
    # ペルソナ設定JSON
    persona_config = Column(
        JSONB,
        nullable=False
    )
    
    # ワークフローID
    workflow_id = Column(
        Integer, ForeignKey("personyx.workflows.id", ondelete="SET NULL"),
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
    
    # リレーション: ワークフロー
    workflow = relationship(
        "Workflows",
        back_populates="personas"
    )

    # リレーション: ペルソナごとのワークフロー差分
    workflow_overrides = relationship(
        "PersonaWorkflowOverrides",
        back_populates="persona",
        cascade="all, delete-orphan"
    )

    # リレーション: 画像情報
    images = relationship(
        "Images",
        back_populates="persona"
    )

    # リレーション: Botペルソナ設定
    bot_profiles = relationship(
        "BotProfiles",
        back_populates="persona"
    )

    # リレーション: キャラクター設定
    character_specs = relationship(
        "PersonaCharacterSpecs",
        back_populates="persona",
        cascade="all, delete-orphan"
    )

    # リレーション: ファイル型セット
    asset_files = relationship(
        "PersonaAssetFiles",
        back_populates="persona",
        cascade="all, delete-orphan"
    )

    # リレーション: アセット設定
    assets = relationship(
        "PersonaAssets",
        back_populates="persona",
        cascade="all, delete-orphan"
    )
