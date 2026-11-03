#!/usr/bin/env bash
# Check: The user platform-reviewer can read and update ConfigMaps in assistant only
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

R=platform-reviewer
can() { kubectl auth can-i "$@" --as="$R" 2>/dev/null; }
for verb in get list update patch; do
  [ "$(can $verb configmaps -n assistant)" = "yes" ] || { echo "FAIL: platform-reviewer cannot $verb ConfigMaps in assistant"; fail=1; }
done
[ "$(can delete configmaps -n assistant)" = "no" ] || { echo "FAIL: platform-reviewer can delete ConfigMaps in assistant"; fail=1; }
[ "$(can update configmaps -n starfleet)" = "no" ] || { echo "FAIL: platform-reviewer can update ConfigMaps in starfleet"; fail=1; }
target="$(kubectl -n assistant get configmaps -l proposal-status=proposed -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)"
if [ -z "$target" ]; then echo "FAIL: no proposal with the status proposed was found"; fail=1
elif ! kubectl -n assistant label configmap "$target" proposal-status=accepted --overwrite --dry-run=server --as="$R" >/dev/null 2>&1; then
  echo "FAIL: platform-reviewer cannot change the status of $target (a server dry run is rejected)"; fail=1
fi

if [ "$fail" -eq 0 ]; then echo "PASS: The user platform-reviewer can read and update ConfigMaps in assistant only"; fi
exit "$fail"
