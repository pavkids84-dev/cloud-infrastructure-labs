# AWS Route 53 DNS Foundations Lab

## Objective

Understand Amazon Route 53 as an AWS DNS service, including domain registration context, DNS records, health checks, routing policies, Alias records, and the difference between DNS routing decisions and network packet routing.

## Scope

```text
Amazon Route 53
DNS
Hosted Zone
Records
Health Checks
Simple Routing
Weighted Routing
Latency-Based Routing
Failover Routing
Geolocation Routing
Geoproximity Routing
Multi-Value Answer
Alias Record
AWS Resource Targets
DNS Troubleshooting
```

---

# Amazon Route 53

Route 53 is an AWS DNS service.

The course connects it with:

```text
Domain Registration
DNS Routing
Health Checks
```

Conceptually:

```text
Client
   ↓
DNS Query
   ↓
Route 53
   ↓
DNS Answer
   ↓
Application Endpoint
```

---

# DNS Routing Is Not Packet Routing

Route 53 answers DNS queries.

It does not replace VPC route tables.

Conceptually:

```text
Route 53
→ Name to Endpoint Decision
```

```text
VPC Route Table
→ Packet Forwarding Decision
```

These operate at different layers.

---

# Domain Registration

Route 53 can register supported domain names.

Domain-registration pricing and provisioning time are time-sensitive.

Do not memorize the course's example price or completion time as a permanent AWS value.

---

# Hosted DNS Records

Route 53 records can direct names toward endpoints such as:

```text
IP Addresses
Domain Names
Selected AWS Resources
```

The exact record type depends on the target and DNS design.

---

# Simple Routing

Simple routing returns configured values for a DNS name.

If multiple values are configured, multiple answers may be returned.

It should not be treated as health-aware failover unless health-check behavior is explicitly configured through an appropriate routing policy.

---

# Weighted Routing

Weighted routing distributes DNS responses according to configured weights.

Conceptually:

```text
One DNS Name
├── Endpoint A → Weight
└── Endpoint B → Weight
```

This can support controlled traffic shifting and migration patterns.

---

# Latency-Based Routing

Latency-based routing selects the configured AWS endpoint that Route 53 considers to provide lower network latency for the requester.

This is a DNS-level decision rather than a guarantee that every request always experiences the lowest possible application response time.

---

# Failover Routing

Failover routing supports primary and secondary endpoint patterns.

Conceptually:

```text
Primary Healthy?
   ├── Yes → Primary
   └── No  → Secondary
```

Health checks are important to the failover decision.

---

# Geolocation Routing

Geolocation routing selects a configured response based on the geographic origin of the DNS query.

It should not be simplified as automatically choosing the physically nearest AWS Region.

The administrator defines the geographic mapping.

---

# Geoproximity Routing

Geoproximity routing uses resource and client geography with traffic-flow policy behavior.

It can shift traffic among geographic resources according to configured bias and routing design.

---

# Multi-Value Answer

Multi-value answer routing can return multiple healthy records.

It provides DNS-level multi-value responses with optional health checking.

It is not the same thing as a full application load balancer.

---

# Health Checks

Route 53 health checks can influence supported routing policies.

Conceptually:

```text
Endpoint Health
      ↓
Route 53 Health Check
      ↓
DNS Response Decision
```

DNS caching means failover behavior is also affected by DNS TTL and resolver behavior.

---

# Alias Records

Route 53 Alias records can point DNS names at supported AWS resources.

Targets introduced by the course include:

```text
CloudFront Distribution
Elastic Load Balancer
S3 Website Endpoint
Elastic Beanstalk
VPC Interface Endpoint
Another Route 53 Record in the Hosted Zone
```

---

# Alias Is Not Simply CNAME

The course compares Alias with CNAME for conceptual convenience.

However, an Alias record is a Route 53-specific feature and is not literally the same DNS record type as CNAME.

One important architectural advantage is that Alias can be used in scenarios where a normal CNAME record would not be suitable, including supported zone-apex targets.

---

# Route 53 and Load Balancing

Route 53 routing and ELB can be combined.

Conceptually:

```text
DNS Name
   ↓
Route 53
   ↓
Load Balancer
   ↓
Application Targets
```

Route 53 decides which endpoint name or address to return, while ELB distributes application traffic to targets.

---

# DNS Troubleshooting

A useful workflow is:

```text
Correct Hosted Zone?
      ↓
Correct Record Name?
      ↓
Correct Record Type?
      ↓
Correct Target?
      ↓
Routing Policy?
      ↓
Health Check?
      ↓
TTL / DNS Cache?
      ↓
Application Endpoint Healthy?
```

DNS success does not prove that the application itself is healthy.

---

# Evidence Policy

Do not fabricate or publish:

```text
Registered Domain Names from Private Accounts
Hosted Zone IDs
Record IDs
Health Check IDs
Private Application Endpoints
Real DNS Query Output
Account-Specific Pricing
CLI Output
```

Actual evidence must come from an authorized AWS environment.

---

# Verification Checklist

- Route 53 was understood as DNS rather than VPC packet routing.
- Domain registration, DNS routing, and health checks were introduced.
- Simple, weighted, latency, failover, geolocation, geoproximity, and multi-value policies were distinguished.
- Geolocation was not simplified as nearest-Region routing.
- Alias records were distinguished from normal CNAME records.
- DNS TTL and health state were connected to failover behavior.
- Course pricing statements were treated as time-sensitive.

## What I Learned

- DNS routing policy determines which endpoint clients discover.
- Route 53 can combine health checks with DNS decisions.
- Route 53 and ELB operate at different layers and can be used together.
- Alias records provide AWS-specific DNS integration with supported resources.
