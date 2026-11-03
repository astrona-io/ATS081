#!/usr/bin/env bash
# Check: Group team-alpha-developers can create requests only in team-alpha and cannot write status or create Deployments
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

can() { kubectl auth can-i "$@" --as=dev-jason --as-group=team-alpha-developers 2>/dev/null; }
R=environmentrequests.platform.starfleet.example
if [ "$(can create "$R" -n team-alpha)" != "yes" ]; then echo "FAIL: the group cannot create requests in team-alpha"; fail=1; fi
if [ "$(can create "$R" -n outpost)" != "no" ]; then echo "FAIL: the group can create requests in outpost"; fail=1; fi
if [ "$(can patch "$R" --subresource=status -n team-alpha)" != "no" ]; then echo "FAIL: the group can write request status"; fail=1; fi
if [ "$(can create deployments -n team-alpha)" != "no" ]; then echo "FAIL: the group can create Deployments"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: Group team-alpha-developers can create requests only in team-alpha and cannot write status or create Deployments"; fi
exit "$fail"
