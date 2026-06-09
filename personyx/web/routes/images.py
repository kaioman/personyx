from flask import Blueprint, render_template, request, session, send_from_directory
from sqlalchemy.orm import joinedload
from web.config import get_app_config
from web.db import get_session
from web.models.images import Images

images_bp = Blueprint("images", __name__)

@images_bp.route("/gen_images/<path:filename>")
def gen_image_file(filename):
    """
    画像パス取得処理
    """
    app_cfg = get_app_config()
    return send_from_directory(app_cfg.gen_images_dir, filename)

@images_bp.route("/images")
def images():
    """
    生成画像ギャラリーページを表示するルート
    """

    # 検索条件取得
    rating = request.args.get("rating", type=int)
    scene_id = request.args.get("scene_id", type=str)

    # ユーザー情報取得
    user_name = session.get("user_name")
    user_id = session.get("user_id")

    # 生成画像情報をDBから取得する
    with get_session() as db_session:
        ratings = [r[0] for r in db_session.query(Images.rating_level).distinct().order_by(Images.rating_level).all()]
        scene_ids = [s[0] for s in db_session.query(Images.scene_id).distinct().order_by(Images.scene_id).all()]

        if user_id is None:
            items = []
        else:
            q = db_session.query(Images).options(joinedload(Images.user))
            q = q.filter(Images.user_id == user_id)
            if rating is not None:
                q = q.filter(Images.rating_level == rating)
            if scene_id:
                q = q.filter(Images.scene_id == scene_id)

            items = q.order_by(Images.created_at.desc()).limit(200).all()

    # アプリ設定取得
    app_cfg = get_app_config()

    # 生成画像ページにリダイレクトする
    return render_template(
        "images.html",
        images=items,
        ratings=ratings,
        scene_ids=scene_ids,
        selected_rating=rating,
        selected_scene_id=scene_id,
        items_per_page=app_cfg.items_per_page,
        user_name=user_name
    )
