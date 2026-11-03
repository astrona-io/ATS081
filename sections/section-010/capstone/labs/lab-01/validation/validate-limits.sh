#!/usr/bin/env bash
# Check: LimitRange team-limits sets container memory default 128Mi, default request 64Mi and maximum 512Mi
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

l="$(kubectl -n team-alpha get limitrange team-limits -o json 2>/dev/null)"
f='.spec.limits[] | select(.type=="Container")'
if [ "$(echo "$l" | jq -r "$f | .default.memory // empty")" != "128Mi" ]; then echo "FAIL: default memory is not 128Mi"; fail=1; fi
if [ "$(echo "$l" | jq -r "$f | .defaultRequest.memory // empty")" != "64Mi" ]; then echo "FAIL: default request memory is not 64Mi"; fail=1; fi
if [ "$(echo "$l" | jq -r "$f | .max.memory // empty")" != "512Mi" ]; then echo "FAIL: max memory is not 512Mi"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: LimitRange team-limits sets container memory default 128Mi, default request 64Mi and maximum 512Mi"; fi
exit "$fail"
