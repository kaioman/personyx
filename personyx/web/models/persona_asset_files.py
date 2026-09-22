from sqlalchemy import Column, String, TIMESTAMP, ForeignKey, text, Text, UniqueConstraint
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from pydbx_hng.models.base.base_model import BaseModel

class PersonaAssetFiles(BaseModel):
    """
    ペルソナ用のファイル型アセットをURLベースで管理するモデル
    - 画像ファイルの実態は外部ストレージ（CloudflareのR2）に置き、DBにはメタデータと参照URLだけを保持する
    - ペルソナに紐づく画像参照を asset_type + asset_key で識別して管理する

    例:
    - asset_type = "faceid"
    - asset_key = "default"
    - file_url = "https://.../aoi_faceid_default.png"
    """
    
    # テーブル名指定
    __tablename__ = "persona_asset_files"
    # スキーマ名指定
    __table_args__ = (
        UniqueConstraint("persona_id", "asset_type", "asset_key", name="uq_persona_asset_file_key"),
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

    # ファイルURL
    file_url = Column(
        Text,
        nullable=False
    )

    # ファイル名
    file_name = Column(
        String(255),
        nullable=True
    )

    # mime_type
    mime_type = Column(
        String(100),
        nullable=True
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
        back_populates="asset_files"
    )
