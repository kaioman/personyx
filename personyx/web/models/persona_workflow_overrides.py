from sqlalchemy import Column, String, TIMESTAMP, ForeignKey, text, Boolean
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.orm import relationship
from pydbx_hng.models.base.base_model import BaseModel

class PersonaWorkflowOverrides(BaseModel):
    """
    ワークフロー置換定義モデル 
    - ワークフローJSONの一部を置換するためのJSONを管理する
    - 完全なワークフロー本体ではなく、ベースワークフローに対する差分のみ保持する
    - 既定のベースワークフローに対してペルソナごとの差分を適用できるようにする

    例:
    - workflow_kind = "api"
    - override_name = "default"
    - override_json = { "nodes": [...], "modifications": [...] }    
    """
    
    # テーブル名指定
    __tablename__ = "persona_workflow_overrides"
    # スキーマ名指定
    __table_args__ = {"schema": "personyx"}

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
    
    # ワークフロー種類
    workflow_kind = Column(
        String(50),
        nullable=False,
        index=True
    )

    # ワークフロー名称
    workflow_name = Column(
        String(255),
        nullable=False
    )

    # ワークフローJSON
    workflow_json = Column(
        JSONB,
        nullable=False
    )

    # デフォルトワークフロー
    is_default = Column(
        Boolean,
        nullable=False,
        default=False
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
        back_populates="workflow_overrides"
    )
