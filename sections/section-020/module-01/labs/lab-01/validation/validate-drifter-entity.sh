#!/usr/bin/env bash
# Check: Entity drifter is a Component with lifecycle experimental, owner group:outpost-team and a dependency on component:scout
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

e="$(kubectl -n catalog get catalogentities.catalog.starfleet.example drifter -o json 2>/dev/null)"
if [ -z "$e" ]; then echo "FAIL: entity drifter does not exist in the namespace catalog"; fail=1
else
  [ "$(echo "$e" | jq -r '.spec.kind')" = "Component" ] || { echo "FAIL: drifter kind is not Component"; fail=1; }
  [ "$(echo "$e" | jq -r '.spec.lifecycle')" = "experimental" ] || { echo "FAIL: drifter lifecycle is not experimental"; fail=1; }
  [ "$(echo "$e" | jq -r '.spec.owner')" = "group:outpost-team" ] || { echo "FAIL: drifter owner is not group:outpost-team"; fail=1; }
  [ "$(echo "$e" | jq -r '[.spec.dependsOn[]? | select(. == "component:scout")] | length')" = "1" ] || { echo "FAIL: drifter does not depend on component:scout"; fail=1; }
fi

if [ "$fail" -eq 0 ]; then echo "PASS: Entity drifter is a Component with lifecycle experimental, owner group:outpost-team and a dependency on component:scout"; fi
exit "$fail"
