#!/usr/bin/env bash
# Check: The namespace team-beta has the tenant label beta and the baseline enforce label
set -uo pipefail
fail=0
t="$(kubectl get ns team-beta -o jsonpath='{.metadata.labels.platform\.starfleet\.example/tenant}' 2>/dev/null)"
p="$(kubectl get ns team-beta -o jsonpath='{.metadata.labels.pod-security\.kubernetes\.io/enforce}' 2>/dev/null)"
[ "$t" = "beta" ] || { echo "FAIL: tenant label is not beta"; fail=1; }
[ "$p" = "baseline" ] || { echo "FAIL: pod-security enforce label is not baseline"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: The namespace team-beta has the tenant label beta and the baseline enforce label"; fi
exit "$fail"
