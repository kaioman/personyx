import os
import shared.configs.app_init as app
from pathlib import Path

def setup_app_config():

    # プロジェクトルート取得
    PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent
    # 環境変数にプロジェクトルート設定
    os.environ["PROJECT_ROOT"] = str(PROJECT_ROOT / "bot")

    # アプリ初期化処理を実行して結果を返す
    return app.init_app(
        __file__, 
        "app_config.json", 
        "gcp_config-dev.json",
        os.environ.get('CONFIG_FILE_NAME', 'personyx-dev.json.enc'),
        "comfyui_config.json"
    )
 