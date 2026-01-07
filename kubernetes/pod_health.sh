#!/bin/bash
set -euo pipefail

POD="${1:-}"
NAMESPACE="${2:-default}"

if [[ -z "$POD" ]]; then
  echo "Usage: pod_health.sh <pod-name> [namespace]"
  exit 1
fi

echo "========== POD HEALTH CHECK =========="
echo "Pod: $POD"
echo "Namespace: $NAMESPACE"

echo
echo "[1] Pod status:"
kubectl get pod "$POD" -n "$NAMESPACE" -o wide

echo
echo "[2] Pod conditions:"
kubectl get pod "$POD" -n "$NAMESPACE" \
  -o jsonpath='{range .status.conditions[*]}{.type}={.status}{"\n"}{end}'

echo
echo "[3] Container restarts:"
kubectl get pod "$POD" -n "$NAMESPACE" \
  -o jsonpath='{range .status.containerStatuses[*]}{.name}: restarts={.restartCount}{"\n"}{end}'

echo
echo "[4] Recent events:"
kubectl describe pod "$POD" -n "$NAMESPACE" | sed -n '/Events:/,$p'

echo
echo "[5] Pod IP & node:"
kubectl get pod "$POD" -n "$NAMESPACE" \
  -o jsonpath='PodIP={.status.podIP} Node={.spec.nodeName}{"\n"}'

