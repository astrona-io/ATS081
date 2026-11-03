#!/usr/bin/env bash
# Check: The catalog:register step comes after the publish:github step
set -uo pipefail
fail=0
file="$(kubectl -n portal get configmap scaffolder-templates -o jsonpath='{.data.template\.yaml}' 2>/dev/null)"
pub="$(echo "$file" | grep -n 'action:[[:space:]]*publish:github' | head -1 | cut -d: -f1)"
reg="$(echo "$file" | grep -n 'action:[[:space:]]*catalog:register' | head -1 | cut -d: -f1)"
[ -n "$pub" ] && [ -n "$reg" ] && [ "$reg" -gt "$pub" ] || { echo "FAIL: catalog:register must come after publish:github"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: The catalog:register step comes after the publish:github step"; fi
exit "$fail"
