#!/usr/bin/env bash
# Check: Deployments without an owner label are denied in team-alpha with a message about owner, and allowed in outpost
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

# deploy <namespace> <labels block>: a Deployment manifest.
deploy() {
  printf 'apiVersion: apps/v1\nkind: Deployment\nmetadata:\n  name: guard-check\n  namespace: %s\n%b\nspec:\n  replicas: 1\n  selector:\n    matchLabels:\n      app: guard-check\n  template:\n    metadata:\n      labels:\n        app: guard-check\n    spec:\n      containers:\n        - name: guard-check\n          image: ghcr.io/stefanprodan/podinfo:6.15.0\n' "$1" "$2"
}
denied_with_message() {
  local msg
  msg="$(deploy team-alpha "" | kubectl create --dry-run=server -f - 2>&1)" && return 1
  echo "$msg" | grep -qi "owner"
}
if ! retry 12 5 denied_with_message; then echo "FAIL: a Deployment without owner label is not denied with a message about owner"; fail=1; fi
if ! deploy team-alpha "  labels:\n    owner: alpha-team" | kubectl create --dry-run=server -f - >/dev/null 2>&1; then echo "FAIL: a labelled Deployment is denied in team-alpha"; fail=1; fi
if ! deploy outpost "" | kubectl create --dry-run=server -f - >/dev/null 2>&1; then echo "FAIL: the policy also blocks the namespace outpost"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: Deployments without an owner label are denied in team-alpha with a message about owner, and allowed in outpost"; fi
exit "$fail"
