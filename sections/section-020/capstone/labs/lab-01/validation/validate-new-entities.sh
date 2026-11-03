#!/usr/bin/env bash
# Check: Entity telemetry-db is a production Resource owned by group:starfleet-team and entity drifter is an experimental Component owned by group:outpost-team
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

get() { kubectl -n catalog get catalogentities.catalog.starfleet.example "$1" -o json 2>/dev/null; }
t="$(get telemetry-db)"
if [ -z "$t" ]; then echo "FAIL: entity telemetry-db does not exist"; fail=1
else
  [ "$(echo "$t" | jq -r '[.spec.kind,.spec.lifecycle,.spec.owner]|join(",")')" = "Resource,production,group:starfleet-team" ] || { echo "FAIL: telemetry-db must be a production Resource owned by group:starfleet-team"; fail=1; }
fi
d="$(get drifter)"
if [ -z "$d" ]; then echo "FAIL: entity drifter does not exist"; fail=1
else
  [ "$(echo "$d" | jq -r '[.spec.kind,.spec.lifecycle,.spec.owner]|join(",")')" = "Component,experimental,group:outpost-team" ] || { echo "FAIL: drifter must be an experimental Component owned by group:outpost-team"; fail=1; }
fi

if [ "$fail" -eq 0 ]; then echo "PASS: Entity telemetry-db is a production Resource owned by group:starfleet-team and entity drifter is an experimental Component owned by group:outpost-team"; fi
exit "$fail"
