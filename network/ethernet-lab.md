# Ethernet Fundamentals Lab

## Objective

Understand Ethernet communication, Ethernet frames, frame fields, MTU, common Ethernet frame errors, and the CSMA/CD access method introduced by the course.

The goal is to connect OSI Data Link concepts with the actual structure and behavior of Ethernet.

## Scope

This lab covers:

```text
Ethernet
Ethernet Frames
Encapsulation into Ethernet
Preamble
SFD
Destination MAC
Source MAC
EtherType / Length
Payload
Padding
FCS
CRC
MTU
Ethernet Frame Errors
CSMA/CD
```

---

# Ethernet Overview

The course introduces Ethernet as a LAN protocol based on broadcast communication and packet-switched networking.

The course identifies three major Ethernet concepts:

```text
Transmission Unit
→ Frame

Access Method
→ CSMA/CD

Physical Cabling / Connector Example
→ RJ45
```

Ethernet operates primarily at the Data Link layer while depending on Physical-layer technologies for actual signal transmission.

---

# Ethernet and Encapsulation

Application data moves through multiple protocol layers before it is transmitted as an Ethernet frame.

A simplified model is:

```text
Application Data
       ↓
Transport Header
       ↓
Transport Segment / Datagram
       ↓
Internet Header
       ↓
Internet Datagram
       ↓
Ethernet Header
       ↓
Ethernet Frame
```

The Ethernet frame carries upper-layer protocol data across the local network link.

---

# Ethernet Frame Structure

The course introduces the following fields:

```text
Preamble
SFD
Destination Address
Source Address
Type / Length
Data
Pad
FCS
```

A simplified representation is:

```text
+----------+
| Preamble |
+----------+
| SFD      |
+----------+
| Dst MAC  |
+----------+
| Src MAC  |
+----------+
| Type     |
+----------+
| Data     |
+----------+
| Pad      |
+----------+
| FCS      |
+----------+
```

---

# Preamble

The course defines the Ethernet preamble as:

```text
7 bytes
```

It consists of alternating bit patterns and is used for synchronization between communicating network interfaces.

Conceptually:

```text
Sender Signal
      ↓
Preamble
      ↓
Receiver Synchronization
```

---

# Start Frame Delimiter

SFD stands for:

```text
Start Frame Delimiter
```

The course identifies it as:

```text
1 byte
```

and provides the bit pattern:

```text
10101011
```

Its purpose is to indicate that the actual Ethernet frame fields follow.

Conceptually:

```text
Preamble
→ Synchronization

SFD
→ Frame begins next
```

---

# Destination Address

The destination Ethernet address is:

```text
6 bytes
```

It identifies the destination MAC address.

Conceptually:

```text
Ethernet Frame
      ↓
Destination MAC
      ↓
Intended Link-Layer Destination
```

---

# Source Address

The source Ethernet address is:

```text
6 bytes
```

It identifies the source MAC address.

The frame therefore contains both:

```text
Source MAC
Destination MAC
```

---

# Type Field

The course identifies a two-byte Type field.

It indicates which upper-layer protocol is encapsulated in the Ethernet frame.

Examples introduced by the course include:

```text
IP
ARP
RARP
IPv6
```

Conceptually:

```text
Ethernet Frame
      ↓
Type Field
      ↓
Which Protocol Processes the Payload?
```

---

# Ethernet II and IEEE 802.3

The course distinguishes:

```text
Ethernet
→ Type field

IEEE 802.3
→ Data length field
```

This reflects different frame-format interpretations of the corresponding field.

The detailed differences between Ethernet II and IEEE 802.3 are beyond this section.

---

# Ethernet Payload

The course associates the data field with upper-layer protocol information.

The Ethernet data area can carry information such as an IP packet.

The course presents a maximum data size of:

```text
1500 bytes
```

This connects directly to the Ethernet MTU introduced later in the section.

---

# Padding

Ethernet requires a minimum frame size.

When the upper-layer data is too small, padding is added.

Conceptually:

```text
Small Payload
     +
Padding
     ↓
Minimum Ethernet Frame Size
```

The course connects padding with the minimum Ethernet frame size of:

```text
64 bytes
```

A common interpretation is that the Ethernet payload is padded to at least 46 bytes so that the frame from Destination MAC through FCS satisfies the minimum frame size.

---

# Frame Check Sequence

FCS stands for:

```text
Frame Check Sequence
```

The course identifies the FCS field as:

```text
4 bytes
```

It is used for Ethernet error detection with CRC.

---

# CRC Error Detection

CRC stands for:

```text
Cyclic Redundancy Check
```

A simplified process is:

```text
Sender
  ↓
Calculate CRC
  ↓
Place Result in FCS
  ↓
Transmit Frame
  ↓
Receiver
  ↓
Calculate CRC Again
  ↓
Compare Result
```

If the calculated values do not match, the frame contains an error and can be discarded.

This provides error detection at the Ethernet layer.

---

# Ethernet MTU

MTU stands for:

```text
Maximum Transmission Unit
```

The course presents the Ethernet MTU as:

```text
1500 bytes
```

A network interface can therefore commonly display an Ethernet MTU of:

```text
1500
```

The MTU value is related to the maximum upper-layer data unit that can be carried without exceeding the link's configured transmission size.

---

# Course MTU Table

The course provides the following example table:

```text
FDDI
→ 4532

Ethernet
→ 1500

IEEE 802.2 / IEEE 802.3
→ 1494

X.25
→ 576

PPP
→ 296

Loopback
→ 8232
```

These values should be understood as the course's reference table rather than universal configuration values for every modern network environment.

Actual MTU can depend on:

```text
Protocol
Operating System
Network Device
Link Type
Configuration
```

The primary value to remember for standard Ethernet fundamentals is:

```text
Ethernet MTU
→ 1500 bytes
```

---

# MTU and Fragmentation

If an upper-layer packet is larger than a network path can carry, additional handling can be required.

Conceptually:

```text
Large Packet
      ↓
Link MTU
      ↓
Can It Be Transmitted Directly?
```

The relationship between MTU and IP fragmentation is studied later in the course.

---

# Ethernet Frame Errors

The course introduces the following frame-error categories:

```text
Runts
Jabbers
Long
Giant
Bad CRC
```

The exact terminology and threshold definitions can vary between network equipment implementations.

The categories below follow the course definitions.

---

# Runts

The course defines a runt frame as:

```text
Frame length < 64 bytes
```

Possible causes introduced by the course include:

```text
Collisions
Cabling problems
Electrical interference
```

A runt is shorter than the normal minimum Ethernet frame size.

---

# Jabbers

The course associates jabbers with frames larger than the normal MTU and describes electrical device problems as a possible cause.

The exact threshold definition of `jabber` can vary between network devices and implementations.

When analyzing real switch or NIC counters, use the vendor-specific definition.

---

# Long Frames

The course defines:

```text
1518 < Frame Length < 6000 bytes
```

as a Long-frame category.

The course associates this condition with possible transmitting-system hardware or software defects.

---

# Giant Frames

The course defines:

```text
Frame Length > 6000 bytes
```

as a Giant-frame category.

The course again associates this with possible sender-side hardware or software defects.

Real network devices can use different definitions for oversized, giant, or jabber counters.

---

# Bad CRC

The course defines:

```text
Bad CRC
→ CRC error
```

A CRC error indicates that the received frame failed the Ethernet integrity check.

Potential troubleshooting areas can include:

```text
Physical link
Cable
NIC
Electrical interference
```

The actual cause must be established using evidence rather than inferred from one counter alone.

---

# CSMA/CD

The course introduces Ethernet's shared-media access method:

```text
CSMA/CD
```

It stands for:

```text
Carrier Sense
Multiple Access
Collision Detection
```

---

# Carrier Sense

Before transmitting, a station checks whether the shared medium is currently in use.

Conceptually:

```text
Need to Transmit
      ↓
Is Medium Busy?
   ┌──┴──┐
  Yes    No
   ↓      ↓
 Wait   Transmit
```

---

# Multiple Access

Multiple systems can share the same communication medium.

Conceptually:

```text
Host A ┐
Host B ├── Shared Medium
Host C ┘
```

Because several systems share the medium, simultaneous transmission attempts can occur.

---

# Collision Detection

If two systems transmit at nearly the same time, a collision can occur.

Conceptually:

```text
Host A ----->
             X Collision
Host B ----->
```

The systems detect the collision and later retry transmission.

---

# CSMA/CD Flow

A simplified workflow is:

```text
Data Ready
    ↓
Listen to Medium
    ↓
Medium Busy?
 ┌────┴────┐
Yes        No
 ↓          ↓
Wait     Transmit
            ↓
        Collision?
        ┌───┴───┐
       Yes      No
        ↓        ↓
     Stop       Success
        ↓
     Retry Later
```

---

# CSMA/CD and Modern Ethernet

CSMA/CD is primarily associated with:

```text
Shared Ethernet
Half-Duplex Ethernet
Hub-Based Ethernet
```

Modern switched Ethernet commonly operates using:

```text
Point-to-point switch links
Full-Duplex communication
```

In normal full-duplex switched Ethernet, collisions are not expected as part of normal operation.

Therefore:

```text
Ethernet
```

should not automatically be interpreted as meaning that active collision handling is always occurring.

The course includes CSMA/CD because it is a fundamental Ethernet access concept and important for understanding legacy shared Ethernet.

---

# Ethernet Troubleshooting Model

Ethernet problems can be investigated at multiple layers.

Conceptually:

```text
Application Problem
      ↓
Transport
      ↓
IP
      ↓
Ethernet Frame
      ↓
MAC Addressing
      ↓
Interface / Physical Link
```

When Ethernet errors appear, inspect evidence such as:

```text
Frame counters
CRC errors
Interface state
Physical link state
Cabling
NIC state
Switch port state
```

Do not immediately replace hardware without confirming the affected layer.

---

# Verification Checklist

- Ethernet was identified as a LAN technology.
- Ethernet's transmission unit was identified as a frame.
- CSMA/CD was identified as the course's Ethernet access method.
- Ethernet encapsulation was connected to upper-layer protocol data.
- The Ethernet frame fields were identified.
- Preamble was associated with synchronization.
- SFD was associated with the start of the frame.
- Destination and source MAC addresses were identified as six-byte fields.
- The Type field was associated with the encapsulated upper-layer protocol.
- Ethernet II Type and IEEE 802.3 length concepts were distinguished.
- Ethernet payload was connected to the MTU.
- Padding was associated with minimum frame size.
- FCS was associated with CRC-based error detection.
- Ethernet MTU was identified as 1500 bytes in the course.
- Other MTU values were treated as course reference values rather than universal defaults.
- Runts were reviewed.
- Jabbers were reviewed.
- Long frames were reviewed.
- Giant frames were reviewed.
- Bad CRC was understood as an Ethernet integrity error.
- Carrier Sense was understood.
- Multiple Access was understood.
- Collision Detection was understood.
- CSMA/CD was connected to shared and half-duplex Ethernet.
- Modern switched full-duplex Ethernet was distinguished from legacy shared Ethernet.

---

# What I Learned

- Ethernet carries Data Link communication using frames.
- Ethernet frames encapsulate upper-layer protocol data.
- Destination and source MAC addresses identify link-layer communication endpoints.
- The Type field identifies the protocol encapsulated in an Ethernet frame.
- FCS provides CRC-based frame error detection.
- Standard Ethernet commonly uses an MTU of 1500 bytes.
- Ethernet requires a minimum frame size and can use padding for small payloads.
- Runts, oversized frames, and CRC errors can provide useful Ethernet troubleshooting evidence.
- CSMA/CD describes how systems share a collision-prone Ethernet medium.
- Carrier Sense checks whether the medium is busy before transmission.
- Collision Detection identifies simultaneous transmissions.
- Modern switched full-duplex Ethernet normally operates without collisions.
- Ethernet troubleshooting should distinguish frame-level problems from IP, transport, and application problems.
