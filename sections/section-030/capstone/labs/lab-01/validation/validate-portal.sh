#!/usr/bin/env bash
# Check: The portal serves all five services including beacon, with real owners and an updated date of 2026-11-01 or later
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
names_ok() { [ "$(fetch | jq -r '[.services[].name] | sort | join(",")')" = "beacon,drifter,probe,scout,shuttle" ]; }
if ! retry 24 5 names_ok; then echo "FAIL: the served list does not contain exactly beacon, drifter, probe, scout and shuttle"; fail=1; fi
fresh_ok() { local u; u="$(fetch | jq -r '.updated // empty')"; [ -n "$u" ] && [[ ! "$u" < "2026-11-01" ]]; }
if ! retry 3 2 fresh_ok; then echo "FAIL: the served updated date is missing or before 2026-11-01"; fail=1; fi
owners_ok() { fetch | jq -e '[.services[] | select((.owner // "") == "" or .owner == "unassigned")] | length == 0' >/dev/null; }
if ! retry 3 2 owners_ok; then echo "FAIL: an entry has no real owner"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: The portal serves all five services including beacon, with real owners and an updated date of 2026-11-01 or later"; fi
exit "$fail"
