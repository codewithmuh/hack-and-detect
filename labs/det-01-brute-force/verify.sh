#!/usr/bin/env bash
# Objective grading for det-01. Two checks:
#   1. RED  — the brute force finds the password and retrieves the flag
#   2. BLUE — the correlation detection flags the compromise in the auth log
# Exits non-zero on FAIL.
set -uo pipefail

TARGET="${TARGET:-http://127.0.0.1:8080}"
EXPECTED_SHA="0c9a9ee4bccd7cf5aab3ed213604d3d302608475a1d2a779609960643069c1f7"
LOGFILE="/var/log/app/auth.log"
WORDLIST="$(dirname "$0")/attack/wordlist.txt"
THRESHOLD=5
pass=1

sha256() { shasum -a 256 2>/dev/null | awk '{print $1}' || sha256sum | awk '{print $1}'; }

echo "== Check 1: brute force retrieves the flag (red) =="
FLAG=""
while IFS= read -r pw; do
  [ -z "$pw" ] && continue
  body=$(curl -s -X POST "$TARGET/login" --data-urlencode "username=admin" --data-urlencode "password=$pw")
  case "$body" in *HND{*) FLAG=$(printf '%s' "$body" | grep -o 'HND{[^}]*}'); break;; esac
done < "$WORDLIST"
if [ "$(printf '%s' "$FLAG" | sha256)" = "$EXPECTED_SHA" ]; then
  echo "  [PASS] brute force found the password and got the flag"
else
  echo "  [FAIL] no flag (hardened target locked the account, or app down?)"
  pass=0
fi

echo "== Check 2: correlation detection fires (blue) =="
ALERT=$(docker compose exec -T target sh -c "cat $LOGFILE 2>/dev/null" | awk -v th="$THRESHOLD" '
  { r="";s="";u="";
    for(i=1;i<=NF;i++){ if($i~/^result=/)r=substr($i,8); if($i~/^src=/)s=substr($i,5); if($i~/^user=/)u=substr($i,6) }
    k=s SUBSEP u
    if(r=="failure") f[k]++
    else if(r=="success" && f[k]>=th) hit=1 }
  END { print (hit?"ALERT":"") }')
if [ "$ALERT" = "ALERT" ]; then
  echo "  [PASS] detection correlated failures-then-success (compromise)"
else
  echo "  [FAIL] detection saw no compromise — run 'make attack' first"
  pass=0
fi

echo "--------------------------------------------"
if [ "$pass" -eq 1 ]; then
  echo "PASS — brute force succeeded AND your detection caught it."
  exit 0
else
  echo "FAIL"
  exit 1
fi
