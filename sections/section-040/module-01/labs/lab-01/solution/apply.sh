#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
kubectl apply -f "$DIR/assistant-roles.yaml"
kubectl apply -f "$DIR/assistant-policy.yaml"
kubectl -n starfleet delete rolebinding ops-assistant-edit --ignore-not-found
echo "[solution] Applied."
