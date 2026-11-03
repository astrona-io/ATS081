#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
kubectl apply -f "$DIR/template.yaml"
kubectl -n portal get configmap golden-path-template -o jsonpath='{.data.deployment\.yaml}' | sed -e 's/__NAME__/beacon/g' -e 's/__OWNER__/outpost-team/g' | kubectl apply -f -
kubectl -n starfleet rollout status deployment/beacon --timeout=180s
kubectl apply -f "$DIR/portal-catalog.yaml"
gp="$(kubectl get deployments -A -l platform.starfleet.example/golden-path=true --no-headers | wc -l | tr -d ' ')"
kubectl -n portal create configmap adoption-report --from-literal=total=5 --from-literal=goldenPath="$gp" --from-literal=coverage=100 --dry-run=client -o yaml | kubectl apply -f -
echo "[solution] Applied."
