#!/usr/bin/env bash
# Check: The probe owner is still group:default/probe-team and scout.yaml still exists
set -uo pipefail
fail=0
file="$(kubectl -n catalog-files get configmap entity-files -o jsonpath='{.data.probe\.yaml}' 2>/dev/null)"
echo "$file" | grep -Eq '^[[:space:]]*owner:[[:space:]]*group:default/probe-team[[:space:]]*$' || { echo "FAIL: owner changed"; fail=1; }
kubectl -n catalog-files get configmap entity-files -o jsonpath='{.data.scout\.yaml}' 2>/dev/null | grep -q 'name: scout' || { echo "FAIL: scout.yaml is missing"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: The probe owner is still group:default/probe-team and scout.yaml still exists"; fi
exit "$fail"
