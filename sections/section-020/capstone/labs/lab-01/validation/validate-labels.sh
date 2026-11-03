#!/usr/bin/env bash
# Check: The Deployments scout, probe, shuttle and drifter carry the label catalog.starfleet.example/entity with their own name
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

for pair in starfleet/scout starfleet/probe starfleet/shuttle outpost/drifter; do
  ns="${pair%%/*}"; name="${pair##*/}"
  got="$(kubectl -n "$ns" get deployment "$name" -o jsonpath='{.metadata.labels.catalog\.starfleet\.example/entity}' 2>/dev/null)"
  if [ "$got" != "$name" ]; then echo "FAIL: deployment $ns/$name has no label catalog.starfleet.example/entity=$name"; fail=1; fi
done

if [ "$fail" -eq 0 ]; then echo "PASS: The Deployments scout, probe, shuttle and drifter carry the label catalog.starfleet.example/entity with their own name"; fi
exit "$fail"
