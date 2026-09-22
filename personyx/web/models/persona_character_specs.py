from sqlalchemy import Column, String, TIMESTAMP, ForeignKey, text, Index, Boolean
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.orm import relationship
from pydbx_hng.models.base.base_model import BaseModel

class PersonaCharacterSpecs(BaseModel):
    """
    キャラクター定義モデル 

    - target_model, rating, negative_logic, base_styleなどの生成仕様(タグ)を保持する
    - config_json にキャラクター定義(character_spec.json)のJSON本体を格納する
    - ペルソナから参照される生成設定の中心として扱う

    例:
    - name = "Aoi"
    - target_model = "ebaraPony"
    - config_json = { "config_paths": {...}, "negative_logic": {...} }    
    """
    
    # テーブル名指定
    __tablename__ = "persona_character_specs"
    # スキーマ名指定
    __table_args__ = (
        Index(
            "uq_persona_character_spec_default",
            "persona_id",
            unique=True,
            postgresql_where=text("is_default = true")            
        ),
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
    
    # 設定名
    name = Column(
        String(255),
        nullable=False
    )

    # 対象生成モデル
    target_model = Column(
        String(255),
        nullable=True
    )

    # 有効化デフォルト設定かどうか
    is_default = Column(
        Boolean,
        nullable=False,
        default=False
    )

    # キャラクター設定JSON
    config_json = Column(
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
        back_populates="character_specs"
    )
