# Network Fundamentals and Troubleshooting

This directory documents my networking studies and labs as part of my cloud infrastructure engineering learning path.

The focus is not only on memorizing protocols or commands, but on understanding how communication moves through network layers, how protocol headers represent that communication, and how to isolate failures using observable evidence.

The learning path progresses through:

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
Docker Networking
Kubernetes Networking
Cloud VPC Networking
Load Balancing
Network Security
Cloud Security
```

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
├── network-troubleshooting-lab.md
└── packet-analysis-lab.md
```

Linux-specific network administration remains under:

```text
../linux/
```

Examples include:

```text
NetworkManager
Linux Bridge
Network Teaming
OpenSSH
NFS
Samba / CIFS
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

Topics include:

```text
OSI 7-Layer Model
Encapsulation
Decapsulation
Protocol Data Units
Hub
Repeater
Bridge
Switch
Router
Gateway
Layer 2 Addressing
Layer 3 Addressing
Layer 4 Ports
```

Core relationships:

```text
Layer 2
→ MAC Address
→ Ethernet Frame
→ Switch / Bridge

Layer 3
→ IP Address
→ Packet
→ Router

Layer 4
→ TCP / UDP
→ Port
```

The OSI model is used throughout this directory as a troubleshooting framework rather than only as a theoretical model.

---

# 2. Network Types and Protocols

File:

```text
network-types-protocols-lab.md
```

Topics include:

```text
Transmission Methods
Network Topologies
Circuit Switching
Packet Switching
Cell Switching
LAN
MAN
WAN
Protocol Syntax
Protocol Semantics
Protocol Timing
TCP/IP Model
```

The goal is to understand how network communication is structured before studying individual protocols in detail.

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
Ethernet Frames
MAC Addresses
Ethernet Headers
FCS
MTU
Switching
Collision Domains
CSMA/CD
Half Duplex
Full Duplex
```

A core relationship is:

```text
IP Packet
    ↓
Encapsulated in
    ↓
Ethernet Frame
    ↓
Delivered across a local link
```

Historical collision-domain concepts are preserved for context while modern switched full-duplex Ethernet behavior is distinguished where appropriate.

---

# 4. IPv4 Addressing

File:

```text
ipv4-addressing-lab.md
```

Topics include:

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

Private IPv4 ranges reviewed include:

```text
10.0.0.0/8

172.16.0.0/12

192.168.0.0/16
```

Modern IPv4 addressing is interpreted using:

```text
IP Address
+
Prefix Length
```

rather than assuming classful network boundaries.

---

# 5. IPv6 Addressing

File:

```text
ipv6-addressing-lab.md
```

Topics include:

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
Dual Stack
IPv6 Routing
```

Important examples include:

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

Topics include:

```text
ARP Request
ARP Reply
Ethernet Broadcast
Neighbor Cache
Direct Communication
Default Gateway MAC Resolution
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

The final IP destination and immediate Ethernet destination can therefore identify different systems.

---

# 7. Routing Fundamentals

File:

```text
routing-fundamentals-lab.md
```

Topics include:

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

A simplified routing decision model is:

```text
Destination IP
      ↓
Routing Table
      ↓
Most Specific Matching Route
      ↓
Local Interface or Gateway
```

Routing is treated as both a router function and a host networking function.

---

# 8. Dynamic Routing Protocols

File:

```text
routing-protocols-lab.md
```

Topics include:

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

Core distinctions include:

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

The focus is on protocol architecture rather than vendor-specific router configuration.

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
→ IETF / RFC Ecosystem
```

Understanding standards helps distinguish protocol specifications from vendor-specific implementation.

---

# 10. DNS Fundamentals

File:

```text
dns-fundamentals-lab.md
```

Topics include:

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

Important DNS records include:

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

TXT
→ Text Data

SRV
→ Service Location
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

Tool selection depends on the question being investigated.

```text
Interface State
→ ip link / ethtool

Addressing
→ ip addr

Neighbor Resolution
→ ip neigh / arping

Routing
→ ip route / traceroute

DNS
→ dig / host / getent

Listening Sockets
→ ss / lsof

Remote TCP Reachability
→ nc

Authorized Host / Port Discovery
→ nmap

Packet Arrival
→ tcpdump / tshark

Application Response
→ curl
```

---

# 12. Packet Analysis

File:

```text
packet-analysis-lab.md
```

Packet analysis connects networking theory to actual captured traffic.

Topics include:

```text
Wireshark
Packet Capture
Packet List
Packet Details
Raw Packet Bytes
IPv4 Header
IPv6 Header
TCP Header
TCP Flags
TCP vs UDP
Ethernet II
ARP Request / Reply
ICMP
IGMP
Follow Stream
Stream Filtering
Flow Graph
Latency Analysis
Capture Filters
Display Filters
```

A typical packet can be analyzed as:

```text
Ethernet
    ↓
IP
    ↓
TCP / UDP / ICMP
    ↓
Application Protocol
```

Not every packet contains every layer.

For example:

```text
ARP

Ethernet
   ↓
ARP
```

while:

```text
TCP over IPv4

Ethernet
   ↓
IPv4
   ↓
TCP
   ↓
Application Data
```

---

# Packet Header Relationships

Important protocol relationships include:

```text
Ethernet
→ Source MAC
→ Destination MAC
→ EtherType
```

```text
IPv4
→ Source IP
→ Destination IP
→ TTL
→ Protocol
```

```text
IPv6
→ Source IP
→ Destination IP
→ Hop Limit
→ Next Header
```

```text
TCP
→ Source Port
→ Destination Port
→ Sequence Number
→ Acknowledgment Number
→ Flags
→ Window
```

These fields make it possible to reconstruct what occurred during network communication.

---

# TCP Flags

The classic TCP flags reviewed include:

```text
URG
ACK
PSH
RST
SYN
FIN
```

Important operational interpretations include:

```text
SYN
→ Connection establishment
```

```text
ACK
→ Acknowledgment information is valid
```

```text
RST
→ Connection reset / abort
```

```text
FIN
→ Normal connection shutdown
```

TCP flags should be interpreted together with packet direction, sequence numbers, acknowledgment numbers, and surrounding traffic.

---

# Follow Stream

Wireshark can reconstruct packets belonging to one conversation.

Conceptually:

```text
Full Packet Capture
       ↓
Select Relevant Packet
       ↓
Follow Stream
       ↓
Client / Server Conversation
```

This is useful when many simultaneous connections exist in the same capture.

Stream analysis can help answer:

```text
What did the client request?

What did the server return?

Which packets belong to this communication?

Did the application conversation complete?
```

---

# Stream Filtering

Once a relevant stream has been identified, the packet list can be narrowed to that conversation.

```text
Large Capture
    ↓
Identify Stream
    ↓
Filter Stream
    ↓
Inspect Related Packets Only
```

This reduces unrelated traffic while preserving the packet sequence associated with the incident.

---

# Flow Graph

A flow graph visualizes communication direction and sequence.

Conceptually:

```text
Client                         Server

  |----------- SYN ------------->|
  |<-------- SYN/ACK ------------|
  |----------- ACK ------------->|
  |                              |
  |-------- Application -------->|
  |<------- Application ---------|
```

Flow graphs can help identify:

```text
TCP Handshake Completion
Request / Response Direction
Communication Sequence
Connection Shutdown
The Point Where Communication Stops
```

The graph complements detailed packet inspection rather than replacing it.

---

# Latency Analysis

Packet timestamps can help identify where visible delay appears in a transaction.

A simplified model is:

```text
Client
   ↓
Request
   ↓
Network
   ↓
Server Processing
   ↓
Response
   ↓
Network
   ↓
Client
```

A large time gap does not automatically prove that the network is slow.

Possible contributors include:

```text
Client Processing
Network Delay
Server Processing
Application Delay
Retransmission
```

The direction and surrounding packets must be inspected before assigning the cause.

---

# Time-Based Analysis

Useful timing perspectives can include:

```text
Time Since Capture Start
Time Since Previous Packet
Time Since Previous Displayed Packet
```

A practical investigation model is:

```text
Compare Packet Timing
      ↓
Identify Large Gap
      ↓
Inspect Packet Before Gap
      ↓
Inspect Packet After Gap
      ↓
Determine Communication Direction
      ↓
Form Hypothesis
```

Packet timing is evidence, not automatic root-cause determination.

---

# Capture Filters

Capture filters decide which packets are collected.

```text
Network Traffic
      ↓
Capture Filter
      ↓
Stored Packets
```

Packets excluded during capture cannot be recovered from that capture later.

Capture filters can narrow traffic by:

```text
Host
Network
Protocol
Port
Broadcast
Multicast
```

Examples of general BPF-style structures include:

```text
host HOST

src host HOST

dst host HOST

net NETWORK/PREFIX

port PORT

tcp port PORT

udp port PORT

icmp
```

Capture filters should be narrow enough to reduce noise but broad enough to preserve troubleshooting context.

---

# Capture Filter Risk

Overly restrictive filters can hide the actual cause of a problem.

An application failure can depend on:

```text
ARP
   ↓
DNS
   ↓
TCP Handshake
   ↓
Application Traffic
```

Capturing only the final application port may remove evidence from earlier stages.

When the failure location is not yet known, a broader capture combined with display filters can preserve more evidence.

---

# Display Filters

Display filters operate after packets have already been captured.

```text
Stored Capture
      ↓
Display Filter
      ↓
Visible Packets
```

Non-matching packets remain in the capture.

They are only hidden from the current view.

Basic protocol-oriented filters can include:

```text
arp
ip
ipv6
tcp
udp
icmp
dns
http
```

Decoded fields can also be used for more specific filtering.

---

# Capture Filter vs Display Filter

This distinction is fundamental.

```text
Capture Filter
→ Applied during capture
→ Non-matching packets are not stored
```

```text
Display Filter
→ Applied after capture
→ Non-matching packets remain stored
→ They are only hidden
```

A useful troubleshooting strategy is:

```text
When uncertain:
Broad Capture
     ↓
Targeted Display Filter
```

rather than discarding potentially useful evidence too early.

---

# Display Filter Operators

Display filters can use comparison and search operators such as:

```text
==
!=
>
<
>=
<=
contains
```

Conceptual examples include:

```text
ip.src == SOURCE_IP
```

```text
tcp.srcport != PORT
```

```text
frame.time_relative > VALUE
```

```text
tcp.window_size < VALUE
```

```text
http contains "GET"
```

Actual field availability depends on the decoded protocol and packet capture.

---

# TCP Analysis Filters

Wireshark provides TCP analysis fields that can help locate suspicious traffic.

Examples introduced include concepts such as:

```text
tcp.analysis.flags
tcp.analysis.zero_window
```

These should be treated as analysis hints.

A Wireshark-generated analysis label is not automatically the root cause.

The surrounding flow and system evidence must still be interpreted.

---

# Saved Filters

Frequently used display filters can be saved for repeated analysis.

The operational value is:

```text
Common Troubleshooting Question
       ↓
Reusable Display Filter
       ↓
Faster Consistent Analysis
```

The useful concept is repeatability rather than the specific user-interface button used to save a filter.

---

# Packet Analysis Workflow

A practical workflow is:

```text
1. Define the symptom.

2. Identify relevant endpoints.

3. Capture broad enough traffic.

4. Confirm Layer 2 / Layer 3 behavior.

5. Apply display filters.

6. Identify the relevant TCP or application stream.

7. Follow the stream.

8. Inspect the flow graph.

9. Compare timestamps.

10. Correlate packet evidence with system evidence.

11. Identify the failing layer.

12. Verify after resolution.
```

---

# Packet Analysis and Troubleshooting

Packet capture answers a different question from configuration inspection.

```text
Configuration
→ What should happen?
```

```text
Packet Capture
→ What actually crossed the interface?
```

Useful packet-analysis questions include:

```text
Did the client send the request?

Did the request reach the server?

Did the server respond?

Did the response leave the server?

Did ARP resolution occur?

Did DNS resolution occur?

Was the TCP handshake completed?

Was the connection reset?

Did the application send data?

Where did the communication stop?

Where did the largest timing gap occur?
```

---

# Example: TCP Connection Failure

```text
Client Cannot Connect
       ↓
SYN sent?
       ↓
SYN reaches server?
       ↓
Server responds?
```

Possible observations include:

```text
No SYN reaches server
→ Investigate network path / firewall before the server
```

```text
SYN reaches server
RST returns
→ Investigate listening service / connection rejection
```

```text
SYN
SYN/ACK
ACK
→ TCP connection established
→ Investigate higher application layers
```

---

# Example: DNS Failure

A packet-oriented DNS workflow is:

```text
Client Generates DNS Query?
       ↓
Query Leaves Client?
       ↓
Query Reaches Resolver?
       ↓
Resolver Responds?
       ↓
Response Returns to Client?
```

Packet evidence should be correlated with:

```text
dig
host
getent
Resolver Configuration
DNS Server Logs
```

---

# Example: Slow Application

A slow service can be analyzed using:

```text
TCP Handshake Timing
        ↓
Application Request
        ↓
Response Delay
        ↓
Data Transfer
        ↓
Acknowledgments
```

Useful Wireshark functions include:

```text
Follow Stream
Flow Graph
Packet Timestamps
Display Filters
```

A visible delay must be interpreted according to direction and protocol context before deciding whether the network or application is responsible.

---

# Packet Capture Is Evidence

Packet analysis can reveal symptoms without proving the underlying cause.

For example:

```text
TCP Retransmission
```

can be related to multiple conditions.

Possible areas can include:

```text
Packet Loss
Congestion
Network Path
Firewall Behavior
Remote Endpoint Behavior
```

Do not conclude the root cause from one packet label alone.

Correlate:

```text
Topology
Configuration
Logs
Socket State
Packet Flow
Application Behavior
```

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

Packet capture can be inserted wherever direct traffic evidence is required.

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
SYN Reaches Server?
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
tcpdump
Wireshark
systemctl
journalctl
```

---

# Example: Web Service Failure

```text
Network Reachability
       ↓
TCP 80 / 443
       ↓
TCP Handshake
       ↓
Listening Socket
       ↓
Firewall
       ↓
HTTP Request
       ↓
Application Response
```

Useful tools can include:

```text
ip
traceroute
nc
ss
tcpdump
Wireshark
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
→ Runtime address change
```

```text
NetworkManager profile
→ Persistent network configuration
```

This same distinction appears throughout Linux and container infrastructure.

---

# Legacy and Modern Tools

Some training materials contain historical Linux networking commands and terminology.

These are preserved for context while modern alternatives are also documented.

Examples include:

```text
route
→ ip route

arp
→ ip neigh

netstat
→ ss

ifconfig
→ ip addr / ip link

nmap -sP
→ nmap -sn

nmap -PN
→ nmap -Pn
```

Historical protocol terminology is treated similarly.

---

# Relationship to Linux Labs

General networking theory is documented under:

```text
network/
```

Operating-system-specific implementation remains under:

```text
linux/
```

For example:

```text
network/
→ Why ARP exists
→ How routing works
→ How DNS resolution works
→ How packet headers are structured
→ How packets move through layers
→ How packet captures expose communication behavior
```

while:

```text
linux/
→ NetworkManager configuration
→ Linux bridge configuration
→ Network teaming
→ SSH administration
→ firewalld
→ SELinux network policy
→ Apache
→ BIND / Unbound
→ NFS / Samba
```

This keeps network theory separate from Linux administration while preserving their relationship.

---

# Relationship to Docker

The networking foundation in this directory directly supports the Docker learning path.

Examples include:

```text
Linux Bridge
+
Ethernet Switching
→ Docker Bridge Networking
```

```text
IP Addressing
+
Routing
→ Container Connectivity
```

```text
TCP / UDP Ports
→ Docker Port Publishing
```

```text
DNS
→ Container Name Resolution
```

```text
Packet Analysis
→ Container Network Troubleshooting
```

Docker networking should therefore be understood as an application of existing Linux and network concepts rather than as an isolated Docker feature.

---

# Troubleshooting Method

Networking incidents should follow:

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

## Evidence

Collect observable state using appropriate tools.

## Root Cause

Identify the layer or configuration actually responsible for the failure.

## Resolution

Apply the smallest controlled change necessary to correct the issue.

## Verification

Repeat the original test and verify that expected behavior has returned.

---

# Evidence Policy

Course screenshots and example values are educational examples.

They are not recorded as actual lab evidence.

Do not fabricate:

```text
IP Addresses
MAC Addresses
Interface Names
Routes
DNS Responses
Packet Captures
TCP Sequence Numbers
TCP Acknowledgment Numbers
Packet Counts
Latency Measurements
Port Scan Results
Command Output
```

Actual environment-specific evidence should come from an authorized lab environment.

---

# Packet Capture Safety

Packet captures can contain sensitive information.

Possible sensitive content includes:

```text
Authentication Data
Internal IP Addresses
Hostnames
Cookies
Tokens
HTTP Payloads
DNS Names
Application Content
User Information
```

Before storing or publishing packet evidence:

```text
Review the capture.
Remove unrelated traffic.
Remove secrets.
Remove credentials.
Remove sensitive identifiers where required.
```

Capture only traffic from systems and networks that are authorized for analysis.

---

# Security Principles

Networking tools can expose information or affect system availability.

Important principles include:

```text
Scan only authorized networks.
Capture only authorized traffic.
Do not expose credentials.
Do not publish sensitive packet payloads.
Do not disable remote-management interfaces without a recovery path.
Do not treat ping success as proof of application availability.
Do not treat one Wireshark analysis label as automatic root cause.
```

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
Packet Analysis
Wireshark Stream Analysis
Flow Graph Analysis
Latency Analysis
Capture Filtering
Display Filtering
```

The networking foundation now covers both:

```text
Protocol Theory
+
Traffic Observation
+
Evidence-Based Troubleshooting
```

This provides a foundation for Docker, Kubernetes, cloud networking, and network security.

---

# Future Expansion

As the infrastructure learning path progresses, this directory can expand into areas such as:

```text
DHCP
VLAN
NAT
Advanced TCP Analysis
Network Segmentation
Load Balancing
Cloud VPC Networking
Security Groups
Network ACLs
VPN
Container Networking
Kubernetes Networking
Overlay Networks
Network Security
```

New files should be added only when those areas are actually studied or reproduced.

---

# What This Directory Demonstrates

This directory demonstrates progression from network fundamentals toward evidence-driven infrastructure troubleshooting.

```text
Theory
   ↓
Protocol Understanding
   ↓
System Observation
   ↓
Packet Capture
   ↓
Stream Analysis
   ↓
Flow Analysis
   ↓
Timing Analysis
   ↓
Troubleshooting
   ↓
Verification
```

The objective is not to collect commands or memorize packet headers.

The objective is to understand:

```text
What should happen?

What actually happened?

What do the headers show?

Which packets belong to the same conversation?

Where did communication stop?

Where did the delay occur?

Which layer failed?

What evidence proves it?

How was recovery verified?
```
