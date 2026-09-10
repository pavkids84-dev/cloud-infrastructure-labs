# Linux Network Management Lab

## Objective

Practice Linux network inspection and administration with NetworkManager, `nmcli`, `ip`, routing tools, DNS configuration, traffic statistics, and socket inspection.

The goal of this lab is to understand the relationship between network interfaces, NetworkManager connection profiles, IP addresses, routes, gateways, DNS configuration, and listening services, and to apply this model during infrastructure troubleshooting.

## Environment

- OS: Rocky Linux
- Shell: Bash
- Network Manager: NetworkManager
- Primary CLI: `nmcli`
- Runtime Network Tool: `ip`
- Socket Inspection: `ss`
- Legacy Comparison Tools: `ifconfig`, `route`, `netstat`
- Privilege: root or sudo-enabled user

## Safety Notice

Network configuration changes can immediately disconnect a remote system.

Before changing:

```text
IP addresses
Default gateway
Routes
DNS
NetworkManager connection profiles
```

confirm that direct VM console access is available.

Do not copy interface names, IP addresses, gateways, UUIDs, or DNS values from course screenshots into a real system.

Inspect the current environment first.

## Network Management Overview

The course introduces the following tools:

```text
ip
route
nmcli
ss
netstat
hostnamectl
```

The primary tools emphasized for a modern Rocky Linux environment are:

```text
NetworkManager
nmcli
ip
ss
```

A useful conceptual model is:

```text
Physical / Virtual NIC
        |
        v
Network Device
        |
        v
NetworkManager
        |
        v
Connection Profile
        |
        +-- IP Address
        +-- Prefix
        +-- Gateway
        +-- DNS
        +-- Routes
```

## Network Addressing Concepts

The course introduces:

```text
Network Address
Host Address
Netmask / Subnet Mask
Broadcast Address
```

An IPv4 address should be interpreted together with its prefix.

Example:

```text
192.168.10.25/24
```

Conceptually:

```text
Network:
192.168.10.0/24

Host:
192.168.10.25

Broadcast:
192.168.10.255
```

The exact values depend on the prefix.

## Classful Addressing Concept

The course also introduces the traditional classful model:

```text
Class A
Class B
Class C
```

and private address ranges based on:

```text
10.0.0.0/8

172.16.0.0 - 172.31.255.255

192.168.0.0/16
```

Modern network administration should primarily interpret networks using CIDR prefixes rather than assuming a subnet mask only from an address class.

## NetworkManager

The course explains that RHEL 8 environments use NetworkManager as the primary network-management service.

Related interfaces include:

```text
nmcli
nmtui
nm-connection-editor
```

This lab focuses primarily on `nmcli`.

## Network Device and Connection Profile

NetworkManager distinguishes between a network device and a connection profile.

```text
Device
→ Actual network interface

Examples:
ens33
ens160


Connection
→ Saved NetworkManager configuration profile

Examples:
ens33
mynet
```

A connection profile can be activated on a network device.

These two concepts should not be treated as identical.

## Inspect NetworkManager Service

Check the NetworkManager service.

```bash
systemctl status NetworkManager
```

Record the actual runtime state from the VM.

## Inspect Interfaces

Use:

```bash
ip addr
```

or the short form:

```bash
ip a
```

Identify:

```text
Interface name
Link state
IPv4 address
IPv6 address
Prefix
```

Do not assume the interface is named `ens33` or `ens160`.

## Legacy Network-Scripts Concept

The course introduces traditional Red Hat configuration files under:

```text
/etc/sysconfig/network-scripts/
```

Example format:

```text
ifcfg-<name>
```

Configuration values shown by the course include:

```text
BOOTPROTO
IPADDR
PREFIX
GATEWAY
DNS1
DEVICE
ONBOOT
NM_CONTROLLED
```

These are documented as course concepts.

The main hands-on administration in this lab uses NetworkManager and `nmcli`.

## NetworkManager Connection Files

The course also introduces NetworkManager connection files under:

```text
/etc/NetworkManager/system-connections/
```

A connection file can contain sections such as:

```text
[connection]

[ethernet]

[ipv4]

[ipv6]

[proxy]
```

IPv4 configuration can contain:

```text
address
gateway
dns
method
```

Inspect available connection files only when appropriate.

Do not modify them blindly.

## Traditional Network Tools

The course introduces older commands such as:

```text
dhclient
ifconfig
route
```

Example concepts include:

```text
dhclient
→ Request DHCP configuration

ifconfig
→ Configure an interface

route
→ Inspect or modify routes
```

This repository records them for compatibility and conceptual comparison.

Modern runtime administration in this lab primarily uses:

```text
ip
nmcli
```

## nmcli Help and Examples

The course introduces:

```bash
man nmcli-examples
```

This is useful for finding NetworkManager command examples.

Also inspect the command manual when required:

```bash
man nmcli
```

## Inspect General NetworkManager State

Use:

```bash
nmcli general status
```

This provides an overview of NetworkManager connectivity and state.

Record only the actual VM output.

## List NetworkManager Connections

Use:

```bash
nmcli connection show
```

Short form:

```bash
nmcli con show
```

Important fields include:

```text
NAME
UUID
TYPE
DEVICE
```

A connection whose `DEVICE` field is empty or `--` is not currently active on a device.

## Create an Ethernet Connection

The course demonstrates a command structure such as:

```bash
nmcli con add type ethernet con-name mynet ifname ens33 ip4 10.1.1.100/24 gw4 10.1.1.254
```

The values above are course examples.

Do not execute them on a real network unless they match the disposable lab topology.

General structure:

```bash
sudo nmcli con add \
  type ethernet \
  con-name CONNECTION_NAME \
  ifname INTERFACE \
  ip4 ADDRESS/PREFIX \
  gw4 GATEWAY
```

## Verify the New Connection

After creating a connection:

```bash
nmcli con show
```

Check that the new profile exists.

A newly created profile can exist without currently being active on an interface.

## Activate a Connection

The course activates the profile using a structure such as:

```bash
nmcli con up mynet ifname ens33
```

General form:

```bash
sudo nmcli con up CONNECTION_NAME ifname INTERFACE
```

Only activate a test profile if console access is available.

Changing the active connection can interrupt remote connectivity.

## Verify the Applied Address

After activation:

```bash
ip addr
```

or:

```bash
ip addr show INTERFACE
```

Verify the actual address rather than assuming the connection command succeeded.

## Verify the Applied Route

Use:

```bash
ip route
```

or:

```bash
ip r
```

Confirm that the intended connected route and default gateway exist.

The verification principle is:

```text
Create Configuration
        |
        v
Activate Configuration
        |
        v
Verify IP Address
        |
        v
Verify Routing
```

## Inspect a Specific Connection

Use:

```bash
nmcli con show CONNECTION_NAME
```

The output can contain properties such as:

```text
connection.id
connection.uuid
connection.type
connection.interface-name
connection.autoconnect
connection.zone

ipv4.method
ipv4.addresses
ipv4.gateway
ipv4.dns
ipv4.routes
```

Use the actual connection name from the VM.

## Modify an IPv4 Address

The course demonstrates:

```bash
nmcli con mod mynet ipv4.addresses 172.20.1.100/24
```

General structure:

```bash
sudo nmcli con mod CONNECTION_NAME ipv4.addresses ADDRESS/PREFIX
```

This modifies the connection-profile property.

## Add an Additional IPv4 Address

The course demonstrates the `+` prefix:

```bash
nmcli con mod mynet +ipv4.addresses 192.168.75.100/24
```

The important distinction is:

```text
ipv4.addresses
→ Set or replace the property value

+ipv4.addresses
→ Append another value
```

A single interface can therefore have multiple IPv4 addresses.

## Modify the Gateway

The course demonstrates:

```bash
nmcli con mod mynet ipv4.gateway 192.168.75.2
```

General structure:

```bash
sudo nmcli con mod CONNECTION_NAME ipv4.gateway GATEWAY
```

Verify the profile afterward:

```bash
nmcli con show CONNECTION_NAME
```

Then activate the changed profile when appropriate.

## Inspect Network Devices

Use:

```bash
nmcli dev status
```

The output shows relationships among:

```text
DEVICE
TYPE
STATE
CONNECTION
```

This makes it useful for determining which connection profile is currently applied to each interface.

## Inspect Detailed Device State

Use:

```bash
nmcli dev show
```

or:

```bash
nmcli dev show INTERFACE
```

Information can include:

```text
Hardware address
MTU
Connection state
Connection profile
IPv4 address
IPv4 gateway
IPv4 routes
DNS servers
```

Record actual values from the current VM.

## Connection vs Device Inspection

```text
nmcli con
→ Saved connection configuration


nmcli dev
→ Current device state
```

During troubleshooting, compare both views rather than assuming that stored configuration and runtime state are identical.

## Add a Runtime IPv4 Address

The course demonstrates:

```bash
ip addr add 10.1.1.100/24 dev ens33
```

General safe structure:

```bash
sudo ip addr add ADDRESS/PREFIX dev INTERFACE
```

Verify:

```bash
ip addr show INTERFACE
```

This directly changes the current kernel interface state.

## Remove a Runtime IPv4 Address

The course demonstrates:

```bash
ip addr del 10.1.1.100/24 dev ens33
```

General form:

```bash
sudo ip addr del ADDRESS/PREFIX dev INTERFACE
```

Verify:

```bash
ip addr show INTERFACE
```

## Runtime Address and Persistent Configuration

An address added with `ip addr add` modifies the current runtime network state.

It should not automatically be treated as a persistent NetworkManager configuration.

Conceptually:

```text
ip addr
→ Current kernel network state


nmcli connection configuration
→ NetworkManager-managed configuration
```

This follows the broader Linux administration principle:

```text
Runtime State
!=
Persistent Configuration
```

## Inspect the Routing Table

Use:

```bash
ip route
```

or:

```bash
ip r
```

A routing table can contain entries such as:

```text
default via GATEWAY dev INTERFACE

NETWORK/PREFIX dev INTERFACE
```

## Default Gateway

The default route is used when the destination does not match a more specific route.

Conceptually:

```text
Local Server
     |
     | Destination is outside local network
     v
Default Gateway
     |
     v
Other Network
```

A gateway problem can allow local-subnet communication while preventing access to remote networks.

## Remove a Runtime Default Route

The course demonstrates the structure:

```bash
ip r del default via GATEWAY dev INTERFACE
```

This can immediately disconnect a remote session.

Perform route-removal exercises only from a VM console.

## Add a Runtime Default Route

General form:

```bash
sudo ip route add default via GATEWAY dev INTERFACE
```

Verify:

```bash
ip route
```

Do not use a gateway that has not been verified for the current test network.

## Legacy Route Command

The course also introduces:

```text
route add
route del
```

These are recorded as legacy administration concepts.

Prefer `ip route` for the main Rocky Linux lab workflow.

## Legacy Route Inspection

The course uses:

```bash
netstat -rn
```

and:

```bash
netstat -r
```

to display routing information.

Modern route inspection in this lab should primarily use:

```bash
ip route
```

## DNS Configuration

The course inspects:

```bash
cat /etc/resolv.conf
```

In the lecture environment, the file reports that it was generated by NetworkManager.

The exact file content depends on the VM.

## Inspect Connection DNS

Use:

```bash
nmcli con show CONNECTION_NAME
```

or inspect device state:

```bash
nmcli dev show INTERFACE
```

Identify the configured DNS servers before making changes.

## Modify DNS with NetworkManager

The course demonstrates a command structure similar to:

```bash
nmcli con mod ens33 ipv4.dns "8.8.8.8 192.168.75.2"
```

General form:

```bash
sudo nmcli con mod CONNECTION_NAME ipv4.dns "DNS_SERVER_1 DNS_SERVER_2"
```

Use only DNS addresses appropriate for the disposable lab network.

## Activate DNS Changes

The course activates the modified connection:

```bash
nmcli con up CONNECTION_NAME
```

Verify afterward:

```bash
cat /etc/resolv.conf
```

and:

```bash
nmcli dev show INTERFACE
```

Do not assume that editing `/etc/resolv.conf` directly is persistent when NetworkManager manages the file.

## Network Connectivity and DNS

When an IP address can be reached but a hostname cannot, DNS should be investigated separately from basic IP connectivity.

Conceptually:

```text
IP Connectivity Works
        |
        v
Hostname Resolution Fails
        |
        v
Inspect DNS Configuration
```

Do not conclude that every hostname failure is a routing failure.

## Traffic Statistics

The course introduces:

```bash
netstat -i
```

for interface statistics.

Fields shown by the course include concepts such as:

```text
RX packets
RX errors
RX drops

TX packets
TX errors
TX drops
```

These can help identify whether an interface is receiving or transmitting traffic and whether errors or drops are occurring.

## Protocol Statistics

The course also introduces:

```bash
netstat -s
```

This displays protocol statistics for areas such as:

```text
IP
ICMP
TCP
UDP
```

The exact counters depend on runtime traffic.

Do not copy the lecture counters into the repository as actual evidence.

## Inspect Listening Services with `ss`

The course uses:

```bash
ss -nlp
```

and filters for SSH.

Example structure:

```bash
ss -nlp | grep ssh
```

Important options are:

```text
-n
→ Display numeric addresses and ports

-l
→ Display listening sockets

-p
→ Display associated process information
```

## Listening Port

A server service must normally have the expected socket listening before a client can connect.

Conceptually:

```text
Service Process
      |
      v
Listening Socket
      |
      v
Firewall
      |
      v
Network
      |
      v
Remote Client
```

## LISTEN and ESTABLISHED

The course shows both socket states.

```text
LISTEN
→ Waiting for incoming connections


ESTABLISHED
→ An active connection exists
```

These states help distinguish:

```text
Service is ready for connections
```

from:

```text
A client is actually connected
```

## Legacy Socket Inspection

The course also uses:

```bash
netstat -an
```

with port filtering.

Example:

```bash
netstat -an | grep PORT
```

For the main Rocky Linux workflow, prefer `ss` when available.

## Network Troubleshooting Model

A network problem should be investigated in layers.

```text
Connection Failure
       |
       v
Is the Network Device Up?
       |
       v
Does It Have the Expected IP?
       |
       v
Is the Prefix Correct?
       |
       v
Is the Required Route Present?
       |
       v
Is the Default Gateway Correct?
       |
       v
Is DNS Working?
       |
       v
Is the Service Listening?
       |
       v
Does the Firewall Allow It?
       |
       v
Does the Application Log Show an Error?
```

Do not change every network component at once.

## NetworkManager Troubleshooting Workflow

```text
Inspect Connections
       |
       v
nmcli con show
       |
       v
Inspect Devices
       |
       v
nmcli dev status
       |
       v
nmcli dev show
       |
       v
Inspect Kernel Addresses
       |
       v
ip addr
       |
       v
Inspect Routes
       |
       v
ip route
```

Compare configuration and runtime state.

## SSH Connectivity Example

When SSH is unreachable:

```text
1. Verify the interface and IP address.

2. Verify the route and gateway.

3. Verify that sshd is running.

4. Verify that TCP port 22 is listening.

5. Verify the firewall rule.

6. Inspect SSH authentication and service logs.

7. Retest the connection.
```

Relevant commands learned across the course include:

```bash
ip addr
```

```bash
ip route
```

```bash
systemctl status sshd
```

```bash
ss -nlp
```

```bash
firewall-cmd --list-all
```

```bash
journalctl _COMM=sshd
```

The exact command selection depends on the observed symptom.

## Ubuntu Netplan Concept

The course briefly introduces Ubuntu 18.04 and later network configuration using Netplan.

An example configuration file is:

```text
/etc/netplan/50-cloud-init.yaml
```

The course structure contains:

```yaml
network:
  version: 2
  ethernets:
    INTERFACE:
      dhcp4: false
      addresses:
        - ADDRESS/PREFIX
      nameservers:
        addresses:
          - DNS_SERVER
      routes:
        - to: default
          via: GATEWAY
```

The values above are placeholders.

## Apply Netplan

The course uses:

```bash
netplan apply
```

and verifies the result with:

```bash
ip addr
```

This Ubuntu example is introductory.

The main hands-on environment of this lab remains Rocky Linux with NetworkManager.

## Verification Checklist

- Network address and host address concepts were reviewed.
- CIDR prefix and subnet concepts were reviewed.
- NetworkManager's role was understood.
- Network devices and connection profiles were distinguished.
- NetworkManager connection profiles were listed.
- General NetworkManager status was inspected.
- The current network interface was identified.
- `nmcli con show` and `nmcli dev show` were distinguished.
- A disposable Ethernet connection-profile workflow was reviewed.
- Connection-profile activation and verification were understood.
- IPv4 address modification with `nmcli` was reviewed.
- Additional IPv4 addresses were reviewed.
- Gateway configuration was reviewed.
- Runtime IP-address addition and deletion with `ip addr` were reviewed.
- Runtime and persistent network configuration were distinguished.
- The routing table was inspected with `ip route`.
- Default-route modification concepts were reviewed.
- DNS configuration was inspected through NetworkManager.
- `/etc/resolv.conf` was recognized as potentially NetworkManager-generated.
- Traffic statistics were reviewed.
- Listening sockets were inspected with `ss`.
- LISTEN and ESTABLISHED socket states were distinguished.
- Legacy commands were distinguished from the primary modern workflow.
- Ubuntu Netplan was reviewed as a separate network-management model.
- Network troubleshooting was organized into independent layers.
- Lecture IP addresses, gateways, UUIDs, and interface names were not recorded as actual lab evidence.

## What I Learned

- Network interfaces and NetworkManager connection profiles are different concepts.
- `nmcli con` is used to inspect and manage connection profiles.
- `nmcli dev` is used to inspect current network-device state.
- `ip addr` displays and changes the current kernel interface addresses.
- `ip route` displays and changes the current routing table.
- A correct local IP address does not guarantee that remote networking will work.
- The default gateway is required to reach destinations outside directly connected networks.
- DNS failure should be distinguished from IP-connectivity failure.
- NetworkManager can manage DNS configuration and generate resolver configuration.
- One interface can have multiple IPv4 addresses.
- A leading `+` in selected `nmcli` properties can append a value rather than replacing the existing property.
- Runtime network changes and persistent NetworkManager configuration must be distinguished.
- `ss` can identify which process is listening on a network port.
- A running systemd service and a listening network socket are separate troubleshooting checkpoints.
- Network failures should be investigated through interface, addressing, routing, DNS, socket, firewall, and application layers.
