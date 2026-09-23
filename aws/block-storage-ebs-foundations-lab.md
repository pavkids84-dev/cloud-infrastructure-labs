# AWS Block Storage and EBS Foundations Lab

## Objective

Understand AWS block storage, the difference between EC2 Instance Store and Amazon EBS, EBS snapshots and encryption, and the Linux steps required to make an attached volume usable.

## Scope

```text
Block Storage
EC2 Instance Store
Amazon EBS
EBS Volume Types
IOPS
Throughput
EBS Snapshots
EBS Encryption
Availability Zone Scope
Filesystem Creation
Mount / Unmount
Detach
Troubleshooting
```

## Block Storage

Block storage exposes storage as blocks to an operating system.

```text
Application
   ↓
Filesystem
   ↓
Block Device
```

It is commonly used for operating-system disks, databases, and transactional workloads.

## EC2 Instance Store

Instance Store provides temporary block storage physically attached to the host running the EC2 instance.

```text
Physical Host
   ↓
Instance Store
   ↓
EC2 Instance
```

Treat it as ephemeral storage. Data that must survive instance lifecycle changes should use an appropriate persistent service.

## Amazon EBS

Amazon Elastic Block Store provides persistent block storage for EC2.

Typical uses include:

```text
Root Volumes
Application Data
Database Storage
Persistent Filesystems
```

## Availability Zone Scope

An EBS volume belongs to one Availability Zone and normally attaches to EC2 instances in the same AZ.

```text
Availability Zone A
├── EC2 Instance
└── EBS Volume
```

## EBS Attachment

An EC2 instance can have multiple EBS volumes attached.

Do not assume every EBS volume can be mounted simultaneously by multiple EC2 instances. Multi-Attach exists only for supported volume types and configurations.

## EBS Volume Types

The course groups EBS performance broadly as:

```text
SSD
→ IOPS-oriented transactional workloads

HDD
→ Throughput-oriented streaming workloads
```

The correct volume type depends on workload I/O characteristics and cost requirements.

## IOPS vs Throughput

```text
IOPS
→ Number of I/O operations per second

Throughput
→ Amount of data transferred per unit time
```

Small random database I/O and large sequential streaming I/O can require different storage designs.

## EBS Snapshots

A snapshot represents a point-in-time backup of an EBS volume.

```text
EBS Volume
    ↓
Snapshot
    ↓
Restore New EBS Volume
```

Snapshots are incremental at the storage implementation level after the first snapshot, while each snapshot can represent a complete restore point.

## Snapshot Storage Context

The course explains that EBS snapshots use Amazon S3 infrastructure. Operationally, EBS snapshots are managed through the EBS snapshot service rather than as normal user-visible objects in a customer S3 bucket.

## EBS Encryption

EBS encryption can protect:

```text
Data at Rest
Data Between EC2 and EBS
Snapshots
Volumes Created from Encrypted Snapshots
```

Encrypted and unencrypted storage can be migrated through supported snapshot-copy and volume-creation workflows.

## Course Practice Workflow

```text
Create EBS Volume
      ↓
Attach to EC2
      ↓
Identify Block Device in Linux
      ↓
Create Filesystem
      ↓
Mount
      ↓
Verify
      ↓
Unmount
      ↓
Detach
```

## Device Name Mapping

The device name requested in the AWS console and the name visible inside Linux can differ depending on the virtualization and storage driver.

Always inspect the real block-device layout before formatting anything.

## Filesystem Safety

Before running a filesystem-creation command:

```text
Inspect Devices
      ↓
Identify the New Volume
      ↓
Confirm No Required Data Exists
      ↓
Create Filesystem
```

Formatting the wrong device can destroy data.

## Mount and Detach

Cloud attachment and Linux mounting are separate layers.

```text
AWS Attachment
      ↓
Linux Block Device
      ↓
Filesystem
      ↓
Mount Point
```

Before detaching a volume, stop application I/O and unmount the filesystem.

## Troubleshooting Workflow

```text
Volume Exists?
      ↓
Correct AZ?
      ↓
Attached to Correct Instance?
      ↓
Device Visible in Linux?
      ↓
Filesystem Present?
      ↓
Mounted?
      ↓
Permissions Correct?
      ↓
Application Using Correct Path?
```

## Evidence Policy

Do not fabricate or publish:

```text
Volume IDs
Snapshot IDs
Instance IDs
Availability Zones from Real Labs
Device Names from Real Labs
Filesystem UUIDs
Encryption Key IDs
Command Output
Billing Values
```

Actual evidence must come from an authorized AWS lab environment.

## What I Learned

- Instance Store is ephemeral block storage.
- EBS is persistent block storage for EC2 workloads.
- EBS volume state in AWS and filesystem state in Linux are separate layers.
- Storage troubleshooting requires both cloud and operating-system evidence.
