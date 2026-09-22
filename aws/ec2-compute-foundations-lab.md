# AWS EC2 Compute Foundations Lab

## Objective

Understand Amazon EC2 as an AWS compute service built on virtualization, and connect AMIs, instance types, pricing models, instance lifecycle states, Elastic IPs, key pairs, Windows and Linux access methods, and AMI-based recovery workflows.

## Scope

```text
Amazon EC2
Virtual Machines
Hypervisor
Multi-Tenancy
AMI
AWS Marketplace
Instance Types
General Purpose
Compute Optimized
Memory Optimized
Accelerated Computing
Storage Optimized
On-Demand
Reserved Instances
Savings Plans
Spot Instances
Dedicated Hosts
Instance States
Elastic IP
Key Pair
RDP
SSH
Windows EC2
Linux EC2
AMI Backup
Cross-Region AMI Copy
```

---

# EC2 as a Virtual Machine Service

Amazon EC2 provides virtual machine capacity in AWS.

Conceptually:

```text
AWS Physical Server
      ↓
Hypervisor
      ↓
EC2 Virtual Machines
```

Multiple EC2 instances can share underlying physical infrastructure while remaining logically isolated.

---

# Multi-Tenancy

The course connects EC2 with multi-tenancy.

Conceptually:

```text
Physical Host
├── EC2 Instance A
├── EC2 Instance B
└── EC2 Instance C
```

AWS manages the virtualization layer and isolation between virtual machines.

---

# EC2 and Cloud Operating Model

EC2 removes the need for customers to build and operate physical data-center infrastructure for each server.

Conceptually:

```text
Need Compute
   ↓
Choose Configuration
   ↓
Launch EC2
   ↓
Run Workload
   ↓
Stop / Terminate When Appropriate
```

This connects directly to the on-demand cloud model introduced earlier.

---

# EC2 Instance

An EC2 instance is a virtual server running in AWS.

The instance runs until it is stopped, hibernated where supported, terminated, or fails.

The exact lifecycle and billing behavior depends on the instance state, operating system, storage, and related AWS resources.

---

# AMI

An Amazon Machine Image, or AMI, is a template used to launch EC2 instances.

An AMI can include:

```text
Operating System
Application Server
Applications
Configuration
```

Conceptually:

```text
AMI
 ↓
Launch
 ↓
EC2 Instance
```

One AMI can be used to launch multiple instances.

---

# AMI and Replaceable Infrastructure

The course emphasizes that a failed instance can be replaced by launching another instance from an AMI.

Conceptually:

```text
Instance Failure
      ↓
Known AMI
      ↓
Launch Replacement Instance
```

This connects to the replaceable-infrastructure mindset already studied with containers and Kubernetes.

---

# AWS Marketplace

AWS Marketplace provides third-party software products designed to run on AWS.

The course connects Marketplace with:

```text
Third-Party Software
Prebuilt Solutions
Commercial Licensing
Free Trials
On-Demand Options
Bring Your Own License Context
```

Marketplace products can simplify software deployment, but licensing, cost, trust, maintenance, and security should still be reviewed.

---

# EC2 Instance Types

EC2 instance types define combinations of infrastructure resources such as:

```text
Compute
Memory
Networking
Storage Capabilities
Accelerators
```

Instance families are optimized for different workload profiles.

---

# General Purpose

General-purpose instances balance multiple resource dimensions.

Typical use cases introduced by the course include:

```text
Web Servers
Code Repositories
General Application Servers
```

---

# Compute Optimized

Compute-optimized instances are intended for CPU-intensive workloads.

The course gives examples such as:

```text
Batch Processing
Media Transcoding
High-Performance Web Servers
HPC
Scientific Modeling
Game Servers
Machine Learning Inference
```

---

# Memory Optimized

Memory-optimized instances are intended for workloads that process large in-memory data sets.

Examples can include:

```text
High-Performance Databases
Large In-Memory Workloads
Real-Time Data Processing
```

---

# Accelerated Computing

Accelerated-computing instances use hardware accelerators or coprocessors for selected workloads.

Examples include:

```text
Graphics
Game Streaming
Application Streaming
Specialized Computation
```

---

# Storage Optimized

Storage-optimized instances are intended for workloads that require high local storage throughput or I/O performance.

The course associates them with:

```text
Distributed File Systems
Data Warehousing
High-Frequency OLTP Context
Large Data Sets
```

---

# Choosing an Instance Type

A useful decision model is:

```text
Workload Characteristics
      ↓
CPU Requirement?
Memory Requirement?
Storage I/O Requirement?
Network Requirement?
Accelerator Requirement?
      ↓
Instance Family
      ↓
Instance Size
```

Do not choose an instance type only by price or only by vCPU count.

---

# EC2 Pricing Models

The course introduces:

```text
On-Demand Instances
Reserved Instances
Savings Plans
Spot Instances
Dedicated Hosts
```

These pricing options represent different tradeoffs among flexibility, commitment, interruption tolerance, and hardware isolation.

---

# On-Demand

On-Demand pricing does not require a long-term commitment.

Conceptually:

```text
Use Compute
      ↓
Pay for Usage
```

It is suitable for workloads that need flexibility or have uncertain duration.

---

# Reserved Instance Context

The course presents Reserved Instances as a long-term commitment model associated with lower effective pricing.

The exact discount, capacity reservation behavior, regional or zonal options, and purchase model should be verified against current AWS pricing documentation before production use.

---

# Savings Plans

Savings Plans exchange a usage commitment for discounted compute pricing.

Conceptually:

```text
Long-Term Compute Commitment
        ↓
Discounted Eligible Usage
```

The course also connects Savings Plans with other AWS compute services such as Fargate and Lambda.

---

# Spot Instances

Spot Instances use spare EC2 capacity and can be interrupted when AWS needs that capacity back.

Conceptually:

```text
Lower Cost Potential
      ↕
Interruption Risk
```

Suitable workloads must tolerate interruption or be able to resume safely.

---

# Dedicated Hosts

Dedicated Hosts provide physical servers dedicated to one customer.

They are relevant for requirements such as:

```text
Dedicated Hardware
Licensing Constraints
Compliance
Host-Level Visibility
```

They should not be chosen unless the workload has a reason to require that model.

---

# Pricing Is Time-Sensitive

Course percentages and pricing statements are educational examples.

Actual pricing changes over time and can vary by:

```text
Region
Instance Type
Operating System
Purchase Model
Commitment Term
Resource Configuration
```

Always verify current pricing before making cost decisions.

---

# EC2 Instance Lifecycle

The course introduces lifecycle states such as:

```text
Pending
Running
Stopping
Shutting-Down
Terminated
```

A simplified lifecycle is:

```text
Launch
  ↓
Pending
  ↓
Running
  ↓
Stop or Terminate
```

State changes affect resource availability and can affect billing.

---

# Stop vs Terminate

These operations are fundamentally different.

```text
Stop
→ Instance can later be started again
```

```text
Terminate
→ Instance is deleted
```

Persistent storage behavior depends on volume configuration and delete-on-termination settings.

---

# Billing and Lifecycle

The course associates running compute with EC2 compute charges and stopped or terminated states with no instance compute charge.

However, related resources can still incur cost.

Examples can include:

```text
EBS Volumes
Elastic IP / Public IPv4 Usage
Snapshots
Data Transfer
Other Attached Services
```

Always evaluate the entire resource set rather than only instance state.

---

# Elastic IP

An Elastic IP is a static public IPv4 address resource that can be associated with supported AWS resources.

Conceptually:

```text
Elastic IP
    ↓
Network Interface / EC2
```

It is different from automatically assigned public IP behavior.

---

# Elastic IP Use Case

A static address can be useful when an endpoint must keep a consistent public IP.

However, static public IPv4 use should be deliberate because public addressing has cost, security, and architecture implications.

---

# Key Pair

The course introduces EC2 key pairs for instance access.

For Linux instances, the reusable security concept is public-key authentication:

```text
Public Key
→ Stored for the EC2 login account

Private Key
→ Kept by the user
```

The private key should never be committed to Git.

---

# Key Pair Security

Do not publish:

```text
.pem Files
.ppk Files
Private Keys
Decrypted Windows Administrator Passwords
```

If a private key is lost, recovery options depend on the operating system, instance configuration, and other access mechanisms.

---

# Linux Login User

The default SSH login name depends on the AMI.

The course uses:

```text
ec2-user
```

for Amazon Linux.

Do not assume every Linux AMI uses the same username.

---

# Windows EC2 Practice

The course practice launches a Windows Server instance in the Seoul Region.

The workflow includes:

```text
Select Windows AMI
Choose Instance Type
Review Storage
Add Tags
Configure Security Group
Create / Use Key Pair
Launch Instance
Connect Through RDP
```

The specific AMI version and instance type shown by the course are examples and can become outdated.

---

# Windows Password Recovery Context

The course demonstrates using the EC2 key pair to obtain the Windows administrator password for RDP access.

This should be treated as a sensitive credential workflow.

Do not store decrypted passwords or private keys in repository evidence.

---

# Windows Disk Management Practice

The course then opens Windows Disk Management and brings an additional disk online, initializes it, creates a simple volume, and verifies the new drive.

This connects EC2 storage with operating-system disk administration.

Detailed storage behavior is studied in the next module.

---

# Linux EC2 Practice

The course launches an Amazon Linux instance and reuses the existing EC2 key pair.

The conceptual workflow is:

```text
Choose Linux AMI
      ↓
Choose Instance Type
      ↓
Configure Storage
      ↓
Configure Tags
      ↓
Configure Security Group
      ↓
Select Key Pair
      ↓
Launch
```

---

# PuTTY Conversion Workflow

The course converts a PEM private key into PPK format with PuTTYgen before connecting through PuTTY.

This is a Windows-tool-specific access workflow.

The reusable concept is:

```text
SSH Client
      +
Compatible Private Key Format
      ↓
Linux EC2 Access
```

Do not treat PuTTY conversion as an AWS requirement for every operating system or SSH client.

---

# Linux Verification

The course logs in as `ec2-user` and creates a directory and file to verify that the instance is usable.

Conceptually:

```text
SSH Login
   ↓
Create Test Directory
   ↓
Create Verification File
```

Actual command output should come from the user's own EC2 lab if documented as evidence.

---

# AMI Backup Practice

The course creates an AMI from a Linux EC2 instance.

Conceptually:

```text
Configured EC2 Instance
        ↓
Create Image
        ↓
AMI
        ↓
Future Instance Launch
```

This demonstrates how an instance configuration can be captured for later reuse.

---

# AMI Copy Across Regions

The course also copies an AMI to another Region.

Conceptually:

```text
AMI in Region A
      ↓
Copy
      ↓
AMI in Region B
```

This introduces the idea that AMIs are regional resources and can be copied when required.

---

# Backup vs Reproducible Build

An AMI image can support recovery and cloning, but it should not automatically replace configuration-as-code or build automation.

A useful distinction is:

```text
Image Backup
→ Capture an instance state
```

```text
Automated Build
→ Recreate infrastructure and configuration from definitions
```

Both can be useful for different goals.

---

# Troubleshooting Perspective

For an EC2 connectivity problem:

```text
Instance Running?
      ↓
Correct Public / Private Address?
      ↓
Security Group?
      ↓
Network Route?
      ↓
Key Pair / Credential?
      ↓
Correct OS Username?
      ↓
SSH / RDP Service?
      ↓
Operating System Firewall?
```

This preserves the layered troubleshooting method used throughout the repository.

---

# EC2 and Linux Relationship

An EC2 Linux instance is still a Linux system.

Previous Linux skills remain directly relevant:

```text
Users
Permissions
SSH
Processes
systemd
Storage
Filesystems
Logs
Firewall
Networking
```

AWS changes how the server is provisioned and integrated with cloud infrastructure, not the underlying operating-system fundamentals.

---

# EC2 and Networking Relationship

EC2 connectivity depends on cloud and operating-system networking.

Relevant concepts include:

```text
Private IP
Public IP
Elastic IP
Security Groups
Subnets
Routes
Internet Connectivity
SSH
RDP
```

VPC networking is studied later in the course.

---

# Evidence Policy

Do not fabricate or publish:

```text
AWS Account IDs
Instance IDs
AMI IDs
Public IP Addresses
Private IP Addresses
Elastic IP Addresses
Key Pair Private Files
Windows Administrator Passwords
Security Group IDs
Real Resource Names
Real Region / AZ Results
CLI Output
RDP Screenshots
SSH Output
Billing Values
```

Course screenshots and example values are educational references only.

Actual evidence must come from an authorized AWS lab environment.

---

# Verification Checklist

- EC2 was understood as virtual machine compute on AWS-managed physical infrastructure.
- Hypervisor and multi-tenancy concepts were connected to EC2.
- AMIs were understood as instance templates.
- AWS Marketplace was introduced.
- Instance families were connected to workload characteristics.
- Major EC2 pricing models were introduced.
- Course pricing numbers were treated as time-sensitive.
- EC2 lifecycle states were introduced.
- Stop and terminate were distinguished.
- Elastic IP was distinguished from ordinary public IP behavior.
- Key-pair access was connected to public-key authentication.
- Linux AMI usernames were treated as image-specific.
- Windows RDP and Linux SSH workflows were introduced.
- The PuTTY PEM-to-PPK workflow was recognized as tool-specific.
- AMI creation was connected to image-based recovery.
- Cross-Region AMI copy was introduced.
- Course credentials and resource identifiers were not treated as actual lab evidence.

## What I Learned

- EC2 provides flexible virtual machine compute in AWS.
- AMIs allow repeatable instance launches and image-based recovery.
- Instance types should be chosen according to workload characteristics.
- EC2 pricing models trade flexibility, commitment, interruption tolerance, and isolation.
- Instance state and related resources both matter for cost.
- Secure remote access depends on correct credentials, network controls, and operating-system configuration.
- EC2 troubleshooting still relies on Linux and networking fundamentals.
