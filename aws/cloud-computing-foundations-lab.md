# AWS Cloud Computing Foundations Lab

## Objective

Understand the cloud-computing concepts introduced in the AWS course before studying individual AWS services.

This lab focuses on the operating model behind cloud infrastructure: scalability, elasticity, virtualization, shared resources, usage-based consumption, service models, and deployment models.

## Scope

```text
Cloud Computing
Scalability
Elasticity
On-Premises
Capacity Planning
Virtualization
On-Demand Self-Service
Broad Network Access
Resource Pooling
Multi-Tenancy
Rapid Elasticity
Measured Service
IaaS
PaaS
SaaS
Public Cloud
Hybrid Cloud
Private Cloud
```

---

# Cloud Computing

The course defines cloud computing as a style of computing in which scalable and elastic IT-related capabilities are provided as services through network technologies.

Conceptually:

```text
Network
   ↓
Cloud Provider Infrastructure
   ↓
IT Resources as Services
   ↓
Customer Workloads
```

Two important properties are:

```text
Scalability
Elasticity
```

---

# Scalability

Scalability is the ability to support increased or decreased workload demand by changing available capacity.

Conceptually:

```text
Workload Demand Changes
        ↓
Capacity Changes
```

Scaling can involve compute, memory, storage, network capacity, or higher-level managed services.

---

# Elasticity

Elasticity emphasizes adjusting resource capacity according to changing demand.

Conceptually:

```text
Demand Increases
→ Add Capacity

Demand Decreases
→ Release Capacity
```

Elasticity is especially important in cloud operating models because resources can often be provisioned and removed more quickly than traditional hardware procurement allows.

---

# Traditional On-Premises Capacity Planning

The course contrasts cloud computing with traditional on-premises infrastructure.

A traditional model often requires estimating capacity before workload demand is fully known.

```text
Expected Business Demand
        ↓
Estimate CPU / Memory / Storage / Network
        ↓
Purchase Infrastructure
        ↓
Install Infrastructure
        ↓
Run Workload
```

A bad estimate can lead to:

```text
Too Little Capacity
→ Performance or availability problems
```

or:

```text
Too Much Capacity
→ Underused infrastructure
```

---

# Cloud Provisioning Model

The course describes AWS cloud resources such as servers, databases, storage, and higher-level applications as resources that can be started quickly and treated as temporary or replaceable when appropriate.

Conceptually:

```text
Need Resource
      ↓
Provision
      ↓
Use
      ↓
Change / Replace / Delete
```

This operating model is different from treating each server as a long-lived physical asset that must be preserved indefinitely.

---

# Disposable Infrastructure Mindset

The course introduces the idea that cloud resources can be treated as temporary and removable.

This connects directly to concepts already studied in Docker and Kubernetes.

```text
Traditional Server
→ Preserve individual machine
```

```text
Cloud / Container Infrastructure
→ Recreate from definition when practical
```

This does not mean every resource should be deleted casually.

Persistent data, identity, configuration, and dependency relationships still require deliberate design.

---

# Virtualization

The course defines virtualization as abstracting physical hardware components into logical objects.

Virtualized resources can include:

```text
CPU
Memory
Storage
Networking
GPU
```

Conceptually:

```text
Physical Hardware
      ↓
Virtualization Layer
      ↓
Logical Compute Resources
```

Virtualization allows physical infrastructure to be divided and managed more flexibly.

---

# Virtualization and Resource Utilization

One goal of virtualization is improved infrastructure utilization.

Instead of dedicating one complete physical server to one workload:

```text
Physical Server
└── Single Workload
```

virtualization can support:

```text
Physical Server
├── Virtual Machine A
├── Virtual Machine B
└── Virtual Machine C
```

while maintaining logical isolation between workloads.

---

# On-Demand Self-Service

The course introduces on-demand self-service as a major cloud characteristic.

Conceptually:

```text
User Needs Resource
      ↓
Online Request
      ↓
Resource Provisioning
```

The customer does not need to wait for a traditional manual hardware-procurement cycle for every infrastructure request.

---

# Broad Network Access

Cloud resources are accessed through network technologies.

Conceptually:

```text
User / Application
       ↓
Network
       ↓
Cloud Service
```

This makes networking knowledge fundamental to cloud engineering.

DNS, routing, IP addressing, ports, encryption, and access-control concepts remain important.

---

# Resource Pooling

Cloud providers pool infrastructure resources and allocate them to customers as required.

Conceptually:

```text
Provider Resource Pool
      ↓
Logical Allocation
      ↓
Multiple Customers / Workloads
```

The physical implementation is abstracted from the customer.

---

# Multi-Tenancy

The course connects resource pooling with multi-tenancy.

Conceptually:

```text
Shared Provider Infrastructure
        ↓
Multiple Isolated Customers
```

Multi-tenancy does not mean customers should be able to access each other's resources.

Logical isolation and provider security controls are essential to the model.

---

# Rapid Elasticity

The course describes rapid elasticity as using computing resources flexibly according to business conditions.

Conceptually:

```text
Business Demand
      ↓
Resource Demand
      ↓
Scale Capacity
```

This becomes more concrete later when AWS Auto Scaling is studied.

---

# Measured Service

Measured service connects resource consumption to usage measurement.

Conceptually:

```text
Resource Usage
      ↓
Measurement
      ↓
Billing / Cost Visibility
```

This supports:

```text
Pay Per Use
Pay As You Go
```

Cost therefore becomes part of infrastructure operations.

---

# Cloud Service Models

The course introduces:

```text
IaaS
PaaS
SaaS
```

The main distinction is the responsibility boundary between the customer and the provider.

---

# IaaS

Infrastructure as a Service provides basic infrastructure capabilities.

Typical categories include:

```text
Compute
Networking
Storage
```

The customer retains a relatively high level of infrastructure control.

Conceptually:

```text
Provider
→ Physical Infrastructure / Virtualization

Customer
→ Operating System / Runtime / Applications / Data
```

The exact responsibility boundary depends on the service.

---

# PaaS

Platform as a Service reduces the amount of lower-level infrastructure management required from the customer.

Conceptually:

```text
Provider
→ Infrastructure + More Platform Management

Customer
→ Application + Application Data
```

This allows teams to focus more heavily on application development and operation.

---

# SaaS

Software as a Service provides a completed software product managed largely by the provider.

Conceptually:

```text
Provider
→ Application Platform and Infrastructure

Customer
→ Uses the Application
```

The customer does not normally manage the underlying operating system, runtime, or physical infrastructure.

---

# Service Model Responsibility Boundary

The p.13 diagram illustrates how management responsibility shifts from the customer toward the provider as the service model moves from infrastructure toward software.

Conceptually:

```text
More Customer Control
IaaS
 ↓
PaaS
 ↓
SaaS
More Provider Management
```

This is one of the most useful ways to distinguish the three service models.

---

# Public Cloud

The course describes public-cloud deployment as running cloud-based applications in the provider cloud environment.

Conceptually:

```text
Application
      ↓
Public Cloud Infrastructure
```

Applications can be created directly in the cloud or migrated from existing infrastructure.

---

# Hybrid Cloud

Hybrid deployment connects cloud resources with resources that remain outside the cloud.

Conceptually:

```text
On-Premises Infrastructure
          ↕
      Connectivity
          ↕
     Cloud Resources
```

Hybrid design becomes especially important later when VPN, Direct Connect, migration, and hybrid services are studied.

---

# Private Cloud

The course describes private cloud as deploying resources through virtualization and resource-management tools for a dedicated organization, often in an on-premises environment.

Conceptually:

```text
Dedicated Infrastructure
        ↓
Virtualization
        ↓
Cloud-Like Resource Management
```

A private cloud can provide dedicated-resource control while adopting some cloud operating principles.

---

# Public vs Hybrid vs Private

The simplest conceptual comparison is:

```text
Public
→ Workloads primarily in public cloud
```

```text
Hybrid
→ Public cloud connected with existing non-cloud / on-premises resources
```

```text
Private
→ Dedicated cloud-style environment for one organization
```

The correct model depends on technical, regulatory, operational, and business requirements.

---

# Relationship to Linux

Cloud virtual machines still run operating systems.

Previous Linux skills remain directly relevant:

```text
Processes
systemd
Users and Permissions
SSH
Storage
Filesystems
Logs
Firewall
Networking
```

Cloud infrastructure changes how servers are provisioned, not the fundamentals of operating-system behavior.

---

# Relationship to Networking

Cloud computing depends heavily on networking.

Relevant previous topics include:

```text
IPv4 / IPv6
Subnetting
Routing
DNS
TCP / UDP
Ports
Firewalls
Packet Analysis
```

These concepts become essential when AWS VPC is studied later.

---

# Relationship to Docker and Kubernetes

The course's temporary and replaceable infrastructure model connects naturally to container and orchestration concepts.

```text
Docker Image
→ Reproducible Container Definition
```

```text
Kubernetes Manifest
→ Reproducible Desired State
```

```text
Cloud Infrastructure
→ Reproducible and Replaceable Resource Design
```

These are related operational ideas, even though the technologies and resource lifecycles differ.

---

# Troubleshooting Perspective

Cloud services add provider-managed layers, but troubleshooting still requires identifying the responsible layer.

Example:

```text
Application Unreachable
      ↓
Application?
Operating System?
Cloud Compute?
Network?
Security Control?
Managed Service?
Provider Platform?
```

Do not assume that every failure inside a cloud environment is an AWS platform failure.

---

# Cost Perspective

Cloud resources can be created quickly, which also means cost can be created quickly.

A useful operational habit is:

```text
Provision
      ↓
Verify
      ↓
Use
      ↓
Stop / Delete When No Longer Needed
      ↓
Verify Cleanup
```

Exact pricing behavior should be checked for each AWS service when that service is studied.

---

# Evidence Policy

Course screenshots and example values are educational references.

Do not fabricate:

```text
AWS Account IDs
Access Keys
Secret Access Keys
Session Tokens
Resource IDs
ARNs
Regions Used in Actual Labs
Availability Zones Used in Actual Labs
IP Addresses
Console Results
CLI Output
Billing Values
```

Actual evidence must come from an authorized AWS environment.

---

# Verification Checklist

- Cloud computing was connected to scalable and elastic IT services.
- Traditional on-premises capacity planning was distinguished from cloud provisioning.
- Temporary and replaceable cloud-resource thinking was introduced.
- Virtualization was connected to logical abstraction of physical resources.
- On-demand self-service was understood.
- Broad network access was connected to cloud-resource connectivity.
- Resource pooling and multi-tenancy were introduced.
- Rapid elasticity was distinguished from static capacity.
- Measured service was connected to usage-based consumption.
- IaaS, PaaS, and SaaS were distinguished by responsibility boundaries.
- Public, hybrid, and private deployment models were distinguished.
- Previous Linux, networking, Docker, and Kubernetes knowledge was connected to AWS study.
- Course examples were not treated as actual AWS evidence.

## What I Learned

- Cloud computing changes infrastructure from a hardware-procurement model toward an on-demand service-consumption model.
- Scalability and elasticity are central properties of cloud infrastructure.
- Virtualization provides an important abstraction layer between physical hardware and logical compute resources.
- Cloud resources can often be provisioned, replaced, scaled, and removed more dynamically than traditional servers.
- IaaS, PaaS, and SaaS mainly differ in how management responsibility is divided between customer and provider.
- Public, hybrid, and private cloud models describe different deployment and connectivity approaches.
- Cloud engineering still depends on Linux, networking, security, troubleshooting, and cost-management fundamentals.
