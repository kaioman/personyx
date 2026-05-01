import os

from flask import Flask, render_template

app = Flask(__name__, template_folder="templates")
DATA_ROOT = "/app/data"


def scan_data_root():
    entries = []
    if os.path.isdir(DATA_ROOT):
        for root, dirs, files in os.walk(DATA_ROOT):
            rel_path = os.path.relpath(root, DATA_ROOT)
            if rel_path == ".":
                rel_path = ""
            entries.append({
                "path": rel_path,
                "dirs": sorted(dirs),
                "files": sorted(files),
            })
    return entries


@app.route("/")
def index():
    data_entries = scan_data_root()
    return render_template("index.html", data_root=DATA_ROOT, entries=data_entries)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
