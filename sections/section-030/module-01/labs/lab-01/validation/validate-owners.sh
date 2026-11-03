#!/usr/bin/env bash
# Check: Every served entry has a real owner, probe is owned by starfleet-team and drifter by outpost-team
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

fetch() { kubectl -n outpost exec deploy/drifter -- curl -fsS --max-time 5 http://portal.portal.svc.cluster.local/services.json 2>/dev/null; }
owners_ok() {
  fetch | jq -e '[.services[] | select((.owner // "") == "" or .owner == "unassigned")] | length == 0' >/dev/null &&
  [ "$(fetch | jq -r '.services[] | select(.name=="probe") | .owner')" = "starfleet-team" ] &&
  [ "$(fetch | jq -r '.services[] | select(.name=="drifter") | .owner')" = "outpost-team" ]
}
if ! retry 24 5 owners_ok; then echo "FAIL: an entry has no real owner, probe is not owned by starfleet-team or drifter is not owned by outpost-team"; fail=1; fi
fields_ok() { fetch | jq -e '[.services[] | select((.lifecycle // "") == "" or (.docs // "") == "")] | length == 0' >/dev/null; }
if ! retry 3 2 fields_ok; then echo "FAIL: an entry has no lifecycle or docs"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: Every served entry has a real owner, probe is owned by starfleet-team and drifter by outpost-team"; fi
exit "$fail"
