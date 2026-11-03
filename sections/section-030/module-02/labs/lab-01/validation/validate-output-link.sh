#!/usr/bin/env bash
# Check: The output has a link with an entityRef
set -uo pipefail
fail=0
file="$(kubectl -n portal get configmap scaffolder-templates -o jsonpath='{.data.template\.yaml}' 2>/dev/null)"
echo "$file" | grep -Eq '^[[:space:]]*entityRef:' || { echo "FAIL: no entityRef in the output"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: The output has a link with an entityRef"; fi
exit "$fail"
