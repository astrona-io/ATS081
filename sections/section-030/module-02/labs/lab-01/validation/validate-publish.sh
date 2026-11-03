#!/usr/bin/env bash
# Check: The template has a step with the action publish:github
set -uo pipefail
fail=0
file="$(kubectl -n portal get configmap scaffolder-templates -o jsonpath='{.data.template\.yaml}' 2>/dev/null)"
echo "$file" | grep -Eq '^[[:space:]]*action:[[:space:]]*publish:github[[:space:]]*$' || { echo "FAIL: no publish:github step"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: The template has a step with the action publish:github"; fi
exit "$fail"
