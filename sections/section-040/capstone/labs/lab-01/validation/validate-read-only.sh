#!/usr/bin/env bash
# Check: The assistant can read Deployments and Pods in starfleet and cannot change them or read Secrets
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

SA=system:serviceaccount:assistant:ops-assistant
can() { kubectl auth can-i "$@" --as="$SA" 2>/dev/null; }
for what in "list deployments" "get deployments" "list pods" "get pods/log"; do
  [ "$(can $what -n starfleet)" = "yes" ] || { echo "FAIL: the assistant cannot $what in starfleet"; fail=1; }
done
for what in "delete deployments" "patch deployments" "create deployments" "delete pods" "get secrets" "list secrets"; do
  [ "$(can $what -n starfleet)" = "no" ] || { echo "FAIL: the assistant can $what in starfleet"; fail=1; }
done

if [ "$fail" -eq 0 ]; then echo "PASS: The assistant can read Deployments and Pods in starfleet and cannot change them or read Secrets"; fi
exit "$fail"
