# DNS Fundamentals Lab

## Objective

Understand Domain Name System fundamentals, hierarchical DNS namespaces, domains and zones, client name resolution, DNS server roles, common resource-record types, forward and reverse lookup, and DNS troubleshooting concepts.

The goal is to understand how human-readable names are resolved into network addresses and how DNS distributes naming information across a hierarchical infrastructure.

## Scope

This lab covers:

```text
DNS
FQDN
Name Resolution
/etc/hosts Concept
DNS Namespace
Root Domain
Top-Level Domains
Domains
Zones
Recursive Resolution
Iterative Resolution
DNS Resolver
DNS Server Types
DNS Client Tools
DNS Resource Records
Forward Lookup
Reverse Lookup
TTL
SOA
Zone Transfer Concepts
```

---

# DNS Overview

DNS stands for:

```text
Domain Name System
```

The course introduces name resolution primarily as:

```text
Hostname / FQDN
        ↓
IPv4 or IPv6 Address
```

DNS allows applications to use names instead of manually entering IP addresses.

Conceptually:

```text
Application
    ↓
Hostname
    ↓
DNS Resolution
    ↓
IP Address
    ↓
Network Communication
```

---

# FQDN

FQDN stands for:

```text
Fully Qualified Domain Name
```

A fully qualified DNS name can conceptually include the root:

```text
www.example.com.
```

The final:

```text
.
```

represents the DNS root.

In ordinary application use, the trailing dot is often omitted.

---

# Local Name Mapping

The course identifies:

```text
/etc/hosts
```

as another name-resolution source.

Conceptually:

```text
/etc/hosts
→ Local static hostname-to-address mapping

DNS
→ Distributed network name service
```

These mechanisms should not be treated as the same service.

---

# Name Service Source Order

Linux can determine which name sources are used through configuration such as:

```text
/etc/nsswitch.conf
```

The course shows the conceptual host lookup order:

```text
hosts: files dns
```

This can be interpreted as:

```text
Hostname Lookup
      ↓
Local Files
      ↓
DNS
```

The actual configuration must be inspected on the current system.

---

# DNS Namespace

DNS uses a hierarchical namespace.

A simplified structure is:

```text
             .
          Root
            |
       +----+----+
       |         |
      com        kr
       |
    example
       |
      www
```

Names are organized from the DNS root downward.

---

# Root Domain

The top of the DNS namespace is:

```text
.
```

This is the root domain.

Top-level domains exist directly beneath it.

---

# Top-Level Domains

Examples include:

```text
com
org
net
edu
kr
jp
```

These are Top-Level Domains, commonly abbreviated as:

```text
TLD
```

---

# Hierarchical Name Example

A name such as:

```text
www.example.com.
```

can be read from right to left:

```text
.
↓
com
↓
example
↓
www
```

This hierarchy allows DNS administration and resolution to be distributed.

---

# Domain

A domain represents a portion of the DNS namespace.

Conceptually:

```text
example.com
```

can contain:

```text
www.example.com
mail.example.com
server1.example.com
```

and additional subdomains.

---

# Zone

A zone represents the portion of DNS namespace for which a DNS server has administrative authority.

A simplified distinction is:

```text
Domain
→ Namespace concept

Zone
→ DNS administrative / authoritative data boundary
```

A domain and a zone can correspond closely, but they are not always identical because DNS authority can be delegated.

---

# Delegation Concept

A parent domain can delegate responsibility for a child domain to another DNS server.

Conceptually:

```text
example.com
    |
    +-- Managed by DNS Server A
    |
    +-- dev.example.com
            |
            +-- Delegated to DNS Server B
```

This can create separate DNS zones inside a larger domain namespace.

---

# DNS Client Resolution

The course illustrates a client using a local DNS name server to resolve an external name.

A simplified path is:

```text
Client
   ↓
Local DNS Resolver
   ↓
Root DNS
   ↓
TLD DNS
   ↓
Authoritative DNS
   ↓
Answer
   ↓
Client
```

---

# Recursive Resolver

A client commonly sends its query to a configured resolver.

Conceptually:

```text
Client
  |
  | Resolve this name for me
  v
Recursive Resolver
```

The resolver performs or delegates the required DNS lookup and returns the result.

---

# Recursive and Iterative Resolution

A useful conceptual model is:

```text
Client
   ↓ Recursive Query
Resolver
   ↓
Root Server
   ↓ Referral
TLD Server
   ↓ Referral
Authoritative Server
   ↓ Final Answer
Resolver
   ↓
Client
```

The exact behavior can depend on resolver and DNS-server configuration.

---

# Resolver Configuration

The course introduces:

```text
/etc/resolv.conf
```

with directives such as:

```text
search
nameserver
```

---

# `nameserver`

The `nameserver` directive identifies a DNS resolver that the client can query.

Conceptually:

```text
Client
   ↓
Configured Nameserver
   ↓
DNS Resolution
```

Do not copy the course DNS server address as actual environment configuration.

---

# `search`

The `search` directive defines domain suffixes that can be tried for incomplete hostnames.

Conceptually:

```text
Input
server1

Search Domain
example.com

Possible Candidate
server1.example.com
```

The exact resolver behavior depends on the current system configuration.

---

# DNS Server Roles

The course introduces:

```text
Root Servers
Primary Servers
Secondary Servers
Caching-Only Servers
Forwarding Servers
```

---

# Root DNS Servers

Root DNS servers provide the top-level starting point for DNS hierarchy resolution.

Conceptually:

```text
Resolver
    ↓
Root
    ↓
Which DNS servers know about this TLD?
```

The course states that there are `13` root servers.

This should be interpreted as the thirteen named root-server identities:

```text
A through M
```

rather than only thirteen physical machines worldwide.

---

# Primary DNS Server

The course uses the historical term:

```text
Primary / Master
```

A primary DNS server maintains the authoritative source data for a zone.

Conceptually:

```text
Zone Data
   ↓
Primary DNS
```

---

# Secondary DNS Server

The course uses the historical term:

```text
Secondary / Slave
```

A secondary DNS server can obtain zone data from a primary DNS server.

Conceptually:

```text
Primary
   ↓
Zone Transfer
   ↓
Secondary
```

Modern terminology commonly uses:

```text
Primary
Secondary
```

---

# Caching Resolver

A caching DNS server stores query results temporarily.

```text
Client Query
      ↓
Resolver
      ↓
External Resolution
      ↓
Answer
      ↓
Cache
```

Later queries can use cached information while its TTL remains valid.

---

# Forwarding Resolver

A forwarding DNS server sends queries to another configured DNS resolver.

Conceptually:

```text
Internal Client
      ↓
Internal Resolver
      ↓
Configured Forwarder
      ↓
External DNS Infrastructure
```

This allows an organization to centralize upstream DNS resolution.

---

# Forward-Only Concept

The course demonstrates a configuration equivalent to:

```text
forward only
```

Conceptually:

```text
Query
  ↓
Configured Forwarder
  ↓
Use Forwarder's Answer
```

The resolver does not fall back to performing its own full iterative lookup when operating in strict forward-only behavior.

---

# DNS Client Tools

The course introduces:

```text
nslookup
dig
host
getent
```

These tools can be used for different name-resolution investigations.

---

# `nslookup`

`nslookup` can perform DNS queries and request specific resource-record types.

Conceptually:

```bash
nslookup HOSTNAME
```

The course demonstrates querying NS records interactively.

---

# `dig`

`dig` provides detailed DNS query information.

General examples include:

```bash
dig example.com A
```

```bash
dig example.com NS
```

```bash
dig example.com MX
```

A specific DNS server can be queried with:

```bash
dig @DNS_SERVER example.com A
```

Use only authorized lab servers.

---

# `host`

`host` provides concise name and address lookup functionality.

General form:

```bash
host HOSTNAME
```

---

# `getent`

`getent` can use the Linux Name Service Switch configuration.

Example:

```bash
getent hosts HOSTNAME
```

This makes it useful for checking the result as seen through the operating system's configured name-resolution path.

---

# `dig` vs `getent`

A useful troubleshooting distinction is:

```text
dig
→ Direct DNS query behavior
```

```text
getent
→ Operating-system name-service behavior
```

For example:

```text
dig succeeds
getent fails
```

can suggest that the DNS server itself is responding while the operating-system resolver path requires further inspection.

---

# DNS Resource Records

The course introduces resource-record types including:

```text
A
AAAA
CNAME
MX
NS
PTR
SOA
TXT
SRV
```

Different records store different kinds of DNS information.

---

# A Record

```text
A
→ Hostname to IPv4 address
```

Conceptually:

```text
server1.example.com
        ↓
IPv4 Address
```

---

# AAAA Record

```text
AAAA
→ Hostname to IPv6 address
```

A useful distinction is:

```text
A
→ IPv4

AAAA
→ IPv6
```

---

# CNAME Record

```text
CNAME
→ Canonical-name alias
```

Conceptually:

```text
www.example.com
       ↓
web01.example.com
```

---

# MX Record

```text
MX
→ Mail Exchange
```

It identifies mail-handling systems for a domain.

---

# NS Record

```text
NS
→ Name Server
```

It identifies authoritative DNS servers associated with a zone.

---

# PTR Record

```text
PTR
→ Reverse DNS lookup
```

Conceptually:

```text
IP Address
   ↓
PTR
   ↓
Hostname
```

---

# SOA Record

SOA stands for:

```text
Start of Authority
```

It contains core authority and management information for a DNS zone.

Typical SOA data includes:

```text
Serial
Refresh
Retry
Expire
Negative TTL
```

---

# Forward Lookup

Forward lookup resolves:

```text
Hostname
    ↓
A / AAAA
    ↓
IP Address
```

This is the most common hostname-resolution direction.

---

# Reverse Lookup

Reverse lookup resolves:

```text
IP Address
    ↓
PTR
    ↓
Hostname
```

IPv4 reverse DNS uses the:

```text
in-addr.arpa
```

namespace.

---

# Reverse DNS Naming

An IPv4 network is represented in reverse-octet order.

Conceptually:

```text
10.100.0.0/24
```

corresponds to a reverse zone such as:

```text
0.100.10.in-addr.arpa
```

The exact reverse-zone boundary depends on the delegated network prefix.

---

# TTL

TTL stands for:

```text
Time To Live
```

It controls how long DNS information can remain cached.

Conceptually:

```text
DNS Response
    ↓
Cache
    ↓
TTL
    ↓
Expiration
    ↓
New Query Required
```

---

# DNS Class

The course introduces the common DNS class:

```text
IN
```

which means:

```text
Internet
```

Resource records commonly appear in structures such as:

```text
NAME IN TYPE DATA
```

---

# SOA Timing Fields

A simplified interpretation is:

```text
Serial
→ Zone version

Refresh
→ Secondary check interval

Retry
→ Retry interval after failure

Expire
→ Maximum period before stale secondary data expires

Negative TTL
→ Negative-answer caching behavior
```

---

# Zone Transfer

Zone transfer allows DNS zone data to be replicated between authoritative servers.

Conceptually:

```text
Primary
   ↓
Zone Transfer
   ↓
Authorized Secondary
```

Zone transfer should be restricted to systems that legitimately require the zone data.

---

# DNS Troubleshooting Model

When hostname resolution fails:

```text
Network Connectivity
       ↓
Name-Service Source Order
       ↓
Resolver Configuration
       ↓
DNS Server Reachability
       ↓
DNS Query
       ↓
Zone / Record
       ↓
Cache
```

Do not restart the DNS server before identifying which layer is actually failing.

---

# Troubleshooting by Symptom

## IP Works, Hostname Fails

```text
IP Connectivity
→ Working

Name Resolution
→ Failing
```

Investigate:

```text
/etc/nsswitch.conf
/etc/resolv.conf
DNS Server
DNS Record
```

## Direct DNS Query Works, System Lookup Fails

```text
dig @DNS_SERVER
→ Works

getent hosts
→ Fails
```

Investigate the operating-system resolver configuration.

## Forward Lookup Fails

Investigate:

```text
A / AAAA Record
Authoritative Zone
Zone Configuration
```

## Reverse Lookup Fails

Investigate:

```text
PTR Record
Reverse Zone
in-addr.arpa
```

---

# Verification Checklist

- DNS was understood as a distributed name-resolution system.
- FQDN was understood.
- `/etc/hosts` was distinguished from DNS.
- `/etc/nsswitch.conf` was connected to name-service source order.
- The DNS root was identified.
- TLDs were identified.
- Domains and zones were distinguished.
- Delegation was understood conceptually.
- Recursive resolution was reviewed.
- Iterative referrals were reviewed.
- `/etc/resolv.conf` was understood.
- `search` and `nameserver` were distinguished.
- Root DNS server identity terminology was clarified.
- Primary and secondary server roles were reviewed.
- Caching and forwarding resolvers were distinguished.
- `nslookup`, `dig`, `host`, and `getent` were introduced.
- A and AAAA records were distinguished.
- CNAME, MX, NS, PTR, and SOA records were reviewed.
- Forward and reverse lookup were distinguished.
- TTL was understood as a cache-lifetime concept.
- Zone transfer was understood conceptually.
- Course server addresses and command output were not treated as actual runtime evidence.

---

# What I Learned

- DNS maps human-readable names to network addressing information.
- DNS uses a hierarchical and distributed namespace.
- A domain and a DNS zone are related but not always identical.
- Linux name resolution can involve both local files and DNS.
- Recursive resolvers obtain answers on behalf of clients.
- DNS hierarchy uses root, TLD, and authoritative servers.
- DNS caching reduces repeated lookup work.
- Forwarding resolvers send queries to configured upstream servers.
- Different DNS resource records store different kinds of information.
- Forward lookup uses records such as A and AAAA.
- Reverse IPv4 lookup uses PTR records under `in-addr.arpa`.
- DNS troubleshooting should separate network connectivity, resolver configuration, server behavior, authoritative data, and caching.
