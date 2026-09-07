"""
Hardened sensor. Same services, but it defends against scanning:

A source that touches more than THRESHOLD distinct ports within WINDOW seconds is
treated as a scanner and gets blocked — further connections are dropped without a
reply. This models a firewall / port-scan protection (e.g. iptables recent module,
fail2ban, or a cloud security group with connection rate limits).

Effect: the noisy sweep trips the limiter before it can enumerate every port, so
the hidden admin service on 9007 is no longer reliably discoverable.
"""
import os
import socket
import threading
import time
from collections import defaultdict
from datetime import datetime, timezone

PORT_START = 9000
PORT_END = 9020
HIDDEN_PORT = 9007
FLAG = "HND{p0rt_sc4n_uncl0aks_h1dd3n_svc}"
LOG = "/var/log/sensor/conn.log"

THRESHOLD = 5       # distinct ports before we treat the source as a scanner
WINDOW = 10         # seconds
# Note: the active-blocking threshold is tighter than the SIEM *alert* threshold
# (detect/sigma-portscan.yml alerts at >10). Blocking has to trip early — before a
# sweep can walk far enough to reach the hidden service — while the alert can wait
# for a clearly abnormal count. Different jobs, different thresholds.

_lock = threading.Lock()
_hits = defaultdict(list)   # src -> [(ts, port), ...]
_blocked = set()


def log(src, port, event="connect"):
    os.makedirs(os.path.dirname(LOG), exist_ok=True)
    ts = datetime.now(timezone.utc).isoformat()
    with open(LOG, "a") as f:
        f.write(f"{ts} src={src} dst_port={port} event={event}\n")


def is_scanner(src, port):
    now = time.time()
    with _lock:
        if src in _blocked:
            return True
        hits = [(t, p) for (t, p) in _hits[src] if now - t <= WINDOW]
        hits.append((now, port))
        _hits[src] = hits
        distinct = len({p for _, p in hits})
        if distinct > THRESHOLD:
            _blocked.add(src)
            return True
    return False


def handle(conn, addr, port):
    src = addr[0]
    if is_scanner(src, port):
        log(src, port, event="blocked")
        conn.close()
        return
    log(src, port)
    try:
        if port == HIDDEN_PORT:
            conn.sendall(f"220 admin-svc ready {FLAG}\n".encode())
        else:
            conn.sendall(b"\n")
    except OSError:
        pass
    finally:
        conn.close()


def serve(port):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind(("0.0.0.0", port))
    s.listen(50)
    while True:
        conn, addr = s.accept()
        threading.Thread(target=handle, args=(conn, addr, port), daemon=True).start()


if __name__ == "__main__":
    for p in range(PORT_START, PORT_END + 1):
        threading.Thread(target=serve, args=(p,), daemon=True).start()
    print(f"hardened sensor up on {PORT_START}-{PORT_END}")
    threading.Event().wait()
