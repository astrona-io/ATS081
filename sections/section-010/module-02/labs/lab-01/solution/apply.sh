#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
kubectl label namespace team-beta platform.starfleet.example/tenant=beta pod-security.kubernetes.io/enforce=baseline --overwrite
kubectl apply -f "$DIR/solution.yaml"
echo "[solution] Applied."
