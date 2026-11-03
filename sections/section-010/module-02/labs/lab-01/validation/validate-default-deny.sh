#!/usr/bin/env bash
# Check: The NetworkPolicy default-deny-ingress selects all pods, has type Ingress and no ingress rules
set -uo pipefail
fail=0
np="$(kubectl -n team-beta get networkpolicy default-deny-ingress -o json 2>/dev/null)"
echo "$np" | jq -e '(.spec.podSelector == {}) and (.spec.policyTypes == ["Ingress"]) and (.spec.ingress == null)' >/dev/null 2>&1 || { echo "FAIL: default-deny-ingress is missing or has the wrong spec"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: The NetworkPolicy default-deny-ingress selects all pods, has type Ingress and no ingress rules"; fi
exit "$fail"
