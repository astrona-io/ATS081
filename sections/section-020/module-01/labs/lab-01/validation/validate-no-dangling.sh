#!/usr/bin/env bash
# Check: No entity depends on an entity that does not exist, and scout, probe and shuttle are still registered
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
for n in scout probe shuttle; do
  kubectl -n catalog get catalogentities.catalog.starfleet.example "$n" >/dev/null 2>&1 || { echo "FAIL: entity $n was deleted"; fail=1; }
done

if [ "$fail" -eq 0 ]; then echo "PASS: No entity depends on an entity that does not exist, and scout, probe and shuttle are still registered"; fi
exit "$fail"
