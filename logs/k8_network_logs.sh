#!/bin/bash
set -euo pipefail

POD="${1:-}"
NAMESPACE="${2:-default}"

if [[ -z "$POD" ]]; then
  echo "Usage: k8s_network_logs.sh <pod> [namespace]"
  exit 1
fi

echo "========== K8S NETWORK LOG SCAN =========="

kubectl logs "$POD" -n "$NAMESPACE" --tail=200 | \
grep -Ei 'timeout|refused|unreachable|reset|deadline|broken pipe' \
|| echo "[INFO] No common network errors found"

