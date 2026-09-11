# ARP and RARP Lab

## Objective

Understand how IPv4 communication is mapped to Ethernet MAC addressing using ARP, how ARP requests and replies operate, how neighbor information is cached, and how historical RARP differs from ARP.

The goal is to understand the relationship between Layer 3 IPv4 addressing and Layer 2 Ethernet forwarding.

## Scope

This lab covers:

```text
ARP
IPv4-to-MAC Resolution
Direct Routing and ARP
Indirect Routing and Gateway MAC Resolution
ARP Request
ARP Reply
Broadcast MAC Address
ARP Cache
Linux Neighbor Table
RARP
```

---

# ARP Overview

ARP stands for:

```text
Address Resolution Protocol
```

The course defines ARP as a mechanism used to map:

```text
32-bit IPv4 Address
        ↓
48-bit Ethernet MAC Address
```

Conceptually:

```text
IPv4 Address
     ↓
ARP
     ↓
MAC Address
```

ARP allows an IPv4 host to determine the Ethernet destination address required for local-link communication.

---

# Why ARP Is Required

An IP packet identifies its destination using an IPv4 address.

Ethernet frames require a destination MAC address.

Conceptually:

```text
IP Layer

Destination IP
192.168.1.20

        ↓

Ethernet Layer

Destination MAC
?
```

ARP resolves the missing Layer 2 address.

---

# ARP Between IP and Ethernet

ARP connects network-layer addressing with link-layer addressing.

Conceptually:

```text
IPv4
  ↓
ARP
  ↓
Ethernet / MAC
```

Different teaching models can place ARP differently in simplified protocol-layer diagrams.

The important concept is its function:

```text
IPv4 Address
→ Ethernet MAC Address
```

---

# Direct Routing and ARP

When two systems belong to the same local network, the sender can deliver the Ethernet frame directly to the destination host.

Example:

```text
Host A
192.168.1.10/24

Host B
192.168.1.20/24
```

The sender determines that the destination is local.

It then needs:

```text
Host B MAC Address
```

to create the Ethernet frame.

The process is:

```text
Destination IPv4 Address
        ↓
Local Network?
        ↓
ARP
        ↓
Destination MAC
        ↓
Ethernet Frame
```

---

# Name Resolution vs ARP

The course example begins by finding the destination IP address through `/etc/hosts`.

This should be distinguished from ARP.

```text
Hostname
→ IPv4 Address
```

is a name-resolution function.

Possible sources can include:

```text
/etc/hosts
DNS
Other configured name services
```

ARP begins after the IPv4 destination is known.

```text
IPv4 Address
→ MAC Address
```

is the ARP function.

---

# Determine Whether the Destination Is Local

The sender uses its address and network mask or prefix to determine whether the destination is on the local network.

Conceptually:

```text
Destination IPv4
      ↓
Apply Network Prefix
      ↓
Local Network?
   ┌───────┴───────┐
  Yes              No
   ↓                ↓
Resolve          Resolve
Destination      Gateway
MAC              MAC
```

---

# ARP Cache

Before sending an ARP request, a system can inspect its existing ARP or neighbor cache.

The cache stores mappings such as:

```text
IPv4 Address
      ↕
MAC Address
```

Example structure:

```text
192.168.1.20
→ aa:bb:cc:dd:ee:ff
```

If a usable mapping already exists, another ARP broadcast may not be necessary.

---

# ARP Request

If the MAC address is not available in the cache, the sender transmits an ARP Request.

Conceptually:

```text
Who has 192.168.1.20?
Tell 192.168.1.10.
```

The request must reach systems on the local Ethernet segment because the sender does not yet know which MAC owns the target IPv4 address.

---

# ARP Request and Broadcast

The ARP Request is sent using the Ethernet broadcast destination:

```text
ff:ff:ff:ff:ff:ff
```

Conceptually:

```text
Host A
   |
   | Broadcast ARP Request
   v
+------+------+------+------+
Host B Host C Host D Host E
```

All systems in the broadcast domain can receive the request.

---

# ARP Reply

Each receiving system compares the ARP target IPv4 address with its own address.

The system that owns the target address responds with its MAC address.

Conceptually:

```text
Host A:
Who has 192.168.1.20?

        ↓

Host B:
I have 192.168.1.20.
My MAC is aa:bb:cc:dd:ee:ff.
```

---

# Cache Update

After receiving the ARP Reply, the sender can update its neighbor information.

```text
IPv4
192.168.1.20

MAC
aa:bb:cc:dd:ee:ff
```

The sender can then create an Ethernet frame using the learned destination MAC.

---

# ARP Communication Flow

```text
Destination IPv4 Known
        ↓
Check Network Prefix
        ↓
Destination Is Local
        ↓
Check ARP / Neighbor Cache
        ↓
Mapping Available?
   ┌────────┴────────┐
  Yes                No
   ↓                  ↓
Use MAC         Send ARP Request
                       ↓
                   Broadcast
                       ↓
                   ARP Reply
                       ↓
                  Update Cache
                       ↓
                  Use MAC Address
                       ↓
                 Send Ethernet Frame
```

---

# Indirect Routing and ARP

If the destination is outside the local network, the sender does not resolve the remote host's MAC address directly.

Instead, it needs the MAC address of the local gateway.

Conceptually:

```text
Host A
192.168.1.10

Destination IP
10.0.0.20

        ↓

Different Network

        ↓

Default Gateway
192.168.1.1

        ↓

ARP for Gateway MAC
```

---

# IP Destination vs Ethernet Destination

For remote communication:

```text
IP Header

Destination IP
→ Final Remote Host
```

while the first Ethernet frame uses:

```text
Ethernet Header

Destination MAC
→ Local Default Gateway
```

The two destination identifiers therefore can refer to different devices.

---

# Hop-by-Hop Ethernet Forwarding

As an IP packet crosses routers, Ethernet headers can change on each local link.

Conceptually:

```text
Host A
  ↓ Frame 1
Router 1
  ↓ Frame 2
Router 2
  ↓ Frame 3
Host B
```

The end-to-end IP destination remains associated with the remote host, while local-link MAC addresses can change at each Ethernet hop.

---

# Inspect ARP Cache

The course demonstrates:

```bash
arp -a
```

to inspect cached IPv4-to-MAC mappings.

The course screenshots show information such as:

```text
IPv4 Address
MAC Address
Interface
```

Do not copy the lecture addresses or MAC values as actual lab evidence.

---

# Modern Linux Neighbor Inspection

Modern Linux commonly uses:

```bash
ip neigh
```

or:

```bash
ip neigh show
```

to inspect the neighbor table.

This provides the modern Linux view of IPv4 neighbor resolution.

---

# Neighbor States

Depending on the environment, Linux neighbor entries can include states such as:

```text
REACHABLE
STALE
DELAY
FAILED
```

These states can provide useful evidence during local-link troubleshooting.

Actual output must come from the lab environment.

---

# ARP Troubleshooting Model

When two IPv4 systems on the same subnet cannot communicate:

```text
Interface State
      ↓
IPv4 Address
      ↓
Prefix / Subnet
      ↓
Destination Is Local?
      ↓
Neighbor Table
      ↓
ARP Request
      ↓
ARP Reply
      ↓
Ethernet / Switch / Link
```

Do not investigate a remote routing protocol before confirming whether the destination is actually local.

---

# Remote-Network Troubleshooting

When the destination is outside the local subnet:

```text
Destination IPv4
      ↓
Routing Table
      ↓
Default / Specific Route
      ↓
Gateway
      ↓
Gateway Neighbor Entry
      ↓
Gateway MAC Resolution
      ↓
Forward Packet
```

The sender requires the gateway MAC rather than the final remote host MAC.

---

# RARP

RARP stands for:

```text
Reverse Address Resolution Protocol
```

Its conceptual mapping is:

```text
MAC Address
    ↓
RARP
    ↓
IPv4 Address
```

This is the reverse direction of ARP.

---

# ARP vs RARP

```text
ARP

IPv4
 ↓
MAC
```

```text
RARP

MAC
 ↓
IPv4
```

The course page contains an introductory sentence that labels the MAC-to-IP mapping as ARP, but the table and section context show that the intended protocol is RARP.

---

# RARP and Network Boot

The course associates RARP with network boot.

Conceptually:

```text
Device Knows MAC Address
        ↓
Needs IPv4 Address
        ↓
RARP
```

RARP is primarily of historical importance.

Modern network boot and dynamic address configuration use later mechanisms such as BOOTP and DHCP rather than relying on RARP.

---

# Verification Checklist

- ARP was identified as Address Resolution Protocol.
- ARP was understood as IPv4-to-MAC resolution.
- IPv4 and Ethernet destination addressing were distinguished.
- Name resolution was distinguished from ARP.
- Local-network determination using a prefix was understood.
- ARP cache behavior was reviewed.
- ARP Requests were identified as Ethernet broadcasts.
- The broadcast MAC address was identified.
- ARP Reply behavior was understood.
- Cache update after ARP Reply was understood.
- Direct routing was connected to destination-host MAC resolution.
- Indirect routing was connected to gateway MAC resolution.
- Final IP destination and local Ethernet destination were distinguished.
- `arp -a` was reviewed as the course command.
- `ip neigh` was introduced as the modern Linux neighbor-table command.
- RARP was identified as MAC-to-IPv4 resolution.
- The course RARP wording error was recognized.
- RARP was understood as a historical network-boot mechanism.
- Lecture IP and MAC addresses were not recorded as actual runtime evidence.

---

# What I Learned

- ARP resolves an IPv4 address to an Ethernet MAC address.
- Ethernet communication requires a destination MAC address.
- An ARP Request uses Ethernet broadcast because the destination MAC is not yet known.
- The host owning the requested IPv4 address responds with its MAC address.
- Resolved neighbor information can be stored in a cache.
- A local destination requires the destination host's MAC address.
- A remote destination requires the local gateway's MAC address.
- The final IP destination and immediate Ethernet destination can be different devices.
- `ip neigh` is useful for inspecting Linux neighbor state.
- RARP performs the conceptual reverse mapping from MAC address to IPv4 address.
- RARP is primarily a historical protocol and has been superseded by later network-configuration mechanisms.
