#!/usr/bin/env bash
# Check: ConfigMap catalog-report in the namespace catalog has total, owners and dangling that match the live catalog
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
r="$(kubectl -n catalog get configmap catalog-report -o json 2>/dev/null)"
if [ -z "$r" ]; then echo "FAIL: ConfigMap catalog-report does not exist in the namespace catalog"; fail=1
else
  total="$($ENT 2>/dev/null | jq -r '.items | length')"
  owners="$($ENT 2>/dev/null | jq -r '[.items[].spec.owner] | unique | length')"
  dang="$(dangling | grep -c . || true)"
  [ "$(echo "$r" | jq -r '.data.total // empty')" = "$total" ] || { echo "FAIL: report total is not $total"; fail=1; }
  [ "$(echo "$r" | jq -r '.data.owners // empty')" = "$owners" ] || { echo "FAIL: report owners is not $owners"; fail=1; }
  [ "$(echo "$r" | jq -r '.data.dangling // empty')" = "$dang" ] || { echo "FAIL: report dangling is not $dang"; fail=1; }
  [ "$total" = "5" ] || { echo "FAIL: the catalog should hold 5 entities, found $total"; fail=1; }
fi

if [ "$fail" -eq 0 ]; then echo "PASS: ConfigMap catalog-report in the namespace catalog has total, owners and dangling that match the live catalog"; fi
exit "$fail"
