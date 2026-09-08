# Cloud Infrastructure Labs

Hands-on infrastructure labs documenting my progress in Linux system administration, Bash scripting, troubleshooting, and cloud infrastructure fundamentals.

This repository focuses on learning infrastructure concepts through direct practice rather than command memorization.

The main workflow used throughout the repository is:

```text
Learn
  ↓
Practice
  ↓
Verify
  ↓
Troubleshoot
  ↓
Document
```

## Current Focus

The current focus is Linux infrastructure administration using Rocky Linux and Bash.

Topics covered so far include:

```text
Linux Fundamentals
        |
        v
Files and Permissions
        |
        v
Shell Environment
        |
        v
Text Processing
        |
        v
Bash Scripting
        |
        v
Processes and Services
        |
        v
Users and Packages
        |
        v
Time and Job Scheduling
        |
        v
Storage and Partitions
        |
        v
Filesystems
        |
        v
Logical Volume Management
```

## Environment

- OS: Rocky Linux
- Virtualization: VMware
- Shell: Bash
- Init System: systemd
- Package Management: RPM / DNF
- Primary Area: Linux Infrastructure
- Learning Style: Hands-on labs and troubleshooting

## Repository Structure

```text
cloud-infrastructure-labs/
├── README.md
└── linux/
    ├── README.md
    ├── file-directory-permission-lab.md
    ├── filesystem-management-lab.md
    ├── job-scheduling-lab.md
    ├── lvm-management-lab.md
    ├── package-management-lab.md
    ├── process-management-lab.md
    ├── search-archive-compression-lab.md
    ├── service-management-lab.md
    ├── shell-basics-lab.md
    ├── shell-environment-lab.md
    ├── ssh-basic-lab.md
    ├── storage-management-lab.md
    ├── system-information-lab.md
    ├── text-processing-lab.md
    ├── user-management-lab.md
    ├── vi-basic-lab.md
    └── shell-script/
        ├── README.md
        ├── args.sh
        ├── argument-for.sh
        ├── argument-loop.sh
        ├── basic.sh
        ├── compare-numbers.sh
        ├── execution-scope.sh
        ├── file-check.sh
        ├── function-basics.sh
        ├── process-arguments.sh
        ├── read-lines.sh
        ├── service-action.sh
        ├── shift.sh
        └── variables-and-expansion.sh
```

## Linux Infrastructure Labs

Detailed Linux lab documentation is available here:

[Linux Infrastructure Labs](./linux/README.md)

The Linux section currently covers four major areas.

### Linux Fundamentals

```text
System Information
File and Directory Permissions
vi Editor
Shell Basics
Shell Environment
Search and Archives
Text Processing
```

### Bash Automation

```text
Variables
Arguments
Positional Parameters
Exit Status
Conditions
File Tests
Loops
Input Processing
Functions
Execution Scope
```

### Linux Administration

```text
Processes
systemd Services
SSH
Package Management
Users and Groups
Time Synchronization
Job Scheduling
```

### Storage Administration

```text
Disk
  ↓
Partition
  ↓
LVM
  ↓
Filesystem
  ↓
Mount Point
```

The storage labs include:

```text
Block-device inspection
MBR and GPT
fdisk and parted
ext4 and XFS
Mount management
/etc/fstab
XFS repair
PV / VG / LV
LVM expansion
LVM shrinking
LVM snapshots
```

## Bash Shell Scripting

Bash scripting exercises are organized under:

```text
linux/shell-script/
```

Detailed documentation:

[Shell Script Labs](./linux/shell-script/README.md)

The scripting exercises progress from basic syntax to reusable administration logic.

```text
Basic Script
    ↓
Variables
    ↓
Arguments
    ↓
Conditions
    ↓
Loops
    ↓
File Processing
    ↓
Functions
    ↓
Process and Service Logic
```

## Troubleshooting Approach

The repository emphasizes troubleshooting as part of system administration.

The general process is:

```text
1. Identify the symptom
2. Inspect the current state
3. Collect evidence
4. Determine the affected layer
5. Apply a controlled change
6. Verify the result
```

Examples practiced in the labs include:

- Inspecting processes by PID and process name
- Distinguishing service runtime state from boot configuration
- Investigating package and repository state
- Inspecting package transaction history
- Checking account and group configuration
- Verifying scheduled-job services and system time
- Detecting newly attached disks
- Creating and verifying partitions
- Diagnosing filesystem mount failures
- Repairing a disposable XFS filesystem
- Extending LVM storage layer by layer
- Safely shrinking an ext filesystem and Logical Volume
- Creating an LVM snapshot for backup

## Verification-First Documentation

Commands are not considered complete simply because they execute without an obvious error.

Changes are followed by verification.

```text
Create
  ↓
Verify

Modify
  ↓
Verify

Stop
  ↓
Verify

Start
  ↓
Verify

Repair
  ↓
Verify
```

Examples include:

```bash
systemctl status
```

```bash
lsblk
```

```bash
df -hT
```

```bash
id
```

```bash
rpm -q
```

The exact verification command depends on the system layer being changed.

## Infrastructure Layer Awareness

A major goal of these labs is to understand which infrastructure layer is being modified.

For example:

```text
Physical Disk
      ↓
Partition
      ↓
Physical Volume
      ↓
Volume Group
      ↓
Logical Volume
      ↓
Filesystem
      ↓
Mount Point
```

A change at one layer does not automatically mean that every higher layer has changed.

The same principle applies to other Linux administration areas.

```text
Package
≠ Service
≠ Process
```

```text
User
≠ Group
≠ Permission
```

```text
Service Active State
≠ Service Boot Configuration
```

Understanding these boundaries helps make troubleshooting more systematic.

## Documentation Principles

### Hands-On First

Labs are based on direct practice in a Rocky Linux virtual machine.

### Verify Every Change

System state is checked after configuration changes.

### Do Not Fabricate Runtime Values

Values such as the following should come from the actual lab environment:

```text
PID
UID
GID
UUID
Disk names
Filesystem sizes
Package versions
Service states
Command output
```

### Use Disposable Resources for Destructive Labs

Potentially destructive commands are practiced only with dedicated lab resources.

Examples include:

```text
fdisk
parted
mkfs
dd
xfs_repair
pvcreate
lvreduce
```

### Understand Failures

Errors are documented when they help explain system behavior.

The goal is not only to make a command succeed, but to understand:

```text
Why did it fail?
What evidence showed the cause?
What layer was affected?
How was the issue corrected?
How was the recovery verified?
```

## Learning Direction

These Linux labs provide the operating-system foundation required for broader infrastructure and cloud engineering work.

The current progression is:

```text
Linux Administration
        ↓
Shell Automation
        ↓
Infrastructure Troubleshooting
        ↓
Storage and System Operations
```

The repository will continue to evolve as additional infrastructure topics are practiced and documented.
