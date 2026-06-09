from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from contextlib import contextmanager

# 内部セッションファクトリ（init_dbで設定される）
_SessionLocal = None

def init_db(database_url: str):
    """
    データベース接続を初期化する。アプリ起動時に1回呼ぶこと。
    """
    
    global _SessionLocal
    engine = create_engine(database_url)
    _SessionLocal = sessionmaker(bind=engine, autoflush=False, autocommit=False)

@contextmanager
def get_session():
    """
    DBセッションのコンテキストマネージャ

    使用例:
        with get_session() as db_session:
            ...
    """
    if _SessionLocal is None:
        raise RuntimeError("Database not initialized. Call init_db() before using get_session().")
    sess = _SessionLocal()
    try:
        yield sess
    finally:
        sess.close()
