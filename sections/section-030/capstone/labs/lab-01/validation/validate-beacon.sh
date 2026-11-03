#!/usr/bin/env bash
# Check: The Deployment beacon in starfleet was rendered from the fixed template: owner outpost-team, entity beacon, golden-path true, probe, memory limit and one available replica
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

b="$(kubectl -n starfleet get deployment beacon -o json 2>/dev/null)"
if [ -z "$b" ]; then echo "FAIL: Deployment beacon does not exist in the namespace starfleet"; fail=1
else
  [ "$(echo "$b" | jq -r '.metadata.labels.owner // empty')" = "outpost-team" ] || { echo "FAIL: beacon owner label is not outpost-team"; fail=1; }
  [ "$(echo "$b" | jq -r '.metadata.labels["catalog.starfleet.example/entity"] // empty')" = "beacon" ] || { echo "FAIL: beacon has no entity label beacon"; fail=1; }
  [ "$(echo "$b" | jq -r '.metadata.labels["platform.starfleet.example/golden-path"] // empty')" = "true" ] || { echo "FAIL: beacon has no golden-path label"; fail=1; }
  [ -n "$(echo "$b" | jq -r '.spec.template.spec.containers[0].readinessProbe // empty')" ] || { echo "FAIL: beacon has no readiness probe"; fail=1; }
  [ -n "$(echo "$b" | jq -r '.spec.template.spec.containers[0].resources.limits.memory // empty')" ] || { echo "FAIL: beacon has no memory limit"; fail=1; }
  [ "$(echo "$b" | jq -r '.status.availableReplicas // 0')" = "1" ] || { echo "FAIL: beacon has no available replica yet"; fail=1; }
fi

if [ "$fail" -eq 0 ]; then echo "PASS: The Deployment beacon in starfleet was rendered from the fixed template: owner outpost-team, entity beacon, golden-path true, probe, memory limit and one available replica"; fi
exit "$fail"
