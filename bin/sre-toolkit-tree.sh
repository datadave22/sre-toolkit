#!/bin/bash
set -euo pipefail

DIRS=(
  bin
  disk
  memory
  network
  services
  logs
  kubernetes
  lib
)

echo "Creating directory structure..."

for dir in "${DIRS[@]}"; do
  mkdir -p "$dir"
done

touch \
  disk/usage.sh \
  memory/usage.sh \
  network/check_ports.sh \
  network/socket_usage.sh \
  services/check_service.sh \
  lib/common.sh

chmod +x bin/* disk/*.sh memory/*.sh network/*.sh services/*.sh

echo "SRE toolkit initialized successfully."

