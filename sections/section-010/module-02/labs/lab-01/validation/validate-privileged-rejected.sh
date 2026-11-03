#!/usr/bin/env bash
# Check: A privileged pod in team-beta is rejected and the namespace outpost has no tenant label
set -uo pipefail
fail=0
retry() {
  local attempts="$1" pause="$2"
  shift 2
  for _ in $(seq 1 "$attempts"); do
    if "$@"; then return 0; fi
    sleep "$pause"
  done
  return 1
}
rejected() {
  printf 'apiVersion: v1\nkind: Pod\nmetadata:\n  name: privileged-check\n  namespace: team-beta\nspec:\n  containers:\n    - name: c\n      image: ghcr.io/stefanprodan/podinfo:6.15.0\n      securityContext:\n        privileged: true\n' | kubectl create --dry-run=server -f - >/dev/null 2>&1 && return 1
  return 0
}
retry 6 3 rejected || { echo "FAIL: a privileged pod is accepted in team-beta"; fail=1; }
o="$(kubectl get ns outpost -o jsonpath='{.metadata.labels.platform\.starfleet\.example/tenant}' 2>/dev/null)"
[ -z "$o" ] || { echo "FAIL: outpost was changed"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: A privileged pod in team-beta is rejected and the namespace outpost has no tenant label"; fi
exit "$fail"
