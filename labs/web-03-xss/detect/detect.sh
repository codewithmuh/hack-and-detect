#!/usr/bin/env bash
# Blue-team side: run the detection from detect/sigma-xss.yml against the app's
# logs and show it firing on the attack you just ran.
#
# The Sigma rule lives in your SIEM/WAF in production; here we translate its
# selections into grep so you see it work with zero infrastructure. The signal:
# HTML/JS injection markers in the request parameter.
set -uo pipefail
LOGFILE="/var/log/app/access.log"
echo "[*] Reading search requests from the target's logs..."

PATTERN='<script|</script>|<img|<svg|<iframe|onerror=|onload=|onmouseover=|javascript:'
HITS=$(docker compose exec -T target grep -Ei "$PATTERN" "$LOGFILE" 2>/dev/null || true)

if [ -n "$HITS" ]; then
  COUNT=$(printf '%s\n' "$HITS" | grep -c .)
  echo "[+] ALERT: $COUNT XSS indicator(s) detected:"
  echo "-------------------------------------------------------------"
  printf '%s\n' "$HITS"
  echo "-------------------------------------------------------------"
  echo "[+] Detection fired (MITRE T1059.007). This is what your SOC would triage."
else
  echo "[-] No XSS indicators found. Run 'make attack' first."
fi
