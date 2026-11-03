#!/usr/bin/env bash
# Check: The probe descriptor has the annotation backstage.io/kubernetes-id with the value probe
set -uo pipefail
fail=0
file="$(kubectl -n catalog-files get configmap entity-files -o jsonpath='{.data.probe\.yaml}' 2>/dev/null)"
echo "$file" | grep -Eq '^[[:space:]]*backstage\.io/kubernetes-id:[[:space:]]*probe[[:space:]]*$' || { echo "FAIL: annotation backstage.io/kubernetes-id: probe is missing"; fail=1; }

if [ "$fail" -eq 0 ]; then echo "PASS: The probe descriptor has the annotation backstage.io/kubernetes-id with the value probe"; fi
exit "$fail"
