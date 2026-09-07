"""
Login service for Hack & Detect lab det-01 (Detection Engineering).

This service is not "vulnerable" in the code-bug sense — it just authenticates
users and logs every attempt in a realistic format. The lab is about the BLUE
side: generating brute-force traffic and then engineering a detection that spots
the compromise in the logs. The admin password is intentionally weak so a small
wordlist finds it.
"""
import os
from datetime import datetime, timezone
from flask import Flask, request, jsonify

LOG = "/var/log/app/auth.log"
USERS = {"admin": "sunshine"}          # weak on purpose
FLAG = "HND{brut3_f0rc3_cr3d_4cc3ss_t1110}"

app = Flask(__name__)


def log(result, ip, user):
    os.makedirs(os.path.dirname(LOG), exist_ok=True)
    line = f"{datetime.now(timezone.utc).isoformat()} event=auth result={result} src={ip} user={user}\n"
    with open(LOG, "a") as f:
        f.write(line)


@app.route("/login", methods=["POST"])
def login():
    user = request.form.get("username", "")
    pw = request.form.get("password", "")
    ip = request.headers.get("X-Forwarded-For", request.remote_addr)

    if USERS.get(user) == pw:
        log("success", ip, user)
        return jsonify(message="Welcome!", secret=FLAG)
    log("failure", ip, user)
    return jsonify(error="invalid credentials"), 401


@app.route("/healthz")
def healthz():
    return "ok"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
