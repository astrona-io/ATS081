#!/usr/bin/env bash
# Check: ResourceQuota team-quota in team-alpha allows 6 pods and 2 CPU of requests
set -uo pipefail
fail=0
# retry <attempts> <seconds> <command...>: run the command until it succeeds.
retry() {
  local attempts="$1" pause="$2"
  shift 2
  for _ in $(seq 1 "$attempts"); do
    if "$@"; then return 0; fi
    sleep "$pause"
  done
  return 1
}

q="$(kubectl -n team-alpha get resourcequota team-quota -o json 2>/dev/null)"
if [ "$(echo "$q" | jq -r '.spec.hard.pods // empty')" != "6" ]; then echo "FAIL: pods hard limit is not 6"; fail=1; fi
if [ "$(echo "$q" | jq -r '.spec.hard["requests.cpu"] // empty')" != "2" ]; then echo "FAIL: requests.cpu hard limit is not 2"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: ResourceQuota team-quota in team-alpha allows 6 pods and 2 CPU of requests"; fi
exit "$fail"
