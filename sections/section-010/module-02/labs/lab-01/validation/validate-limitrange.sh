#!/usr/bin/env bash
# Check: The LimitRange tenant-defaults sets the container memory default limit 256Mi and request 128Mi
set -uo pipefail
fail=0
lim="$(kubectl -n team-beta get limitrange tenant-defaults -o jsonpath='{.spec.limits[?(@.type=="Container")].default.memory}' 2>/dev/null)"
req="$(kubectl -n team-beta get limitrange tenant-defaults -o jsonpath='{.spec.limits[?(@.type=="Container")].defaultRequest.memory}' 2>/dev/null)"
[ "$lim" = "256Mi" ] || { echo "FAIL: default memory limit is not 256Mi"; fail=1; }
[ "$req" = "128Mi" ] || { echo "FAIL: default memory request is not 128Mi"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: The LimitRange tenant-defaults sets the container memory default limit 256Mi and request 128Mi"; fi
exit "$fail"
