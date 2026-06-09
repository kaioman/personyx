import os
from flask import Flask
from werkzeug.middleware.proxy_fix import ProxyFix
from web.config import get_app_config
from web.db import init_db
from web.routes.auth import auth_bp
from web.routes.images import images_bp
from web.routes.main import main_bp

def create_app():
    """
    Flaskアプリファクトリ。重い初期化はここで行う
    """
    
    # アプリ設定取得
    app_cfg = get_app_config()

    # Flaskインスタンス生成
    app = Flask(__name__, template_folder="templates")
    app.secret_key = os.environ.get("FLASK_SECRET_KEY", os.urandom(24))

    # nginx などのリバースプロキシ経由でのプロトコル・ホスト情報を正しく処理
    app.wsgi_app = ProxyFix(app.wsgi_app, x_for=1, x_proto=1, x_host=1, x_port=1)

    # DB初期化
    init_db(app_cfg.database_url)

    # ルーティング登録
    app.register_blueprint(images_bp)
    app.register_blueprint(auth_bp)
    app.register_blueprint(main_bp)

    return app

if __name__ == "__main__":
    create_app().run(host="0.0.0.0", port=5000)
