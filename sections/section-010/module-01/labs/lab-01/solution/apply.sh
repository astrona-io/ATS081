#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
kubectl apply -f "$DIR/crd.yaml"
kubectl wait --for=condition=Established crd/environmentrequests.platform.starfleet.example --timeout=60s
echo "[solution] Applied."
