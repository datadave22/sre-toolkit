#!/bin/bash
set -euo pipefail

PORTS=(22 80 443)

echo "[INFO] Checking listening ports..."

for port in "${PORTS[@]}"; do
  if ss -lnt | awk '{print $4}' | grep -q ":$port$"; then
    echo "[OK] Port $port is LISTENING"
  else
    echo "[WARN] Port $port is NOT listening"
  fi
done

