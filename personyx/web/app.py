import os
#from pathlib import Path
from flask import Flask, render_template, request, send_from_directory
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from models.images import Images

app = Flask(__name__, template_folder="templates")
#DATA_ROOT = "/app/data"
#BASE_DIR = os.path.dirname(os.path.abspath(__file__))
gen_images_root = "/app/gen_images"
#print(gen_images_root)
GEN_IMAGES_DIR = os.environ.get("GEN_IMAGES_DIR", gen_images_root)
DATABASE_URL = os.environ.get(
    "DATABASE_URL",
    "postgresql+psycopg2://personyx:personyx@personyx_db:5432/personyx_pg12"
)
ITEMS_PER_PAGE = 24

# SQLAlchemy engine + session
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(bind=engine, autoflush=False, autocommit=False)

@app.route("/gen_images/<path:filename>")
def gen_image_file(filename):
    return send_from_directory(GEN_IMAGES_DIR, filename)

@app.route("/images")
def images():
    rating = request.args.get("rating", type=int)
    scene_id = request.args.get("scene_id", type=str)

    with SessionLocal() as session:
        # distinct lists for dropdowns
        ratings = [r[0] for r in session.query(Images.rating_level).distinct().order_by(Images.rating_level).all()]
        scene_ids = [s[0] for s in session.query(Images.scene_id).distinct().order_by(Images.scene_id).all()]

        q = session.query(Images)
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
        items_per_page=ITEMS_PER_PAGE
    )

# def scan_data_root():
#     entries = []
#     if os.path.isdir(DATA_ROOT):
#         for root, dirs, files in os.walk(DATA_ROOT):
#             rel_path = os.path.relpath(root, DATA_ROOT)
#             if rel_path == ".":
#                 rel_path = ""
#             entries.append({
#                 "path": rel_path,
#                 "dirs": sorted(dirs),
#                 "files": sorted(files),
#             })
#     return entries

@app.route("/")
def index():
    #data_entries = scan_data_root()
    return render_template("index.html")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
