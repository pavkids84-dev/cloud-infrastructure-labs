# Linux Bridge Management Lab

## Objective

Understand Linux software bridging and configure a Layer 2 bridge using NetworkManager.

The goal is to distinguish Linux bridging from routing and network teaming while understanding how a physical network interface can participate as a bridge port.

## Environment

- OS: Rocky Linux lab environment
- Network Management: NetworkManager
- Primary Tool: `nmcli`
- Inspection Tools: `ip`
- Legacy Course Tools: `brctl`, network-scripts
- Example Bridge: `br0`

## Safety Notice

Bridge configuration can immediately interrupt network connectivity.

Perform bridge creation from:

```text
VM Console
Local Console
Recovery-Safe Management Access
```

when possible.

Do not convert the only remotely accessible management interface into a bridge without a recovery path.

Do not copy lecture interface names or IP addresses as actual lab values.

---

# Linux Bridge Overview

A Linux bridge provides software-based Layer 2 forwarding.

Conceptually:

```text
Physical Interface
        |
        v
      br0
   Linux Bridge
        |
        v
Virtual or Physical Network
```

A Linux bridge can act similarly to a software Ethernet switch.

---

# OSI Layer

A bridge primarily operates at:

```text
Layer 2
Data Link
```

It forwards Ethernet frames based on link-layer behavior.

This should be distinguished from IP routing.

```text
Bridge
→ Layer 2

Router
→ Layer 3
```

---

# Bridge Use Cases

Linux bridges can be useful in areas such as:

```text
Virtual Machines
Virtual Networking
Containers
KVM
Host-to-Guest Network Connectivity
Lab Network Segmentation
```

The course focuses on basic Linux bridge construction rather than a complete virtualization platform.

---

# Bridge Architecture

A simplified Linux bridge configuration is:

```text
Linux Host

       IP Address
           |
           v
          br0
     Linux Bridge
           |
           v
      Bridge Port
           |
           v
   Physical Interface
           |
           v
     External Network
```

The bridge receives the host's Layer 3 address while the physical interface acts as a Layer 2 port.

---

# Physical Interface as a Bridge Port

The course first demonstrates the legacy network-scripts model.

The physical interface configuration contains:

```text
BRIDGE=br0
```

Conceptually:

```text
Physical NIC
      |
      v
     br0
```

The physical interface becomes associated with the bridge.

---

# Legacy Bridge Configuration

The course shows an older Red Hat-style configuration file:

```text
/etc/sysconfig/network-scripts/ifcfg-INTERFACE
```

with values such as:

```text
TYPE=Ethernet
DEVICE=INTERFACE
ONBOOT=yes
BRIDGE=br0
```

This should be understood as historical Red Hat network-scripts administration.

Modern Rocky Linux administration primarily uses NetworkManager.

---

# Legacy `br0` Configuration

The course also shows:

```text
/etc/sysconfig/network-scripts/ifcfg-br0
```

with example settings such as:

```text
DEVICE=br0
TYPE=Bridge
STP=yes
BOOTPROTO=none
NAME=br0
ONBOOT=yes
BRIDGING_OPTS=priority=32768
IPADDR=ADDRESS
PREFIX=24
```

The lecture IP address is an example only.

Use the actual disposable lab network configuration.

---

# NetworkManager vs network-scripts

The course includes both:

```text
network-scripts
```

and:

```text
NetworkManager / nmcli
```

methods.

For the current Rocky Linux learning path:

```text
Primary
→ NetworkManager
→ nmcli
```

Legacy course material:

```text
network-scripts
systemctl restart network
brctl
```

should be understood for historical compatibility rather than treated as the primary modern workflow.

---

# Create a Bridge with NetworkManager

Inspect current devices:

```bash
nmcli dev status
```

Inspect current connections:

```bash
nmcli con show
```

Create the bridge:

```bash
sudo nmcli con add type bridge con-name br0 ifname br0
```

Command structure:

```text
type bridge
→ Bridge connection

con-name br0
→ NetworkManager profile name

ifname br0
→ Linux bridge interface
```

---

# Verify the Bridge Connection

After creation:

```bash
nmcli con show
```

and:

```bash
ip link show
```

can be used to confirm that the logical bridge exists.

Do not assume that successful profile creation proves connectivity.

---

# Add a Physical Bridge Port

The course demonstrates a bridge-slave style command.

General course structure:

```bash
sudo nmcli con add \
  type bridge-slave \
  con-name br0-port1 \
  ifname INTERFACE \
  master br0
```

Conceptually:

```text
br0
 |
 +-- br0-port1
       |
       v
  Physical NIC
```

Use the actual disposable interface from the current VM.

---

# Connection Name vs Interface Name

These should not be confused.

```text
br0-port1
→ NetworkManager connection profile

INTERFACE
→ Physical network device
```

This follows the same distinction used in previous NetworkManager labs.

---

# Configure IPv4 on the Bridge

The course assigns the IPv4 configuration to:

```text
br0
```

rather than the physical bridge member.

General modern structure:

```bash
sudo nmcli con mod br0 ipv4.addresses ADDRESS/PREFIX
```

Configure manual addressing:

```bash
sudo nmcli con mod br0 ipv4.method manual
```

Use only a valid lab address.

---

# Why the IP Belongs on `br0`

The physical interface participates as a Layer 2 bridge port.

The host's Layer 3 endpoint is the bridge.

Conceptually:

```text
Host IPv4 Address
       |
       v
      br0
       |
       v
Physical Interface
       |
       v
External Network
```

Do not independently assign conflicting host addresses to both the bridge and its member interface.

---

# Activate the Bridge

The course uses:

```bash
nmcli con up br0
```

Activate the bridge member as needed:

```bash
nmcli con up br0-port1
```

Actual connection names must match the current environment.

---

# Inspect Bridge Addressing

Use:

```bash
ip addr
```

The intended state is conceptually:

```text
Physical Interface
→ Bridge member

br0
→ Host IPv4 address
```

Do not copy the lecture's address, UUID, or interface name as actual evidence.

---

# STP

The course enables:

```text
STP=yes
```

STP stands for:

```text
Spanning Tree Protocol
```

STP helps prevent Layer 2 loops in bridged networks.

Conceptually:

```text
Redundant Layer 2 Paths
        ↓
Potential Loop
        ↓
STP
        ↓
Loop-Free Active Topology
```

The course does not provide a detailed STP algorithm lab in this section.

---

# Bridge Priority

The course shows:

```text
priority=32768
```

as a bridge option.

Bridge priority is related to STP bridge selection behavior.

The detailed STP root-election algorithm is outside the scope of this course section.

---

# Legacy `brctl`

The course demonstrates:

```bash
brctl show
```

which can display information such as:

```text
Bridge name
Bridge ID
STP state
Member interfaces
```

`brctl` should be treated as a legacy Linux bridge-management tool.

Modern Linux environments commonly use:

```text
ip
NetworkManager
nmcli
```

for current configuration workflows.

---

# Inspect Devices

Use:

```bash
nmcli dev status
```

This helps distinguish:

```text
Physical devices
Bridge interface
Device state
```

---

# Inspect Connection Profiles

Use:

```bash
nmcli con show
```

This helps verify:

```text
br0 connection exists
bridge-port connection exists
profiles reference the intended devices
```

---

# Inspect Link State

Use:

```bash
ip link
```

This provides information about:

```text
Interface state
Master relationship
MAC address
MTU
```

---

# Inspect IP State

Use:

```bash
ip addr
```

Verify that the intended host address is associated with the bridge interface.

---

# Bridge vs Network Teaming

These concepts create logical interfaces for different reasons.

## Linux Bridge

```text
Purpose
→ Layer 2 forwarding

Concept
→ Software switch

Use
→ Connect multiple Layer 2 interfaces
```

## Network Teaming

```text
Purpose
→ Link redundancy / aggregation

Concept
→ Multiple NICs operate as one logical connection

Use
→ Failover or traffic-distribution behavior
```

Do not treat a bridge and a team as equivalent configurations.

---

# Bridge vs Router

A bridge forwards:

```text
Ethernet Frames
```

primarily at Layer 2.

A router forwards:

```text
IP Packets
```

between Layer 3 networks.

Conceptually:

```text
Bridge
→ MAC / Layer 2
```

```text
Router
→ IP / Layer 3
```

---

# Virtualization Example

A Linux bridge can conceptually connect virtual-machine interfaces to a physical network.

```text
Virtual Machine
      |
   Virtual NIC
      |
      v
     br0
      |
      v
Physical NIC
      |
      v
Physical LAN
```

This is one reason Linux bridge concepts are relevant to cloud and virtualization fundamentals.

---

# Linux Bridge Troubleshooting Workflow

When the bridge does not provide connectivity:

```text
Physical Interface Exists?
        ↓
Physical Interface Up?
        ↓
Bridge Connection Exists?
        ↓
Bridge Port Exists?
        ↓
Correct Interface Attached?
        ↓
IPv4 Assigned to br0?
        ↓
Route Uses br0?
        ↓
STP / Link State?
        ↓
Connectivity Test
```

Collect evidence before recreating the entire bridge.

---

# Verify Connection Relationships

Inspect:

```bash
nmcli con show
```

Confirm:

```text
Bridge profile
Bridge-port profile
Expected physical interface
```

---

# Verify Device State

Inspect:

```bash
nmcli dev status
```

and:

```bash
ip link
```

Determine whether the problem is:

```text
Connection configuration
```

or:

```text
Device state
```

before making changes.

---

# Verify Address Placement

Inspect:

```bash
ip addr
```

A common troubleshooting question is:

```text
Is the host IP attached to the bridge or incorrectly left on the bridge member?
```

The bridge configuration should be interpreted as one layered network structure rather than independent unrelated interfaces.

---

# Runtime and Persistent Configuration

NetworkManager connection profiles provide managed configuration.

Runtime state should still be independently verified after activation.

Conceptually:

```text
Connection Profile
      ↓
Activate
      ↓
Runtime Device State
      ↓
Verify
```

A stored configuration alone does not prove that the bridge is currently working.

---

# Verification Checklist

- Linux bridging was understood as Layer 2 forwarding.
- A Linux bridge was distinguished from a router.
- A Linux bridge was distinguished from network teaming.
- The physical interface was understood as a bridge member.
- The host IPv4 address was associated with `br0`.
- Legacy network-scripts bridge configuration was reviewed.
- Legacy `systemctl restart network` workflow was recognized as historical material.
- NetworkManager was identified as the primary current Rocky Linux workflow.
- A bridge profile was created or reviewed with `nmcli`.
- A bridge-port profile was created or reviewed.
- Connection names and interface names were distinguished.
- `ip addr` was used or reviewed for address verification.
- `ip link` was used or reviewed for link verification.
- `nmcli dev status` was used or reviewed.
- `nmcli con show` was used or reviewed.
- STP was associated with Layer 2 loop prevention.
- Bridge priority was recognized as an STP-related concept.
- `brctl` was recognized as a legacy bridge-management tool.
- Lecture IP addresses, interface names, UUIDs, and runtime output were not recorded as actual lab evidence.
- Connectivity-sensitive bridge configuration was treated as a recovery-safe lab activity.

---

# What I Learned

- Linux can implement a software Layer 2 bridge.
- A bridge forwards Ethernet traffic rather than routing IP traffic between networks.
- Physical interfaces can participate as bridge ports.
- The host IP configuration can reside on the logical bridge interface.
- NetworkManager can create and manage Linux bridge connections.
- Connection profiles and network devices are separate concepts.
- STP helps prevent Layer 2 loops.
- Linux bridges and network teams solve different infrastructure problems.
- Linux bridging is relevant to virtualization and cloud networking.
- Bridge troubleshooting should separate profile configuration, device state, addressing, and routing.
