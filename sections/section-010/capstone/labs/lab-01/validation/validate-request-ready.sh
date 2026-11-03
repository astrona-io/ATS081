#!/usr/bin/env bash
# Check: The EnvironmentRequest starter in team-alpha has owner alpha-team, phase Ready and a Ready condition with status True
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

r="$(kubectl -n team-alpha get environmentrequest starter -o json 2>/dev/null)"
if [ -z "$r" ]; then echo "FAIL: request starter does not exist"; fail=1
else
  if [ "$(echo "$r" | jq -r '.spec.owner')" != "alpha-team" ]; then echo "FAIL: owner is not alpha-team"; fail=1; fi
  if [ "$(echo "$r" | jq -r '.status.phase // empty')" != "Ready" ]; then echo "FAIL: phase is not Ready"; fail=1; fi
  if [ "$(echo "$r" | jq -r '[.status.conditions[]? | select(.type=="Ready" and .status=="True")] | length')" != "1" ]; then echo "FAIL: no Ready condition with status True"; fail=1; fi
fi

if [ "$fail" -eq 0 ]; then echo "PASS: The EnvironmentRequest starter in team-alpha has owner alpha-team, phase Ready and a Ready condition with status True"; fi
exit "$fail"
