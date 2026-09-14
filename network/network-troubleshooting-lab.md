# Network Troubleshooting Lab

## Objective

Build a structured network troubleshooting workflow using routing, DNS, socket, process, neighbor, service-discovery, connectivity, and packet-capture tools.

The goal is to identify the failing network layer with evidence before changing configuration.

## Environment

- OS: Linux lab environment
- Network Inspection: `ip`, `ss`, `netstat`
- Routing Diagnostics: `traceroute`
- DNS Diagnostics: `dig`, `host`, `nslookup`, `getent`
- Socket and Process Inspection: `lsof`, `fuser`
- Neighbor Diagnostics: `ip neigh`, `arping`
- Service Discovery: `nmap`
- Connectivity Testing: `nc`
- RPC Diagnostics: `rpcinfo`
- Packet Capture: `tcpdump`, `tshark`
- HTTP Testing: `curl`, `elinks`
- Link Inspection: `ethtool`

## Safety

Use network scanning and packet-capture tools only on systems and networks that you own or are explicitly authorized to test.

Do not scan unrelated public networks.

Do not intentionally disconnect a remote management interface without a recovery-safe console.

Do not capture or store credentials, private application payloads, or unrelated user traffic.

## Troubleshooting Principle

Do not begin by changing configuration.

Use:

```text
Symptom
   ↓
Identify Layer
   ↓
Collect Evidence
   ↓
Narrow Scope
   ↓
One Controlled Change
   ↓
Verify
```

A useful network troubleshooting stack is:

```text
Physical / Interface
        ↓
Data Link / Neighbor
        ↓
IP Address / Prefix
        ↓
Routing
        ↓
DNS
        ↓
Transport / Port
        ↓
Service
        ↓
Application
```

---

# Routing Troubleshooting

The course introduces:

```bash
traceroute DESTINATION
```

and the legacy:

```bash
route -n
```

for routing investigation.

Modern Linux primarily uses:

```bash
ip route
```

for routing-table inspection.

## Inspect the Routing Table

Use:

```bash
ip route
```

Inspect:

```text
Connected routes
Specific routes
Default route
Gateway
Interface
Metric
```

Do not copy lecture routes or addresses as actual lab evidence.

## Trace a Network Path

Use:

```bash
traceroute DESTINATION
```

A simplified path can look like:

```text
Local Host
    ↓
Default Gateway
    ↓
Intermediate Router
    ↓
Intermediate Router
    ↓
Destination
```

Each responding router represents a network hop.

## Interpret Missing Traceroute Responses

A line containing:

```text
* * *
```

does not automatically prove that the router or route is broken.

Possible causes can include:

```text
Filtering
Rate limiting
No TTL-expired response
Firewall policy
Actual routing failure
```

Correlate traceroute with other evidence.

## Routing Troubleshooting Flow

```text
Interface Up?
    ↓
Correct IP Address?
    ↓
Correct Prefix?
    ↓
Destination Local or Remote?
    ↓
Expected Route Exists?
    ↓
Default Gateway Exists?
    ↓
Gateway Reachable?
    ↓
Trace Remote Path
```

---

# DHCP Troubleshooting

The course demonstrates DHCP server log inspection with:

```bash
journalctl -u dhcpd
```

and live monitoring with:

```bash
journalctl -f -u dhcpd
```

The exact DHCP service unit must match the current environment.

## DHCP Log Workflow

```text
Client Requests Address
        ↓
Watch Server Journal
        ↓
Request Reaches Server?
        ↓
Server Responds?
        ↓
Lease Configuration Valid?
```

## DHCP Troubleshooting Flow

```text
Client Interface
      ↓
DHCP Request
      ↓
Layer 2 Network
      ↓
DHCP Server
      ↓
Server Service
      ↓
Address Pool
      ↓
Lease
```

The course also recommends checking client time synchronization.

Time synchronization can be useful for interpreting logs and timing information, but it should not replace investigation of the normal DHCP request and lease path.

---

# DNS Troubleshooting

The course introduces:

```text
/etc/nsswitch.conf
/etc/resolv.conf
nslookup
dig
host
getent
```

as DNS and name-resolution troubleshooting areas.

## Name-Service Source Order

Inspect:

```text
/etc/nsswitch.conf
```

A configuration such as:

```text
hosts: files dns
```

means that local files and DNS participate in host lookup according to the configured order.

## Resolver Configuration

Inspect:

```text
/etc/resolv.conf
```

Review the configured:

```text
nameserver
search
```

values.

## Direct DNS Test

Use:

```bash
dig @DNS_SERVER NAME TYPE
```

This allows one specific DNS server to be tested directly.

## System Resolver Test

Use:

```bash
getent hosts NAME
```

This follows the operating system's configured name-service path.

## DNS Isolation Example

```text
dig @DNS_SERVER succeeds
        ↓
DNS server can answer directly

getent fails
        ↓
Inspect local resolver / NSS configuration
```

## DNS Troubleshooting Flow

```text
IP Connectivity
      ↓
DNS Server Address
      ↓
DNS Server Reachability
      ↓
Direct DNS Query
      ↓
Record Exists?
      ↓
Resolver Configuration
      ↓
NSS Configuration
      ↓
Application Lookup
```

---

# Connection Statistics

The course demonstrates:

```bash
netstat -tulpn
```

```bash
netstat -i
```

```bash
netstat -s
```

`netstat` is useful legacy knowledge.

Modern Linux commonly uses other tools for the same areas.

## Listening Sockets

Modern equivalent:

```bash
ss -tulpn
```

This helps identify:

```text
TCP listeners
UDP listeners
Local addresses
Ports
Processes
```

## Interface Statistics

The course uses:

```bash
netstat -i
```

Modern Linux can also use:

```bash
ip -s link
```

Inspect packet, error, and drop counters.

## Protocol Statistics

The course uses:

```bash
netstat -s
```

This exposes protocol-level statistics for areas such as:

```text
IP
ICMP
TCP
UDP
```

---

# Nmap Network Discovery

The course introduces Nmap for host discovery, operating-system detection, local interface inspection, and selected port testing.

Use Nmap only on authorized targets.

## OS Detection

Course example structure:

```bash
nmap -O TARGET
```

`-O` enables operating-system detection.

Treat the result as a fingerprint-based estimate rather than guaranteed identification.

## Host Discovery

The course uses the historical:

```bash
nmap -sP NETWORK
```

Current Nmap normally uses:

```bash
nmap -sn NETWORK
```

for host discovery without a normal port scan.

## Exclude a Host

General structure:

```bash
nmap -sn NETWORK --exclude EXCLUDED_HOST
```

This excludes the specified target from the authorized discovery operation.

## Skip Host Discovery

The course uses the historical spelling:

```text
-PN
```

Current Nmap uses:

```bash
nmap -Pn TARGET
```

This skips normal host discovery and treats the target as online for the requested scan.

## Inspect Local Interfaces

Use:

```bash
nmap --iflist
```

This displays local interface and routing information recognized by Nmap.

## Compare Network Snapshots

An authorized lab can capture two discovery snapshots:

```bash
nmap -sn LAB_NETWORK > scan1.txt
```

Later:

```bash
nmap -sn LAB_NETWORK > scan2.txt
```

Compare:

```bash
diff scan1.txt scan2.txt
```

A difference indicates a change in observed scan results.

It does not by itself identify the reason for the change.

---

# Open Files and Sockets with `lsof`

Linux treats many sockets through file-descriptor abstractions.

`lsof` can therefore connect processes, files, and network sockets.

## Inspect a Process

Example:

```bash
lsof -c sshd
```

Inspect files and sockets opened by the SSH daemon.

Actual command-selection syntax can vary with the installed `lsof` version.

## Inspect a Port

Use:

```bash
lsof -i:22
```

This can identify processes associated with port 22.

Conceptually:

```text
Port
 ↓
Open Socket
 ↓
Process
```

## Inspect Network Files

A general pattern is:

```bash
lsof -i
```

Additional filters can narrow by protocol, address, or service.

## Directory Inspection

The course demonstrates:

```bash
lsof +d DIRECTORY
```

and recursive:

```bash
lsof +D DIRECTORY
```

Recursive traversal can be expensive on a large directory tree.

Use the smallest useful scope.

---

# Filesystem Users with `fuser`

The course demonstrates:

```bash
fuser -m MOUNT_OR_PATH
```

This can help identify processes using a mounted filesystem.

A common troubleshooting question is:

```text
Why is this filesystem still busy?
```

Collect process evidence before terminating anything.

---

# Interface State Changes

The course demonstrates:

```bash
ip link set INTERFACE down
```

This changes the interface state and can immediately disconnect the system.

Use it only in a disposable lab or from a recovery-safe console.

Do not run it on the interface carrying the only remote management connection.

---

# Neighbor Table

The course connects:

```bash
ip neigh list
```

with traditional:

```bash
arp -a
```

Modern Linux commonly uses:

```bash
ip neigh
```

Inspect:

```text
Neighbor IP
MAC Address
Interface
Neighbor State
```

## Neighbor Troubleshooting Flow

For a destination on the local subnet:

```text
Correct Prefix?
      ↓
Connected Route?
      ↓
Neighbor Entry?
      ↓
ARP Resolution?
      ↓
Layer 2 Connectivity?
```

---

# DNS Trace

The course demonstrates a reverse DNS trace using a structure such as:

```bash
dig +trace -x ADDRESS
```

`-x` requests reverse lookup.

`+trace` follows DNS delegation information.

Use the actual address from the authorized lab.

---

# RPC Diagnostics

The course introduces:

```bash
rpcinfo -p SERVER
```

This displays registered RPC services.

It also demonstrates TCP verification for an RPC program using:

```bash
rpcinfo -t SERVER PROGRAM_NUMBER
```

The course associates program number `100003` with NFS.

## RPC Troubleshooting Model

```text
Network Reachability
       ↓
RPC Service Registration
       ↓
Required RPC Program
       ↓
NFS / RPC Application
```

---

# Selected Port Testing with Nmap

The course demonstrates testing selected ports with Nmap.

A simple authorized TCP connect test can use:

```bash
nmap -sT -p PORT TARGET
```

`-sT` performs a TCP connect-style scan.

Use only approved lab targets.

The course also contains a combined Nmap command using several historical scan flags.

Nmap option support changes across versions.

Verify:

```bash
nmap --help
```

or the installed manual before copying older course syntax.

---

# Netcat

Netcat can create simple TCP or UDP connections and listeners.

The course introduces it as a network diagnosis tool.

## TCP Listener

General lab structure:

```bash
nc -l LOCAL_PORT
```

This creates a listener according to the installed Netcat implementation.

Use an unprivileged disposable lab port where possible.

## Verbose Listener

Some Netcat implementations support a form such as:

```bash
nc -lvp LOCAL_PORT
```

Option syntax can differ between Netcat variants.

Check:

```bash
nc -h
```

on the actual system.

## Remote TCP Port Test

The course uses:

```bash
nc -z -v SERVER 22
```

Conceptually:

```text
-z
→ Zero-I/O connectivity test

-v
→ Verbose
```

This is useful for answering:

```text
Can I establish TCP connectivity to this port?
```

## UDP

The course demonstrates:

```bash
nc -u SERVER PORT
```

UDP has no TCP-style connection establishment.

A lack of immediate error does not by itself prove that the remote UDP application is working.

Use protocol responses or packet capture for stronger evidence.

---

# Packet Capture with `tcpdump`

The course introduces packet capture as a lower-level troubleshooting method.

## Capture on an Interface

Use:

```bash
tcpdump -n -e -i INTERFACE
```

Options:

```text
-n
→ Do not perform name resolution

-e
→ Display link-layer header information

-i
→ Select interface
```

## Full Snapshot Length

The course uses:

```text
-s0
```

The slide describes this as header-only monitoring.

That description is incorrect for modern `tcpdump`.

```text
-s 0
→ Capture the packet at the maximum available snapshot length
```

This can include payload data.

Treat packet captures as potentially sensitive.

## Hex and ASCII Display

Use:

```text
-X
```

to display captured packet content in hexadecimal and ASCII representations.

Do not capture unrelated user traffic.

## BPF Filter Expression

The course provides a filter concept equivalent to:

```bash
sudo tcpdump -X -s0 \
  'src host SOURCE_ADDRESS and (tcp port 80 or icmp)'
```

Quote complex filter expressions so that the shell does not interpret parentheses.

## Exclude SSH Traffic

The course demonstrates:

```bash
sudo tcpdump -n -i INTERFACE 'not port 22'
```

This can prevent the current SSH management connection from dominating a remote packet capture.

## DNS and ICMP Capture

Example:

```bash
sudo tcpdump -n 'icmp or port 53'
```

This can help determine whether ICMP or DNS traffic is actually transmitted and received.

---

# Tshark

The course introduces `tshark`, the command-line Wireshark tool.

A capture can be written to a file with an ASCII hyphen option such as:

```bash
tshark -w CAPTURE_FILE
```

The course slide contains a typographic dash before `w`; actual shell options require:

```text
-
```

not a typographic dash.

Use capture formats supported by the installed Tshark version.

---

# HTTP Diagnostics

The course introduces:

```bash
elinks -dump URL
```

and:

```bash
curl URL
```

These operate at a higher application layer than packet-capture tools.

A useful workflow is:

```text
TCP Connectivity
      ↓
HTTP Request
      ↓
HTTP Response
```

If TCP connectivity works but `curl` fails at the application level, investigate the web service or application configuration.

---

# Link Diagnostics with `ethtool`

Use:

```bash
ethtool INTERFACE
```

to inspect Ethernet link information.

Possible information includes:

```text
Link detected
Speed
Duplex
Autonegotiation
Driver-related properties
```

Actual fields depend on the interface and environment.

---

# `mii-tool`

The course also introduces:

```bash
mii-tool INTERFACE
```

This is legacy Ethernet link-management knowledge.

Modern Linux troubleshooting generally prioritizes:

```bash
ethtool
```

---

# ARP Testing with `arping`

The course demonstrates:

```bash
arping -I INTERFACE TARGET_IPV4
```

`arping` uses ARP at the local link layer.

Conceptually:

```text
Target IPv4
     ↓
ARP Request
     ↓
Local Ethernet Segment
     ↓
ARP Reply
```

It is useful for local-link troubleshooting.

It does not trace a remote IP destination across routers.

---

# Layer-Based Tool Selection

| Layer / Question | Useful Tools |
|---|---|
| Interface / Physical Link | `ip link`, `ethtool` |
| Local Neighbor / ARP | `ip neigh`, `arping` |
| IPv4 Routing | `ip route`, `traceroute` |
| DNS | `dig`, `host`, `getent` |
| Listening Sockets | `ss`, `netstat`, `lsof` |
| Process / Open File | `lsof`, `fuser` |
| RPC / NFS | `rpcinfo` |
| TCP / UDP Connectivity | `nc` |
| Authorized Discovery | `nmap` |
| HTTP | `curl`, `elinks` |
| Packet Capture | `tcpdump`, `tshark` |

---

# SSH Failure Workflow

```text
Interface
   ↓
IP Address
   ↓
Neighbor / Gateway
   ↓
Route
   ↓
TCP Port 22
   ↓
sshd Listener
   ↓
sshd Service
   ↓
Authentication
```

Possible tools include:

```text
ip link
ip addr
ip neigh
ip route
traceroute
nc
ss
systemctl
journalctl
```

Use evidence from each layer before changing SSH configuration.

---

# DNS Failure Workflow

```text
Interface / Route
        ↓
DNS Server Reachability
        ↓
Packet Reaches DNS Server?
        ↓
Direct dig
        ↓
Resolver Configuration
        ↓
NSS
        ↓
Application
```

Possible tools:

```text
ip route
nc
tcpdump
dig
getent
```

---

# Web Failure Workflow

```text
Network Reachability
       ↓
TCP 80 / 443
       ↓
Listening Socket
       ↓
Firewall
       ↓
HTTP Request
       ↓
Application Response
```

Possible tools:

```text
traceroute
nc
ss
tcpdump
curl
```

---

# Packet Capture as Evidence

Packet capture can answer questions such as:

```text
Did the client send the request?

Did the packet reach this interface?

Did the server reply?

Did the reply leave the host?
```

Packet capture should be used to confirm hypotheses, not as a replacement for understanding the network topology.

---

# Incident Documentation

A useful troubleshooting record is:

```text
Symptom
→ What failed?

Evidence
→ What commands or packet evidence showed the failure?

Root Cause
→ Which layer and configuration caused it?

Resolution
→ What controlled change fixed it?

Verification
→ What proved that the service worked afterward?
```

Do not claim an incident was reproduced unless actual evidence was collected in the lab.

---

# Verification Checklist

- The network troubleshooting stack was understood.
- `traceroute` was reviewed.
- Missing traceroute responses were not automatically treated as failed routers.
- Legacy `route -n` was connected to modern `ip route`.
- DHCP logs were reviewed with `journalctl`.
- DNS troubleshooting tools were reviewed.
- `dig` and `getent` were distinguished.
- `netstat` course commands were reviewed.
- Modern `ss` and `ip -s link` alternatives were identified.
- Nmap was restricted to authorized lab targets.
- Historical `-sP` was mapped to modern `-sn`.
- Historical `-PN` was mapped to modern `-Pn`.
- Nmap OS detection was treated as an estimate.
- Network-scan snapshots were not treated as proof of a security incident.
- `lsof` was connected to open files and sockets.
- `fuser` was connected to filesystem users.
- Interface-down operations were treated as connectivity-sensitive changes.
- `ip neigh` was connected to ARP and local-link troubleshooting.
- RPC inspection was reviewed.
- Netcat TCP and UDP behavior was distinguished.
- `tcpdump` interface and filter concepts were reviewed.
- The course's incorrect `-s0` explanation was corrected.
- Complex BPF expressions were quoted for shell safety.
- SSH traffic exclusion during remote packet capture was reviewed.
- `tshark` was introduced.
- `curl` and `elinks` were connected to application-layer tests.
- `ethtool` was connected to physical/link diagnostics.
- `mii-tool` was recognized as legacy knowledge.
- `arping` was connected to local ARP testing.
- Lecture addresses and command outputs were not recorded as actual lab evidence.
- Troubleshooting evidence was organized using Symptom, Evidence, Root Cause, Resolution, and Verification.

## What I Learned

- Network troubleshooting is a process of narrowing the failing layer.
- Routing, DNS, sockets, services, and applications should be tested separately.
- A missing traceroute response does not automatically prove a routing failure.
- Modern Linux tools such as `ip`, `ss`, and `ip neigh` complement or replace older networking commands.
- DNS server behavior and Linux resolver behavior can be tested independently.
- Nmap can support authorized host and port diagnostics.
- `lsof` connects processes with open network sockets and files.
- Netcat is useful for simple TCP and UDP connectivity testing.
- Packet capture provides direct evidence of whether traffic enters or leaves an interface.
- `tcpdump -s0` captures the maximum packet length rather than headers only.
- ARP tools apply to the local network segment, while routing tools investigate remote paths.
- The best troubleshooting record explains the symptom, evidence, root cause, resolution, and final verification.
