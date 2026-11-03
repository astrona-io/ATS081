#!/usr/bin/env bash
# Check: The probe descriptor depends on component:default/scout
set -uo pipefail
fail=0
file="$(kubectl -n catalog-files get configmap entity-files -o jsonpath='{.data.probe\.yaml}' 2>/dev/null)"
echo "$file" | grep -Eq '^[[:space:]]*-[[:space:]]*component:default/scout[[:space:]]*$' || { echo "FAIL: dependsOn component:default/scout is missing"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: The probe descriptor depends on component:default/scout"; fi
exit "$fail"
