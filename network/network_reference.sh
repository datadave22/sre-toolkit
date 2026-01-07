#!/bin/bash
set -euo pipefail

print_section() {
  echo
  echo "=================================================="
  echo "$1"
  echo "=================================================="
}

print_section "NETWORK TROUBLESHOOTING QUICK REFERENCE"
echo "Purpose: Fast recall during network-layer incidents"
echo "Scope: L2 → L4 (with L7 context)"

# --------------------------------------------------

print_section "LAYER 2 — LINK / ARP (LOCAL CONNECTIVITY)"

cat <<'EOF'
Tool: ip link
Solves: Interface up/down, carrier issues

Common command:
  ip link show

Sample output:
  2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP>

How to read:
  UP        → interface enabled
  LOWER_UP → cable / virtual link present
  missing LOWER_UP → link problem (VM, NIC, switch)

---

Tool: arp / ip neigh
Solves: IP-to-MAC resolution issues

Common command:
  ip neigh show

Sample output:
  192.168.1.1 dev eth0 lladdr aa:bb:cc:dd REACHABLE

How to read:
  REACHABLE → ARP working
  FAILED / INCOMPLETE → L2 or local network issue
EOF

# --------------------------------------------------

print_section "LAYER 3 — IP / ROUTING"

cat <<'EOF'
Tool: ip addr
Solves: IP assignment, subnet mistakes

Common command:
  ip addr show eth0

Sample output:
  inet 10.0.1.15/24

How to read:
  Wrong subnet → traffic never routed correctly

---

Tool: ip route
Solves: Default gateway, routing loops

Common command:
  ip route

Sample output:
  default via 10.0.1.1 dev eth0

How to read:
  No default route → outbound traffic fails

---

Tool: traceroute
Solves: Where packets stop

Common command:
  traceroute 8.8.8.8

Sample output:
  1 10.0.1.1
  2 *
  3 *

How to read:
  Stops early → local routing/firewall
  Stops later → upstream/network provider
EOF

# --------------------------------------------------

print_section "LAYER 4 — TCP / UDP (MOST SRE DEBUGGING)"

cat <<'EOF'
Tool: ss
Solves: Listening ports, socket states

Common commands:
  ss -lntp    # listening TCP ports
  ss -ant     # all TCP connections
  ss -s       # TCP statistics

Sample output:
  ESTAB 120
  SYN-RECV 45
  TIME-WAIT 300

How to read:
  SYN-RECV spike → possible SYN flood / LB issue
  CLOSE-WAIT → application bug (not closing sockets)
  TIME-WAIT high → normal under load

---

Tool: tcpdump
Solves: Packet-level truth (last resort)

Common command:
  tcpdump -nn -i eth0 port 443

Sample output:
  IP 10.0.1.5.443 > 10.0.1.20.52344: Flags [S]

How to read:
  [S] only → SYN sent, no response
  [S.] → SYN-ACK received (healthy path)
  No packets → traffic not reaching host
EOF

# --------------------------------------------------

print_section "LAYER 7 — APPLICATION CONTEXT"

cat <<'EOF'
Tool: curl
Solves: Is the service actually responding?

Common command:
  curl -v http://localhost:8080

Sample output:
  HTTP/1.1 200 OK

How to read:
  Timeout → network or service hung
  5xx → app failure, network probably fine
EOF

# --------------------------------------------------

print_section "COMMON INCIDENT PATTERNS (FAST RECALL)"

cat <<'EOF'
Port closed         → check ss -lntp
Port open, no reply → traceroute + tcpdump
High SYN-RECV       → load balancer or firewall
CLOSE-WAIT spike    → application socket leak
Works locally only  → routing / firewall
EOF

echo
echo "[INFO] End of network reference"

