#!/usr/bin/env bash
# Check: The ResourceQuota tenant-quota limits team-beta to 10 pods and requests.cpu 2
set -uo pipefail
fail=0
pods="$(kubectl -n team-beta get resourcequota tenant-quota -o jsonpath='{.spec.hard.pods}' 2>/dev/null)"
cpu="$(kubectl -n team-beta get resourcequota tenant-quota -o jsonpath='{.spec.hard.requests\.cpu}' 2>/dev/null)"
[ "$pods" = "10" ] || { echo "FAIL: pods limit is not 10"; fail=1; }
[ "$cpu" = "2" ] || { echo "FAIL: requests.cpu limit is not 2"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: The ResourceQuota tenant-quota limits team-beta to 10 pods and requests.cpu 2"; fi
exit "$fail"
