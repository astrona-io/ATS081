#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
kubectl apply -f "$DIR/assistant-roles.yaml"
kubectl apply -f "$DIR/assistant-policy.yaml"
kubectl -n starfleet delete rolebinding ops-assistant-edit --ignore-not-found
kubectl -n assistant create configmap assistant-evaluation --from-literal=reviewed=10 --from-literal=accepted=7 --from-literal=rejected=3 --from-literal=acceptanceRate=70 --from-literal=mode=suggest-only --dry-run=client -o yaml | kubectl apply -f -
echo "[solution] Applied."
