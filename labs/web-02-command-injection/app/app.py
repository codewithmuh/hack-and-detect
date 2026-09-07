"""
Deliberately vulnerable "network tools" app for Hack & Detect lab web-02.
DO NOT deploy this. It runs a shell command built from user input on purpose.
"""
import os
import subprocess
from datetime import datetime, timezone
from flask import Flask, request, jsonify

LOG = "/var/log/app/access.log"

app = Flask(__name__)


def log(event, ip, field, raw):
    os.makedirs(os.path.dirname(LOG), exist_ok=True)
    line = f'{datetime.now(timezone.utc).isoformat()} event={event} ip={ip} field={field} payload="{raw}"\n'
    with open(LOG, "a") as f:
        f.write(line)


@app.route("/ping")
def ping():
    host = request.args.get("host", "")
    ip = request.headers.get("X-Forwarded-For", request.remote_addr)

    # VULNERABLE: user input is concatenated into a shell command.
    cmd = f"ping -c 1 {host}"
    log("ping", ip, "host", cmd)

    # shell=True means ;  |  $()  &&  all work — this is the bug.
    out = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=5)
    return jsonify(cmd=cmd, output=out.stdout + out.stderr)


@app.route("/healthz")
def healthz():
    return "ok"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
