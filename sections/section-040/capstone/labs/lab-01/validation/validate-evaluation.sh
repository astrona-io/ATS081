#!/usr/bin/env bash
# Check: ConfigMap assistant-evaluation holds reviewed, accepted, rejected, acceptanceRate and mode that match the proposals
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

e="$(kubectl -n assistant get configmap assistant-evaluation -o json 2>/dev/null)"
if [ -z "$e" ]; then echo "FAIL: ConfigMap assistant-evaluation does not exist in the namespace assistant"; fail=1
else
  all="$(kubectl -n assistant get configmaps -l proposal-status -o json 2>/dev/null)"
  acc="$(echo "$all" | jq -r '[.items[] | select(.metadata.labels["proposal-status"]=="accepted")] | length')"
  rej="$(echo "$all" | jq -r '[.items[] | select(.metadata.labels["proposal-status"]=="rejected")] | length')"
  rev=$(( acc + rej ))
  rate=0; [ "$rev" -gt 0 ] && rate=$(( acc * 100 / rev ))
  mode=suggest-only; [ "$rev" -ge 20 ] && [ "$rate" -ge 90 ] && mode=auto-low-risk
  get() { echo "$e" | jq -r ".data.$1 // empty"; }
  [ "$(get reviewed)" = "$rev" ] || { echo "FAIL: reviewed is not $rev"; fail=1; }
  [ "$(get accepted)" = "$acc" ] || { echo "FAIL: accepted is not $acc"; fail=1; }
  [ "$(get rejected)" = "$rej" ] || { echo "FAIL: rejected is not $rej"; fail=1; }
  [ "$(get acceptanceRate)" = "$rate" ] || { echo "FAIL: acceptanceRate is not $rate"; fail=1; }
  [ "$(get mode)" = "$mode" ] || { echo "FAIL: mode is not $mode"; fail=1; }
fi

if [ "$fail" -eq 0 ]; then echo "PASS: ConfigMap assistant-evaluation holds reviewed, accepted, rejected, acceptanceRate and mode that match the proposals"; fi
exit "$fail"
