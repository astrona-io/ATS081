#!/usr/bin/env bash
# Check: Entity scout was reviewed on 2026-11-01 or later and no entity has a review date before 2026-08-01 or none
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
s="$(kubectl -n catalog get catalogentities.catalog.starfleet.example scout -o jsonpath='{.metadata.annotations.catalog\.starfleet\.example/last-reviewed}' 2>/dev/null)"
if [ -z "$s" ] || [[ "$s" < "2026-11-01" ]]; then echo "FAIL: scout last-reviewed is '$s', expected 2026-11-01 or later"; fail=1; fi
stale="$($ENT 2>/dev/null | jq -r --arg c "2026-08-01" '.items[] | select((.metadata.annotations["catalog.starfleet.example/last-reviewed"] // "") < $c) | .metadata.name')"
if [ -n "$stale" ]; then echo "FAIL: stale entities: $(echo $stale)"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: Entity scout was reviewed on 2026-11-01 or later and no entity has a review date before 2026-08-01 or none"; fi
exit "$fail"
