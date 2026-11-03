#!/usr/bin/env bash
# Check: The probe descriptor belongs to the system navigation
set -uo pipefail
fail=0
file="$(kubectl -n catalog-files get configmap entity-files -o jsonpath='{.data.probe\.yaml}' 2>/dev/null)"
echo "$file" | grep -Eq '^[[:space:]]*system:[[:space:]]*navigation[[:space:]]*$' || { echo "FAIL: system is not navigation"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: The probe descriptor belongs to the system navigation"; fi
exit "$fail"
