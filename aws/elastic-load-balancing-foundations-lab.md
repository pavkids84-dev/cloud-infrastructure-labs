# AWS Elastic Load Balancing Foundations Lab

## Objective

Understand AWS Elastic Load Balancing, its major load balancer types, target health checks, listener and routing behavior, sticky sessions, cross-zone concepts, client IP forwarding, connection draining or deregistration delay, and the course multi-AZ web-server practice.

## Scope

```text
Elastic Load Balancing
ALB
NLB
GWLB
CLB
Listener
Target Group
Health Check
High Availability
Traffic Distribution
Sticky Session
Cross-Zone Load Balancing
X-Forwarded-For
Deregistration Delay
ACM
CloudWatch
Deletion Protection
Multi-AZ Web Servers
Troubleshooting
```

---

# Elastic Load Balancing

Elastic Load Balancing distributes incoming traffic across healthy targets.

Conceptually:

```text
Clients
   ↓
Load Balancer
   ↓
Target Group
├── Target A
├── Target B
└── Target C
```

Targets can exist across multiple Availability Zones when the architecture is configured that way.

---

# Why Load Balancing Matters

Load balancing supports:

```text
Traffic Distribution
High Availability
Failure Isolation
Horizontal Scaling
Maintenance
```

A load balancer should direct traffic only toward targets considered healthy.

---

# Load Balancer Types

The course introduces:

```text
Application Load Balancer
Network Load Balancer
Gateway Load Balancer
Classic Load Balancer
```

These solve different networking problems.

---

# Application Load Balancer

ALB operates at the application layer for protocols such as HTTP and HTTPS.

It supports routing decisions based on application-level request information.

Examples include:

```text
Host Header
URL Path
HTTP Header
HTTP Method
Query Parameters
Source IP Conditions
```

---

# ALB Routing

Conceptually:

```text
HTTP Request
     ↓
ALB Listener
     ↓
Listener Rule
     ↓
Target Group
     ↓
Application Target
```

This is useful for modern web and API architectures.

---

# TLS and ACM

The course connects ALB with AWS Certificate Manager.

Conceptually:

```text
Client HTTPS
      ↓
ALB
      ↓
ACM Certificate
      ↓
Target
```

Exact TLS termination and target-protocol design depend on application requirements.

---

# Network Load Balancer

NLB focuses on high-performance network transport and low-latency connection handling.

The course associates it with:

```text
TCP
UDP
TLS Context
Long-Lived Connections
Static Addressing Characteristics
```

NLB behavior is different from ALB's application-layer routing.

---

# NLB Addressing Clarification

The course contains simplified wording that can sound like an NLB has only one address.

A better model is that an NLB can provide addresses per enabled Availability Zone, with static addressing characteristics depending on configuration.

Do not generalize it as one global single IP for the entire load balancer.

---

# Gateway Load Balancer

GWLB is designed for transparent insertion and scaling of virtual network appliances.

Examples include:

```text
Firewalls
Inspection Appliances
Third-Party Security Appliances
```

Conceptually:

```text
Application Traffic
      ↓
GWLB / GWLBE
      ↓
Security Appliance Fleet
      ↓
Destination
```

---

# Classic Load Balancer

CLB is an older-generation Elastic Load Balancing option.

The course includes it for comparison.

For new architectures, the current supported load-balancer type that fits the protocol and application requirements should be evaluated rather than choosing CLB simply because it appears in older material.

---

# Health Checks

Load balancers use health checks to determine whether a target should receive traffic.

Conceptually:

```text
Target
   ↓
Health Check
   ↓
Healthy?
├── Yes → Receive Traffic
└── No  → Removed from Active Routing
```

A running EC2 instance is not automatically a healthy application target.

---

# Target Group

A target group is a logical collection of load-balancer destinations.

Examples can include supported targets such as:

```text
Instances
IP Addresses
Lambda Functions for Supported ALB Use Cases
```

The supported target type depends on the load balancer.

---

# Operational Metrics

The course connects ELB with CloudWatch metrics.

Useful metrics can include:

```text
Request Count
Errors
Latency
Active Flows
New Flows
Processed Bytes
```

The exact metric set depends on load balancer type.

---

# Deletion Protection

Deletion protection can reduce the risk of accidentally deleting an important load balancer.

It is an operational safety control, not a replacement for IAM permissions or change management.

---

# Hybrid and Container Integration

The course connects ELB with:

```text
EC2
ECS
EKS
Lambda
Hybrid Targets
Global Accelerator
```

The exact integration depends on load balancer type and architecture.

---

# Generic Load-Balancing Algorithms

The course introduces generic concepts such as:

```text
Round Robin
Weighted Round Robin
Least Connections
```

These are useful load-balancing concepts.

However, they should not be interpreted as a guarantee that every ELB type exposes all of these algorithms as directly configurable choices.

AWS load-balancer target-selection behavior depends on load balancer type and current feature set.

---

# Sticky Sessions

Sticky sessions attempt to keep a client associated with the same target for a period of time.

For HTTP load balancing, cookie-based stickiness can be used in supported scenarios.

Sticky sessions can simplify stateful applications but can also reduce even traffic distribution.

---

# Cross-Zone Load Balancing

Cross-zone load balancing affects how load-balancer nodes distribute traffic across targets in multiple Availability Zones.

The course uses a simplified example to show why uneven target counts between AZs can create uneven per-target load.

Defaults and behavior differ by load balancer type and have changed over time, so current configuration should always be verified.

---

# Client IP and X-Forwarded-For

For HTTP-based proxy load balancers, the original client IP can be conveyed through forwarding headers such as:

```text
X-Forwarded-For
```

Applications should understand when they are reading the proxy address versus the original client address.

---

# Connection Draining Context

The course uses the term:

```text
Connection Draining
```

for allowing existing requests or connections to finish before a target is fully removed.

In current target-group terminology, this concept is commonly associated with deregistration delay.

Conceptually:

```text
Target Scheduled for Removal
        ↓
Stop New Traffic
        ↓
Allow Existing Work to Drain
        ↓
Remove Target
```

---

# Multi-AZ Practice

The course creates an additional public subnet in a second Availability Zone and launches two web servers.

Conceptually:

```text
VPC
├── Public Subnet AZ A
│   └── Web Server 1
└── Public Subnet AZ B
    └── Web Server 2
```

This creates a better foundation for high availability than placing both servers in one AZ.

---

# Web Server Practice

The course installs and enables Apache HTTP Server on both EC2 instances.

Each instance serves distinguishable content so traffic distribution can be observed.

The exact package manager and AMI version are course examples.

---

# Target Group Practice

The course creates a target group and registers the two EC2 instances.

Conceptually:

```text
Target Group
├── Web Server 1
└── Web Server 2
```

Target health should be verified before interpreting traffic-distribution results.

---

# ALB Practice

The course creates an internet-facing Application Load Balancer across the selected public subnets and connects it to the target group.

Conceptually:

```text
Internet
   ↓
ALB
   ↓
Target Group
   ↓
Web Servers in Multiple AZs
```

---

# Failure Verification

The course stops one web server and checks target health and application behavior.

The reusable observation is:

```text
Target Fails
      ↓
Health Check Detects Failure
      ↓
Failed Target Removed from Active Routing
      ↓
Healthy Target Continues Serving
```

Actual timing depends on health-check settings.

---

# Round-Robin Observation Context

The course expects users to observe traffic reaching multiple web servers.

Browser caching, persistent HTTP connections, target-selection behavior, and load-balancer algorithms mean requests do not always have to alternate in a perfectly deterministic A-B-A-B sequence.

Treat the course result as an illustration of distributed traffic, not a strict packet-order guarantee.

---

# ELB Troubleshooting Workflow

A useful workflow is:

```text
Load Balancer Active?
      ↓
Correct Subnets / AZs?
      ↓
Listener Correct?
      ↓
Security Groups / Network Path?
      ↓
Target Group Correct?
      ↓
Targets Registered?
      ↓
Health Checks Passing?
      ↓
Application Listening?
      ↓
DNS Resolves?
      ↓
Client Receives Expected Response?
```

---

# High Availability Perspective

A load balancer alone does not make an application highly available.

A stronger design combines:

```text
Multiple Healthy Targets
Multiple Availability Zones
Correct Health Checks
Appropriate Scaling
Resilient Data Layer
```

The next course module introduces Auto Scaling, which connects directly to this design.

---

# Evidence Policy

Do not fabricate or publish:

```text
Load Balancer ARNs
Load Balancer DNS Names
Target Group ARNs
Instance IDs
Public IP Addresses
Security Group IDs
Health Check Results
CloudWatch Metrics
Actual Request Distribution
Browser Output
Billing Values
```

Actual evidence must come from an authorized AWS environment.

---

# Verification Checklist

- The major ELB types were distinguished.
- ALB was connected to application-layer routing.
- NLB was connected to high-performance transport-layer traffic.
- GWLB was connected to virtual appliances.
- CLB was recognized as older-generation context.
- Health checks were connected to target routing.
- Target groups were introduced.
- Generic load-balancing algorithms were not treated as universal ELB configuration options.
- Sticky sessions were introduced.
- Cross-zone behavior was treated as load-balancer-type dependent.
- X-Forwarded-For was connected to original client IP information.
- Connection draining was connected to deregistration delay.
- The course multi-AZ ALB practice was understood without fabricating evidence.

## What I Learned

- Elastic Load Balancing distributes traffic only when the entire listener, target, health, network, and application path is correctly configured.
- Multi-AZ targets improve failure tolerance.
- ALB, NLB, GWLB, and CLB solve different traffic-management problems.
- Load balancer health is application-aware only to the extent defined by configured health checks.
- ELB becomes more powerful when combined with Auto Scaling.
