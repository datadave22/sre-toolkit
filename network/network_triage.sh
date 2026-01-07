#!/bin/bash
set -euo pipefail

echo "========== NETWORK TRIAGE =========="

echo
echo "[1] Listening TCP ports:"
ss -lntp

echo
echo "[2] TCP socket state summary:"
ss -s

echo
echo "[3] Top TCP states:"
ss -ant | awk 'NR>1 {states[$1]++} END {for (s in states) print s, states[s]}' \
  | sort -nr -k2

echo
echo "[4] Top processes by open sockets:"
ss -antp | awk '{print $7}' | sed 's/pid=//' | cut -d, -f1 \
  | sort | uniq -c | sort -nr | head



#Large SYN-RECV count → traffic is hitting the host
#but connections aren’t completing → check LB health or firewall rules.”
#OUT: APP Crash & Port Binding -> network path or upstream
