#!/usr/bin/env bash
# Check: The PriorityClass training-low has the value 1000 and the preemption policy Never
set -uo pipefail
fail=0
v="$(kubectl get priorityclass training-low -o jsonpath='{.value}' 2>/dev/null)"
p="$(kubectl get priorityclass training-low -o jsonpath='{.preemptionPolicy}' 2>/dev/null)"
[ "$v" = "1000" ] || { echo "FAIL: value is not 1000"; fail=1; }
[ "$p" = "Never" ] || { echo "FAIL: preemptionPolicy is not Never"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: The PriorityClass training-low has the value 1000 and the preemption policy Never"; fi
exit "$fail"
