# AWS Cloud Infrastructure Labs

This directory documents my AWS cloud infrastructure learning path.

The goal is to connect AWS services to the Linux, networking, Docker, and Kubernetes foundations already studied in this repository.

The focus is not only on console operations. Each topic should be understood through architecture, responsibility boundaries, networking, security, runtime behavior, troubleshooting, cost awareness, and reproducible configuration.

## Course Roadmap

```text
AWS Introduction
      ↓
Global Infrastructure
      ↓
Security / IAM
      ↓
Computing
      ↓
Storage
      ↓
Networking
      ↓
Auto Scaling
      ↓
CloudFormation
      ↓
Lambda
      ↓
Database
      ↓
Migration
```

## Directory Structure

```text
aws/
├── README.md
├── cloud-computing-foundations-lab.md
├── global-infrastructure-foundations-lab.md
├── iam-security-foundations-lab.md
├── ec2-compute-foundations-lab.md
├── block-storage-ebs-foundations-lab.md
├── s3-cloudfront-foundations-lab.md
└── efs-cloud-storage-comparison-lab.md
```

Additional files should be added only after the corresponding AWS topics are actually studied.

## 1. Cloud Computing Foundations

File:

```text
cloud-computing-foundations-lab.md
```

Current topics include:

```text
Cloud Computing
Scalability
Elasticity
On-Premises Capacity Planning
Disposable Infrastructure Mindset
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

## Cloud Computing Model

The course defines cloud computing as providing scalable and elastic IT-related capabilities as services through network technologies.

Conceptually:

```text
Network Access
      ↓
Shared / Abstracted Infrastructure
      ↓
On-Demand IT Resources
      ↓
Scalable and Elastic Services
```

## On-Premises vs Cloud

Traditional capacity planning often requires estimating infrastructure demand before the business workload actually runs.

```text
Expected Demand
      ↓
Capacity Estimation
      ↓
Hardware Purchase
      ↓
Installation
      ↓
Operation
```

Cloud computing changes this operating model by making infrastructure resources available on demand.

```text
Need Resource
      ↓
Provision
      ↓
Use
      ↓
Scale / Replace / Delete
```

This does not remove the need for architecture or capacity planning, but it changes how capacity can be acquired and adjusted.

## Virtualization

Virtualization abstracts physical computing components into logical resources.

Relevant resources include:

```text
CPU
Memory
Storage
Networking
GPU
```

Virtualization provides an important technical foundation for efficient infrastructure sharing and flexible resource allocation.

## Core Cloud Characteristics

The course introduces:

```text
On-Demand Self-Service
Broad Network Access
Resource Pooling
Rapid Elasticity
Measured Service
```

Resource pooling is connected to multi-tenancy.

Measured service is connected to usage-based billing.

Rapid elasticity is connected to scaling infrastructure according to changing business demand.

## Service Models

The course introduces three service models:

```text
IaaS
PaaS
SaaS
```

### IaaS

Infrastructure as a Service provides infrastructure building blocks such as:

```text
Compute
Networking
Storage
```

The customer keeps relatively high control over the operating-system and application layers.

### PaaS

Platform as a Service reduces responsibility for lower infrastructure and operating-system management so the customer can focus more on application development and application operation.

### SaaS

Software as a Service provides a completed application managed largely by the service provider.

The user primarily focuses on using the software rather than maintaining the underlying platform.

## Responsibility Boundary

The important difference among IaaS, PaaS, and SaaS is not only the product category.

It is also:

```text
Which layers do I manage?
Which layers does the provider manage?
```

As the service model moves from IaaS toward SaaS, more underlying infrastructure and platform responsibility shifts toward the provider.

## Deployment Models

The course introduces:

```text
Public Cloud
Hybrid Cloud
Private Cloud
```

### Public Cloud

Applications and infrastructure resources are deployed in a public cloud provider environment.

### Hybrid Cloud

Cloud resources are connected with resources outside the cloud, commonly existing on-premises infrastructure.

Conceptually:

```text
On-Premises
      ↕
Network Connectivity
      ↕
Public Cloud
```

### Private Cloud

Private cloud refers to cloud-style resource management and virtualization deployed for a dedicated organization, commonly in an on-premises or dedicated environment.

## 2. Global Infrastructure Foundations

File:

```text
global-infrastructure-foundations-lab.md
```

Current topics include:

```text
AWS Global Infrastructure
Region
Availability Zone
Region Selection
Multi-AZ Design
Edge Location
CloudFront
Outposts
AWS Management Console
AWS CLI
AWS SDK
CloudFormation
Infrastructure as Code
```

Core hierarchy:

```text
AWS Global Infrastructure
        ↓
Regions
        ↓
Availability Zones
        ↓
Data Centers
```

Additional infrastructure extends AWS toward users and customer facilities:

```text
Edge Locations
Outposts
```

AWS access methods introduced by the course are:

```text
Management Console
CLI
SDK
CloudFormation
```

These should be understood as different interfaces and automation layers over AWS service APIs.

## 3. IAM and Security Foundations

File:

```text
iam-security-foundations-lab.md
```

Current topics include:

```text
Shared Responsibility Model
Security OF the Cloud
Security IN the Cloud
IAM
Root User
IAM User
IAM Group
IAM Policy
IAM Role
MFA
AWS Organizations
Organizational Units
Service Control Policies
Least Privilege
AWS Security Services
```

Core IAM model:

```text
Principal
   ↓
Authentication
   ↓
Permissions
   ↓
AWS API Action
   ↓
AWS Resource
```

AWS Organizations adds a higher-level multi-account governance layer:

```text
Organization
   ↓
OU
   ↓
Accounts
   ↓
SCP Guardrails
```

SCPs should be understood as permission boundaries and not as direct permission grants.

## 4. EC2 Compute Foundations

File:

```text
ec2-compute-foundations-lab.md
```

Current topics include:

```text
EC2
Virtual Machines
Hypervisor
Multi-Tenancy
AMI
AWS Marketplace
Instance Families
Pricing Models
Instance Lifecycle
Elastic IP
Key Pair
Windows RDP
Linux SSH
AMI Backup
Cross-Region AMI Copy
```

Core compute model:

```text
AMI
 ↓
EC2 Instance
 ↓
Operating System
 ↓
Application
```

Instance selection should be driven by workload characteristics:

```text
CPU
Memory
Storage I/O
Networking
Accelerators
```

EC2 access and troubleshooting also depend on:

```text
Credentials
Security Groups
Network Paths
Operating-System Services
```

## 5. Storage Foundations

Files:

```text
block-storage-ebs-foundations-lab.md
s3-cloudfront-foundations-lab.md
efs-cloud-storage-comparison-lab.md
```

The module introduces three fundamental storage models:

```text
Block → EBS / Instance Store
Object → S3
File → EFS
```

Current topics include EBS volumes and snapshots, S3 storage classes and lifecycle, CloudFront caching, and EFS shared file storage.

A useful selection model is:

```text
Required Access Semantics
      ↓
Block / File / Object
      ↓
Sharing / Availability / Performance / Lifecycle / Cost
```

## Relationship to Previous Study

AWS concepts build directly on previous repository topics.

```text
Linux
→ Operating systems and server administration

Networking
→ IP addressing, routing, DNS, firewalls, packet flow

Docker
→ Images, containers, immutable infrastructure concepts

Kubernetes
→ Desired state, orchestration, services, security

AWS
→ Managed cloud infrastructure and services
```

## Troubleshooting Perspective

Cloud troubleshooting should still follow the same evidence-based method used in earlier study areas.

```text
Symptom
   ↓
Evidence
   ↓
Responsible Layer
   ↓
Root Cause
   ↓
Resolution
   ↓
Verification
```

Do not assume that a cloud-managed service removes the need to identify the responsible layer.

## Security Perspective

Cloud service models change responsibility boundaries, but they do not eliminate customer security responsibility.

Security topics become more detailed later in the IAM module.

For now, remember:

```text
Managed Service
!=
No Customer Responsibility
```

## Cost Perspective

Measured service and pay-as-you-go pricing make resource usage part of operational design.

Provisioning resources can create cost.

Deleting, stopping, resizing, or scaling resources can therefore be operational as well as financial decisions.

Exact billing behavior depends on the AWS service and pricing model and should be verified when those services are studied.

## Evidence Policy

Do not fabricate:

```text
AWS Account IDs
Access Keys
Secret Access Keys
Session Tokens
ARNs
Resource IDs
Public IP Addresses
Private IP Addresses
Regions Used in Actual Labs
Availability Zones Used in Actual Labs
Billing Values
Console Screenshots
CLI Output
API Responses
```

Course screenshots and sample values are educational references only.

Actual evidence must come from an authorized AWS account and lab environment.

## Current Learning Progress

Completed:

```text
PDF p.1-p.88
Module 1: Amazon Web Services Introduction
Module 2: Global Infrastructure
Module 3: Security (IAM)
Module 4: Computing
Module 5: Storage
```

Next:

```text
Module 6: Network
Starting at p.89
```

## What This Directory Demonstrates

This directory will document progression from cloud fundamentals toward practical AWS infrastructure operation.

```text
Cloud Concepts
      ↓
Global Infrastructure
      ↓
Identity and Security
      ↓
Compute
      ↓
Storage
      ↓
Networking
      ↓
Scaling
      ↓
Infrastructure as Code
      ↓
Serverless
      ↓
Data Services
      ↓
Migration
```
