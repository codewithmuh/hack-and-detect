#!/usr/bin/env bash
# Blue-team side: run the detection logic from detect/sigma-sqli.yml against the
# app's real logs and show it firing on the attack you just ran.
#
# In production this Sigma rule would run in your SIEM (Splunk, Elastic, etc.).
# Here we translate the same detection into grep so you can see it work with zero
# infrastructure. The signal: SQLi tokens in the login payload/username field.
set -uo pipefail

LOGFILE="/var/log/app/access.log"
echo "[*] Reading login events from the target's logs..."

# Same tokens as the Sigma rule's selections.
PATTERN="-- |/\*|' or |or 1=1|user=\"[^\"]*'"

HITS=$(docker compose exec -T target grep -Ei "$PATTERN" "$LOGFILE" 2>/dev/null || true)

if [ -n "$HITS" ]; then
  COUNT=$(printf '%s\n' "$HITS" | grep -c .)
  echo "[+] ALERT: $COUNT SQL-injection indicator(s) detected:"
  echo "-------------------------------------------------------------"
  printf '%s\n' "$HITS"
  echo "-------------------------------------------------------------"
  echo "[+] Detection fired. This is the alert your SOC would triage."
else
  echo "[-] No SQLi indicators found. Run 'make attack' first."
fi
