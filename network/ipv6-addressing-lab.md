# IPv6 Addressing Lab

## Objective

Understand IPv6 addressing, address representation, address types, link-local communication, IPv6 prefixes, Linux IPv6 inspection, routing, and basic IPv6 connectivity.

The goal is to distinguish IPv6 from IPv4 while understanding how IPv6 addressing appears and behaves on a Linux system.

## Scope

This lab covers:

```text
IPv6
128-bit Addressing
IPv6 Text Representation
Zero Compression
Unicast
Anycast
Multicast
Link-Local Addresses
Global Addresses
Historical Site-Local Addresses
Interface Identifiers
IPv6 Loopback
Linux IPv6 Inspection
IPv6 Routing
IPv6 Link-Local Connectivity
```

---

# IPv6 Overview

IPv6 uses:

```text
128 bits
16 bytes
```

This provides a much larger address space than IPv4.

IPv4:

```text
32 bits
```

IPv6:

```text
128 bits
```

The number of possible IPv6 addresses is extremely large but not mathematically infinite.

---

# IPv6 Features Introduced by the Course

The course introduces the following IPv6 characteristics:

```text
Very large address space
IPsec-related security capabilities
Extension headers
Stateless autoconfiguration
Network renumbering support
```

IPv6 support does not automatically make a network secure.

Security still depends on areas such as:

```text
Firewall policy
Routing
Application security
Access control
IPsec configuration
```

---

# IPv6 Address Structure

The course describes IPv6 using:

```text
Subnet Prefix
+
Interface ID
```

An IPv6 address contains 128 bits and is commonly written as eight 16-bit hexadecimal groups.

Example:

```text
FEDC:BA98:7654:3210:FEDC:BA98:7654:3210
```

General structure:

```text
xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx
```

---

# IPv6 Zero Compression

IPv6 notation can shorten long sequences of zero groups.

Example:

```text
1080:0:0:0:8:800:200C:417A
```

can be written as:

```text
1080::8:800:200C:417A
```

The `::` represents one or more consecutive zero groups.

---

# `::` Usage

A compressed IPv6 address must still be uniquely expandable back to 128 bits.

Therefore `::` is normally used only once within one IPv6 address.

Valid conceptual example:

```text
2001:db8::1
```

An address with multiple independent `::` sequences would be ambiguous.

---

# IPv6 Address Types

The course introduces:

```text
Unicast
Anycast
Multicast
```

Unlike IPv4, IPv6 does not use a broadcast address type.

Functions that previously depended on broadcast can use multicast mechanisms instead.

---

# IPv6 Unicast

The course introduces the following unicast categories:

```text
Link-Local
Site-Local
Global
```

The course material includes a historical Site-Local category.

Modern IPv6 operation should distinguish this historical concept from current address planning.

---

# Link-Local Address

IPv6 link-local addresses use the prefix:

```text
FE80::/10
```

They are used for communication on the local link.

Conceptually:

```text
Host A
   |
Same Link
   |
Host B
```

A router does not normally forward IPv6 link-local traffic beyond that link.

---

# Link-Local vs IPv4 Private Addressing

The course describes link-local addressing as serving a private-address-like role.

However, the scopes are not identical.

```text
IPv4 Private Address
→ Can be routed between internal subnets.

IPv6 Link-Local Address
→ Limited to the local link.
```

Do not treat the two concepts as direct equivalents.

---

# Historical Site-Local Address

The course introduces:

```text
Site-Local
```

and associates it with internal routing.

It also shows the historical range:

```text
FEC0::/10
```

Site-Local IPv6 addressing is deprecated.

It should therefore be treated as historical course content rather than a current IPv6 addressing recommendation.

---

# Global Unicast Address

A Global IPv6 Unicast address is used for routable IPv6 communication.

Conceptually:

```text
Host
  ↓
Global IPv6 Address
  ↓
Router
  ↓
IPv6 Network / Internet
```

---

# Anycast

The course identifies Anycast as an IPv6 address type.

Conceptually, the same anycast address can be associated with multiple nodes, while routing delivers traffic toward an appropriate instance.

The course does not provide a detailed Anycast configuration exercise in this section.

---

# Multicast

IPv6 supports multicast communication.

A major IPv6 multicast prefix is:

```text
FF00::/8
```

Multicast provides group-oriented communication and replaces several use cases that depend on broadcast in IPv4.

---

# IPv6 Loopback

The IPv6 loopback address is:

```text
::1
```

Conceptually it corresponds to the local-host loopback role represented in IPv4 by:

```text
127.0.0.1
```

---

# Interface Identifier Concepts

The course diagram introduces a method of creating an IPv6 Interface Identifier using a MAC address and an inserted `FFFE` value.

This relates to EUI-64-style interface identifier generation.

Conceptually:

```text
MAC Address
     ↓
Interface-Identifier Transformation
     ↓
IPv6 Interface ID
```

Modern IPv6 hosts do not always derive Interface IDs directly from MAC addresses.

Privacy and other address-generation mechanisms can also be used.

---

# Historical IPv6 Hierarchy

The course includes an older IPv6 hierarchy containing fields such as:

```text
FP
TLA-ID
NLA-ID
SLA-ID
Interface ID
```

This should be treated as historical IPv6 allocation material.

The enduring concept is that IPv6 addresses contain:

```text
Prefix Information
+
Interface Identification
```

Do not memorize the old TLA/NLA field structure as the current global IPv6 addressing architecture.

---

# Important IPv6 Prefixes

Useful concepts introduced by the course include:

```text
FE80::/10
→ Link-Local

FF00::/8
→ Multicast

::1
→ Loopback
```

The course also displays historical Site-Local addressing, which is deprecated.

---

# Inspect IPv6 Addresses on Linux

Use:

```bash
ip addr
```

or:

```bash
ip -6 addr
```

A link-local address can appear in a form such as:

```text
fe80::...
```

with:

```text
scope link
```

Actual addresses must come from the current lab environment.

Do not copy addresses from the lecture screenshot as runtime evidence.

---

# IPv6 Link Scope

A link-local address can exist independently on multiple network interfaces.

Therefore an interface scope identifier can be required when using a link-local destination.

Conceptually:

```text
fe80::ADDRESS%INTERFACE
```

Example structure:

```bash
ping6 fe80::ADDRESS%INTERFACE
```

Use the actual address and interface from the current lab environment.

---

# IPv6 Connectivity Test

The course demonstrates `ping6` with a link-local IPv6 address and an interface identifier.

A general workflow is:

```text
Inspect IPv6 Address
       ↓
Identify Interface
       ↓
Ping Link-Local Destination
       ↓
Specify Interface Scope
       ↓
Verify Replies
```

Do not fabricate response times or ICMP sequence numbers.

---

# IPv6 Routing Table

Inspect IPv6 routes with:

```bash
ip -6 route
```

IPv4 and IPv6 routing information can therefore be inspected separately.

```text
IPv4
→ ip route

IPv6
→ ip -6 route
```

Routing is studied in greater detail in the following network section.

---

# IPv6 SSH Concept

The course demonstrates remote SSH communication using an IPv6 link-local address.

Conceptually:

```text
SSH
 ↓
TCP
 ↓
IPv6
 ↓
Link-Local Interface
```

When a link-local destination is used, the interface scope can be required.

Use only authorized lab systems for remote-access tests.

---

# IPv4 and IPv6 Dual Stack

A Linux host can use both protocol stacks.

Conceptually:

```text
Linux Host
   |
   +-- IPv4
   |
   +-- IPv6
```

Network socket inspection can therefore display both IPv4 and IPv6 communication.

This is commonly referred to as a dual-stack environment.

---

# IPv4 vs IPv6

| Concept | IPv4 | IPv6 |
|---|---|---|
| Address Size | 32 bits | 128 bits |
| Common Representation | `192.168.1.10` | `2001:db8::1` |
| Unicast | Yes | Yes |
| Multicast | Yes | Yes |
| Broadcast | Yes | No IPv6 broadcast address |
| Link-Local | Different IPv4 mechanism | `FE80::/10` |
| Loopback | `127.0.0.1` | `::1` |

---

# IPv6 Troubleshooting Model

When IPv6 communication fails:

```text
Interface State
      ↓
IPv6 Address
      ↓
Address Scope
      ↓
Prefix
      ↓
IPv6 Route
      ↓
Link-Local Interface Scope
      ↓
Transport / Application
```

Do not interpret an IPv6 failure automatically as an IPv4 or DNS problem.

---

# Verification Checklist

- IPv6 was identified as a 128-bit protocol.
- IPv6 was distinguished from 32-bit IPv4.
- The very large IPv6 address space was understood.
- IPv6 text representation was reviewed.
- Zero compression using `::` was understood.
- Unicast was identified.
- Anycast was introduced.
- Multicast was identified.
- IPv6 broadcast absence was recognized.
- Link-local addressing was associated with `FE80::/10`.
- Link-local scope was distinguished from IPv4 private addressing.
- Historical Site-Local addressing was recognized as deprecated.
- Global IPv6 addressing was understood conceptually.
- IPv6 multicast was associated with `FF00::/8`.
- IPv6 loopback was associated with `::1`.
- EUI-64-style Interface ID generation was reviewed as one possible mechanism.
- Historical TLA/NLA addressing was not treated as the current IPv6 hierarchy.
- IPv6 addresses were inspected with Linux networking tools.
- Link-local interface scope identifiers were understood.
- IPv6 routing was inspected or reviewed with `ip -6 route`.
- IPv6 SSH communication was reviewed.
- IPv4 and IPv6 dual-stack operation was recognized.
- Lecture IPv6 addresses, interface names, and command outputs were not recorded as actual lab evidence.

---

# What I Learned

- IPv6 uses 128-bit addresses.
- IPv6 addresses are represented using hexadecimal groups.
- Consecutive zero groups can be compressed using `::`.
- IPv6 provides unicast, anycast, and multicast addressing.
- IPv6 does not use a broadcast address type.
- Link-local IPv6 addresses use `FE80::/10` and remain within the local link.
- Historical Site-Local addressing is deprecated.
- `::1` is the IPv6 loopback address.
- IPv6 Interface IDs can be generated using different mechanisms.
- `ip addr` can display both IPv4 and IPv6 configuration.
- `ip -6 route` displays the IPv6 routing table.
- Link-local IPv6 communication can require an interface scope identifier.
- Linux hosts can operate with IPv4 and IPv6 simultaneously.
