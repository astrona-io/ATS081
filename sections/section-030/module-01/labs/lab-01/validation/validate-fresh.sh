#!/usr/bin/env bash
# Check: The served updated date is 2026-11-01 or later
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

fetch() { kubectl -n outpost exec deploy/drifter -- curl -fsS --max-time 5 http://portal.portal.svc.cluster.local/services.json 2>/dev/null; }
fresh_ok() { local u; u="$(fetch | jq -r '.updated // empty')"; [ -n "$u" ] && [[ ! "$u" < "2026-11-01" ]]; }
if ! retry 24 5 fresh_ok; then echo "FAIL: the served updated date is missing or before 2026-11-01"; fail=1; fi

if [ "$fail" -eq 0 ]; then echo "PASS: The served updated date is 2026-11-01 or later"; fi
exit "$fail"
