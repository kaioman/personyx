import os
from flask import Flask, render_template, request, send_from_directory, redirect, url_for, session
from requests_oauthlib import OAuth2Session
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, joinedload
from models.images import Images
from models.users import Users
from models.user_accounts import UserAccounts

app = Flask(__name__, template_folder="templates")
app.secret_key = os.environ.get("FLASK_SECRET_KEY", os.urandom(24))

# OAuth2 settings
DISCORD_CLIENT_ID = os.getenv("DISCORD_CLIENT_ID")
DISCORD_CLIENT_SECRET = os.getenv("DISCORD_CLIENT_SECRET")
DISCORD_REDIRECT_URI = os.getenv("DISCORD_REDIRECT_URI")
DISCORD_AUTH_BASE = "https://discord.com/api/oauth2/authorize"
DISCORD_TOKEN_URL = "https://discord.com/api/oauth2/token"
DISCORD_USER_API = "https://discord.com/api/users/@me"
DISCORD_SCOPE = ["identify"]

# データベース設定
gen_images_root = "/app/gen_images"
GEN_IMAGES_DIR = os.environ.get("GEN_IMAGES_DIR", gen_images_root)
DATABASE_URL = os.environ.get(
    "DATABASE_URL",
    "postgresql+psycopg2://personyx:personyx@personyx_db:5432/personyx_pg12"
)
ITEMS_PER_PAGE = 24

# SQLAlchemy engine + session
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(bind=engine, autoflush=False, autocommit=False)

class Database:
    def __init__(self, session_factory):
        self._session_factory = session_factory

    @property
    def session(self):
        return self._session_factory()


db = Database(SessionLocal)

@app.route("/gen_images/<path:filename>")
def gen_image_file(filename):
    return send_from_directory(GEN_IMAGES_DIR, filename)

@app.route("/images")
def images():
    rating = request.args.get("rating", type=int)
    scene_id = request.args.get("scene_id", type=str)
    user_name = session.get("user_name")

    with SessionLocal() as db_session:
        # distinct lists for dropdowns
        ratings = [r[0] for r in db_session.query(Images.rating_level).distinct().order_by(Images.rating_level).all()]
        scene_ids = [s[0] for s in db_session.query(Images.scene_id).distinct().order_by(Images.scene_id).all()]

        q = db_session.query(Images).options(joinedload(Images.user))
        if rating is not None:
            q = q.filter(Images.rating_level == rating)
        if scene_id:
            q = q.filter(Images.scene_id == scene_id)

        items = q.order_by(Images.created_at.desc()).limit(200).all()

    return render_template(
        "images.html",
        images=items,
        ratings=ratings,
        scene_ids=scene_ids,
        selected_rating=rating,
        selected_scene_id=scene_id,
        items_per_page=ITEMS_PER_PAGE,
        user_name=user_name
    )

@app.route("/login")
def login():
    discord = OAuth2Session(
        client_id=DISCORD_CLIENT_ID,
        redirect_uri=DISCORD_REDIRECT_URI,
        scope=DISCORD_SCOPE
    )
    authorization_url, state = discord.authorization_url(DISCORD_AUTH_BASE)
    session["oauth2_state"] = state
    return redirect(authorization_url)


@app.route("/callback")
def callback():
    state = session.get("oauth2_state")
    if state is None:
        return redirect(url_for("index"))

    discord = OAuth2Session(
        client_id=DISCORD_CLIENT_ID,
        redirect_uri=DISCORD_REDIRECT_URI,
        state=state
    )
    discord.fetch_token(
        DISCORD_TOKEN_URL,
        client_secret=DISCORD_CLIENT_SECRET,
        authorization_response=request.url
    )

    discord_user = discord.get(DISCORD_USER_API).json()
    provider_user_id = str(discord_user.get("id"))
    username = discord_user.get("username")
    if not provider_user_id or not username:
        return redirect(url_for("index"))

    with db.session as db_session:
        account = db_session.query(UserAccounts).filter_by(
            provider="discord",
            provider_user_id=provider_user_id
        ).one_or_none()

        if account:
            user_id = account.user_id
        else:
            user = Users(display_name=username)
            db_session.add(user)
            db_session.flush()

            account = UserAccounts(
                user_id=user.id,
                provider="discord",
                provider_user_id=provider_user_id
            )
            db_session.add(account)
            db_session.commit()
            user_id = user.id

    session.clear()
    session["user_id"] = str(user_id)
    session["user_name"] = username

    return redirect(url_for("index"))


@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("index"))

@app.route("/")
def index():
    return render_template("index.html")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
