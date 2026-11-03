#!/usr/bin/env bash
# Check: The ResourceQuota ml-quota allows 2 GPUs and 10 pods in ml-team
set -uo pipefail
fail=0
gpu="$(kubectl -n ml-team get resourcequota ml-quota -o jsonpath='{.spec.hard.requests\.nvidia\.com/gpu}' 2>/dev/null)"
pods="$(kubectl -n ml-team get resourcequota ml-quota -o jsonpath='{.spec.hard.pods}' 2>/dev/null)"
[ "$gpu" = "2" ] || { echo "FAIL: requests.nvidia.com/gpu is not 2"; fail=1; }
[ "$pods" = "10" ] || { echo "FAIL: pods is not 10"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: The ResourceQuota ml-quota allows 2 GPUs and 10 pods in ml-team"; fi
exit "$fail"
