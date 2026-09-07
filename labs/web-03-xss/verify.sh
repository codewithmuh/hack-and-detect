#!/usr/bin/env bash
# Objective grading for web-03. Two checks:
#   1. RED  — an injected <script> payload is reflected UNESCAPED (would execute)
#   2. BLUE — the detection fires on the XSS payload in the logs
# Exits non-zero on FAIL.
set -uo pipefail

TARGET="${TARGET:-http://127.0.0.1:8080}"
LOGFILE="/var/log/app/access.log"
NONCE="xss$$"
PAYLOAD="<script>${NONCE}</script>"
pass=1

echo "== Check 1: payload reflected unescaped (red) =="
RESP=$(curl -s -G "$TARGET/" --data-urlencode "q=$PAYLOAD" || true)
if printf '%s' "$RESP" | grep -qF "$PAYLOAD"; then
  echo "  [PASS] <script> came back verbatim — a victim's browser would run it"
elif printf '%s' "$RESP" | grep -q "&lt;script&gt;${NONCE}"; then
  echo "  [FAIL] payload was HTML-escaped — target is patched"
  pass=0
else
  echo "  [FAIL] payload not reflected — is the app up?"
  pass=0
fi

echo "== Check 2: detection fires (blue) =="
HITS=$(docker compose exec -T target grep -Eic '<script|onerror=|onload=|javascript:|<img|<svg' "$LOGFILE" 2>/dev/null || echo 0)
if [ "${HITS:-0}" -gt 0 ]; then
  echo "  [PASS] detection matched $HITS XSS indicator(s)"
else
  echo "  [FAIL] detection found nothing — run 'make attack' first"
  pass=0
fi

echo "--------------------------------------------"
if [ "$pass" -eq 1 ]; then
  echo "PASS — reflected XSS confirmed AND detected. Flag: HND{r3fl3ct3d_xss_unescaped_0utput}"
  exit 0
else
  echo "FAIL"
  exit 1
fi
