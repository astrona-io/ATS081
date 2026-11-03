#!/usr/bin/env bash
# Check: The probe descriptor has the lifecycle production
set -uo pipefail
fail=0
file="$(kubectl -n catalog-files get configmap entity-files -o jsonpath='{.data.probe\.yaml}' 2>/dev/null)"
echo "$file" | grep -Eq '^[[:space:]]*lifecycle:[[:space:]]*production[[:space:]]*$' || { echo "FAIL: lifecycle is not production"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: The probe descriptor has the lifecycle production"; fi
exit "$fail"
