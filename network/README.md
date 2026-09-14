# Network Fundamentals and Troubleshooting

This directory documents my networking studies and labs as part of my cloud infrastructure engineering learning path.

The focus is not only on memorizing protocols or commands, but on understanding how communication moves through network layers and how to isolate failures using observable evidence.

The learning path progresses from:

```text
OSI Model
    ↓
Network Types and Protocols
    ↓
Ethernet and MAC Addressing
    ↓
IPv4 / IPv6 Addressing
    ↓
ARP
    ↓
Routing
    ↓
Dynamic Routing Protocols
    ↓
DNS
    ↓
Network Troubleshooting
    ↓
Packet Analysis
```

The long-term goal is to apply these fundamentals to:

```text
Linux Infrastructure
Cloud Networking
Containers
Kubernetes
Infrastructure as Code
Network Security
Cloud Security
```

---

# Learning Principles

The networking materials in this directory follow several principles.

```text
Understand the protocol
        ↓
Understand the packet path
        ↓
Inspect actual system state
        ↓
Generate a hypothesis
        ↓
Collect evidence
        ↓
Identify the failing layer
        ↓
Make one controlled change
        ↓
Verify recovery
```

The goal is to avoid troubleshooting by random configuration changes.

---

# Directory Structure

```text
network/
├── README.md
├── osi-model-lab.md
├── network-types-protocols-lab.md
├── ethernet-lab.md
├── ipv4-addressing-lab.md
├── ipv6-addressing-lab.md
├── arp-rarp-lab.md
├── routing-fundamentals-lab.md
├── routing-protocols-lab.md
├── network-standards-lab.md
├── dns-fundamentals-lab.md
└── network-troubleshooting-lab.md
```

Linux-specific network administration remains under:

```text
linux/
```

Examples include:

```text
NetworkManager configuration
Linux bridges
Network teaming
OpenSSH
NFS
Samba
firewalld
SELinux
BIND / Unbound
Apache HTTP Server
```

This separation keeps general networking concepts independent from operating-system-specific implementation.

---

# 1. OSI Model

File:

```text
osi-model-lab.md
```

Topics:

```text
OSI 7-Layer Model
Encapsulation
Decapsulation
Protocol Data Units
Layer 2 / Layer 3 / Layer 4 Addressing
Hub
Repeater
Bridge
Switch
Router
Gateway
```

Core relationships:

```text
Layer 2
→ MAC Address
→ Ethernet Frame
→ Switch

Layer 3
→ IP Address
→ Packet
→ Router

Layer 4
→ TCP / UDP
→ Port
```

This layer model is also used as a troubleshooting framework throughout the networking labs.

---

# 2. Network Types and Protocols

File:

```text
network-types-protocols-lab.md
```

Topics include:

```text
LAN
MAN
WAN
Internet
Network Topologies
Circuit Switching
Packet Switching
Protocol Concepts
OSI vs TCP/IP
TCP/IP Protocol Suite
```

The objective is to understand how different network scopes and protocol layers work together before studying individual protocols in detail.

---

# 3. Ethernet

File:

```text
ethernet-lab.md
```

Topics include:

```text
Ethernet
IEEE 802.3
Ethernet Frame
MAC Address
Frame Header
Frame Trailer
FCS
MTU
Switching
Collision Domains
CSMA/CD
Full Duplex
Half Duplex
```

A key relationship is:

```text
IP Packet
    ↓
Encapsulated in
    ↓
Ethernet Frame
    ↓
Delivered across a local link
```

Ethernet concepts provide the foundation for later ARP and packet-analysis labs.

---

# 4. IPv4 Addressing

File:

```text
ipv4-addressing-lab.md
```

Topics:

```text
32-bit IPv4 Addresses
Network Portion
Host Portion
Unicast
Multicast
Broadcast
Private IPv4 Addresses
Historical Classful Addressing
Subnetting
CIDR
VLSM
Prefix Length
Linux IPv4 Inspection
```

Private IPv4 ranges reviewed:

```text
10.0.0.0/8

172.16.0.0/12

192.168.0.0/16
```

Modern addressing is interpreted using:

```text
IP Address + Prefix Length
```

rather than assuming classful network boundaries.

---

# 5. IPv6 Addressing

File:

```text
ipv6-addressing-lab.md
```

Topics:

```text
128-bit IPv6 Addresses
IPv6 Representation
Zero Compression
Unicast
Anycast
Multicast
Link-Local Addresses
Global Addresses
IPv6 Loopback
Interface Identifiers
IPv6 Routing
Dual Stack
```

Important examples:

```text
FE80::/10
→ Link-Local

FF00::/8
→ Multicast

::1
→ Loopback
```

Historical IPv6 concepts in the course material are separated from current addressing practices where appropriate.

---

# 6. ARP and Neighbor Resolution

File:

```text
arp-rarp-lab.md
```

ARP connects IPv4 communication to Ethernet addressing.

```text
IPv4 Address
     ↓
ARP
     ↓
MAC Address
```

Topics:

```text
ARP Request
ARP Reply
Ethernet Broadcast
ARP Cache
Linux Neighbor Table
Direct Communication
Gateway MAC Resolution
Historical RARP
```

One of the most important distinctions is:

```text
Local Destination
→ Resolve the destination host MAC
```

```text
Remote Destination
→ Resolve the gateway MAC
```

The final IP destination and immediate Ethernet destination can therefore represent different systems.

---

# 7. Routing Fundamentals

File:

```text
routing-fundamentals-lab.md
```

Topics:

```text
Routing Tables
Direct Routing
Indirect Routing
Connected Routes
Next-Hop Gateways
Default Routes
Static Routing
Dynamic Routing
Longest Prefix Match
Linux IPv4 Forwarding
```

Basic decision model:

```text
Destination IP
      ↓
Routing Table
      ↓
Most Specific Matching Route
      ↓
Local Interface or Gateway
```

Routing is treated as a host function as well as a router function.

---

# 8. Dynamic Routing Protocols

File:

```text
routing-protocols-lab.md
```

Topics:

```text
RIP
Distance Vector
Hop Count
OSPF
Link State
Routing Cost
IGRP
Autonomous Systems
IGP
EGP
BGP
```

Core distinctions:

```text
RIP
→ Distance Vector
→ Hop Count
```

```text
OSPF
→ Link State
→ Cost
```

```text
BGP
→ Inter-AS Routing
```

The goal at this stage is to understand routing-protocol architecture rather than memorize vendor-specific router configuration.

---

# 9. Network Standards

File:

```text
network-standards-lab.md
```

Organizations and standards reviewed include:

```text
ISO
ANSI
EIA
IEEE
ITU-T
IAB
IETF
RFC
```

Important relationships include:

```text
OSI
→ ISO

Ethernet
→ IEEE 802.3

Internet Protocol Standards
→ IETF / RFC ecosystem
```

Understanding standards helps distinguish protocol specifications from vendor-specific implementations.

---

# 10. DNS Fundamentals

File:

```text
dns-fundamentals-lab.md
```

Topics:

```text
DNS
FQDN
DNS Namespace
Root Domain
TLD
Domains
Zones
Delegation
Recursive Resolution
Iterative Resolution
Caching
Forwarding
Forward Lookup
Reverse Lookup
```

Important DNS records:

```text
A
→ IPv4 Address

AAAA
→ IPv6 Address

CNAME
→ Alias

MX
→ Mail Server

NS
→ Name Server

PTR
→ Reverse Lookup

SOA
→ Zone Authority Metadata
```

DNS troubleshooting is treated separately from basic IP connectivity.

For example:

```text
IP Connectivity Works
+
Hostname Resolution Fails
        ↓
Investigate DNS / Name Resolution
```

---

# 11. Network Troubleshooting

File:

```text
network-troubleshooting-lab.md
```

This section combines the previous networking concepts into an evidence-based troubleshooting workflow.

Tools reviewed include:

```text
ip
traceroute
ss
netstat
dig
host
getent
ip neigh
arping
lsof
fuser
rpcinfo
nc
nmap
tcpdump
tshark
curl
ethtool
```

Tool selection depends on the layer being investigated.

| Question | Useful Tools |
|---|---|
| Is the interface operational? | `ip link`, `ethtool` |
| Is addressing correct? | `ip addr` |
| Can a local neighbor be resolved? | `ip neigh`, `arping` |
| Is a route available? | `ip route`, `traceroute` |
| Does DNS work? | `dig`, `host`, `getent` |
| Is a port listening? | `ss`, `lsof` |
| Is a remote TCP port reachable? | `nc` |
| Which hosts or ports are visible in an authorized lab? | `nmap` |
| Did the packet actually arrive? | `tcpdump`, `tshark` |
| Does the application respond? | `curl` |

---

# Troubleshooting Method

Troubleshooting is documented using:

```text
Symptom
   ↓
Evidence
   ↓
Root Cause
   ↓
Resolution
   ↓
Verification
```

## Symptom

Describe exactly what failed.

Example:

```text
The client cannot reach the remote HTTP service.
```

## Evidence

Collect observable system or network state.

Examples:

```text
ip addr
ip route
ip neigh
ss
dig
nc
tcpdump
```

Do not replace evidence with assumptions.

## Root Cause

Identify which layer actually caused the failure.

Examples:

```text
Incorrect route
Missing gateway
ARP failure
DNS configuration error
Firewall rule
Service not listening
```

## Resolution

Make the smallest controlled configuration change required to correct the issue.

## Verification

Repeat the original test and verify the affected layers.

A fix is not complete until normal behavior is demonstrated.

---

# Layer-Based Troubleshooting

A general troubleshooting path is:

```text
1. Physical / Interface
        ↓
2. Data Link / Neighbor
        ↓
3. IP Address / Prefix
        ↓
4. Routing
        ↓
5. DNS
        ↓
6. Transport / Port
        ↓
7. Service
        ↓
8. Application
```

This avoids immediately changing application configuration when the actual failure exists at a lower layer.

---

# Example: SSH Connection Failure

```text
Interface Up?
      ↓
Correct IP?
      ↓
Neighbor / Gateway Reachable?
      ↓
Correct Route?
      ↓
TCP Port Reachable?
      ↓
SSH Listening?
      ↓
sshd Running?
      ↓
Authentication?
```

Useful tools can include:

```text
ip link
ip addr
ip neigh
ip route
traceroute
nc
ss
systemctl
journalctl
```

---

# Example: DNS Failure

```text
Network Connectivity
       ↓
DNS Server Reachable?
       ↓
Direct DNS Query Works?
       ↓
Resolver Configuration
       ↓
NSS Configuration
       ↓
Application Lookup
```

Useful tools:

```text
ip route
dig
getent
tcpdump
```

---

# Example: Web Service Failure

```text
Network Reachability
       ↓
TCP 80 / 443
       ↓
Listening Socket
       ↓
Firewall
       ↓
HTTP Request
       ↓
Application Response
```

Useful tools:

```text
traceroute
nc
ss
tcpdump
curl
```

---

# Runtime vs Persistent Configuration

Networking labs also reinforce an important infrastructure principle:

```text
Runtime State
!=
Persistent Configuration
```

Examples include:

```text
ip addr add
→ Runtime IP state
```

```text
NetworkManager profile
→ Persistent network configuration
```

This same principle appears throughout the Linux infrastructure labs.

---

# Legacy and Modern Tools

Some course materials contain older Linux networking commands.

They are preserved for understanding, while modern alternatives are also documented.

Examples:

```text
route
→ ip route

arp
→ ip neigh

netstat
→ ss

ifconfig
→ ip addr / ip link
```

The goal is to understand both the course material and the tools commonly used on current Linux systems.

---

# Evidence Policy

This repository does not treat course screenshots or example values as actual lab evidence.

Do not fabricate:

```text
IP addresses
MAC addresses
Interface names
Routes
PIDs
Packet captures
DNS responses
Port-scan results
Command output
```

Actual environment-specific evidence should come from the system where the lab is performed.

---

# Security Principles

Networking tools can expose or affect systems.

The following rules apply:

```text
Use scanning only on authorized networks.
Do not capture unrelated user traffic.
Do not publish credentials or secrets.
Do not publish SSH private keys.
Do not publish sensitive packet payloads.
Do not disconnect remote management interfaces without a recovery path.
```

Packet captures should be reviewed before they are committed to a public repository.

---

# Relationship to Linux Labs

General network theory is documented here under:

```text
network/
```

Operating-system-specific network administration remains under:

```text
linux/
```

For example:

```text
network/
→ Why ARP exists
→ How routing works
→ How DNS resolution works
→ How packets move through layers
```

while:

```text
linux/
→ NetworkManager configuration
→ Linux bridge configuration
→ SSH administration
→ firewalld
→ SELinux network policy
→ Apache
→ BIND / Unbound
→ NFS / Samba
```

This separation keeps the repository organized by responsibility.

---

# Current Learning Progress

Completed areas in this directory include:

```text
OSI Model
Network Types and Protocols
Ethernet
IPv4
IPv6
ARP / RARP
Routing Fundamentals
Dynamic Routing Protocols
Network Standards
DNS Fundamentals
Network Troubleshooting
```

The next major area is:

```text
Packet Analysis
```

The packet-analysis section will build on:

```text
Ethernet Frames
ARP
IP
ICMP
TCP
UDP
DNS
Packet Capture
```

and focus on reading actual protocol headers and communication flows.

---

# Future Expansion

As the infrastructure learning path progresses, this directory can expand into areas such as:

```text
TCP / UDP Deep Dive
Packet Analysis
DHCP
VLAN
NAT
Network Segmentation
Load Balancing
Cloud VPC Networking
Security Groups
Network ACLs
VPN
Container Networking
Kubernetes Networking
Network Security
```

New files should be added only when those areas are actually studied or reproduced.

---

# What This Directory Demonstrates

This directory is intended to demonstrate progression from network fundamentals toward infrastructure troubleshooting.

```text
Theory
   ↓
Protocol Understanding
   ↓
Linux Observation
   ↓
Traffic Verification
   ↓
Troubleshooting
   ↓
Cloud Infrastructure
```

The objective is not to collect commands.

The objective is to understand:

```text
What should happen?

What actually happened?

Which layer failed?

What evidence proves it?

How was the system verified after recovery?
```
