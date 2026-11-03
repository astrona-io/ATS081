#!/usr/bin/env bash
# Check: No entity has the placeholder owner group:unassigned and probe is owned by group:starfleet-team
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
n="$($ENT 2>/dev/null | jq -r '[.items[] | select(.spec.owner == "group:unassigned")] | length')"
if [ "$n" != "0" ]; then echo "FAIL: $n entities still have the owner group:unassigned"; fail=1; fi
o="$(kubectl -n catalog get catalogentities.catalog.starfleet.example probe -o jsonpath='{.spec.owner}' 2>/dev/null)"
if [ "$o" != "group:starfleet-team" ]; then echo "FAIL: probe owner is '$o'"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: No entity has the placeholder owner group:unassigned and probe is owned by group:starfleet-team"; fi
exit "$fail"
