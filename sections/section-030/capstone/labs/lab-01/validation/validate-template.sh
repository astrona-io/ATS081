#!/usr/bin/env bash
# Check: The template renders to a Deployment that passes a server dry run and carries the catalog label, the golden-path label, a readiness probe and a memory limit
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

tpl="$(kubectl -n portal get configmap golden-path-template -o jsonpath='{.data.deployment\.yaml}' 2>/dev/null)"
if [ -z "$tpl" ]; then echo "FAIL: ConfigMap golden-path-template or its key deployment.yaml is missing"; fail=1
else
  out="$(echo "$tpl" | sed -e 's/__NAME__/template-check/g' -e 's/__OWNER__/check-team/g' | kubectl create --dry-run=server -o json -f - 2>/dev/null)"
  if [ -z "$out" ]; then echo "FAIL: the rendered template is rejected by a server dry run"; fail=1
  else
    [ "$(echo "$out" | jq -r '.metadata.labels["catalog.starfleet.example/entity"] // empty')" = "template-check" ] || { echo "FAIL: the template has no catalog entity label set to the service name"; fail=1; }
    [ "$(echo "$out" | jq -r '.metadata.labels["platform.starfleet.example/golden-path"] // empty')" = "true" ] || { echo "FAIL: the template has no golden-path label with the value true"; fail=1; }
    [ "$(echo "$out" | jq -r '.metadata.labels.owner // empty')" = "check-team" ] || { echo "FAIL: the template has no owner label"; fail=1; }
    [ -n "$(echo "$out" | jq -r '.spec.template.spec.containers[0].readinessProbe // empty')" ] || { echo "FAIL: the template has no readiness probe"; fail=1; }
    [ -n "$(echo "$out" | jq -r '.spec.template.spec.containers[0].resources.limits.memory // empty')" ] || { echo "FAIL: the template has no memory limit"; fail=1; }
  fi
fi

if [ "$fail" -eq 0 ]; then echo "PASS: The template renders to a Deployment that passes a server dry run and carries the catalog label, the golden-path label, a readiness probe and a memory limit"; fi
exit "$fail"
