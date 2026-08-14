import os
import libcore_hng.utils.app_core as app
from pathlib import Path
from dotenv import load_dotenv
from shared.configs.discord import PersonyxConfig

config = None
_is_initialized = False

def get_project_root(caller_file: str, depth: int):
    """
    プロジェクトルートを取得する
    caller_fileで指定したファイルパスから depthで指定した階層を上に行ったパスをプロジェクトルートとする

    Parameters
    ----------
    caller_file : str
        呼び出し元の__file__
    depth : int
        呼び出し元ファイルから見たプロジェクトルートまでの階層数    
    """
    try:
        caller_path = Path(caller_file).resolve()
        get_project_root = caller_path.parents[depth - 1]
    except IndexError:
        raise ValueError(f"指定された depth({depth}) がファイルのパス階層を超えています: {caller_file}")

    return get_project_root

def set_env(project_root: Path):
    """
    環境変数を設定する

    Parameters
    ----------
    project_root : Path
        プロジェクトルートパス   
    """
    # 環境変数にプロジェクトルート設定
    os.environ["PROJECT_ROOT"] = str(project_root)

    # .envの読み込み(既存の環境変数は上書きしない)
    env_path = project_root.parent / "personyx-service" / ".env"
    load_dotenv(dotenv_path=env_path, override=False)

def setup(caller_file: str, depth: int = 1):
    """
    環境変数と設定を初期化する
    （初回呼び出し時のみ実行）

    Parameters
    ----------
    caller_file : str
        呼び出し元の__file__
    depth : int
        呼び出し元ファイルから見たプロジェクトルートまでの階層数(デフォルトは1)

    Returns
    -------
    PersonyxConfig
        Personyx設定クラスインスタンス
    """

    # 設定格納用変数、初期化済判定用変数をグローバル変数化する
    global config, _is_initialized

    # 初期化済判定。初期化済の場合はconfigを返す
    if _is_initialized:
        return config

    # プロジェクトルート取得
    PROJECT_ROOT = get_project_root(caller_file, depth)

    # 環境変数を設定
    set_env(PROJECT_ROOT)

    # アプリケーションを初期化する
    app.init_app(PersonyxConfig, __file__)
    config = app.get_config(PersonyxConfig)

    # 初期化フラグを倒す
    _is_initialized = True

    # configを返す
    return config
