#!/bin/bash
set -euo pipefail

echo "[INFO] TCP socket state summary:"
ss -s

echo
echo "[INFO] Top TCP states:"
ss -ant | awk 'NR>1 {states[$1]++} END {for (s in states) print s, states[s]}' \
  | sort -nr -k2

#High TIME-WAIT → normal under load
#High SYN-RECV → possible SYN flood or LB issue
#High CLOSE-WAIT → application bug

