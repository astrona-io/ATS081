#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
kubectl apply -f "$DIR/entities.yaml"
for d in scout probe shuttle; do kubectl -n starfleet label deployment $d catalog.starfleet.example/entity=$d --overwrite; done
kubectl -n outpost label deployment drifter catalog.starfleet.example/entity=drifter --overwrite
echo "[solution] Applied."
