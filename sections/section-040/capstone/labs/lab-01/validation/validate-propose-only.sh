#!/usr/bin/env bash
# Check: The assistant can only create ConfigMaps in assistant and cannot update or delete them
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
[ "$(can create configmaps -n assistant)" = "yes" ] || { echo "FAIL: the assistant cannot create ConfigMaps in assistant"; fail=1; }
for verb in update patch delete; do
  [ "$(can $verb configmaps -n assistant)" = "no" ] || { echo "FAIL: the assistant can $verb ConfigMaps in assistant"; fail=1; }
done
[ "$(can create configmaps -n starfleet)" = "no" ] || { echo "FAIL: the assistant can create ConfigMaps in starfleet"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: The assistant can only create ConfigMaps in assistant and cannot update or delete them"; fi
exit "$fail"
