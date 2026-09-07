"""
Patched login. The ONLY change that matters: the query is parameterized.
User input is passed as bound values, never concatenated into SQL, so the
database treats  admin' --  as a literal username, not as code. The injection
becomes a failed login instead of an auth bypass.
"""
import os
import sqlite3
from datetime import datetime, timezone
from flask import Flask, request, jsonify

DB = "/tmp/app.db"
LOG = "/var/log/app/access.log"

app = Flask(__name__)


def init_db():
    conn = sqlite3.connect(DB)
    c = conn.cursor()
    c.execute("DROP TABLE IF EXISTS users")
    c.execute("CREATE TABLE users (id INTEGER PRIMARY KEY, username TEXT, password TEXT, secret TEXT)")
    c.execute(
        "INSERT INTO users (username, password, secret) VALUES (?, ?, ?)",
        ("admin", os.urandom(16).hex(), "HND{sql_1nj3ction_l0gin_byp4ss}"),
    )
    conn.commit()
    conn.close()


def log(event, ip, username, raw):
    os.makedirs(os.path.dirname(LOG), exist_ok=True)
    line = f'{datetime.now(timezone.utc).isoformat()} event={event} ip={ip} user="{username}" payload="{raw}"\n'
    with open(LOG, "a") as f:
        f.write(line)


@app.route("/login", methods=["POST"])
def login():
    username = request.form.get("username", "")
    password = request.form.get("password", "")
    ip = request.headers.get("X-Forwarded-For", request.remote_addr)

    # FIXED: parameterized query. Values are bound, not concatenated.
    query = "SELECT secret FROM users WHERE username = ? AND password = ?"
    log("login_attempt", ip, username, f"{query} -- params=({username!r},***)")

    conn = sqlite3.connect(DB)
    try:
        row = conn.execute(query, (username, password)).fetchone()
    except sqlite3.Error as e:
        log("sql_error", ip, username, str(e))
        return jsonify(error="query failed"), 400
    finally:
        conn.close()

    if row:
        log("login_success", ip, username, query)
        return jsonify(message="Welcome!", secret=row[0])
    return jsonify(error="invalid credentials"), 401


@app.route("/healthz")
def healthz():
    return "ok"


if __name__ == "__main__":
    init_db()
    app.run(host="0.0.0.0", port=8080)
