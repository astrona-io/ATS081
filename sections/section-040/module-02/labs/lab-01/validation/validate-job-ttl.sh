#!/usr/bin/env bash
# Check: The Job retrain has ttlSecondsAfterFinished 3600
set -uo pipefail
fail=0
t="$(kubectl -n ml-team get job retrain -o jsonpath='{.spec.ttlSecondsAfterFinished}' 2>/dev/null)"
[ "$t" = "3600" ] || { echo "FAIL: ttlSecondsAfterFinished is not 3600"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: The Job retrain has ttlSecondsAfterFinished 3600"; fi
exit "$fail"
