#!/usr/bin/env bash
# Blue-team side: run the detection from detect/sigma-cmdi.yml against the app's
# logs and show it firing on the attack you just ran.
#
# In production this Sigma rule runs in your SIEM. Here we translate the same
# selections into grep so you see it work with zero infrastructure. The signal:
# shell metacharacters or command names in the request parameter.
set -uo pipefail

LOGFILE="/var/log/app/access.log"
echo "[*] Reading /ping requests from the target's logs..."

# Same tokens as the Sigma rule's selections.
PATTERN=';|\||&&|\$\(|`|>|cat |whoami|/etc/passwd|curl |wget |nc '

HITS=$(docker compose exec -T target grep -Ei "$PATTERN" "$LOGFILE" 2>/dev/null || true)

if [ -n "$HITS" ]; then
  COUNT=$(printf '%s\n' "$HITS" | grep -c .)
  echo "[+] ALERT: $COUNT command-injection indicator(s) detected:"
  echo "-------------------------------------------------------------"
  printf '%s\n' "$HITS"
  echo "-------------------------------------------------------------"
  echo "[+] Detection fired (MITRE T1059). This is what your SOC would triage."
else
  echo "[-] No injection indicators found. Run 'make attack' first."
fi
