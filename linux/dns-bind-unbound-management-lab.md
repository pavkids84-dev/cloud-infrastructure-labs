# BIND and Unbound DNS Management Lab

## Objective

Understand basic DNS service administration on Rocky Linux using BIND for authoritative zone configuration and Unbound for caching and forwarding DNS resolution.

The goal is to connect DNS protocol fundamentals with Linux service configuration, zone files, forward and reverse lookup, zone-transfer restrictions, resolver caching, firewall access, and evidence-based troubleshooting.

## Environment

- OS: Rocky Linux lab environment
- Authoritative DNS Software: BIND
- BIND Configuration: `/etc/named.conf`
- BIND Zone Data: `/var/named/`
- Resolver Software: Unbound
- Unbound Configuration: `/etc/unbound/unbound.conf`
- Firewall: firewalld
- Service Manager: systemd

## BIND Overview

BIND stands for:

```text
Berkeley Internet Name Domain
```

The course introduces BIND as software implementing DNS server functionality.

Conceptually:

```text
DNS
→ Protocol / Naming System

BIND
→ DNS Server Software
```

This is similar to:

```text
HTTP
→ Protocol

Apache
→ HTTP Server Software
```

---

# Install BIND

The course uses:

```bash
dnf install -y bind
```

Package availability and versions must be verified in the current Rocky Linux environment.

Do not record course package versions as runtime evidence.

---

# BIND Data Directory

The course creates:

```bash
mkdir -p /var/named/data
```

The lab uses:

```text
/var/named/data
```

for custom zone data.

Actual ownership, permissions, and SELinux contexts must be verified in the current environment.

---

# Main BIND Configuration

The course uses:

```text
/etc/named.conf
```

This file defines BIND server behavior and DNS zones.

A simplified relationship is:

```text
/etc/named.conf
       ↓
Zone Definition
       ↓
Zone File
       ↓
Resource Records
```

---

# Root Hint Zone

The course shows a root hint definition similar to:

```text
zone "." IN {
    type hint;
    file "named.ca";
};
```

The root zone:

```text
.
```

represents the DNS namespace root.

The hint file contains information used to begin DNS hierarchy resolution.

---

# Authoritative Zone Definition

The course defines a zone such as:

```text
zone "example.com" {
    type master;
    file "data/named.example.com";
};
```

Conceptually:

```text
example.com
     ↓
Primary Zone
     ↓
/var/named/data/named.example.com
```

The course uses the historical BIND keyword:

```text
master
```

for the primary authoritative zone.

---

# Reverse Zone Definition

The course also defines reverse zones using:

```text
in-addr.arpa
```

Examples in the course include structures such as:

```text
0.100.10.in-addr.arpa
```

A reverse zone provides PTR records for IPv4 address-to-name resolution.

---

# Forward Lookup Zone File

The course creates:

```text
/var/named/data/named.example.com
```

The file contains resource records used for hostname-to-address resolution.

A simplified zone-file structure is:

```text
$TTL VALUE

@ IN SOA ...
  IN NS  ...
HOST IN A ADDRESS
```

Do not copy lecture hostnames, addresses, serial numbers, or outputs as actual lab evidence.

---

# Zone File Fields

The course introduces:

```text
TTL
Class
Type
Data
```

A common record structure is:

```text
NAME TTL CLASS TYPE DATA
```

Some fields can inherit defaults depending on zone-file context.

---

# TTL

TTL stands for:

```text
Time To Live
```

It controls DNS cache lifetime.

A cached record can be reused until its TTL expires.

---

# DNS Class

The course uses:

```text
IN
```

which represents the Internet DNS class.

---

# Resource Record Type

The course introduces resource-record types including:

```text
A
AAAA
PTR
CNAME
SOA
NS
MX
TXT
SRV
```

The type determines how the record data is interpreted.

---

# `@` Zone Origin

In a zone file:

```text
@
```

commonly represents the current zone origin.

For an `example.com` zone, it can conceptually refer to the current zone name.

---

# SOA Record

SOA stands for:

```text
Start of Authority
```

The course SOA example includes fields such as:

```text
Serial
Refresh
Retry
Expire
Negative TTL
```

These values are important for authoritative zone administration and secondary synchronization.

---

# SOA Serial

The Serial value identifies the zone-data version.

Conceptually:

```text
Zone Modified
      ↓
Serial Increased
      ↓
Secondary Can Detect Newer Version
```

Maintain a consistent serial-management convention in real environments.

---

# SOA Refresh

Refresh defines how frequently a secondary DNS server can check for updated zone information.

---

# SOA Retry

Retry defines how long a secondary waits before retrying after a failed refresh attempt.

---

# SOA Expire

Expire defines how long a secondary can continue using zone information when it cannot successfully refresh from the primary.

---

# Negative TTL

The negative TTL is associated with caching negative DNS responses such as non-existent names.

---

# SOA Administrative Mailbox Concept

The SOA record can contain a field such as:

```text
root.example.com.
```

which represents an administrative mailbox using DNS zone-file notation.

Conceptually:

```text
root.example.com.
→ root@example.com
```

The actual zone configuration should follow BIND syntax exactly.

---

# NS Record

The zone contains an NS record identifying the authoritative nameserver.

Conceptually:

```text
example.com
     ↓
NS
     ↓
server1.example.com
```

---

# A Record

An A record maps a hostname to an IPv4 address.

```text
server1 IN A ADDRESS
```

Actual addresses must come from the lab environment.

---

# Reverse Lookup Zone File

The course creates:

```text
/var/named/data/0.100.10.in-addr.arpa
```

for reverse lookup.

A reverse-zone record can use:

```text
PTR
```

to map an IPv4 address to a hostname.

---

# Reverse Lookup Example

Conceptually:

```text
10.100.0.254
       ↓
Reverse Zone
       ↓
254 IN PTR server1.example.com.
       ↓
server1.example.com
```

The exact reverse-zone name depends on the delegated IPv4 network.

---

# `$GENERATE`

The course demonstrates:

```text
$GENERATE 1-45 $ PTR station$.example.com.
```

This generates multiple similar PTR records.

Conceptually:

```text
1
→ station1.example.com

2
→ station2.example.com

...

45
→ station45.example.com
```

This reduces repetitive zone-file entries.

---

# Loopback Reverse Zone

The course also introduces a loopback reverse zone:

```text
0.0.127.in-addr.arpa
```

and a PTR relationship for:

```text
127.0.0.1
→ localhost
```

This is a reverse-DNS example for the loopback network.

---

# Zone Transfer

Authoritative DNS zone data can be transferred from a primary server to secondary servers.

Conceptually:

```text
Primary
   ↓
Zone Transfer
   ↓
Secondary
```

Zone transfer should be restricted to intended systems.

---

# Zone-Transfer Access Control

The course shows an `allow-transfer` example.

The slide syntax uses parentheses, but BIND access lists use braces.

Conceptual correct form:

```text
allow-transfer {
    SECONDARY_IP_1;
    SECONDARY_IP_2;
};
```

Use only verified authorized secondary DNS servers.

---

# Why Restrict Zone Transfer

An unrestricted zone transfer can expose large portions of internal DNS namespace information.

A safer model is:

```text
Primary DNS
      ↓
Authorized Secondary Only
```

Do not allow transfer merely to make troubleshooting easier.

---

# BIND Troubleshooting Model

When an authoritative DNS response is incorrect:

```text
named Service
      ↓
/etc/named.conf
      ↓
Correct Zone Defined?
      ↓
Correct Zone File?
      ↓
SOA / NS Records?
      ↓
A / AAAA / PTR Record?
      ↓
Client Query
```

Inspect evidence before restarting or rewriting the zone.

---

# Forward vs Reverse Troubleshooting

## Forward Lookup Failure

Inspect:

```text
Zone Name
A / AAAA Record
Authoritative Server
Zone File
```

## Reverse Lookup Failure

Inspect:

```text
Reverse Zone
in-addr.arpa
PTR Record
```

A working A record does not automatically imply that a PTR record exists.

---

# Unbound Overview

The course introduces Unbound as a caching DNS server.

The demonstrated configuration also forwards DNS queries to another resolver.

A more precise description of the course lab is therefore:

```text
Caching Resolver
+
Forwarding Resolver
```

---

# Install Unbound

The course uses:

```bash
yum install -y unbound
```

On Rocky Linux using DNF:

```bash
sudo dnf install -y unbound
```

---

# Start Unbound

The course uses:

```bash
systemctl start unbound
```

Verify:

```bash
systemctl status unbound
```

Do not fabricate service state, PID, or logs.

---

# Enable Unbound

The course uses:

```bash
systemctl enable unbound
```

Distinguish:

```text
start
→ Current runtime state

enable
→ Boot-time configuration
```

---

# Unbound Configuration

The course uses:

```text
/etc/unbound/unbound.conf
```

Important parameters introduced include:

```text
interface
access-control
domain-insecure
forward-zone
forward-addr
```

---

# `interface`

The course uses an IP address with:

```text
interface:
```

This controls the local interface or address where Unbound listens for DNS queries.

Use only actual interface addresses from the lab environment.

---

# `access-control`

The course uses a rule conceptually equivalent to:

```text
access-control: NETWORK allow
```

This determines which client network can query the resolver.

Conceptually:

```text
Client Network
      ↓
Access Control
      ↓
Allowed DNS Query
```

Do not expose a recursive resolver broadly without an explicit reason.

---

# `domain-insecure`

The course uses:

```text
domain-insecure:
```

to exclude a domain from DNSSEC validation.

This weakens validation for the selected domain and should be treated as an exception rather than a generic troubleshooting fix.

Do not disable DNSSEC validation simply to hide an unresolved DNSSEC problem.

---

# `forward-zone`

The course uses:

```text
forward-zone:
    name: "."
```

The root name:

```text
.
```

means that the forwarding rule applies broadly across the DNS namespace.

Conceptually:

```text
All Queries
    ↓
Unbound
    ↓
Configured Forwarder
```

---

# `forward-addr`

The course uses:

```text
forward-addr: UPSTREAM_DNS
```

This identifies the resolver to which Unbound forwards queries.

Do not record the lecture IP address as actual infrastructure configuration.

---

# Validate Unbound Configuration

The course uses:

```bash
unbound-checkconf
```

This should be performed before restarting the service after configuration changes.

Recommended workflow:

```text
Edit Configuration
       ↓
unbound-checkconf
       ↓
Restart Service
       ↓
Verify
```

---

# Restart Unbound

The course slide contains:

```text
systemctl restat unbound
```

This is a typo.

The intended command is:

```bash
sudo systemctl restart unbound
```

---

# Allow DNS Through firewalld

The course uses:

```bash
sudo firewall-cmd --permanent --add-service=dns
sudo firewall-cmd --reload
```

Verify the actual active zone and service configuration afterward.

---

# DNS Transport

DNS commonly uses:

```text
UDP 53
TCP 53
```

Do not assume that DNS operates only over UDP.

The firewalld `dns` service definition can manage the expected DNS service access.

---

# Test a Specific DNS Server

The course uses:

```bash
dig @DNS_SERVER_IP A server2.domain.com
```

General form:

```bash
dig @DNS_SERVER NAME TYPE
```

This queries a specific DNS server directly instead of relying only on the operating system's default resolver selection.

---

# Inspect Unbound Cache

The course uses:

```bash
unbound-control dump_cache
```

before and after a query.

Conceptually:

```text
Inspect Cache
      ↓
Perform Query
      ↓
Inspect Cache Again
      ↓
Observe Cached Result
```

Actual cache content must come from the current environment.

---

# Flush an Unbound Cache Entry

The course uses:

```bash
unbound-control flush NAME
```

This removes cached information associated with the specified name.

Conceptually:

```text
Cached Record
      ↓
Flush
      ↓
Removed
      ↓
Future Query Requires Resolution Again
```

---

# `unbound-control` Availability

`unbound-control` depends on the Unbound control interface being configured appropriately.

If it cannot connect, inspect:

```text
Unbound remote-control configuration
Control certificates / keys
Service state
Configuration validity
```

Do not fabricate successful `dump_cache` output when the control interface has not actually been configured.

---

# Runtime and Persistent DNS Layers

DNS administration again demonstrates the difference between configuration and runtime state.

```text
Configuration File
      ↓
Service Restart / Reload
      ↓
Runtime Service
      ↓
Client Query
```

A correct file on disk does not prove that the running process is using it successfully.

---

# DNS Service Troubleshooting

When clients cannot resolve names:

```text
Client Network
      ↓
Client Resolver Configuration
      ↓
Firewall
      ↓
DNS Service Listening?
      ↓
Server Configuration
      ↓
Zone / Forwarding Configuration
      ↓
Upstream Resolver
      ↓
Cache
```

Change one layer at a time.

---

# Authoritative DNS Troubleshooting

```text
Query Fails
   ↓
Is named running?
   ↓
Can client reach TCP/UDP 53?
   ↓
Is the zone loaded?
   ↓
Is the expected record present?
   ↓
Does the queried server have authority?
   ↓
Inspect logs / errors
```

---

# Resolver Troubleshooting

```text
Query Fails
   ↓
Is Unbound running?
   ↓
Is the client network allowed?
   ↓
Is the correct interface listening?
   ↓
Is the forwarder reachable?
   ↓
Does direct dig to forwarder work?
   ↓
Is DNSSEC validation involved?
   ↓
Inspect cache and logs
```

---

# Verification Checklist

- BIND was identified as DNS server software.
- `/etc/named.conf` was identified as the main BIND configuration file.
- Root hint configuration was reviewed.
- Primary authoritative zone configuration was reviewed.
- Forward zone files were understood.
- Reverse zones using `in-addr.arpa` were understood.
- TTL, class, type, and data were identified as zone-file concepts.
- SOA fields were reviewed.
- NS records were understood.
- A records were understood.
- PTR records were connected to reverse lookup.
- `$GENERATE` was introduced.
- Loopback reverse DNS was reviewed.
- Zone transfer was understood.
- `allow-transfer` was recognized as a zone-transfer restriction.
- The course's incorrect `allow-transfer` parenthesis syntax was corrected conceptually.
- Unbound was identified as a caching and forwarding resolver in the course example.
- `interface` was understood.
- `access-control` was understood.
- `domain-insecure` was treated as a security-sensitive exception.
- `forward-zone` and `forward-addr` were understood.
- `unbound-checkconf` was reviewed.
- The course `restat` typo was recognized as `restart`.
- firewalld DNS access was reviewed.
- DNS TCP and UDP transport were distinguished from the misconception that DNS uses only UDP.
- Direct testing with `dig @SERVER` was understood.
- Unbound cache inspection and flush concepts were reviewed.
- Lecture IP addresses, hostnames, zone serials, and command output were not recorded as actual runtime evidence.

---

# What I Learned

- BIND can provide authoritative DNS zone service on Linux.
- `/etc/named.conf` connects zone names to zone data files.
- Forward zones map hostnames to addresses.
- Reverse zones map IPv4 addresses to names with PTR records.
- SOA records contain essential zone-administration metadata.
- Zone transfers should be limited to authorized secondary servers.
- Unbound can provide caching and forwarding resolver functionality.
- Resolver access should be restricted to intended client networks.
- DNSSEC validation exceptions should not be used as generic fixes.
- DNS configuration should be validated before service restart.
- `dig @SERVER` is useful for isolating a specific DNS server from the system resolver path.
- Cache state can explain why clients continue seeing old DNS data.
- DNS troubleshooting should separate client configuration, network access, server service state, authoritative data, forwarding, and caching.
