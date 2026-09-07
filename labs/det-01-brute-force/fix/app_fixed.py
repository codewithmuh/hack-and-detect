"""
Hardened login service. The detection tells you an attack happened; this stops it.

Fix: account lockout / rate limiting. After MAX_FAILS failed attempts for an
account within WINDOW seconds, further attempts are refused with HTTP 429 for
LOCKOUT seconds — even if the password is correct. A 10-word wordlist can no
longer walk straight to the right password.

Real systems layer this with MFA, strong-password policy, and CAPTCHA, plus the
detection you just built (lockout + alerting, not one or the other).
"""
import os
import time
from collections import defaultdict
from datetime import datetime, timezone
from flask import Flask, request, jsonify

LOG = "/var/log/app/auth.log"
USERS = {"admin": "sunshine"}
FLAG = "HND{brut3_f0rc3_cr3d_4cc3ss_t1110}"

MAX_FAILS = 5
WINDOW = 300      # seconds to count failures over
LOCKOUT = 900     # seconds locked once tripped

app = Flask(__name__)
_fails = defaultdict(list)   # user -> [timestamps]
_locked_until = defaultdict(float)


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
    now = time.time()

    if now < _locked_until[user]:
        log("locked", ip, user)
        return jsonify(error="account temporarily locked"), 429

    if USERS.get(user) == pw:
        _fails[user].clear()
        log("success", ip, user)
        return jsonify(message="Welcome!", secret=FLAG)

    # record failure within the rolling window
    _fails[user] = [t for t in _fails[user] if now - t <= WINDOW] + [now]
    log("failure", ip, user)
    if len(_fails[user]) >= MAX_FAILS:
        _locked_until[user] = now + LOCKOUT
        log("locked", ip, user)
    return jsonify(error="invalid credentials"), 401


@app.route("/healthz")
def healthz():
    return "ok"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
