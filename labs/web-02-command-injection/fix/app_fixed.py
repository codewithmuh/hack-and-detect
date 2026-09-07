"""
Patched network-tools app. Two changes kill the injection:

1. No shell. subprocess is called with an ARGUMENT LIST and shell=False, so the
   OS runs `ping` directly with `host` as a single argument — shell metacharacters
   like ; | $() have no meaning and can't start a second command.
2. Input validation. `host` must match a strict hostname/IP allowlist regex, so
   junk is rejected before it ever reaches the command.

Defense in depth: either change alone stops this attack; together they're robust.
"""
import os
import re
import subprocess
from datetime import datetime, timezone
from flask import Flask, request, jsonify

LOG = "/var/log/app/access.log"
# letters, digits, dot, hyphen only — valid hostnames and IPv4 addresses
HOST_RE = re.compile(r"^[A-Za-z0-9.-]{1,253}$")

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
    log("ping", ip, "host", host)

    # FIXED 1: validate input against a strict allowlist.
    if not HOST_RE.match(host):
        log("rejected", ip, "host", host)
        return jsonify(error="invalid host"), 400

    # FIXED 2: no shell. Args are passed as a list; host is a single argument.
    out = subprocess.run(
        ["ping", "-c", "1", host], capture_output=True, text=True, timeout=5
    )
    return jsonify(cmd=f"ping -c 1 {host}", output=out.stdout + out.stderr)


@app.route("/healthz")
def healthz():
    return "ok"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
