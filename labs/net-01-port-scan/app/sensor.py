"""
Network sensor for Hack & Detect lab net-01.

Listens on a block of TCP ports and logs every connection (src, port, time).
Most ports just accept and close. ONE port hosts a hidden "admin" service that
returns a banner containing the flag. To find it you have to scan the range —
which is exactly the noisy behaviour the detection is built to catch.

This is the VULNERABLE version: it answers everyone, so a scan trivially maps
every open port and discovers the hidden service.
"""
import os
import socket
import threading
from datetime import datetime, timezone

PORT_START = 9000
PORT_END = 9020            # inclusive
HIDDEN_PORT = 9007
FLAG = "HND{p0rt_sc4n_uncl0aks_h1dd3n_svc}"
LOG = "/var/log/sensor/conn.log"


def log(src, port):
    os.makedirs(os.path.dirname(LOG), exist_ok=True)
    ts = datetime.now(timezone.utc).isoformat()
    with open(LOG, "a") as f:
        f.write(f"{ts} src={src} dst_port={port} event=connect\n")


def handle(conn, addr, port):
    src = addr[0]
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
    print(f"sensor up on {PORT_START}-{PORT_END}")
    threading.Event().wait()
