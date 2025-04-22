from flask import Flask, send_from_directory, abort
from pathlib import Path

app = Flask(__name__, static_folder="build/web")

# Add headers for COOP and COEP
@app.after_request
def add_headers(response):
    response.headers["Cross-Origin-Opener-Policy"] = "same-origin"
    response.headers["Cross-Origin-Embedder-Policy"] = "require-corp"
    return response

# Serve all paths (even non-existent ones) as index.html for SPAs
@app.route('/', defaults={'path': 'index.html'})
@app.route('/<path:path>')
def serve(path):
    file_path = Path(app.static_folder) / path
    if file_path.exists():
        return send_from_directory(app.static_folder, path)
    else:
        # If file doesn't exist, serve index.html (SPA behavior)
        return send_from_directory(app.static_folder, 'index.html')

if __name__ == "__main__":
    app.run(debug=True, port=8080, use_reloader=True, extra_files=[app.static_folder])
