from pycorex.configs.pycorex import PyCorexConfig
from bot.models.discord import DiscordModel

class PersonyxConfig(PyCorexConfig):
    """
    Personyx共通設定クラス
    """
    
    discord: DiscordModel = DiscordModel()
    """ Discord設定クラスモデル"""
