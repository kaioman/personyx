from libcore_hng.utils.app_core import AppInitializer
from pycorex.configs import app_init as core_app
from shared.configs.discord import PersonyxConfig

class PersonyxAppInitializer(AppInitializer[PersonyxConfig]):
    """
    AppInitializer拡張クラス
    """
    def __init__(self, base_file: str = __file__, *config_file: str):
        # 基底コンストラクタに拡張Configクラスを渡す
        super().__init__(PersonyxConfig, base_file, *config_file)

core: PersonyxAppInitializer | None = None
""" AppInitializer拡張クラスインスタンス """

def init_app(base_file: str = __file__, *config_file: str) -> PersonyxAppInitializer:
    """
    アプリケーション初期化
    """
    global core
    core = PersonyxAppInitializer(base_file, *config_file)
    if core_app.core is None:
        core_app.init_app(base_file, *config_file)
    return core
