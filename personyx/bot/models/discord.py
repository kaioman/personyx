from libcore_hng.core.base_config_model import BaseConfigModel

class OAuth2Model(BaseConfigModel):

    app_id: str = ""
    """ アプリID """

    secret_key: str = ""
    """ 秘密鍵 """

class DiscordModel(BaseConfigModel):
    """
    Discord設定クラス
    """

    app_token: str = ""
    """ アプリトークン """

    oauth2: OAuth2Model = OAuth2Model()
    """ OAuth2認証設定 """
