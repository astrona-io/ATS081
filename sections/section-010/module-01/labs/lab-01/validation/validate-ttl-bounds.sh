#!/usr/bin/env bash
# Check: ttlHours accepts 1 to 72 and rejects 0 and 100
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

CRD=environmentrequests.platform.starfleet.example
# dry <spec lines>: send an EnvironmentRequest through the API server without storing it.
dry() {
  printf 'apiVersion: platform.starfleet.example/v1alpha1\nkind: EnvironmentRequest\nmetadata:\n  name: check-request\n  namespace: team-alpha\nspec:\n%b\n' "$1" | kubectl create --dry-run=server -f - "${@:2}"
}
in_bounds() { dry "  owner: alpha-team\n  ttlHours: 1" >/dev/null 2>&1 && dry "  owner: alpha-team\n  ttlHours: 72" >/dev/null 2>&1; }
too_high() { ! dry "  owner: alpha-team\n  ttlHours: 100" >/dev/null 2>&1; }
too_low() { ! dry "  owner: alpha-team\n  ttlHours: 0" >/dev/null 2>&1; }
if ! retry 3 2 in_bounds; then echo "FAIL: ttlHours 1 or 72 is rejected"; fail=1; fi
if ! retry 12 5 too_high; then echo "FAIL: ttlHours 100 is accepted"; fail=1; fi
if ! retry 3 2 too_low; then echo "FAIL: ttlHours 0 is accepted"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: ttlHours accepts 1 to 72 and rejects 0 and 100"; fi
exit "$fail"
