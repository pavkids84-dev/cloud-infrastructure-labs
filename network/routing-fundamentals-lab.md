# Routing Fundamentals Lab

## Objective

Understand routing decisions, direct and indirect routing, routing tables, default routes, static and dynamic routing, Linux route inspection, IPv4 forwarding, and the basic operation of RIP.

The goal is to understand how a host or router decides where an IPv4 packet should be sent.

## Scope

This lab covers:

```text
Routing
Host Routing Tables
Routers
Direct Routing
Indirect Routing
Default Gateway
Static Routing
Dynamic Routing
Routing Table Inspection
IPv4 Forwarding
RIP
Distance Vector Routing
Hop Count
RIPv2
Triggered Updates
Hold-Down State
```

---

# Routing Overview

The course defines routing as the process of determining the path used to forward a transmitted or received packet.

Conceptually:

```text
Packet
  ↓
Destination IPv4 Address
  ↓
Routing Table
  ↓
Select Route
  ↓
Forward Packet
```

Routing is performed by both hosts and routers.

---

# Host Routing

A host uses its own routing table before sending an IP packet.

Conceptually:

```text
Application Generates Traffic
        ↓
Destination IPv4 Address
        ↓
Host Routing Table
        ↓
Select Local Interface / Gateway
```

A host therefore participates in routing decisions even when it is not functioning as a router between networks.

---

# Router

A router is a Layer 3 network device used to connect different networks.

Conceptually:

```text
Network A
    |
    v
  Router
    |
    v
Network B
```

A router examines destination IP information and uses its routing table to determine where packets should be forwarded.

---

# Direct Routing

The course distinguishes direct routing from indirect routing.

Direct routing occurs when the destination can be reached without passing through a router.

Conceptually:

```text
Host A
192.168.1.10/24
       |
       | Same Network
       |
Host B
192.168.1.20/24
```

The sender communicates directly over the local network.

---

# Indirect Routing

Indirect routing occurs when the destination belongs to another network and a router must be used.

Conceptually:

```text
Host A
192.168.1.10
      |
      v
Default Gateway
192.168.1.1
      |
      v
Router
      |
      v
Remote Network
10.0.0.0/24
```

The local system sends the packet toward a gateway or next hop.

---

# Local-Network Decision

A host uses its IPv4 address and prefix to determine whether a destination belongs to the same network.

Conceptually:

```text
Destination IPv4
      ↓
Apply Prefix
      ↓
Same Network?
   ┌───────┴───────┐
  Yes              No
   ↓                ↓
Direct          Indirect
Routing          Routing
```

This decision also determines which MAC address must be resolved with ARP.

---

# Direct vs Indirect Ethernet Destination

For direct routing:

```text
IP Destination
→ Destination Host

Ethernet Destination
→ Destination Host MAC
```

For indirect routing:

```text
IP Destination
→ Final Remote Host

Ethernet Destination
→ Local Gateway MAC
```

This distinction is fundamental to IP-over-Ethernet forwarding.

---

# Routing Table

A routing table describes how destinations should be reached.

A route can identify:

```text
Destination Network
Prefix
Gateway / Next Hop
Interface
Metric
Protocol Source
```

The exact fields depend on the routing command being used.

---

# Directly Connected Route

A directly connected route can appear conceptually as:

```text
192.168.10.0/24 dev eth0
```

This indicates that the network is reachable directly through the specified interface.

No intermediate gateway is required.

---

# Gateway Route

An indirect route can appear conceptually as:

```text
DESTINATION/PREFIX via GATEWAY dev INTERFACE
```

The gateway is the next-hop router used to continue forwarding the packet.

---

# Default Route

The course defines a default gateway as the routing entry used when no more specific route is available.

IPv4 default routing can be represented as:

```text
0.0.0.0/0
```

Conceptually:

```text
Destination
     ↓
Specific Route Exists?
  ┌─────┴─────┐
 Yes          No
  ↓            ↓
Use It     Default Route
```

---

# Longest Prefix Match

A routing table can contain several routes that match one destination.

The most specific matching prefix is normally selected.

Example:

```text
10.0.0.0/8
10.10.0.0/16
0.0.0.0/0
```

Destination:

```text
10.10.20.5
```

matches all three, but:

```text
10.10.0.0/16
```

is the most specific route.

This principle is commonly known as:

```text
Longest Prefix Match
```

The course section does not name this rule directly, but it is an important extension of routing-table interpretation.

---

# Static Routing

The course introduces static routes as manually managed routing-table entries.

Conceptually:

```text
Administrator
     ↓
Configure Route
     ↓
Routing Table
```

Static routes are predictable and simple but require manual management.

---

# Dynamic Routing

Dynamic routing uses routing protocols to automatically exchange and update route information.

The course lists examples such as:

```text
RIP
OSPF
RDISC
```

Conceptually:

```text
Router A
   ↕
Routing Protocol
   ↕
Router B
   ↕
Routing Protocol
   ↕
Router C
```

Routers can adapt their routing tables based on received network information.

---

# Static vs Dynamic Routing

```text
Static Routing
→ Administrator configures routes manually.
```

```text
Dynamic Routing
→ Routing protocols learn and update routes.
```

The course associates static routing primarily with hosts and dynamic routing primarily with routers.

Actual network designs can use both approaches together.

---

# Inspect Routing Tables

The course introduces:

```bash
netstat -rn
```

```bash
route
```

```bash
ip route
```

For modern Linux administration, the primary command in this lab is:

```bash
ip route
```

The other commands are useful for understanding legacy Linux routing output.

---

# Inspect IPv4 Routing

Use:

```bash
ip route
```

Inspect information such as:

```text
Default route
Connected networks
Gateway
Interface
Source address
Metric
Protocol
Scope
```

Actual routes must come from the lab environment.

---

# Add a Default Route

The course demonstrates legacy syntax such as:

```bash
route add default gw GATEWAY metric 1 dev INTERFACE
```

and the modern `ip` form:

```bash
ip route add default via GATEWAY
```

General modern structure:

```bash
sudo ip route add default via GATEWAY
```

Use only a verified gateway from a disposable lab network.

Changing the default route can immediately disconnect a remote session.

---

# Remove a Default Route

The course demonstrates removing the default gateway using the legacy `route` command.

In a lab, route-removal operations should be performed from a VM console or another recovery-safe access method.

Do not remove the management route of a remotely administered system without a recovery path.

---

# Verify Route Changes

After modifying a route:

```bash
ip route
```

should be used to verify the resulting runtime routing table.

The workflow is:

```text
Inspect Baseline
      ↓
Modify One Route
      ↓
Inspect Routing Table Again
      ↓
Verify Connectivity
```

---

# Legacy Routing Table Fields

The course explains fields used by tools such as `route` and `netstat -rn`.

These include:

```text
Destination
Gateway
Flags
Ref
Use
Interface
```

---

# Legacy Route Flags

The course introduces:

```text
U
→ Route or interface is up.

H
→ Destination is a host rather than a network.

G
→ Route uses a gateway.

D
→ Entry was dynamically added through ICMP redirect behavior.
```

These flags are primarily useful when reading legacy route output.

Modern Linux troubleshooting commonly focuses on `ip route` fields instead.

---

# Modern `ip route` Concepts

Useful `ip route` terms can include:

```text
default
via
dev
src
metric
proto
scope
```

Understanding these is generally more useful in a current Rocky Linux environment than memorizing legacy flag output.

---

# Linux as an IPv4 Router

A Linux system can act as a router between interfaces.

The course introduces:

```bash
sysctl -a | grep forward
```

and:

```bash
sysctl -w net.ipv4.ip_forward=1
```

The kernel parameter:

```text
net.ipv4.ip_forward
```

controls IPv4 packet forwarding.

---

# IPv4 Forwarding

A normal host primarily processes packets addressed to itself.

A router forwards packets whose destination belongs to another network.

Conceptually:

```text
Packet Arrives
       ↓
Destination Is Local?
   ┌──────┴──────┐
  Yes            No
   ↓              ↓
Process       Routing Table
Locally           ↓
             Forward Packet
```

IPv4 forwarding must be enabled when a Linux host is intentionally operating as a router.

---

# Runtime vs Persistent Forwarding

The command:

```bash
sysctl -w net.ipv4.ip_forward=1
```

changes the runtime kernel state.

Conceptually:

```text
sysctl -w
→ Runtime
```

Persistent forwarding requires persistent sysctl configuration.

This follows the infrastructure principle:

```text
Runtime State
!=
Persistent Configuration
```

---

# Dynamic Routing with RIP

RIP stands for:

```text
Routing Information Protocol
```

The course introduces RIP as a basic dynamic routing protocol.

Key course characteristics include:

```text
Distance Vector Protocol
15-Hop Limit
Periodic 30-Second Route Advertisement
Designed for Small Networks
RIPv2 VLSM Support
Triggered Update Support
Hold-Down State
```

---

# Distance Vector Routing

RIP is a distance-vector routing protocol.

A simplified interpretation is:

```text
Distance
→ How far is the destination?

Vector
→ In which direction should traffic be sent?
```

RIP uses router information received from neighboring routers.

---

# Hop Count

RIP uses:

```text
Hop Count
```

as its primary routing metric.

Conceptually:

```text
Host
 ↓
Router 1
 ↓ Hop 1
Router 2
 ↓ Hop 2
Router 3
 ↓ Hop 3
Destination Network
```

A path with fewer RIP hops is preferred over one with more hops.

---

# RIP Hop Limit

The course states that RIP is limited to:

```text
15 hops
```

Traditionally:

```text
1-15
→ Reachable

16
→ Unreachable
```

This limits RIP scalability.

---

# Periodic Routing Updates

The course states that RIP advertises routing information every:

```text
30 seconds
```

Conceptually:

```text
Router A
   |
   | Routing Update
   v
Router B
```

Periodic advertisements allow neighboring routers to learn network reachability.

---

# RIP and Small Networks

The course describes RIP as appropriate for smaller networks.

Characteristics that limit scalability include:

```text
Hop-count limit
Periodic route advertisement
Distance-vector convergence behavior
```

RIP is therefore useful for learning dynamic-routing fundamentals but is not generally the routing protocol used for large modern enterprise networks.

---

# Equal-Cost Paths

The course states that multiple equal-cost routes can be used for load balancing and provides a value of six paths.

The exact number of equal-cost paths supported can depend on router or routing-software implementation.

The important concept for this lab is:

```text
Multiple routes with equal routing cost can potentially be used.
```

Do not treat the course value as a universal RIP protocol limit.

---

# RIPv2 and VLSM

The course states that RIPv2 supports:

```text
VLSM
```

This allows routes to include classless prefix information.

Conceptually:

```text
10.0.0.0/25
10.0.0.128/26
```

can be represented with their actual prefix lengths rather than relying on classful boundaries.

---

# Triggered Updates

The course introduces triggered updates with RIPv2.

Conceptually:

```text
Network Change
      ↓
Do Not Wait Only for Next Periodic Update
      ↓
Send Routing Change Information
```

Triggered updates can reduce the delay before neighboring routers learn an important change.

---

# Route Failure and Hold-Down

The course introduces a hold-down state to reduce instability caused by frequent routing updates.

Conceptually:

```text
Route Failure Detected
        ↓
Start Hold-Down Timer
        ↓
Mark Path as Possibly Down
        ↓
Receive Route Update
        ↓
Evaluate Metric
```

---

# Hold-Down Behavior from the Course

The course describes the logic as:

```text
Receive a better metric
→ Cancel timer
→ Update path
```

while other path information can be ignored during the hold-down period.

The purpose is to reduce unstable routing behavior after a failure.

---

# Routing Troubleshooting Model

When a remote IPv4 destination cannot be reached:

```text
Interface
    ↓
IPv4 Address
    ↓
Prefix
    ↓
Destination Local or Remote?
    ↓
Routing Table
    ↓
Specific Route
    ↓
Default Route
    ↓
Gateway
    ↓
Neighbor Resolution
    ↓
Next-Hop Connectivity
```

Do not change DNS or application configuration before confirming that the network route itself exists.

---

# Direct-Destination Troubleshooting

If the destination belongs to the local subnet:

```text
IPv4 / Prefix
      ↓
Connected Route
      ↓
ARP / Neighbor
      ↓
Ethernet Link
```

A gateway should not normally be required for the local destination.

---

# Remote-Destination Troubleshooting

If the destination belongs to another network:

```text
Destination
      ↓
Specific Route?
      ↓
Default Route?
      ↓
Gateway
      ↓
Gateway Neighbor Entry
      ↓
Router Path
```

This helps distinguish a local Layer 2 problem from a Layer 3 routing problem.

---

# Verification Checklist

- Routing was understood as path selection based on a routing table.
- Hosts were recognized as having routing tables.
- Routers were identified as Layer 3 forwarding devices.
- Direct routing was understood.
- Indirect routing was understood.
- Local-network determination using a prefix was understood.
- Default gateway behavior was understood.
- Connected routes were distinguished from gateway routes.
- Static routing was reviewed.
- Dynamic routing was reviewed.
- `ip route` was identified as the primary modern Linux routing command.
- Legacy `route` and `netstat -rn` output concepts were reviewed.
- Legacy route flags were understood as compatibility knowledge.
- Route modifications were treated as connectivity-sensitive operations.
- IPv4 forwarding was associated with `net.ipv4.ip_forward`.
- Runtime and persistent forwarding configuration were distinguished.
- RIP was identified as a distance-vector protocol.
- Hop count was understood as the RIP metric.
- The 15-hop reachable limit was understood.
- Periodic 30-second advertisements were reviewed.
- RIPv2 VLSM support was identified.
- Triggered updates were reviewed.
- Hold-down behavior was reviewed.
- Course equal-cost path values were not treated as universal implementation limits.
- Lecture routes, gateway addresses, interface names, and output were not recorded as actual lab evidence.

---

# What I Learned

- Routing determines where an IP packet should be sent.
- Both hosts and routers maintain routing information.
- Direct routing reaches a destination without an intermediate router.
- Indirect routing sends traffic through a gateway.
- A default route is used when no more specific route matches.
- A connected route represents a directly reachable network.
- Static routes are manually configured.
- Dynamic routing protocols automatically exchange route information.
- `ip route` is the primary modern Linux tool for routing-table inspection.
- Linux requires IPv4 forwarding to operate intentionally as a router between interfaces.
- `sysctl -w` changes runtime forwarding state rather than persistent configuration.
- RIP is a distance-vector routing protocol that uses hop count.
- RIP limits reachable paths to 15 hops.
- RIPv2 supports classless routing features such as VLSM.
- Triggered updates and hold-down behavior help manage routing changes.
- Routing troubleshooting should first determine whether the destination is local or remote.
