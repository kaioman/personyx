from sqlalchemy import Column, String, TIMESTAMP, ForeignKey, text, UniqueConstraint
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.orm import relationship
from pydbx_hng.models.base.base_model import BaseModel

class PersonaAssets(BaseModel):
    """
    キャラクター設定に含まれる JSON アセットを管理するモデル
    - camera.json, scene.json, wardrobe.json, environments.json, expressions.jsonのような設定JSONをDBで保持する
    - 1つの asset はasset_typeとasset_keyで一意に識別する
    - payloadには元のJSON本体をそのまま格納する

    例:
    - asset_type = "camera"
    - asset_key = "default"
    - payload = { "camera_angles": [...] }
    """
    
    # テーブル名指定
    __tablename__ = "persona_assets"
    # スキーマ名指定
    __table_args__ = (
        UniqueConstraint("persona_id", "asset_type", "asset_key", name="uq_persona_asset_key"),
        {"schema": "personyx"}
    )

    # 主キー(UUIDはDB側で自動生成)
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        server_default=text("gen_random_uuid()")
    )

    # ペルソナID
    persona_id = Column(
        UUID(as_uuid=True),
        ForeignKey("personyx.personas.id", ondelete="CASCADE"),
        nullable=False,
        index=True
    )
    
    # アセットタイプ
    asset_type = Column(
        String(50),
        nullable=False,
        index=True
    )

    # アセットキー
    asset_key = Column(
        String(255),
        nullable=False,
        index=True
    )

    # payload
    payload = Column(
        JSONB,
        nullable=False
    )
    
    # 生成日時
    created_at = Column(
        TIMESTAMP(timezone=True),
        nullable=False,
        server_default=text("NOW()"),
        index=True
    )
    
    # リレーション: ペルソナ定義モデル
    persona = relationship(
        "Personas",
        back_populates="assets"
    )
