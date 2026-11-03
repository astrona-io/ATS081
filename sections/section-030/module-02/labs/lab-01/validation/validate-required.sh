#!/usr/bin/env bash
# Check: The parameters name and owner are in a required list
set -uo pipefail
fail=0
file="$(kubectl -n portal get configmap scaffolder-templates -o jsonpath='{.data.template\.yaml}' 2>/dev/null)"
block="$(echo "$file" | awk '/^[[:space:]]*required:/{f=1;next} f&&/^[[:space:]]*-[[:space:]]/{print;next} f{exit}')"
echo "$block" | grep -Eq '^[[:space:]]*-[[:space:]]*name[[:space:]]*$' || { echo "FAIL: name is not required"; fail=1; }
echo "$block" | grep -Eq '^[[:space:]]*-[[:space:]]*owner[[:space:]]*$' || { echo "FAIL: owner is not required"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: The parameters name and owner are in a required list"; fi
exit "$fail"
