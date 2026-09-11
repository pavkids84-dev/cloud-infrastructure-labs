# Dynamic Routing Protocols Lab

## Objective

Understand how dynamic routing protocols exchange network reachability information, how RIP learns routes using hop count, how OSPF differs from distance-vector routing, and how routing protocols are divided between intra-AS and inter-AS operation.

The goal is to build a conceptual foundation for dynamic routing before performing more advanced router configuration.

## Scope

This lab covers:

```text
RIP Route Learning
Hop Count
Distance Vector Routing
OSPF
Link-State Routing
IGRP
Autonomous Systems
IGP
EGP
BGP
Intra-AS Routing
Inter-AS Routing
```

---

# RIP Route Learning

RIP stands for:

```text
Routing Information Protocol
```

RIP is a distance-vector routing protocol.

The course illustrates routers exchanging reachability information and building routing tables based on hop count.

Conceptually:

```text
Neighbor Routing Information
        ↓
Increase Hop Count
        ↓
Evaluate Candidate Route
        ↓
Update Routing Table
```

---

# Directly Connected Networks

A directly connected network can be represented as:

```text
Hop Count
→ 0
```

Conceptually:

```text
Router A
   |
Network 10

Network 10
Hop 0
```

A neighboring router can learn the same network through Router A:

```text
Network 10
via Router A
Hop 1
```

---

# Hop Count Growth

As route information moves between routers, the distance increases.

```text
Direct Connection
→ Hop 0

One Router Away
→ Hop 1

Two Routers Away
→ Hop 2

Three Routers Away
→ Hop 3
```

RIP prefers a route with the lower hop count.

---

# Hop Count Limitation

Hop count measures router distance but does not directly measure:

```text
Latency
Bandwidth
Congestion
Link Quality
```

Therefore:

```text
2 hops
```

does not automatically mean that the path is faster in every operational sense than:

```text
3 hops
```

RIP uses a relatively simple routing metric.

---

# Distance Vector Routing

A simplified distance-vector model is:

```text
Distance
→ How far is the destination?

Vector
→ Through which neighbor should it be reached?
```

Routers learn reachability from neighboring routers rather than maintaining a complete identical view of every physical link.

---

# OSPF

OSPF stands for:

```text
Open Shortest Path First
```

The course introduces OSPF as:

```text
Link-State Protocol
Suitable for Large Networks
Advertises Changes in Network State
Selects an Optimized Path
```

OSPF and RIP use different routing approaches.

---

# RIP vs OSPF

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

A simplified comparison is:

| Characteristic | RIP | OSPF |
|---|---|---|
| Routing Model | Distance Vector | Link State |
| Basic Metric | Hop Count | Cost |
| Scale | Smaller networks | Larger networks |
| Update Model | Periodic updates | Link-state changes and synchronization |
| Complexity | Simpler | More complex |

---

# OSPF Path Selection

The course describes OSPF as selecting a path with a shorter actual communication time.

This should be understood as a simplified description of route optimization.

OSPF normally selects paths using:

```text
OSPF Cost
```

rather than continuously measuring application round-trip time.

The metric can be related to interface characteristics such as bandwidth.

---

# Link-State Concept

A simplified link-state model is:

```text
Router
  ↓
Learn Local Link State
  ↓
Exchange Link-State Information
  ↓
Build Network Topology View
  ↓
Calculate Best Routes
```

This differs from a basic distance-vector model based primarily on neighbor-provided distance information.

---

# IGRP

IGRP stands for:

```text
Interior Gateway Routing Protocol
```

The course introduces IGRP as a Cisco routing protocol.

Metrics described by the course include:

```text
Bandwidth
Delay
Load
MTU
Reliability
```

The course primarily uses IGRP to demonstrate that routing protocols can use metrics more complex than hop count.

---

# IGRP Historical Context

IGRP should be treated as a historical Cisco routing protocol.

For modern networking study, the more important conceptual routing protocols in this learning path are:

```text
RIP
OSPF
BGP
```

Detailed IGRP configuration is outside the scope of this lab.

---

# Autonomous System

AS stands for:

```text
Autonomous System
```

An AS is a group of networks and routers operated under a common routing administration or policy.

Conceptually:

```text
+----------------------+
| Autonomous System    |
|                      |
| Router -- Router     |
|    \      /          |
|     Networks         |
+----------------------+
```

Autonomous Systems make large-scale routing easier to organize.

---

# Interior and Exterior Routing

The course distinguishes routing inside an AS from routing between Autonomous Systems.

```text
Inside an AS
→ IGP
→ Interior Gateway Protocol
```

```text
Between Autonomous Systems
→ EGP-class routing
→ Exterior routing
```

---

# IGP

Examples introduced by the course include:

```text
RIP
OSPF
IGRP
```

Conceptually:

```text
AS
|
+-- Router
|      ↕
|     IGP
|      ↕
+-- Router
```

IGPs maintain routing information within an Autonomous System.

---

# Exterior Routing

Exterior routing exchanges route information between Autonomous Systems.

Conceptually:

```text
AS 1
  |
  | Exterior Routing
  |
AS 2
```

The course introduces:

```text
EGP
BGP
```

in this context.

---

# EGP

EGP can refer to the historical:

```text
Exterior Gateway Protocol
```

The course explains that early EGP development was closely connected to the concept of Autonomous Systems.

Modern inter-AS routing primarily uses BGP.

---

# BGP

BGP stands for:

```text
Border Gateway Protocol
```

The course introduces BGP as the protocol that replaced the older EGP approach for modern inter-AS routing.

A simplified model is:

```text
AS 1
  |
 BGP
  |
AS 2
  |
 BGP
  |
AS 3
```

BGP is a core concept in Internet-scale routing.

---

# IGP and BGP Together

A large routing environment can conceptually use:

```text
              BGP
      AS 1 <-------> AS 2
       |               |
      IGP             IGP
       |               |
    Routers          Routers
```

Inside each AS:

```text
IGP
```

can maintain internal reachability.

Between Autonomous Systems:

```text
BGP
```

can exchange inter-AS routing information.

---

# AS Number

The course describes an AS number as a unique identifier.

The course material describes AS numbers using a historical 16-bit model.

Modern networks also support:

```text
32-bit AS Numbers
```

The important concept for this lab is:

```text
AS Number
→ Identifies an Autonomous System for inter-domain routing
```

rather than memorizing only the historical address width.

---

# Routing Protocol Hierarchy

A simplified hierarchy is:

```text
Dynamic Routing
      |
      +-- Interior Routing
      |      |
      |      +-- RIP
      |      +-- OSPF
      |      +-- IGRP
      |
      +-- Exterior Routing
             |
             +-- BGP
```

---

# Dynamic Routing Selection Concepts

Different routing protocols use different metrics and algorithms.

Examples:

```text
RIP
→ Hop Count

OSPF
→ Cost

BGP
→ Inter-AS path and routing-policy information
```

A routing metric should therefore always be interpreted in the context of the protocol using it.

---

# Relationship to Static Routing

Static routing and dynamic routing solve the same broad problem:

```text
How should a destination network be reached?
```

but use different management methods.

```text
Static Routing
→ Administrator defines the route.

Dynamic Routing
→ Routing protocols exchange route information.
```

A network can use both static and dynamic routes.

---

# Linux Router Practice Connection

The course later demonstrates a Linux system acting as a router between separate networks.

A simplified environment is:

```text
Host A
   |
Network A
   |
Linux Router
   |
Network B
   |
Host B
```

The Linux router requires forwarding capability.

The course demonstrates the runtime setting:

```bash
sysctl -w net.ipv4.ip_forward=1
```

This command changes runtime kernel forwarding behavior.

It does not by itself provide persistent forwarding configuration.

---

# Dynamic Routing Troubleshooting Questions

When a dynamic route is missing, useful conceptual questions include:

```text
Is the destination network directly connected?

Is the routing protocol active?

Is the expected neighbor reachable?

Is the route being advertised?

What metric is being learned?

Is another route preferred?

Is the failure inside one AS or between Autonomous Systems?
```

Protocol-specific commands are outside the scope of this course section.

---

# Verification Checklist

- RIP route learning was understood conceptually.
- Directly connected routes were associated with zero RIP hops in the course example.
- Neighbor-learned routes were understood to increase in hop count.
- RIP was identified as a distance-vector protocol.
- Hop count was recognized as the basic RIP metric.
- OSPF was identified as a link-state protocol.
- OSPF cost was distinguished from direct RTT measurement.
- RIP and OSPF were compared.
- IGRP was identified as a historical Cisco routing protocol.
- An Autonomous System was understood as a routing administration domain.
- IGP was associated with routing inside an AS.
- Exterior routing was associated with routing between ASes.
- BGP was identified as the major inter-AS routing protocol.
- AS numbers were recognized as Autonomous System identifiers.
- The historical 16-bit AS-number explanation was not treated as the only modern ASN format.
- Linux IPv4 forwarding was connected to router operation.
- Lecture topology values were not recorded as actual runtime evidence.

---

# What I Learned

- RIP learns network reachability through neighboring routers.
- RIP measures distance using hop count.
- OSPF uses a link-state routing model.
- OSPF and RIP use different route-selection methods.
- IGRP is primarily relevant as historical routing-protocol knowledge.
- Autonomous Systems divide large networks into routing administration domains.
- IGPs operate inside an Autonomous System.
- BGP exchanges routing information between Autonomous Systems.
- Dynamic routing allows routers to update network reachability automatically.
- Static and dynamic routing can coexist in the same infrastructure.
