#!/usr/bin/env bash
# Check: A request with only an owner gets class small and ttlHours 24
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
got_defaults() {
  local cls ttl
  cls="$(dry "  owner: alpha-team" -o jsonpath='{.spec.class}' 2>/dev/null)"
  ttl="$(dry "  owner: alpha-team" -o jsonpath='{.spec.ttlHours}' 2>/dev/null)"
  [ "$cls" = "small" ] && [ "$ttl" = "24" ]
}
if ! retry 12 5 got_defaults; then echo "FAIL: defaults class=small and ttlHours=24 are not applied"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: A request with only an owner gets class small and ttlHours 24"; fi
exit "$fail"
