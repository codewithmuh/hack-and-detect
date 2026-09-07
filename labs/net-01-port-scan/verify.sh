#!/usr/bin/env bash
# Objective grading for net-01. Two checks:
#   1. RED  — the port scan discovers the hidden service and leaks the flag
#   2. BLUE — the aggregation detection fires on the scan in the sensor log
# Exits non-zero on FAIL.
set -uo pipefail

HOST="${HOST:-127.0.0.1}"
EXPECTED_SHA="c23b8391c41ea7acc3185b9eb673e3d15748dc9f504a29146a33bb750cb0d0d3"
LOGFILE="/var/log/sensor/conn.log"
THRESHOLD=10
pass=1

sha256() { shasum -a 256 2>/dev/null | awk '{print $1}' || sha256sum | awk '{print $1}'; }

echo "== Check 1: scan discovers the hidden service (red) =="
FLAG=""
for port in $(seq 9000 9020); do
  banner=""
  if exec 3<>"/dev/tcp/$HOST/$port" 2>/dev/null; then
    IFS= read -r -t 1 banner <&3 || true
    exec 3<&- 3>&- 2>/dev/null || true
  fi
  case "$banner" in *HND{*) FLAG=$(printf '%s' "$banner" | grep -o 'HND{[^}]*}');; esac
done
GOT_SHA=$(printf '%s' "$FLAG" | sha256)
if [ "$GOT_SHA" = "$EXPECTED_SHA" ]; then
  echo "  [PASS] found the hidden service and captured the flag"
else
  echo "  [FAIL] hidden service not found (hardened target, or sensor down?)"
  pass=0
fi

echo "== Check 2: detection fires on the scan (blue) =="
MAXPORTS=$(docker compose exec -T target sh -c "cat $LOGFILE 2>/dev/null" | awk '
  { src=""; port="";
    for (i=1;i<=NF;i++){ if($i ~ /^src=/) src=substr($i,5); if($i ~ /^dst_port=/) port=substr($i,10) }
    if (src!="" && port!="" && !seen[src SUBSEP port]++) count[src]++ }
  END { m=0; for (s in count) if (count[s]>m) m=count[s]; print m }')
MAXPORTS=${MAXPORTS:-0}
if [ "$MAXPORTS" -gt "$THRESHOLD" ]; then
  echo "  [PASS] detection saw a source hit $MAXPORTS distinct ports (> $THRESHOLD)"
else
  echo "  [FAIL] no scan pattern in logs — run 'make attack' first"
  pass=0
fi

echo "--------------------------------------------"
if [ "$pass" -eq 1 ]; then
  echo "PASS — you discovered the service by scanning AND you can detect the scan."
  exit 0
else
  echo "FAIL"
  exit 1
fi
