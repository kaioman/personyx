import os
import subprocess
import libcore_hng.utils.app_core as app
import libcore_hng.utils.crypto as crypto
from pathlib import Path
from libcore_hng.core.base_config import BaseConfig

# アプリ初期化
#app.init_app(BaseConfig, __file__, "app_config.json")

# 秘密鍵の入力
secret_key = input("Enter decryption key:")

# 暗号化ファイルのパス入力
encrypt_file_str = input("Enter encrypt file path(personyx/bot/configs/personyx-dev.json.enc):")

# 暗号化ファイルの格納ディレクトリ取得
encrypt_file_path = Path(encrypt_file_str)
encrypt_file_dir = encrypt_file_path.parent

# 暗号化ファイルのファイル名部分取得(.enc除く)
encrypt_file_name = encrypt_file_path.stem

# 一時ファイルのパスを取得
tmp_json_path = Path(encrypt_file_dir) / encrypt_file_name
tmp_json_str = str(tmp_json_path)

# 暗号化ファイルを復号して一時ファイルとして出力
print("decrypt file...")
crypto.create_decryption_file(encrypt_file_str, tmp_json_str, secret_key)

# 一時ファイルをメモ帳として開く
subprocess.run(["notepad.exe", tmp_json_path])
print("encrypt file...")

# 編集したjsonファイルを暗号化する
crypto.create_encryption_file(tmp_json_str, secret_key)

# 一時ファイル削除
if os.path.exists(tmp_json_str):
    os.remove(tmp_json_str)
    print("complete.")