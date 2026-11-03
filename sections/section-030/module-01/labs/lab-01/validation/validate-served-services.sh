#!/usr/bin/env bash
# Check: The portal serves a list with the services scout, probe, shuttle and drifter
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
names_ok() { [ "$(fetch | jq -r '[.services[].name] | sort | join(",")')" = "drifter,probe,scout,shuttle" ]; }
if ! retry 24 5 names_ok; then echo "FAIL: the served list does not contain exactly drifter, probe, scout and shuttle"; fail=1; fi
ready="$(kubectl -n portal get deployment portal -o jsonpath='{.status.availableReplicas}' 2>/dev/null)"
if [ "$ready" != "1" ]; then echo "FAIL: the portal Deployment is not available"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: The portal serves a list with the services scout, probe, shuttle and drifter"; fi
exit "$fail"
