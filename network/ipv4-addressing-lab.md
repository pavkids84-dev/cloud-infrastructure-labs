# IPv4 Addressing Lab

## Objective

Understand IPv4 addressing, address types, private address ranges, classful addressing concepts, subnetting, CIDR, VLSM, and basic Linux IPv4 inspection and runtime configuration.

The goal is to understand how IPv4 addresses identify networks and hosts and how addressing relates to later routing and ARP behavior.

## Scope

This lab covers:

```text
IPv4
Network Address
Host Address
Unicast
Multicast
Broadcast
Classful Addressing
Private IPv4 Addresses
Subnetting
CIDR
VLSM
Linux IPv4 Inspection
Runtime IPv4 Configuration
Persistent Network Configuration Concepts
```

---

# IPv4 Overview

IPv4 uses:

```text
32 bits
4 bytes
```

An IPv4 address is commonly represented using four decimal octets.

Example:

```text
192.168.10.20
```

Conceptually, an IP address contains:

```text
Network Portion
+
Host Portion
```

The network portion identifies the network.

The host portion identifies a host or interface within that network.

---

# IPv4 Address Types

The course introduces:

```text
Unicast
Multicast
Broadcast
```

A simplified communication model is:

```text
Unicast
→ One sender to one destination

Multicast
→ One sender to selected group members

Broadcast
→ One sender to all hosts in the local IPv4 broadcast domain
```

---

# Unicast

The course describes unicast as:

```text
1:1 communication
```

A unicast IPv4 address identifies an individual communication destination.

Conceptually:

```text
Host A
   |
   | Unicast
   v
Host B
```

---

# Classful IPv4 Addressing

The course introduces the historical classful addressing model.

```text
Class A
→ First octet 0-127
→ Network portion historically based on the first byte

Class B
→ First octet 128-191
→ Network portion historically based on the first two bytes

Class C
→ First octet 192-223
→ Network portion historically based on the first three bytes
```

The bit prefixes introduced by the course are:

```text
Class A
→ 0

Class B
→ 10

Class C
→ 110
```

Classful addressing is important historically, but modern network design primarily uses CIDR prefixes.

---

# CIDR Instead of Class Assumptions

Modern network addressing should normally be interpreted using:

```text
IP Address + Prefix Length
```

Examples:

```text
192.168.10.0/24
10.0.0.0/16
172.16.32.0/20
```

Do not assume that an address beginning with `192` must always use a `/24` network.

The prefix determines the actual network boundary.

---

# Private IPv4 Address Ranges

The course introduces the standard private IPv4 ranges.

```text
10.0.0.0/8

172.16.0.0/12

192.168.0.0/16
```

The second range covers:

```text
172.16.0.0
through
172.31.255.255
```

These ranges are commonly used for internal networks.

---

# Private and Public Addressing

A private IPv4 address is normally used inside private network environments.

A public IPv4 address can be globally routed on the Internet.

Conceptually:

```text
Private Network
      ↓
Routing / NAT Environment
      ↓
Public Network
```

The detailed NAT mechanism is studied separately.

---

# Multicast

The course introduces IPv4 multicast as:

```text
1:M communication
```

The receivers are members of a multicast group.

The classful multicast range introduced by the course is:

```text
224.0.0.0
through
239.255.255.255
```

The course examples include:

```text
224.0.0.1
→ All hosts on the local network

224.0.0.2
→ Routers on the local network
```

The course also introduces:

```text
IGMP
```

as a protocol associated with multicast-group management.

---

# Broadcast

IPv4 broadcast communication targets all hosts in a local broadcast domain.

For a subnet, the directed broadcast address is created by:

```text
Keep the network bits
+
Set all host bits to 1
```

Example:

```text
Network
192.168.10.0/24

Host bits
11111111

Directed Broadcast
192.168.10.255
```

This should be distinguished from:

```text
255.255.255.255
```

which represents the limited IPv4 broadcast address.

---

# Unicast, Multicast, and Broadcast

```text
Unicast

Sender
  |
  v
One Receiver
```

```text
Multicast

Sender
  |
  v
Multicast Group
  |
  +-- Member A
  +-- Member B
  +-- Member C
```

```text
Broadcast

Sender
  |
  v
All Hosts in Local Broadcast Domain
```

---

# IPv4 Address Transformation Concepts

The course introduces:

```text
Subnetting
Supernetting / CIDR
VLSM
```

These concepts allow networks to be divided or represented independently of historical address classes.

---

# Subnetting

Subnetting divides a larger address space into smaller networks.

A simplified hierarchy is:

```text
Network Number
+
Host Number
```

becoming:

```text
Network Number
+
Subnet Number
+
Host Number
```

Example concept:

```text
10.0.0.0/16
     |
     +-- 10.0.1.0/24
     +-- 10.0.2.0/24
     +-- 10.0.3.0/24
```

Subnetting allows network address space to be organized into smaller routing and broadcast domains.

---

# CIDR

CIDR stands for:

```text
Classless Inter-Domain Routing
```

CIDR represents a network using:

```text
ADDRESS/PREFIX_LENGTH
```

Example:

```text
192.168.10.0/24
```

IPv4 contains 32 bits.

A `/24` prefix means:

```text
Network bits
→ 24

Host bits
→ 8
```

The corresponding subnet mask is:

```text
255.255.255.0
```

---

# CIDR Example from the Course

The course states that:

```text
204.106.8.1/22
204.106.9.1/22
```

belong to the same subnet.

A `/22` mask is:

```text
255.255.252.0
```

The third-octet block size is:

```text
256 - 252
= 4
```

Therefore the subnet beginning at third octet `8` covers:

```text
204.106.8.0
through
204.106.11.255
```

The network is:

```text
204.106.8.0/22
```

Both course addresses fall inside that subnet.

---

# VLSM

VLSM stands for:

```text
Variable Length Subnet Mask
```

The course lists VLSM as an IPv4 addressing method but does not provide a detailed VLSM configuration exercise in this section.

Conceptually, VLSM allows different prefix lengths to be used inside a larger address space.

Example:

```text
10.0.0.0/24
   |
   +-- 10.0.0.0/25
   +-- 10.0.0.128/26
   +-- 10.0.0.192/27
```

This allows subnet size to be adapted to different host requirements.

---

# Linux IPv4 Inspection

The course introduces:

```text
ifconfig
ip
nmcli
```

as network-management tools.

Modern Rocky Linux administration primarily uses:

```text
ip
NetworkManager
nmcli
```

---

# Interface Naming Concepts

Interface names introduced by the course include:

```text
eth0
eth1
eno...
→ Ethernet

wlan0
→ Wireless LAN

virbr0
→ Virtual bridge

bond0
team0
→ Grouped network interfaces
```

Actual interface names depend on the current operating system and environment.

Do not copy the course interface names as runtime evidence.

---

# Inspect IPv4 Addresses

Use:

```bash
ip addr
```

or:

```bash
ip addr show INTERFACE
```

Information can include:

```text
Interface state
MAC address
IPv4 address
IPv6 address
Prefix
MTU
```

---

# Inspect Link State

Use:

```bash
ip link
```

This exposes information such as:

```text
Interface
Link state
MAC address
MTU
```

The command provides lower-layer information that complements IP addressing.

---

# Inspect IPv4 Routes

Use:

```bash
ip route
```

This displays the IPv4 routing table.

Typical information includes:

```text
Connected networks
Default route
Gateway
Interface
```

Routing is studied in greater detail in the next network section.

---

# Temporary IPv4 Configuration

The course introduces command-based temporary configuration.

Examples include:

```bash
dhclient INTERFACE
```

and historical `ifconfig` configuration.

The course also demonstrates the modern `ip` command form:

```bash
sudo ip addr add ADDRESS/PREFIX dev INTERFACE
```

Example structure:

```bash
sudo ip addr add 192.168.10.100/24 dev INTERFACE
```

Use only addresses belonging to the disposable lab network.

---

# Runtime Configuration

A command such as:

```bash
ip addr add
```

changes the current kernel network state.

Conceptually:

```text
ip addr
→ Runtime state
```

It should not automatically be treated as persistent NetworkManager configuration.

---

# Persistent Network Configuration

The course introduces:

```text
network.service
NetworkManager.service
```

for persistent network management.

For a modern Rocky Linux environment, NetworkManager is the primary management framework used in these labs.

The legacy `network.service` approach should be understood as part of older Red Hat network administration.

---

# Runtime vs Persistent Networking

```text
ip addr add
→ Current runtime network state
```

```text
NetworkManager connection configuration
→ Managed persistent configuration
```

This follows the broader infrastructure principle:

```text
Runtime State
!=
Persistent Configuration
```

---

# IPv4 Troubleshooting Model

When an IPv4 connectivity problem occurs:

```text
Interface
    ↓
IPv4 Address
    ↓
Prefix / Subnet
    ↓
Route
    ↓
Gateway
    ↓
Name Resolution
    ↓
Transport / Service
```

Address configuration should be verified before changing unrelated application settings.

---

# Verification Checklist

- IPv4 was identified as a 32-bit protocol.
- Network and host portions were distinguished.
- Unicast was understood.
- Multicast was understood.
- Broadcast was understood.
- Historical Class A, B, and C concepts were reviewed.
- CIDR was distinguished from classful addressing.
- Private IPv4 ranges were identified.
- The multicast range was reviewed.
- Directed broadcast was understood as all host bits set to 1.
- Subnetting was understood conceptually.
- CIDR prefix notation was understood.
- The course `/22` example was calculated.
- VLSM was introduced.
- Linux interface naming concepts were reviewed.
- `ip addr` was used or reviewed for address inspection.
- `ip link` was used or reviewed for link inspection.
- `ip route` was used or reviewed for routing-table inspection.
- Runtime IPv4 configuration with `ip addr` was distinguished from persistent configuration.
- NetworkManager was recognized as the primary modern Rocky Linux network-management framework.
- Course IP addresses and interface names were not recorded as actual environment evidence.

---

# What I Learned

- IPv4 uses 32-bit addresses.
- An IPv4 address contains network and host information.
- Unicast, multicast, and broadcast support different communication scopes.
- Private IPv4 addresses use the `10/8`, `172.16/12`, and `192.168/16` ranges.
- Historical IPv4 classes help explain older addressing models, but CIDR is the modern addressing model.
- A prefix length defines the network boundary.
- Subnetting divides larger address spaces into smaller networks.
- VLSM allows different subnet sizes inside an address space.
- `ip addr` inspects and modifies runtime IP state.
- `ip link` exposes interface and link information.
- `ip route` exposes IPv4 routing information.
- Runtime network changes and persistent network configuration are separate concepts.
