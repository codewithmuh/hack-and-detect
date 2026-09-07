"""
Patched search app. The fix: contextually ENCODE user input before it goes into
HTML, so a payload renders as harmless text instead of executing.

We use markupsafe.escape() (bundled with Flask) to turn  <script>  into
&lt;script&gt;. We also send a Content-Security-Policy header as a second layer:
even if some markup slips through, the browser refuses to run inline script.
"""
import os
from datetime import datetime, timezone
from flask import Flask, request, Response
from markupsafe import escape

LOG = "/var/log/app/access.log"

app = Flask(__name__)

PAGE = """<!doctype html>
<title>Product search</title>
<h1>Search our catalog</h1>
<form action="/" method="get">
  <input name="q" placeholder="search..." value="{q}">
  <button>Search</button>
</form>
<p>Results for: {q}</p>
"""


def log(ip, q):
    os.makedirs(os.path.dirname(LOG), exist_ok=True)
    line = f'{datetime.now(timezone.utc).isoformat()} event=search ip={ip} payload="{q}"\n'
    with open(LOG, "a") as f:
        f.write(line)


@app.route("/")
def home():
    q = request.args.get("q", "")
    ip = request.headers.get("X-Forwarded-For", request.remote_addr)
    if q:
        log(ip, q)
    # FIXED: escape input for the HTML context. <script> becomes &lt;script&gt;.
    safe_q = escape(q)
    resp = Response(PAGE.format(q=safe_q), mimetype="text/html")
    # Defense in depth: block inline script execution.
    resp.headers["Content-Security-Policy"] = "default-src 'self'; script-src 'self'"
    return resp


@app.route("/healthz")
def healthz():
    return "ok"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
