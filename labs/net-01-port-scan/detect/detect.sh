#!/usr/bin/env bash
# Blue-team side: implement the Sigma aggregation rule (detect/sigma-portscan.yml)
# against the sensor's connection log.
#
# The rule: any single src that connected to more than THRESHOLD distinct
# destination ports is scanning. In a SIEM this is a count-by-src aggregation;
# here we do the same with awk so you see it fire with zero infrastructure.
set -uo pipefail
LOGFILE="/var/log/sensor/conn.log"
THRESHOLD=10

echo "[*] Counting distinct destination ports per source in the sensor log..."

REPORT=$(docker compose exec -T target sh -c "cat $LOGFILE 2>/dev/null" | awk -v th="$THRESHOLD" '
  {
    src=""; port="";
    for (i = 1; i <= NF; i++) {
      if ($i ~ /^src=/)      src  = substr($i, 5)
      if ($i ~ /^dst_port=/) port = substr($i, 10)
    }
    if (src != "" && port != "" && !seen[src SUBSEP port]++) count[src]++
  }
  END {
    for (s in count)
      if (count[s] > th) printf "  ALERT  src=%s scanned %d distinct ports\n", s, count[s]
  }
')

if [ -n "$REPORT" ]; then
  echo "[+] Port scan detected:"
  echo "$REPORT"
  echo "[+] This is the alert your SOC would triage (MITRE T1046)."
else
  echo "[-] No scan detected. Run 'make attack' first."
fi
