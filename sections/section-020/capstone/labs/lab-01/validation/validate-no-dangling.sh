#!/usr/bin/env bash
# Check: Every dependency of every entity points at an entity that exists, and shuttle still depends on resource:telemetry-db
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

ENT="kubectl -n catalog get catalogentities.catalog.starfleet.example -o json"
dangling() {
  $ENT 2>/dev/null | jq -r '[.items[] | ((.spec.kind | ascii_downcase) + ":" + .metadata.name)] as $ids | .items[] | .metadata.name as $n | .spec.dependsOn[]? | select(. as $d | $ids | any(. == $d) | not) | $n + " -> " + .'
}
d="$(dangling)"
if [ -n "$d" ]; then echo "FAIL: dangling references remain: $d"; fail=1; fi
k="$(kubectl -n catalog get catalogentities.catalog.starfleet.example shuttle -o json 2>/dev/null | jq -r '[.spec.dependsOn[]? | select(. == "resource:telemetry-db")] | length')"
if [ "$k" != "1" ]; then echo "FAIL: shuttle no longer depends on resource:telemetry-db"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: Every dependency of every entity points at an entity that exists, and shuttle still depends on resource:telemetry-db"; fi
exit "$fail"
