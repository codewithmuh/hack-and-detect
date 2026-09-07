"""
Deliberately vulnerable search app for Hack & Detect lab web-03.
DO NOT deploy this. It reflects user input into HTML without encoding on purpose.
"""
import os
from datetime import datetime, timezone
from flask import Flask, request, Response

LOG = "/var/log/app/access.log"
FLAG = "HND{r3fl3ct3d_xss_unescaped_0utput}"

app = Flask(__name__)

PAGE = """<!doctype html>
<title>Product search</title>
<h1>Search our catalog</h1>
<form action="/" method="get">
  <input name="q" placeholder="search..." value="{q}">
  <button>Search</button>
</form>
<p>Results for: {q}</p>
<!-- If your input renders as HTML here, a victim's browser will execute it. -->
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
    # VULNERABLE: `q` is interpolated straight into HTML, unescaped.
    return Response(PAGE.format(q=q), mimetype="text/html")


@app.route("/healthz")
def healthz():
    return "ok"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
