from flask import Blueprint, redirect, request, session, url_for
from web.db import get_session
from web.service.auth_service import AuthService

auth_bp = Blueprint("auth", __name__)
auth_service = AuthService()

@auth_bp.route("/login")
def login():
    """
    Discordアカウントによるログイン処理
    """

    # AuthServiceから認証URLとstateを取得
    authorization_url, state = auth_service.get_authorization_url()
    # セッションにstateを保存
    session["oauth2_state"] = state

    # 認証ページにリダイレクトする
    return redirect(authorization_url)

@auth_bp.route("/callback")
def callback():
    """
    Discordアカウント認証後のコールバック処理
    """

    # セッションからstateを取得
    state = session.get("oauth2_state")
    if state is None:
        return redirect(url_for("main.index"))

    with get_session() as db_session:
        
        # 認証後のコールバック処理を実行する
        user_info = auth_service.process_callback(
            state=state,
            authorization_response_url=request.url,
            db_session=db_session
        )

        # 認証失敗時にトップページにリダイレクト
        if user_info is None:
            return redirect(url_for("main.index"))
        
        user_id, username = user_info
        
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
