#!/usr/bin/env bash
# Check: The parameter name has a pattern
set -uo pipefail
fail=0
file="$(kubectl -n portal get configmap scaffolder-templates -o jsonpath='{.data.template\.yaml}' 2>/dev/null)"
echo "$file" | grep -Eq '^[[:space:]]*pattern:' || { echo "FAIL: no pattern on the name"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: The parameter name has a pattern"; fi
exit "$fail"
