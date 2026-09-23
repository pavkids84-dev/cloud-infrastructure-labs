# AWS EFS and Cloud Storage Comparison Lab

## Objective

Understand Amazon EFS as managed NFS file storage and compare the access models of EFS, S3, and EBS.

## Scope

```text
Amazon EFS
NFS
File Storage
Shared Filesystem
Multi-AZ Access
Elastic Capacity
EFS Storage Classes
Lifecycle Management
File System Policy
Hybrid Access
EFS vs S3 vs EBS
```

## Amazon EFS

Amazon Elastic File System provides managed network file storage based on NFS.

```text
EC2 Instance A ─┐
EC2 Instance B ─┼→ EFS Filesystem
EC2 Instance C ─┘
```

Multiple clients can access the same shared filesystem.

## File Storage

File storage exposes hierarchical filesystem semantics.

```text
Filesystem
├── directory-a/
│   └── file.txt
└── directory-b/
```

This differs from an EBS block device and an S3 object API.

## VPC and NFS Access

The course connects EFS with NFS v4 and VPC-based access.

```text
EC2
 ↓
VPC Network
 ↓
EFS
```

Network reachability and security controls therefore matter.

## Elastic Capacity

The course emphasizes that EFS can grow as data is added without pre-provisioning a fixed filesystem size like a traditional block volume.

## Multi-AZ Availability

The course presents EFS as a Regional service capable of storing data across multiple Availability Zones.

```text
Region
├── AZ A ─→ EFS Access
├── AZ B ─→ EFS Access
└── AZ C ─→ EFS Access
```

This differs from normal EBS volumes, which are AZ-scoped.

## EFS Storage Classes

The course introduces frequently accessed and infrequently accessed file-storage classes.

Lifecycle policies can move less frequently used files into lower-cost storage classes after a configured period.

## File System Policy

The course introduces EFS file-system policies as resource policies for controlling access.

Security can involve multiple layers:

```text
IAM / Resource Policy
Network Controls
Encryption in Transit
NFS / Linux Permissions
```

## Hybrid Access

The course connects EFS with hybrid access through services such as VPN or Direct Connect.

```text
On-Premises
      ↓
Hybrid Network
      ↓
AWS VPC
      ↓
EFS
```

## EFS vs S3 vs EBS

```text
EFS
→ File Storage

S3
→ Object Storage

EBS
→ Block Storage
```

This is the central architecture comparison in the Storage module.

## Access Model Comparison

```text
EBS
→ EC2 sees a block device

EFS
→ Client mounts a shared network filesystem

S3
→ Application calls an object API
```

## Typical Patterns

EBS:

```text
Root Disk
Database Volume
Application Filesystem
```

EFS:

```text
Shared Application Content
Home Directories
Shared File Workloads
```

S3:

```text
Backups
Static Assets
Media
Logs
Data Lakes
Artifacts
```

## Storage Selection Model

Start with:

```text
Does the workload need block, file, or object semantics?
```

Then evaluate:

```text
Sharing Requirement
Availability Scope
Latency
Throughput
IOPS
Durability
Access Pattern
Lifecycle
Cost
```

## Troubleshooting Perspective

For EFS:

```text
Filesystem Exists?
      ↓
Network Path?
      ↓
Security Controls?
      ↓
NFS Reachable?
      ↓
Mount Successful?
      ↓
Linux Permissions?
      ↓
Application Path?
```

## Evidence Policy

Do not fabricate or publish:

```text
EFS File System IDs
Mount Target IDs
Private IP Addresses
Security Group IDs
Real DNS Names
Mount Output
VPN / Direct Connect IDs
Billing Values
```

Actual evidence must come from an authorized AWS environment.

## What I Learned

- EBS provides block-device semantics.
- EFS provides shared file semantics.
- S3 provides object semantics.
- Storage architecture begins with workload access requirements rather than product-name memorization.
