#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
kubectl apply -f "$DIR/solution.yaml"
kubectl patch job retrain -n ml-team --type merge -p '{"spec":{"ttlSecondsAfterFinished":3600}}'
echo "[solution] Applied."
