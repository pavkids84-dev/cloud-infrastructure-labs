# OSI Model Lab

## Objective

Understand the OSI 7-layer model, the role of each layer, encapsulation and decapsulation, layered addressing, and the functions of common network devices.

The goal of this lab is to use the OSI model as a structured framework for understanding network communication and troubleshooting rather than simply memorizing the seven layers.

## Scope

This lab covers:

```text
OSI 7-Layer Model
Physical Layer
Data Link Layer
MAC Addressing
Network Layer
Transport Layer
Session Layer
Presentation Layer
Application Layer
Encapsulation
Decapsulation
Repeaters
Hubs
Bridges
Switches
Routers
Gateways
```

---

# OSI Model Overview

The OSI model divides network communication into seven logical layers.

```text
7  Application
6  Presentation
5  Session
4  Transport
3  Network
2  Data Link
1  Physical
```

The model was introduced as a standardized architecture for describing network communication functions.

Rather than treating networking as one large process, the OSI model separates communication into layers with different responsibilities.

A simplified view is:

```text
Application
    ↓
Presentation
    ↓
Session
    ↓
Transport
    ↓
Network
    ↓
Data Link
    ↓
Physical
```

When data is received, the processing direction is reversed.

---

# Why the OSI Model Matters

The OSI model helps organize network behavior into layers.

This is useful when troubleshooting because a communication failure can be investigated according to the affected layer.

For example:

```text
Application Problem?
        ↓
Transport / Port Problem?
        ↓
IP / Routing Problem?
        ↓
MAC / Local-Link Problem?
        ↓
Physical-Link Problem?
```

Instead of changing multiple components at once, the failure can be localized to a specific layer.

---

# Layer 1 - Physical

The Physical layer defines the physical characteristics required to transmit a bit stream.

The course describes characteristics such as:

```text
Electrical
Functional
Mechanical
```

Technologies introduced by the course include:

```text
10BASE-T
10BASE-5
100BASE-T
100BASE-TX
100BASE-FX
100BASE-T4
1000BASE-X
```

Typical devices associated with the Physical layer are:

```text
Repeater
Hub
```

The basic transmission unit can be represented as:

```text
Bit
```

A simplified model is:

```text
Data
  ↓
Bits
  ↓
Electrical / Optical Signal
  ↓
Physical Medium
```

The Physical layer focuses on the actual transmission of signals rather than IP routing or MAC-based forwarding.

---

# Repeater

A repeater operates at the Physical layer.

The course describes its primary function as signal amplification.

Conceptually:

```text
Weak Signal
     ↓
Repeater
     ↓
Regenerated Signal
```

A repeater does not inspect:

```text
IP addresses
Routing tables
MAC address tables
```

Its role is associated with physical signal transmission.

---

# Hub

The course describes a hub as:

```text
Multi-port repeater
```

A simplified structure is:

```text
        Host A
          |
Host B -- Hub -- Host C
          |
        Host D
```

The course associates hubs with an expanded collision domain.

A hub does not maintain a MAC address table like a switch.

---

# Collision Domain

A collision domain represents a shared Ethernet area in which simultaneous transmissions can interfere with each other.

Conceptually:

```text
Host A
Host B
Host C
Host D
   |
   v
Shared Collision Domain
```

Hub-based shared Ethernet extends the same collision domain across connected hosts.

This concept is especially associated with older shared and half-duplex Ethernet environments.

---

# Layer 2 - Data Link

The Data Link layer is responsible for local-link communication.

The course introduces the following functions:

```text
LAN communication
Point-to-point data transfer
Error detection
CRC
FCS
MAC
LLC
Frame creation
MAC addressing
```

Typical devices associated with this layer include:

```text
Bridge
Switch
```

The primary data unit is:

```text
Frame
```

---

# Data Link Layer Structure

The course divides the Data Link layer into:

```text
LLC
MAC
```

A simplified representation is:

```text
+------------------+
| LLC              |
+------------------+
| MAC              |
+------------------+
| Physical Layer   |
+------------------+
```

The course also associates Ethernet and IEEE 802 technologies with this area.

---

# Frame

The course explains that the Data Link layer adds a header and trailer to upper-layer data.

Conceptually:

```text
+------------------+
| Data Link Header |
+------------------+
| Upper-Layer Data |
+------------------+
| Trailer          |
+------------------+
```

This unit is called a:

```text
Frame
```

The detailed Ethernet frame structure is covered later in the network course.

---

# MAC Address

The course introduces a MAC address as:

```text
Ethernet address
Hardware address
6 bytes
```

Six bytes correspond to:

```text
48 bits
```

A common representation is:

```text
00:0c:29:12:34:56
```

Another possible representation is:

```text
00-0C-29-12-34-56
```

The course conceptually divides the 6-byte address into two 3-byte portions:

```text
+----------------+----------------+
| Vendor Portion | Device Portion |
|    3 Bytes     |    3 Bytes     |
+----------------+----------------+
```

The first portion is associated with the organization or manufacturer.

The remaining portion is used by the organization to identify interfaces within its assigned address space.

MAC addresses operate at the Data Link layer.

---

# Bridge

A bridge operates at the Data Link layer.

The course introduces the following purposes:

```text
Separate traffic inside the same network
Separate collision domains
Filter collision traffic
```

Conceptually:

```text
Network Segment A
        |
      Bridge
        |
Network Segment B
```

A bridge separates Layer 2 network segments while remaining within the same broader network environment.

---

# Switch

The course describes a switch as:

```text
Multi-port bridge
```

Each switch port can perform bridge-like forwarding functions.

The course highlights that a switch:

```text
Supports multiple ports
Creates and manages a MAC address table
Provides better performance than a simple bridge
```

A simplified topology is:

```text
        Switch
      /   |   \
     /    |    \
Host A  Host B  Host C
```

---

# MAC Address Table

A switch learns relationships between MAC addresses and switch ports.

Conceptually:

```text
MAC Address A
→ Port 1

MAC Address B
→ Port 3
```

When a frame arrives for MAC Address B:

```text
Destination MAC
       ↓
MAC Address Table
       ↓
Matching Switch Port
       ↓
Forward Frame
```

This allows a switch to make forwarding decisions using Layer 2 information.

---

# Switch Forwarding Types

The course introduces the following switch forwarding types:

```text
Cut-through
Store-and-forward
Intelligent switching
```

A basic distinction is:

```text
Cut-through
→ Forwarding can begin before the entire frame is received.

Store-and-forward
→ The entire frame is received before it is forwarded.
```

The course lists `intelligent switching` but does not define its detailed behavior in this section.

---

# Duplex Modes

The course introduces:

```text
Full-Duplex
Half-Duplex
```

## Half-Duplex

Communication can occur in either direction, but not simultaneously.

```text
Host A -----> Host B
```

or:

```text
Host A <----- Host B
```

## Full-Duplex

Both directions can operate simultaneously.

```text
Host A <-----> Host B
```

Modern switched Ethernet commonly operates using full-duplex communication.

---

# Layer 3 - Network

The Network layer is responsible for network-level addressing and routing.

The course introduces the following functions:

```text
Routing
QoS
Fragmentation
Reassembly
IP addressing
```

Typical Layer 3 devices include:

```text
Router
Layer 3 Switch
```

A simplified Layer 3 question is:

```text
Which network and host should receive this packet?
```

---

# IP Addressing at Layer 3

The Network layer uses IP addresses.

A simplified distinction between Layer 2 and Layer 3 is:

```text
Layer 2
MAC Address
→ Local-link delivery

Layer 3
IP Address
→ Network-level delivery and routing
```

MAC addresses and IP addresses serve different purposes.

---

# Router

A router operates primarily at the Network layer.

The course describes a router as a device used for:

```text
Communication between different networks
Connecting physically separated network segments
Routing traffic using a routing table
Connecting networks with different network addresses
```

A simplified routing process is:

```text
Destination IP
      ↓
Routing Table
      ↓
Select Route
      ↓
Select Interface / Next Hop
      ↓
Forward Packet
```

---

# Switch vs Router

A basic distinction is:

```text
Switch
→ Layer 2
→ MAC-based forwarding
→ Primarily local network communication
```

```text
Router
→ Layer 3
→ IP-based routing
→ Communication between different networks
```

The key identifiers are:

```text
Switch
→ Destination MAC Address

Router
→ Destination IP Address
```

---

# Layer 4 - Transport

The Transport layer provides end-to-end communication between systems.

The course introduces:

```text
End-to-end communication
Connection-oriented communication
Connectionless communication
Error control
Flow control
Port numbers
Segments
Datagrams
```

This layer is later connected to:

```text
TCP
UDP
```

---

# Port Numbers

Port numbers help identify communicating services or endpoints on a host.

A useful model is:

```text
IP Address
→ Which host?

Port Number
→ Which service or endpoint on that host?
```

For example:

```text
Server
192.168.10.20
   |
   +-- Port 22
   +-- Port 80
   +-- Port 443
```

One IP address can therefore support multiple network services.

---

# Connection-Oriented and Connectionless Communication

The course introduces two transport communication styles:

```text
Connection-oriented
Connectionless
```

These concepts are later associated with:

```text
TCP
→ Connection-oriented

UDP
→ Connectionless
```

At this stage, the important concept is that both communication models belong to Transport-layer behavior.

---

# Transport Data Units

The course introduces:

```text
Segment
Datagram
```

These terms are later associated with:

```text
TCP
→ Segment

UDP
→ Datagram
```

---

# Layer 5 - Session

The Session layer provides additional services for logical communication established between endpoints.

The course introduces:

```text
Logical session services
Duplex mode control
Socket connection
```

The primary concept is:

```text
Communication-session management
```

The OSI Session layer should be understood as a logical model.

In modern TCP/IP software, socket communication is not necessarily implemented as a separate Layer 5 component.

---

# Layer 6 - Presentation

The Presentation layer defines how data is represented.

The course introduces:

```text
ASCII
EBCDIC
Compression
Encryption
```

Conceptually:

```text
Application Data
      ↓
Representation
      ↓
Compression / Encryption
      ↓
Network Communication
```

The OSI model separates these functions logically.

Modern applications can implement representation, encryption, or compression without a separate standalone Presentation-layer component.

---

# Layer 7 - Application

The Application layer provides network services to users and applications.

The course introduces examples such as:

```text
FTP
Telnet
SNMP
SMTP
DNS
TFTP
HTTP
POP3
IMAP4
LDAP
```

Examples of service relationships include:

```text
Web
→ HTTP

Name Resolution
→ DNS

Email Transfer
→ SMTP

Email Retrieval
→ POP3 / IMAP

Directory Services
→ LDAP
```

The Application layer is the OSI layer closest to user-facing network services.

---

# Encapsulation

When data moves from an application toward the physical network, lower layers add control information required for their functions.

This process is called:

```text
Encapsulation
```

The course diagram shows data moving downward through the OSI model while headers are added.

A simplified model is:

```text
Application Data
      ↓
Transport Header + Data
      ↓
Network Header + Transport Data
      ↓
Data Link Header + Network Data
      ↓
Physical Transmission
```

Each layer adds information relevant to its responsibility.

Examples include:

```text
Transport
→ Port information

Network
→ IP information

Data Link
→ MAC information
```

---

# Decapsulation

The receiving system performs the reverse process.

This is called:

```text
Decapsulation
```

Conceptually:

```text
Physical Transmission
      ↓
Data Link Processing
      ↓
Network Processing
      ↓
Transport Processing
      ↓
Application Data
```

Each receiving layer interprets the information associated with that layer and passes the remaining data upward.

---

# Encapsulation and Decapsulation Flow

The course diagram represents the communication process as:

```text
Sender
Application
    ↓
Transport
    ↓
Network
    ↓
Data Link
    ↓
Physical
    ↓
Network
    ↓
Physical
    ↑
Data Link
    ↑
Network
    ↑
Transport
    ↑
Application
Receiver
```

The sender performs encapsulation.

The receiver performs decapsulation.

---

# Protocol Data Units

A useful layered representation is:

```text
Application
→ Data

Transport
→ TCP Segment / UDP Datagram

Network
→ Packet

Data Link
→ Frame

Physical
→ Bits
```

These terms represent communication data from different layer perspectives.

They should not be treated as interchangeable terms.

---

# Layered Addressing

Three important identifiers belong to three different layers.

```text
Layer 2
→ MAC Address

Layer 3
→ IP Address

Layer 4
→ Port Number
```

A useful mental model is:

```text
MAC Address
→ Which interface on the current link?

IP Address
→ Which host or network?

Port Number
→ Which communicating service or endpoint?
```

---

# Encapsulation by Address Type

A simplified communication model is:

```text
Application
→ Actual application data

Transport
→ Port information

Network
→ IP information

Data Link
→ MAC information

Physical
→ Bit transmission
```

This layered structure becomes especially important when analyzing packets later with tools such as Wireshark.

---

# Network Devices by OSI Layer

The course introduces the following general relationship:

```text
Layer 1
→ Repeater
→ Hub

Layer 2
→ Bridge
→ Switch

Layer 3
→ Router

Higher-Layer / Protocol-Conversion Concept
→ Gateway
```

The most important basic mapping is:

```text
Hub
→ Layer 1

Switch
→ Layer 2

Router
→ Layer 3
```

---

# Gateway

The course illustrates a gateway connecting environments that use different network architectures or protocol stacks.

The diagram shows communication between environments such as:

```text
Ethernet + TCP/IP
        ↓
Gateway
        ↓
Token Ring + SNA
```

This represents a broader gateway concept involving communication between different environments.

Conceptually:

```text
Protocol Environment A
        ↓
Gateway
        ↓
Protocol Environment B
```

---

# Gateway vs Default Gateway

The word `gateway` can have different meanings depending on context.

## Default Gateway

In IP networking, a default gateway commonly refers to:

```text
Router / Next Hop
```

used when the destination is outside directly connected networks.

Conceptually:

```text
Host
  ↓
Default Gateway
  ↓
Other Network
```

## Protocol or Application Gateway

A broader gateway can act as an intermediary between different protocol or application environments.

```text
Environment A
    ↓
Gateway
    ↓
Environment B
```

Therefore:

```text
Gateway
```

should not automatically be treated as one fixed OSI-layer device in every context.

---

# Device Comparison

| Device | Primary Layer | Main Concept | Primary Function |
|---|---:|---|---|
| Repeater | Layer 1 | Signal | Regenerate physical signals |
| Hub | Layer 1 | Signal | Multi-port repeater |
| Bridge | Layer 2 | MAC | Separate Layer 2 segments |
| Switch | Layer 2 | MAC Table | Forward Ethernet frames |
| Router | Layer 3 | IP / Routing Table | Route packets between networks |
| Gateway | Context-dependent | Protocol / Route / Translation | Connect different environments |

---

# OSI Troubleshooting Model

The OSI model can be used as a troubleshooting framework.

A top-down investigation can look like:

```text
Application Failure
      ↓
Application / Service
      ↓
Transport / Port
      ↓
IP / Routing
      ↓
MAC / Local Link
      ↓
Physical Link
```

A bottom-up investigation can look like:

```text
Physical Link
      ↓
Data Link
      ↓
Network
      ↓
Transport
      ↓
Application
```

The direction should depend on the observed symptom and available evidence.

---

# Example: SSH by OSI Layer

SSH can be represented using the layered model.

```text
Application
→ SSH

Transport
→ TCP / Port 22

Network
→ IP / Routing

Data Link
→ Ethernet / MAC

Physical
→ NIC / Link
```

Different failures can therefore belong to different areas.

```text
sshd failure
→ Application / Service area

No listening socket
→ Transport / Socket area

Missing route
→ Network layer

Local-link communication failure
→ Data Link layer

Interface or physical link down
→ Physical layer
```

The observed symptom should be used to narrow the investigation before configuration is changed.

---

# Troubleshooting Questions by Layer

## Layer 1

```text
Is the interface physically or virtually connected?
Is the link up?
Is the physical medium working?
```

## Layer 2

```text
Is local-link communication working?
Is the expected MAC relationship available?
Is the switch forwarding traffic correctly?
```

## Layer 3

```text
Does the host have the correct IP address?
Is the destination network reachable?
Is the routing table correct?
```

## Layer 4

```text
Is the expected port being used?
Is the application listening?
Is the transport connection established?
```

## Layer 7

```text
Is the application or service running?
Is the application configuration correct?
```

The exact command used to answer these questions depends on the operating system and network environment.

---

# Key Layer Relationships

The most important address relationship is:

```text
Layer 2
MAC

Layer 3
IP

Layer 4
Port
```

The most important device relationship is:

```text
Layer 1
Hub

Layer 2
Switch

Layer 3
Router
```

The most important encapsulation relationship is:

```text
Application Data
      ↓
Transport Segment / Datagram
      ↓
Network Packet
      ↓
Data Link Frame
      ↓
Physical Bits
```

---

# Verification Checklist

- The seven OSI layers were identified in order.
- The purpose of using a layered network model was understood.
- The Physical layer was associated with bits and signaling.
- Repeaters were associated with signal regeneration.
- Hubs were identified as multi-port repeaters.
- Collision-domain concepts were reviewed.
- The Data Link layer was associated with frames and MAC addresses.
- MAC and LLC were distinguished as Data Link concepts.
- MAC addresses were recognized as 6-byte addresses.
- Bridges were associated with Layer 2 segmentation.
- Switches were understood as multi-port bridges.
- Switch MAC address tables were understood conceptually.
- Cut-through and store-and-forward concepts were reviewed.
- Full-duplex and half-duplex communication were distinguished.
- The Network layer was associated with IP addressing and routing.
- Routers were associated with Layer 3.
- Switch and router forwarding decisions were distinguished.
- The Transport layer was associated with end-to-end communication.
- Port numbers were associated with the Transport layer.
- Connection-oriented and connectionless concepts were reviewed.
- Segment and datagram terminology was reviewed.
- Session-layer concepts were reviewed.
- Presentation-layer representation, compression, and encryption concepts were reviewed.
- Application-layer network services were identified.
- Encapsulation was understood.
- Decapsulation was understood.
- Data, segment/datagram, packet, frame, and bit terminology were distinguished.
- MAC address, IP address, and port number were assigned to different layers.
- The context-dependent meaning of `gateway` was recognized.
- The OSI model was connected to network troubleshooting.

---

# What I Learned

- The OSI model separates network communication into seven logical layers.
- The layered model can be used to localize network failures.
- Layer 1 focuses on physical signaling and bit transmission.
- Layer 2 uses frames and MAC addresses for local-link communication.
- Layer 3 uses IP addresses and routing for communication between networks.
- Layer 4 provides end-to-end communication and uses port numbers.
- Layers 5 through 7 describe session, representation, and application functions.
- Encapsulation adds layer-specific information as data moves toward the network.
- Decapsulation processes that information as data moves toward the receiving application.
- A repeater regenerates signals.
- A hub behaves as a multi-port repeater.
- A bridge separates Layer 2 segments.
- A switch operates as a multi-port bridge and maintains a MAC address table.
- A router forwards packets between networks using IP addresses and routing information.
- `Gateway` can have different meanings depending on the network context.
- MAC addresses, IP addresses, and port numbers belong to different layers.
- Network troubleshooting becomes more systematic when the affected layer is identified before changes are made.
