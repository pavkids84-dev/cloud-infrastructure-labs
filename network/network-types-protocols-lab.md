# Network Types and Protocols Lab

## Objective

Understand common network classification methods, network topologies, LAN/MAN/WAN concepts, the definition and functions of network protocols, and the relationship between the OSI model and the TCP/IP protocol suite.

The goal is to build a structured foundation for understanding how networks are organized and how communication rules are defined.

## Scope

This lab covers:

```text
Circuit-Switched Networks
Packet-Switched Networks
Cell-Switched Networks
Bus Topology
Star Topology
Ring Topology
Tree Topology
LAN
MAN
WAN
Protocol Definition
Syntax
Semantics
Timing
Protocol Functions
OSI and TCP/IP Models
TCP/IP Protocol Suite
```

---

# Network Classification

The course classifies networks using three perspectives:

```text
Data Transmission Method
Topology
Distance / Geographic Scope
```

The same network can therefore be described differently depending on which characteristic is being examined.

---

# Classification by Data Transmission Method

The course introduces three network types:

```text
Circuit-Switched Network
Packet-Switched Network
Cell-Switched Network
```

---

# Circuit-Switched Network

A circuit-switched network establishes a dedicated communication path.

The course introduces the following characteristics:

```text
Exclusive use of a communication path
Telephone-network example
Fixed path during transmission
Other communication waits while the connection is occupied
```

Conceptually:

```text
Endpoint A
    |
    | Dedicated Path
    |
Endpoint B
```

A simplified workflow is:

```text
Establish Connection
        ↓
Reserve Path
        ↓
Communicate
        ↓
Release Connection
```

The path remains associated with the communication session while the connection is active.

---

# Packet-Switched Network

A packet-switched network divides data into packets.

The course describes the following characteristics:

```text
Data is divided into packets
Transmission routes can differ
Source and destination addresses are used
```

Conceptually:

```text
Original Data
     ↓
+----+----+----+
| P1 | P2 | P3 |
+----+----+----+
  ↓    ↓    ↓
Network Paths
  ↓    ↓    ↓
Destination
```

Packets share network resources rather than requiring one permanently reserved communication path.

---

# Circuit Switching vs Packet Switching

A simplified comparison is:

```text
Circuit Switching
→ Dedicated path
→ Path remains fixed during communication
```

```text
Packet Switching
→ Packet-based transmission
→ Shared network resources
→ Routes can differ
```

The course uses the telephone network as a circuit-switching example.

Packet switching is closely associated with modern data networking.

---

# Cell-Switched Network

The course introduces cell-switched networking using ATM.

Course characteristics include:

```text
Fixed-size cell transmission
Flow and error processing performed between endpoints
Reduced header overhead
ATM
```

The course describes an ATM cell as:

```text
5-byte header
+
48-byte data
=
53 bytes
```

ATM stands for:

```text
Asynchronous Transfer Mode
```

This section introduces the concept rather than providing a detailed ATM configuration lab.

---

# Network Topology

Topology describes how network devices and hosts are arranged or interconnected.

The course introduces:

```text
Bus
Star
Ring
Hub / Tree
```

---

# Bus Topology

In a bus topology, multiple systems share a common communication path.

Conceptually:

```text
Host A   Host B   Host C   Host D
   |        |        |        |
================================
             Bus
```

The course diagram shows multiple systems connected to one shared backbone.

---

# Star Topology

In a star topology, systems connect to a central device.

Conceptually:

```text
          Host A
            |
Host B -- Central Device -- Host C
            |
          Host D
```

A switch is a common central device in modern Ethernet LANs.

---

# Ring Topology

A ring topology logically connects systems in a ring.

Conceptually:

```text
Host A → Host B
  ↑        ↓
Host D ← Host C
```

The course introduces the topology diagram without providing a detailed protocol configuration exercise.

---

# Tree Topology

The course introduces a hierarchical topology using multiple switches.

Conceptually:

```text
              Core Switch
             /           \
            /             \
       Switch             Switch
      /  |  \            /  |  \
   Hosts Hosts Hosts   Hosts Hosts Hosts
```

A tree topology combines hierarchical network segments.

---

# Classification by Distance

The course introduces:

```text
LAN
MAN
WAN
```

---

# LAN

LAN stands for:

```text
Local Area Network
```

The course describes it as a network covering a relatively short geographic area.

A simplified example is:

```text
Hosts
  ↓
Switch
  ↓
Local Servers
```

LANs are commonly associated with offices, buildings, or other local network environments.

---

# MAN

MAN stands for:

```text
Metropolitan Area Network
```

The course describes MAN as an intermediate-scale network connecting areas such as:

```text
Cities
Campuses
```

It is presented as larger than a LAN and smaller than a WAN.

---

# WAN

WAN stands for:

```text
Wide Area Network
```

The course describes WAN as a network connecting geographically distant locations.

A simplified structure is:

```text
LAN A
  ↓
Router
  ↓
WAN
  ↓
Router
  ↓
LAN B
```

WAN connectivity allows remote networks to communicate across large geographic distances.

---

# Protocol Definition

The course defines a protocol as:

```text
A set of rules for communication between two nodes
```

A protocol defines how systems exchange information in a predictable and interoperable way.

---

# Three Protocol Elements

The course introduces three core protocol elements:

```text
Syntax
Semantics
Timing
```

---

# Syntax

Syntax defines the format of communication data.

Course examples include:

```text
Data format
Encoding method
```

A useful question is:

```text
How is the message structured?
```

---

# Semantics

Semantics defines the meaning of communication information and control behavior.

The course associates semantics with:

```text
Flow control
Error control
Synchronization control
```

A useful question is:

```text
What does each field or control value mean?
```

---

# Timing

Timing defines communication timing and sequence.

The course associates timing with:

```text
Communication speed
Communication order
```

A useful question is:

```text
When and in what order should communication occur?
```

---

# Protocol Elements Summary

```text
Syntax
→ How is the data structured?

Semantics
→ What does the data or control information mean?

Timing
→ When and in what order is communication performed?
```

---

# Protocol Functions

The course introduces the following protocol functions:

```text
Addressing
Encapsulation
Fragmentation and Reassembly
Sequence Control
Connection Control
Flow Control
Error Control
Synchronization
Multiplexing
Transmission Service
```

---

# Addressing

Addressing identifies communication endpoints according to the relevant communication layer.

A useful layered example is:

```text
Layer 2
→ MAC Address

Layer 3
→ IP Address

Layer 4
→ Port Number
```

Different protocols use different forms of addressing.

---

# Encapsulation

The course describes encapsulation using:

```text
SDU + PCI = PDU
```

Where:

```text
SDU
→ Service Data Unit

PCI
→ Protocol Control Information

PDU
→ Protocol Data Unit
```

Conceptually:

```text
Upper-Layer Data
      +
Current-Layer Control Information
      =
Current-Layer Protocol Data Unit
```

Each protocol layer can add information required for its own operation.

---

# Layered Encapsulation Example

A simplified example is:

```text
Application Data
      ↓
TCP Header + Data
      ↓
TCP Segment
      ↓
IP Header + TCP Segment
      ↓
IP Packet
```

As data moves downward, each protocol can treat the upper-layer unit as data and add its own control information.

---

# Fragmentation and Reassembly

The course introduces:

```text
Fragmentation
→ Divide larger data into smaller pieces

Reassembly
→ Reconstruct the original data
```

Conceptually:

```text
Large Data
    ↓
[1][2][3][4]
    ↓
Network
    ↓
[1][2][3][4]
    ↓
Reassembly
    ↓
Original Data
```

This concept will later be connected to IP and MTU behavior.

---

# Sequence Control

The course associates sequence control with connection-oriented protocols.

Conceptually:

```text
PDU 1
PDU 2
PDU 3
```

Sequence information can help communication endpoints identify ordering and retransmission requirements.

This concept will later be connected to TCP behavior.

---

# Connection Control

The course describes connection control as:

```text
Establish Connection
        ↓
Transfer Data
        ↓
Release Connection
```

This provides a controlled communication lifecycle.

---

# Flow Control

Flow control adjusts the rate of data transmission.

Conceptually:

```text
Fast Sender
     ↓
Flow Control
     ↓
Receiver Capacity
```

The purpose is to prevent a sender from overwhelming a receiver.

---

# Error Control

The course describes error control as the detection of errors in received data.

Error-control mechanisms can exist at different protocol layers.

---

# Synchronization

The course describes synchronization as signaling used so that two systems can meaningfully exchange data.

Conceptually:

```text
Sender State
      ↕
Synchronization
      ↕
Receiver State
```

---

# Multiplexing

Multiplexing allows multiple communications to share communication resources.

Conceptually:

```text
Communication A ┐
Communication B ├── Shared Communication Resource
Communication C ┘
```

---

# Transmission Service

The course associates transmission service with control of areas such as:

```text
Service Level
Security
Priority
```

This section introduces these as categories of protocol functionality.

---

# OSI Model and TCP/IP Model

The course maps the OSI model to a five-layer TCP/IP representation.

```text
OSI                       TCP/IP

7 Application ┐
6 Presentation├────────→ Application
5 Session     ┘

4 Transport ───────────→ Transport

3 Network ─────────────→ Internet

2 Data Link ───────────→ Network Interface

1 Physical ────────────→ Physical
```

The course therefore uses the following TCP/IP layers:

```text
Application
Transport
Internet
Network Interface
Physical
```

Other references can represent TCP/IP using a four-layer model by combining lower-layer functions.

Always identify which model a course or document is using.

---

# TCP/IP Protocol Suite

The course introduces the following protocol relationships.

## Application

```text
HTTP
SMTP
SNMP
DNS
SSH
FTP
Telnet
NFS
SAMBA
```

## Transport

```text
TCP
UDP
```

## Internet

```text
IP
ICMP
IGMP
```

## Network Interface

```text
Ethernet
PPP
SDLC
```

The course diagram also places:

```text
ARP
RARP
```

near the boundary between Internet and Network Interface functions.

---

# Layered Protocol Example

A simplified HTTP communication path is:

```text
HTTP
 ↓
TCP
 ↓
IP
 ↓
Ethernet
 ↓
Physical Network
```

A protocol suite combines multiple protocols to provide end-to-end communication.

---

# ARP Layering Note

ARP connects IPv4 addressing with link-layer addressing.

Conceptually:

```text
IPv4 Address
     ↓
ARP
     ↓
MAC Address
```

Because ARP connects Network-layer and Data-Link-layer information, teaching materials can place it differently in simplified layer diagrams.

The important concept is its role between IP communication and Ethernet addressing.

ARP is studied in greater detail later in the course.

---

# Verification Checklist

- Network classification by transmission method was reviewed.
- Circuit switching was distinguished from packet switching.
- Cell switching and ATM were introduced.
- Bus topology was identified.
- Star topology was identified.
- Ring topology was identified.
- Tree topology was identified.
- LAN, MAN, and WAN were distinguished.
- A protocol was understood as a set of communication rules.
- Syntax, semantics, and timing were distinguished.
- Protocol addressing was reviewed.
- Encapsulation was connected to SDU, PCI, and PDU.
- Fragmentation and reassembly were reviewed.
- Sequence control was reviewed.
- Connection control was reviewed.
- Flow control was reviewed.
- Error control was reviewed.
- Synchronization was reviewed.
- Multiplexing was reviewed.
- Transmission-service concepts were reviewed.
- The OSI model was mapped to the TCP/IP model used by the course.
- Application, Transport, Internet, Network Interface, and Physical layers were identified.
- Major TCP/IP protocol-suite examples were reviewed.
- ARP was recognized as connecting IP and link-layer addressing concepts.

---

# What I Learned

- Networks can be classified by transmission method, topology, and geographic scope.
- Circuit switching uses a dedicated path during communication.
- Packet switching divides communication into independently transmitted packets.
- ATM uses fixed-size cells.
- Topology describes how network devices and systems are interconnected.
- LAN, MAN, and WAN describe different geographic network scopes.
- Protocols define rules that allow systems to communicate consistently.
- Syntax defines structure, semantics defines meaning, and timing defines communication order and timing.
- Protocols provide functions such as addressing, encapsulation, sequencing, flow control, and error control.
- SDU plus protocol control information forms a protocol data unit.
- The course uses a five-layer representation of TCP/IP.
- TCP/IP communication is implemented through multiple protocols operating together.
- ARP connects IPv4 addressing with local link-layer addressing.
