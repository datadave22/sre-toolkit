#!/bin/bash
set -euo pipefail

POD="$1"
NAMESPACE="${2:-default}"

kubectl exec -n "$NAMESPACE" "$POD" -- ss -lntp || \
echo "[WARN] ss not available in container"

