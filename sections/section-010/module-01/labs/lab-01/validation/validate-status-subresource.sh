#!/usr/bin/env bash
# Check: The CRD serves a status subresource
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
if ! kubectl get crd "$CRD" -o json 2>/dev/null | jq -e '.spec.versions[0].subresources.status != null' >/dev/null; then
  echo "FAIL: the CRD has no status subresource"; fail=1
fi

if [ "$fail" -eq 0 ]; then echo "PASS: The CRD serves a status subresource"; fi
exit "$fail"
