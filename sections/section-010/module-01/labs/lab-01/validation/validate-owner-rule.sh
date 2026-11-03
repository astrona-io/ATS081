#!/usr/bin/env bash
# Check: An owner without the suffix -team is rejected with the message "owner must end with -team"
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
rejected_with_message() {
  local msg
  msg="$(dry "  owner: jason" 2>&1)" && return 1
  echo "$msg" | grep -q "owner must end with -team"
}
if ! retry 12 5 rejected_with_message; then echo "FAIL: owner jason is not rejected with the required message"; fail=1; fi
if ! dry "  owner: alpha-team" >/dev/null 2>&1; then echo "FAIL: owner alpha-team is rejected"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: An owner without the suffix -team is rejected with the message \"owner must end with -team\""; fi
exit "$fail"
