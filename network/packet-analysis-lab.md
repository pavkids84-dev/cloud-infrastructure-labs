# Packet Analysis Lab

## Objective

Understand how Ethernet, IPv4, IPv6, TCP, UDP, ARP, ICMP, and IGMP appear in captured network traffic using Wireshark.

The goal is to move from protocol theory to packet-level observation and use packet captures, filters, stream analysis, flow graphs, and timing information as evidence during infrastructure troubleshooting.

## Scope

This lab covers:

```text
Wireshark
Packet Capture
Packet Lists
Protocol Details
Raw Packet Bytes
IPv4 Header
IPv6 Header
TCP Header
TCP Flags
TCP vs UDP
Ethernet II
ARP Request / Reply
ICMP Echo
ICMP Redirect
IGMP
Follow Stream
Flow Graph
Latency Analysis
Capture Filters
Display Filters
Layered Packet Analysis
```

---

# Packet Analysis Model

Packet analysis connects protocol theory to observable traffic.

```text
Protocol Theory
       ↓
Packet Capture
       ↓
Header Inspection
       ↓
Stream / Flow Analysis
       ↓
Timing Analysis
       ↓
Troubleshooting Evidence
```

A capture should be used to answer specific questions rather than simply collecting large amounts of traffic.

---

# Wireshark

The course introduces Wireshark as a graphical packet-analysis tool.

A typical Wireshark view contains:

```text
Packet List
     ↓
Packet Details
     ↓
Raw Packet Bytes
```

## Packet List

The packet list commonly displays information such as:

```text
Packet Number
Timestamp
Source
Destination
Protocol
Length
Summary
```

This view provides a high-level picture of captured traffic.

## Packet Details

Selecting a packet exposes decoded protocol layers.

A typical packet can appear as:

```text
Ethernet II
    ↓
IPv4 / IPv6
    ↓
TCP / UDP / ICMP
    ↓
Application Protocol
```

## Raw Packet Bytes

Wireshark also displays the underlying packet bytes in hexadecimal and ASCII representations.

Conceptually:

```text
Raw Bytes
    ↓
Protocol Decoder
    ↓
Human-Readable Fields
```

---

# Capture Interface Selection

A system can contain multiple interfaces:

```text
Ethernet
Wi-Fi
Loopback
Virtual Interfaces
Bridge Interfaces
```

Packet capture must occur on an interface carrying the traffic of interest.

If expected traffic does not appear, verify the selected interface before concluding that no packets exist.

---

# Packet-Capture Driver Note

The course material references WinPcap for Windows packet capture.

Modern Wireshark installations can use newer packet-capture drivers such as Npcap.

The important concept is:

```text
Wireshark
+
Packet Capture Driver
```

rather than treating a legacy driver name as a permanent requirement.

---

# IPv4 Header

The course introduces the IPv4 header structure:

```text
Version
IHL
Type of Service
Total Length
Identification
Flags
Fragment Offset
TTL
Protocol
Header Checksum
Source Address
Destination Address
Options / Padding
Data
```

---

# IPv4 Version

For IPv4:

```text
Version = 4
```

The field identifies the Internet Protocol version represented by the header.

---

# IHL

IHL stands for:

```text
Internet Header Length
```

The value is measured in 32-bit words.

For example:

```text
IHL = 5
```

means:

```text
5 × 4 bytes
= 20-byte IPv4 header
```

IPv4 options can increase the header length beyond 20 bytes.

---

# Type of Service Field

The course shows the historical TOS interpretation using areas such as:

```text
Precedence
Delay
Throughput
Reliability
```

Modern IPv4 interprets this field using concepts such as:

```text
DSCP
ECN
```

The course diagram should therefore be understood partly as historical protocol context.

---

# Total Length

IPv4 Total Length represents:

```text
IPv4 Header
+
IPv4 Payload
```

in bytes.

It is not the complete Ethernet frame length.

---

# Identification

The Identification field helps associate IPv4 fragments that originated from the same datagram.

Conceptually:

```text
Original Datagram
      ↓
Fragment 1
Fragment 2
Fragment 3
      ↓
Common Identification
```

---

# IPv4 Flags

The course introduces:

```text
Reserved
DF
MF
```

where:

```text
DF
→ Don't Fragment
```

```text
MF
→ More Fragments
```

Fragmentation behavior depends on these fields and the path MTU.

---

# Fragment Offset

Fragment Offset identifies the fragment's position within the original IPv4 datagram.

It allows the receiver to reconstruct fragmented data.

---

# TTL

TTL stands for:

```text
Time To Live
```

It prevents packets from circulating indefinitely in routing loops.

Conceptually:

```text
TTL 64
  ↓ Router
TTL 63
  ↓ Router
TTL 62
```

A packet is discarded when the effective TTL reaches zero.

---

# IPv4 Protocol Field

The Protocol field identifies the next protocol carried by IPv4.

Common values reviewed in the course include:

```text
1
→ ICMP

2
→ IGMP

6
→ TCP

17
→ UDP
```

This field should not be confused with the Ethernet EtherType field.

---

# IPv4 Header Checksum

IPv4 uses a checksum for the IPv4 header.

Conceptually:

```text
IPv4 Header
     ↓
Header Checksum
```

The field does not represent an end-to-end checksum over the complete IP payload.

---

# IPv4 Addresses

The IPv4 header contains:

```text
Source Address
Destination Address
```

The IP destination can remain the final remote host even when the Ethernet destination MAC belongs to the local default gateway.

This reinforces the distinction:

```text
Layer 2 Destination
!=
Layer 3 Destination
```

in routed communication.

---

# IPv4 Options

The course Wireshark example contains IPv4 options.

An IPv4 header can therefore be longer than the basic:

```text
20 bytes
```

The IHL field identifies the actual header length.

---

# IPv6 Header

The course also demonstrates an IPv6 packet in Wireshark.

Important IPv6 fields include:

```text
Version
Traffic Class
Flow Label
Payload Length
Next Header
Hop Limit
Source Address
Destination Address
```

IPv6 uses a different header design from IPv4.

---

# IPv4 Protocol vs IPv6 Next Header

A useful relationship is:

```text
IPv4
→ Protocol
```

```text
IPv6
→ Next Header
```

Both help identify what protocol or extension follows the current IP header.

---

# IPv4 TTL vs IPv6 Hop Limit

Conceptually:

```text
IPv4
→ TTL
```

```text
IPv6
→ Hop Limit
```

Both prevent indefinite packet forwarding through routing loops.

---

# TCP Characteristics

The course introduces TCP characteristics including:

```text
Connection-Oriented Communication
Full-Duplex Communication
Buffered Transmission
Receiver Window
Congestion Window
Large Window Support
```

TCP provides reliable ordered byte-stream communication.

---

# TCP Full Duplex

After a TCP connection is established, data can flow in both directions.

```text
Endpoint A ─────→ Endpoint B
Endpoint A ←───── Endpoint B
```

Both endpoints maintain TCP state.

---

# Receiver Window

The receiver advertises available receive capacity using the TCP window.

This provides:

```text
Flow Control
```

Conceptually:

```text
Receiver Buffer Capacity
        ↓
Advertised Window
        ↓
Sender Transmission Limit
```

---

# Congestion Window

The course places the sender congestion window together with TCP flow-control concepts.

A more precise distinction is:

```text
Receiver Window
→ Flow Control
→ Protects receiver capacity
```

```text
Congestion Window
→ Congestion Control
→ Protects the network path
```

The sender's effective transmission behavior is constrained by both receiver and network conditions.

---

# TCP Header

The course introduces:

```text
Source Port
Destination Port
Sequence Number
Acknowledgment Number
Data Offset
Reserved
Control Bits
Window
Checksum
Urgent Pointer
Options / Padding
Data
```

The basic TCP header is:

```text
20 bytes
```

before options.

---

# TCP Ports

TCP uses ports to identify transport-layer endpoints.

```text
Source Port
→ Sending endpoint port
```

```text
Destination Port
→ Receiving service port
```

Ports should be interpreted together with:

```text
Protocol
IP Address
```

rather than as globally unique identifiers.

---

# Sequence Number

TCP sequence numbers represent positions in the transmitted byte stream.

Conceptually:

```text
Sequence = 1000
Payload Length = 500
```

means the following data continues at approximately:

```text
1500
```

subject to TCP sequence-number semantics.

---

# Acknowledgment Number

The acknowledgment number identifies the next byte sequence number expected by the receiver.

Conceptually:

```text
ACK = 1500
```

means:

```text
Bytes before 1500 were acknowledged
Next expected byte begins at 1500
```

---

# TCP Data Offset

The TCP Data Offset represents:

```text
TCP Header Length
```

It determines where the TCP payload begins.

This is conceptually similar to IPv4 IHL.

---

# TCP Control Flags

The course introduces the classic six TCP flags:

```text
URG
ACK
PSH
RST
SYN
FIN
```

These flags are important for interpreting TCP connection behavior.

---

# SYN

```text
SYN
→ Connection establishment
→ Sequence-number synchronization
```

It appears in the TCP connection-establishment process.

---

# ACK

```text
ACK = 1
→ The Acknowledgment Number field is valid
```

ACK is commonly present on established TCP connection traffic.

---

# PSH

TCP data can be transmitted without PSH.

PSH indicates that received data should be delivered promptly toward the receiving application rather than unnecessarily delayed.

---

# RST

```text
RST
→ Reset / abort the TCP connection
```

RST can appear when a connection is rejected, invalid, or forcibly terminated.

---

# FIN

```text
FIN
→ Normal TCP connection shutdown
```

Because TCP is full duplex, each direction is closed independently.

---

# URG

```text
URG
→ Urgent Pointer field is meaningful
```

URG is less common in typical modern application traffic.

---

# Additional TCP Flags

The course focuses on the classic six flags.

Modern TCP can also expose fields such as:

```text
ECE
CWR
NS
```

depending on the packet and features in use.

---

# TCP Window

The Window field supports TCP flow control.

It indicates how much data the receiver is prepared to accept according to TCP window semantics.

---

# TCP Checksum

TCP uses a checksum to detect corruption affecting the TCP segment.

It participates in transport-layer error detection.

---

# Urgent Pointer

The Urgent Pointer field is associated with:

```text
URG
```

and identifies urgent-data positioning according to TCP semantics.

---

# TCP Options

TCP options can extend the basic header.

Examples can include mechanisms related to:

```text
Maximum Segment Size
Window Scaling
Timestamps
Selective Acknowledgment
```

The exact options must be read from the actual captured packet.

---

# TCP vs UDP

## TCP

```text
Connection-Oriented
Stateful
Reliable Transport
```

TCP includes mechanisms such as:

```text
Sequence Numbers
Acknowledgments
Retransmission
Ordering
Flow Control
Congestion Control
```

## UDP

```text
Connectionless
Stateless at the transport-protocol level
No TCP-style delivery guarantee
```

UDP provides a smaller transport header and simple datagram delivery.

---

# UDP Reliability Meaning

Calling UDP unreliable does not mean that UDP packets always fail.

It means UDP itself does not provide TCP-style:

```text
Delivery Guarantee
Retransmission
Ordering
Connection State
```

Applications can implement additional reliability mechanisms when required.

---

# Ethernet II Header

The course demonstrates Ethernet II in Wireshark.

The important fields are:

```text
Destination MAC
Source MAC
EtherType
```

---

# EtherType

EtherType identifies the protocol carried by the Ethernet frame.

Common examples include:

```text
0x0800
→ IPv4

0x0806
→ ARP

0x86DD
→ IPv6
```

This is different from the IPv4 Protocol field.

---

# Encapsulation Reading Model

A captured TCP/IPv4 frame can be interpreted as:

```text
Ethernet II
    ↓
IPv4
    ↓
TCP
    ↓
Application Data
```

At each layer, inspect the field identifying the next layer.

For example:

```text
EtherType
→ IPv4

IPv4 Protocol
→ TCP

TCP Destination Port
→ Application service context
```

---

# ARP Request

A typical Ethernet ARP request uses:

```text
Destination MAC
→ FF:FF:FF:FF:FF:FF
```

because the sender does not yet know which MAC address owns the requested IPv4 address.

Conceptually:

```text
Who owns TARGET_IP?
```

is transmitted to the local broadcast domain.

---

# ARP Request Fields

Important fields include:

```text
Opcode
Sender MAC
Sender IP
Target MAC
Target IP
```

Conceptually:

```text
Opcode
→ Request

Sender MAC
→ Requesting host MAC

Sender IP
→ Requesting host IPv4

Target MAC
→ Unknown

Target IP
→ IPv4 being resolved
```

---

# ARP Reply

The target host can reply with its MAC address.

Conceptually:

```text
I own TARGET_IP.
My MAC address is TARGET_MAC.
```

The response can be sent directly to the requesting host.

---

# ARP Flow

```text
Host A
  ↓
Broadcast ARP Request
  ↓
Who owns Host B's IP?
  ↓
Host B
  ↓
ARP Reply
  ↓
Host B's MAC
  ↓
Host A Neighbor Cache
```

ARP operates on the local link and does not traverse routers as an end-to-end routed protocol.

---

# ARP and IP Layering

ARP should not be interpreted as an IPv4 payload protocol.

A simplified frame is:

```text
Ethernet
   ↓
ARP
```

rather than:

```text
Ethernet
   ↓
IPv4
   ↓
ARP
```

---

# ICMP Echo Request

A typical IPv4 ICMP Echo Request uses:

```text
Type = 8
Code = 0
```

Additional fields can include:

```text
Identifier
Sequence Number
Payload
```

---

# ICMP Echo Reply

An IPv4 Echo Reply commonly uses:

```text
Type = 0
Code = 0
```

The identifier and sequence number can help associate the reply with the original request.

---

# Ping Flow

```text
Host A
   ↓
ICMP Echo Request
   ↓
Host B
   ↓
ICMP Echo Reply
   ↓
Host A
```

A successful ping demonstrates ICMP reachability.

It does not prove that TCP, UDP, or an application service is available.

---

# ICMP Redirect

The course also introduces:

```text
ICMP Redirect
Type 5
```

An ICMP Redirect can inform a host that a more appropriate next-hop router exists for a destination.

Conceptually:

```text
Host
 ↓
Router A
 ↓
Router A identifies a better gateway
 ↓
ICMP Redirect
 ↓
Host
```

---

# ICMP Redirect Codes

The course lists:

```text
0
→ Redirect for network

1
→ Redirect for host

2
→ Redirect for TOS and network

3
→ Redirect for TOS and host
```

These represent redirect categories rather than generic network errors.

---

# IGMP

IGMP stands for:

```text
Internet Group Management Protocol
```

It is used with IPv4 multicast group membership.

Conceptually:

```text
Host
   ↓
IGMP Membership Information
   ↓
Multicast Router
```

---

# IGMP Membership

Multicast requires information about which hosts want traffic for particular multicast groups.

IGMP provides membership-management signaling between hosts and multicast-aware routers.

---

# IGMPv3

The course Wireshark example demonstrates an:

```text
IGMPv3 Membership Report
```

This shows multicast membership signaling in captured traffic.

---

# Follow Stream

Wireshark can reconstruct and display traffic belonging to one application stream.

The course demonstrates following an HTTP stream.

Conceptually:

```text
Packet List
    ↓
Select Packet
    ↓
Follow Stream
    ↓
Client / Server Conversation
```

This is useful when individual packets are difficult to interpret separately.

---

# Stream Analysis

A stream view helps answer questions such as:

```text
What did the client request?

What did the server return?

Which packets belong to this conversation?

Is the application exchange complete?
```

After identifying a stream, the packet list can be filtered to show only packets belonging to that communication flow.

---

# Why Stream Filtering Matters

A capture can contain traffic from many simultaneous connections.

Conceptually:

```text
Full Capture
   ↓
Identify Relevant Stream
   ↓
Filter to That Stream
   ↓
Inspect Only Related Packets
```

This reduces unrelated traffic and makes sequence analysis easier.

---

# Flow Graph

The course demonstrates using a flow graph after selecting a stream.

A flow graph presents communication direction and packet order between endpoints.

Conceptually:

```text
Client                         Server
  |                              |
  |----------- SYN ------------->|
  |<-------- SYN/ACK ------------|
  |----------- ACK ------------->|
  |                              |
  |-------- Application -------->|
  |<------- Application ---------|
  |                              |
```

A flow graph can help visualize:

```text
TCP Handshake
Request / Response Direction
Sequence of Events
Acknowledgments
Connection Shutdown
```

---

# Flow Graph for Troubleshooting

A flow graph is particularly useful when asking:

```text
Where did the conversation stop?

Did the server respond?

Was the TCP handshake completed?

Did the application request leave the client?

Did the server return application data?
```

It complements raw packet inspection rather than replacing it.

---

# Latency Analysis

The course introduces timing analysis between client and server.

A simplified exchange can be viewed as:

```text
Client                          Server

SYN ---------------------------->
    <---------------------- SYN/ACK
ACK ---------------------------->

Application Request ------------>
    <------------------------- ACK
    <---------------- Application Data
ACK ---------------------------->
```

Timing gaps between these events can help identify where delay occurs.

---

# Network vs Endpoint Delay

A useful reasoning model is:

```text
TCP Request
     ↓
Network Travel
     ↓
Remote Endpoint Processing
     ↓
Response
```

Different time gaps can represent different parts of the interaction.

Do not assume that every long delay automatically means network latency.

Possible areas include:

```text
Client Processing
Network Delay
Server Processing
Application Delay
Retransmission
```

---

# Wireshark Time Display

Wireshark can display packet time using different reference methods.

For delay analysis, the important concept is to compare packet timestamps consistently.

Useful timing views can include:

```text
Time since beginning of capture
Time since previous packet
Time since previous displayed packet
```

The selected time representation should match the troubleshooting question.

---

# Finding Large Time Gaps

The course demonstrates sorting packets by the Time field to identify larger timing gaps.

Conceptually:

```text
Packet Timing
     ↓
Sort / Compare
     ↓
Identify Large Gap
     ↓
Inspect Packets Before and After Gap
```

A large time value should be treated as evidence that requires interpretation rather than automatic proof of server or network failure.

---

# Capture Filters

A capture filter controls which packets are collected.

Conceptually:

```text
Network Traffic
      ↓
Capture Filter
      ↓
Matching Packets Stored
```

Packets rejected by the capture filter are not available later in that capture.

This makes capture filters useful when:

```text
Traffic volume is high
Only one host matters
Only one network matters
Only one service matters
```

---

# Capture Filter vs Display Filter

The distinction is critical.

```text
Capture Filter
→ Applied while packets are being captured
→ Non-matching packets are not stored
```

```text
Display Filter
→ Applied after packets have been captured
→ Non-matching packets remain in the capture
→ They are only hidden from the current view
```

For troubleshooting, use a capture filter only when it is safe to exclude unrelated traffic permanently.

---

# Capture Filter by Host

General BPF-style examples include:

```text
host HOST
```

Capture traffic to or from one host.

```text
not host HOST
```

Exclude one host.

```text
src host HOST
```

Capture packets where the specified host is the source.

```text
dst host HOST
```

Capture packets where the specified host is the destination.

Multiple conditions can be combined:

```text
host HOST_A or host HOST_B
```

---

# Capture Filter by Network

General structures include:

```text
net NETWORK/PREFIX
```

```text
src net NETWORK/PREFIX
```

```text
dst net NETWORK/PREFIX
```

```text
not net NETWORK/PREFIX
```

These are useful when investigating one subnet or excluding a known unrelated network.

---

# Broadcast and Multicast Capture

The course also introduces capture filtering for broadcast and multicast traffic.

Conceptually:

```text
ip broadcast
```

captures IPv4 broadcast traffic.

```text
ip multicast
```

captures IPv4 multicast traffic.

IPv6 multicast traffic can also be narrowed by destination addresses when required.

---

# Capture Filter by Port

General examples include:

```text
port 53
```

Capture traffic associated with port 53.

```text
not port 53
```

Exclude traffic associated with port 53.

```text
tcp port 80
```

Capture TCP traffic using port 80.

```text
udp port 67
```

Capture UDP traffic using port 67.

---

# Capture Port Ranges

Port ranges can also be used.

```text
portrange START-END
```

or protocol-specific forms such as:

```text
tcp portrange START-END
```

This can be useful when one service uses a known range of ports.

---

# Compound Capture Filters

Capture filters can combine host, port, protocol, and logical operators.

Conceptual examples:

```text
host HOST and port PORT
```

```text
host HOST and not port PORT
```

```text
udp src port PORT_A and udp dst port PORT_B
```

Complex filters should be kept readable and tested before relying on them for incident evidence.

---

# ICMP Capture Filters

The course demonstrates ICMP-specific filtering.

The simplest form is:

```text
icmp
```

This captures ICMP traffic.

More detailed BPF expressions can inspect fields within ICMP packets, but byte-offset filters should be used only when the protocol structure is clearly understood.

---

# Capture Filter Caution

A narrow capture filter can accidentally remove the packet that explains the failure.

For example, investigating an application may also require:

```text
ARP
DNS
ICMP
TCP Handshake
Application Traffic
```

If only application packets are captured, lower-layer evidence can be lost.

Use the smallest filter that still preserves the troubleshooting context.

---

# Display Filters

Display filters operate on packets that are already captured.

Conceptually:

```text
Stored Capture
     ↓
Display Filter
     ↓
Packets Visible in Wireshark
```

Changing or removing the display filter does not remove packets from the original capture.

---

# Display Filter by Protocol

Simple protocol filters include:

```text
arp
```

```text
ip
```

```text
ipv6
```

```text
tcp
```

```text
udp
```

```text
dns
```

```text
http
```

```text
icmp
```

These are useful for quickly isolating a protocol from a mixed capture.

---

# Display Filter by Field Existence

Wireshark can display packets where a specific protocol field exists.

Conceptually:

```text
FIELD_NAME
```

Examples introduced by the course include fields related to:

```text
DHCP Hostname
HTTP Host
```

This allows filtering based on decoded protocol information rather than only raw addresses or ports.

---

# TCP Analysis Display Filters

Wireshark exposes analysis-related TCP fields.

Useful examples from the course include concepts such as:

```text
tcp.analysis.flags
```

and:

```text
tcp.analysis.zero_window
```

These can help locate packets Wireshark has identified as relevant to TCP analysis.

Such labels should be treated as analysis hints and correlated with the surrounding packet flow.

---

# Display Filter Operators

Wireshark display filters support comparison and search operators.

Examples include:

```text
==
!=
>
<
>=
<=
contains
```

These allow filters to test decoded protocol fields.

---

# Display Filter Examples

Examples of general filter structures include:

```text
ip.src == SOURCE_IP
```

Display IPv4 packets from one source.

```text
tcp.srcport != 80
```

Exclude packets whose TCP source port is 80.

```text
frame.time_relative > VALUE
```

Show packets after a selected relative time.

```text
tcp.window_size < VALUE
```

Find packets with a TCP window below a selected value.

```text
http contains "GET"
```

Search decoded HTTP traffic for matching content.

Actual filters should match the protocol fields available in the capture.

---

# Display Filter Bookmarks

The course demonstrates saving frequently used display filters.

Conceptually:

```text
Useful Display Filter
       ↓
Save / Bookmark
       ↓
Reuse During Analysis
```

This can improve repeatability when the same diagnostic filter is used frequently.

Do not store environment-specific secrets inside saved filter names or expressions.

---

# Display Filter Buttons

Frequently used filters can also be exposed as reusable interface buttons.

The useful operational idea is not the button itself, but creating repeatable analysis shortcuts for commonly investigated conditions.

Examples might include filters for:

```text
DNS
TCP Analysis
One Application Protocol
One Troubleshooting Condition
```

---

# Recommended Analysis Workflow

A practical packet-analysis workflow is:

```text
1. Define the symptom.

2. Identify the relevant endpoints.

3. Start with a broad enough capture.

4. Confirm lower-layer traffic.

5. Apply display filters.

6. Identify the relevant TCP or application stream.

7. Follow the stream.

8. Use a flow graph to inspect sequence and direction.

9. Compare timestamps for abnormal gaps.

10. Correlate packet evidence with system and application evidence.
```

---

# Why Broad Capture Can Matter

For an application failure, the visible symptom may depend on several protocols.

Example:

```text
ARP
  ↓
DNS
  ↓
TCP Handshake
  ↓
Application Request
```

Capturing only the final application port can hide evidence from earlier stages.

When uncertain, prefer:

```text
Broad Capture
      ↓
Display Filter
```

over an overly restrictive capture filter.

---

# Layered Packet Reading

When analyzing a captured packet, use a consistent sequence.

```text
1. Ethernet
   - Source MAC
   - Destination MAC
   - EtherType

2. IP
   - Version
   - Source IP
   - Destination IP
   - TTL / Hop Limit
   - Protocol / Next Header

3. Transport
   - TCP / UDP
   - Source Port
   - Destination Port
   - Flags
   - Sequence / Acknowledgment

4. Application
   - DNS
   - HTTP
   - SSH
   - Other protocol
```

Not every packet contains every layer.

---

# Packet Type Examples

## ARP

```text
Ethernet
   ↓
ARP
```

## ICMP over IPv4

```text
Ethernet
   ↓
IPv4
   ↓
ICMP
```

## TCP over IPv4

```text
Ethernet
   ↓
IPv4
   ↓
TCP
   ↓
Application Data
```

## UDP over IPv6

```text
Ethernet
   ↓
IPv6
   ↓
UDP
   ↓
Application Data
```

---

# Packet Analysis for Troubleshooting

Packet capture provides evidence about what actually crossed an interface.

Questions packet capture can help answer include:

```text
Did the client send the request?

Did the packet reach this host?

Did the server respond?

Did the response leave this host?

Was the TCP connection established?

Was the connection reset?

Was DNS traffic transmitted?

Did ARP resolution occur?

Where did the conversation stop?

Where is the largest timing gap?
```

---

# Example: TCP Service Failure

Symptom:

```text
A client cannot connect to a TCP service.
```

Possible packet observations:

```text
No SYN reaches server
→ Investigate network path / firewall before server
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
→ Investigate higher application layer
```

Packet evidence should be correlated with:

```text
ss
systemctl
journalctl
firewalld
Application logs
```

---

# Example: Application Response Delay

Symptom:

```text
A service is reachable but feels slow.
```

Investigation model:

```text
TCP Handshake Timing
        ↓
Application Request
        ↓
Server Response Delay
        ↓
Data Transfer
        ↓
Acknowledgments
```

Use:

```text
Packet timestamps
Follow Stream
Flow Graph
```

to identify where the visible delay appears.

Do not automatically classify a time gap as network latency without checking the direction and application context.

---

# Example: DNS Failure

A packet-oriented DNS workflow can be:

```text
Client sends DNS query?
        ↓
Query reaches resolver?
        ↓
Resolver sends response?
        ↓
Response reaches client?
```

If the query never leaves the client, investigate local resolver behavior.

If the query leaves but no response returns, investigate:

```text
Network path
Firewall
DNS server
Upstream resolution
```

Correlate packet evidence with:

```text
dig
getent
Resolver configuration
DNS logs
```

---

# Packet Capture Is Evidence, Not Automatic Root Cause

A capture can show symptoms without proving their cause.

For example:

```text
Retransmission
```

can be associated with multiple underlying conditions.

Do not conclude the root cause from one Wireshark label alone.

Use:

```text
Topology
Configuration
Logs
Socket State
Stream Behavior
Timing
Packet Flow
```

together.

---

# Capture Safety

Packet captures can contain sensitive data.

Do not commit raw captures publicly without reviewing them.

Possible sensitive content includes:

```text
Authentication data
Internal IP addresses
Hostnames
Cookies
Tokens
Application payloads
DNS names
User information
```

Capture only authorized network traffic.

---

# Evidence Policy

Course screenshots and example addresses are educational examples.

Do not record them as actual runtime evidence.

Actual packet-analysis evidence should come from a capture performed in the authorized lab environment.

Do not fabricate:

```text
MAC Addresses
IP Addresses
Sequence Numbers
Acknowledgment Numbers
Ports
Packet Counts
Response Times
Capture Output
Flow Graph Results
Latency Measurements
```

---

# Troubleshooting Documentation

Packet-analysis incidents should use:

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

Example evidence can include:

```text
Packet timestamps
Source / destination addresses
Protocol fields
TCP flags
Stream behavior
Flow graph sequence
ARP request / reply
ICMP request / reply
Application request / response
```

Only document an incident as reproduced after actual evidence has been collected.

---

# Verification Checklist

- Wireshark's packet-list, packet-detail, and raw-byte views were understood.
- The capture interface was recognized as important.
- IPv4 Version and IHL were reviewed.
- IPv4 fragmentation fields were reviewed.
- TTL was understood.
- IPv4 Protocol values were reviewed.
- Source and destination IPv4 addresses were understood.
- IPv6 header fields were reviewed.
- IPv6 Next Header was compared with the IPv4 Protocol field.
- IPv6 Hop Limit was compared with IPv4 TTL.
- TCP full-duplex communication was understood.
- Receiver Window and Congestion Window were distinguished.
- TCP Source and Destination Ports were reviewed.
- TCP Sequence Number was understood as byte-stream positioning.
- TCP Acknowledgment Number was understood.
- TCP Data Offset was interpreted as TCP header length.
- URG, ACK, PSH, RST, SYN, and FIN were reviewed.
- TCP and UDP were compared.
- Ethernet Destination MAC, Source MAC, and EtherType were reviewed.
- ARP Request and Reply were analyzed.
- ICMP Echo Request and Reply were analyzed.
- IGMP multicast membership was reviewed.
- Follow Stream was understood as a way to isolate one conversation.
- Stream filtering was connected to reducing unrelated packet noise.
- Flow Graph was understood as a communication-sequence visualization.
- Timing analysis was connected to locating delays between communication events.
- Client, network, and server delays were not assumed to be identical.
- Capture Filters were distinguished from Display Filters.
- Host-based capture filters were reviewed.
- Network-based capture filters were reviewed.
- Port-based capture filters were reviewed.
- Protocol-based capture filters were reviewed.
- Display filtering by protocol was reviewed.
- Display filtering by decoded fields was reviewed.
- Display filter comparison operators were reviewed.
- TCP analysis display fields were introduced.
- Saved display filters were understood as reusable analysis shortcuts.
- Overly restrictive capture filters were recognized as a risk to troubleshooting evidence.
- Packet captures were treated as evidence rather than automatic root-cause conclusions.
- Course packet values were not treated as actual lab evidence.

## What I Learned

- Packet analysis connects networking theory to actual traffic.
- Wireshark decodes raw frame bytes into protocol layers and fields.
- IPv4 headers contain addressing, fragmentation, lifetime, and next-protocol information.
- IPv6 uses Next Header and Hop Limit instead of the corresponding IPv4 fields.
- TCP uses ports, sequence numbers, acknowledgments, windows, and control flags to maintain a reliable byte stream.
- UDP provides simpler datagram transport without TCP-style connection state.
- Ethernet EtherType identifies the protocol carried by a frame.
- ARP resolves local IPv4 neighbors to MAC addresses.
- ICMP provides control and diagnostic messaging for IP.
- IGMP manages IPv4 multicast group membership.
- Following a stream makes one client/server conversation easier to analyze.
- Flow graphs help visualize TCP and application communication order.
- Packet timing can help identify where delay appears in a transaction.
- Capture filters reduce what is stored, while display filters reduce only what is shown.
- Broad captures combined with targeted display filters can preserve more troubleshooting evidence.
- Packet capture is especially valuable when configuration and logs do not reveal whether traffic actually crossed an interface.
