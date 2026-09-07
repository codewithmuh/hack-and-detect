#!/usr/bin/env bash
# Blue-team side: implement the stateful brute-force rule
# (detect/sigma-bruteforce.yml) against the auth log.
#
# The rule fires when a src accumulates >= THRESHOLD failures for a user and then
# logs a success for that same src+user — a likely account compromise. In a SIEM
# this is an event-sequence / correlation search; here we do it with awk.
set -uo pipefail
LOGFILE="/var/log/app/auth.log"
THRESHOLD=5

echo "[*] Correlating failures-then-success per source+user in the auth log..."

REPORT=$(docker compose exec -T target sh -c "cat $LOGFILE 2>/dev/null" | awk -v th="$THRESHOLD" '
  {
    result=""; src=""; user="";
    for (i = 1; i <= NF; i++) {
      if ($i ~ /^result=/) result = substr($i, 8)
      if ($i ~ /^src=/)    src    = substr($i, 5)
      if ($i ~ /^user=/)   user   = substr($i, 6)
    }
    key = src SUBSEP user
    if (result == "failure") fails[key]++
    else if (result == "success" && fails[key] >= th)
      printf "  ALERT  src=%s user=%s compromised after %d failed attempts\n", src, user, fails[key]
  }
')

if [ -n "$REPORT" ]; then
  echo "[+] Brute-force compromise detected:"
  echo "$REPORT"
  echo "[+] Alert your SOC would triage (MITRE T1110). Contain the account + source."
else
  echo "[-] No brute-force compromise detected. Run 'make attack' first."
fi
