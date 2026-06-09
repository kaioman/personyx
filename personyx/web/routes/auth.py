from flask import Blueprint, redirect, request, session, url_for
from requests_oauthlib import OAuth2Session
from web.config import get_app_config
from web.db import get_session
from web.models.user_accounts import UserAccounts
from web.models.users import Users

auth_bp = Blueprint("auth", __name__)

@auth_bp.route("/login")
def login():
    """
    Discordアカウントによるログイン処理
    """

    # アプリ設定取得
    app_cfg = get_app_config()
    # Discord OAuth2セッションインスタンス取得
    discord = OAuth2Session(
        client_id=app_cfg.discord_client_id,
        redirect_uri=app_cfg.discord_redirect_uri,
        scope=app_cfg.discord_scope
    )
    # 認証用URL取得
    authorization_url, state = discord.authorization_url(app_cfg.discord_auth_base)
    session["oauth2_state"] = state
    return redirect(authorization_url)

@auth_bp.route("/callback")
def callback():
    """
    Discordアカウント認証後のコールバック処理
    """

    state = session.get("oauth2_state")
    if state is None:
        return redirect(url_for("main.index"))

    # アプリ設定取得
    app_cfg = get_app_config()
    # Discord OAuth2セッションインスタンス取得
    discord = OAuth2Session(
        client_id=app_cfg.discord_client_id,
        redirect_uri=app_cfg.discord_redirect_uri,
        state=state
    )
    try:
        discord.fetch_token(
            app_cfg.discord_token_url,
            client_secret=app_cfg.discord_secret,
            authorization_response=request.url
        )
    except Exception as e:
        print("fetch_token error:", e)
        raise
    
    # Discord認証情報取得
    discord_user = discord.get(app_cfg.discord_user_api).json()
    provider_user_id = str(discord_user.get("id"))
    username = discord_user.get("username")

    # 認証情報が取得できなかった場合(未ログインの場合)はトップページにリダイレクトする
    if not provider_user_id or not username:
        return redirect(url_for("main.index"))

    with get_session() as db_session:
        
        # ユーザー情報を取得する
        account = db_session.query(UserAccounts).filter_by(
            provider="discord",
            provider_user_id=provider_user_id
        ).one_or_none()

        # ユーザー情報チェック
        if account:
            user_id = account.user_id
        else:
            # ユーザー情報をUserテーブルに追加する
            user = Users(display_name=username)
            db_session.add(user)
            db_session.flush()

            # ユーザー情報(Discord認証情報)をUserAccountsテーブルに追加する
            account = UserAccounts(
                user_id=user.id,
                provider="discord",
                provider_user_id=provider_user_id
            )
            db_session.add(account)
            db_session.commit()
            user_id = user.id

    # セッションにユーザーIDとユーザー名をセットする
    session.clear()
    session["user_id"] = str(user_id)
    session["user_name"] = username

    # トップページにリダイレクトする
    return redirect(url_for("main.index"))

@auth_bp.route("/logout")
def logout():
    """
    ログアウト処理
    """

    # セッションクリア
    session.clear()

    # トップページにリダイレクトする
    return redirect(url_for("main.index"))
