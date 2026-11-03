#!/usr/bin/env bash
# Check: ConfigMap adoption-report in portal has total, goldenPath and coverage that match the live cluster and the served list
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
r="$(kubectl -n portal get configmap adoption-report -o json 2>/dev/null)"
if [ -z "$r" ]; then echo "FAIL: ConfigMap adoption-report does not exist in the namespace portal"; fail=1
else
  all="$(kubectl get deployments -A -o json 2>/dev/null)"
  total="$(echo "$all" | jq -r '[.items[] | select(.metadata.namespace=="starfleet" or .metadata.namespace=="outpost")] | length')"
  gp="$(echo "$all" | jq -r '[.items[] | select((.metadata.namespace=="starfleet" or .metadata.namespace=="outpost") and .metadata.labels["platform.starfleet.example/golden-path"]=="true")] | length')"
  listed="$(fetch | jq -r '.services | length')"
  cov=$(( listed * 100 / total ))
  [ "$(echo "$r" | jq -r '.data.total // empty')" = "$total" ] || { echo "FAIL: report total is not $total"; fail=1; }
  [ "$(echo "$r" | jq -r '.data.goldenPath // empty')" = "$gp" ] || { echo "FAIL: report goldenPath is not $gp"; fail=1; }
  [ "$(echo "$r" | jq -r '.data.coverage // empty')" = "$cov" ] || { echo "FAIL: report coverage is not $cov"; fail=1; }
  [ "$gp" -ge 1 ] || { echo "FAIL: no Deployment carries the golden-path label"; fail=1; }
fi

if [ "$fail" -eq 0 ]; then echo "PASS: ConfigMap adoption-report in portal has total, goldenPath and coverage that match the live cluster and the served list"; fi
exit "$fail"
