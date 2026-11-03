#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
kubectl apply -f "$DIR/solution.yaml"
sleep 5
kubectl wait --for=condition=Established crd/environmentrequests.platform.starfleet.example --timeout=60s
kubectl -n team-alpha patch environmentrequest starter --subresource=status --type=merge --patch-file "$DIR/status.yaml"
echo "[solution] Applied."
