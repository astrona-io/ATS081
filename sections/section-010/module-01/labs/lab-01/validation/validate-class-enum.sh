#!/usr/bin/env bash
# Check: Classes small and medium are accepted and any other class is rejected
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
ok_class() { dry "  owner: alpha-team\n  class: medium" >/dev/null 2>&1 && dry "  owner: alpha-team\n  class: small" >/dev/null 2>&1; }
bad_class() { ! dry "  owner: alpha-team\n  class: huge" >/dev/null 2>&1; }
if ! retry 3 2 ok_class; then echo "FAIL: class small or medium is rejected"; fail=1; fi
if ! retry 12 5 bad_class; then echo "FAIL: class huge is accepted"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: Classes small and medium are accepted and any other class is rejected"; fi
exit "$fail"
