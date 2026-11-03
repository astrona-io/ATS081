#!/usr/bin/env bash
# Check: The Job retrain is still suspended
set -uo pipefail
fail=0
s="$(kubectl -n ml-team get job retrain -o jsonpath='{.spec.suspend}' 2>/dev/null)"
[ "$s" = "true" ] || { echo "FAIL: the Job is not suspended"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: The Job retrain is still suspended"; fi
exit "$fail"
