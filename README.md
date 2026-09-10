# Cloud Infrastructure Labs

Hands-on infrastructure labs documenting my progress in Linux system administration, Bash automation, troubleshooting, system security, networking, and cloud infrastructure fundamentals.

This repository focuses on understanding infrastructure through direct practice rather than command memorization.

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

The labs have progressed from Linux fundamentals into system operations, storage, recovery, observability, security, and networking.

```text
Linux Fundamentals
        ↓
Shell and Bash Automation
        ↓
Processes and Services
        ↓
Users, Packages, and Scheduling
        ↓
Storage and Filesystems
        ↓
LVM and RAID
        ↓
Memory and Swap
        ↓
Boot and Kernel
        ↓
Backup and Recovery
        ↓
Logging and Troubleshooting
        ↓
Firewall and SELinux
        ↓
Network Administration
```

## Environment

- OS: Rocky Linux
- Virtualization: VMware
- Shell: Bash
- Init System: systemd
- Package Management: RPM / DNF
- Network Management: NetworkManager / nmcli
- Firewall Management: firewalld
- Security: SELinux
- Primary Area: Linux Infrastructure
- Learning Style: Hands-on labs, verification, and troubleshooting

## Repository Structure

```text
cloud-infrastructure-labs/
├── README.md
└── linux/
    ├── README.md
    ├── backup-recovery-lab.md
    ├── boot-kernel-management-lab.md
    ├── file-directory-permission-lab.md
    ├── filesystem-management-lab.md
    ├── firewall-management-lab.md
    ├── job-scheduling-lab.md
    ├── log-management-lab.md
    ├── lvm-management-lab.md
    ├── memory-swap-management-lab.md
    ├── network-management-lab.md
    ├── package-management-lab.md
    ├── process-management-lab.md
    ├── raid-management-lab.md
    ├── search-archive-compression-lab.md
    ├── selinux-management-lab.md
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

The Linux labs currently cover the following major areas.

### Linux Fundamentals

```text
System Information
Files and Directories
Permissions
vi Editor
Shell Fundamentals
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
Process and Service Logic
```

Detailed Bash documentation:

[Shell Script Labs](./linux/shell-script/README.md)

### System Administration

```text
Process Management
systemd Services
SSH Fundamentals
Package Management
User and Group Management
Time Synchronization
Job Scheduling
```

### Storage Administration

```text
Disk
  ↓
Partition
  ↓
RAID / LVM
  ↓
Filesystem
  ↓
Mount Point
  ↓
Data
```

Topics include:

```text
Block-device inspection
SCSI rescanning
MBR and GPT
fdisk and parted
ext4 and XFS
Mount management
/etc/fstab
XFS repair
PV / VG / LV
LVM expansion and shrinking
LVM snapshots
Software RAID
RAID failure and rebuild
```

### System Operations and Recovery

```text
Memory and Swap
Boot Process
GRUB2
Kernel Management
Kernel Parameters
Kernel Modules
Backup and Restore
rsync
```

### Logging and Observability

```text
rsyslog
systemd-journald
journalctl
Log Filtering
Persistent Journals
logrotate
```

### Security Administration

```text
firewalld
Firewall Zones
Runtime and Permanent Rules
Service and Port Rules
SELinux
Security Contexts
SELinux Booleans
File Context Management
```

### Network Administration

```text
NetworkManager
nmcli
Network Interfaces
Connection Profiles
IPv4 Addressing
Routing
Default Gateway
DNS
Socket Inspection
Listening Ports
```

## Lab Index

### Fundamentals

- [System Information](./linux/system-information-lab.md)
- [File and Directory Permissions](./linux/file-directory-permission-lab.md)
- [vi Editor](./linux/vi-basic-lab.md)
- [Shell Basics](./linux/shell-basics-lab.md)
- [Shell Environment](./linux/shell-environment-lab.md)
- [Search, Archive, and Compression](./linux/search-archive-compression-lab.md)
- [Text Processing](./linux/text-processing-lab.md)
- [Bash Shell Scripting](./linux/shell-script/README.md)

### System Administration

- [Process Management](./linux/process-management-lab.md)
- [Service Management](./linux/service-management-lab.md)
- [SSH Fundamentals](./linux/ssh-basic-lab.md)
- [Package Management](./linux/package-management-lab.md)
- [User and Group Management](./linux/user-management-lab.md)
- [Time and Job Scheduling](./linux/job-scheduling-lab.md)

### Storage and System Operations

- [Storage and Partition Management](./linux/storage-management-lab.md)
- [Filesystem Management](./linux/filesystem-management-lab.md)
- [Logical Volume Management](./linux/lvm-management-lab.md)
- [RAID Management](./linux/raid-management-lab.md)
- [Memory and Swap Management](./linux/memory-swap-management-lab.md)
- [Boot and Kernel Management](./linux/boot-kernel-management-lab.md)
- [Backup and Recovery](./linux/backup-recovery-lab.md)

### Logging, Security, and Networking

- [Log Management](./linux/log-management-lab.md)
- [Firewall Management](./linux/firewall-management-lab.md)
- [SELinux Management](./linux/selinux-management-lab.md)
- [Network Management](./linux/network-management-lab.md)

## Troubleshooting Approach

Troubleshooting is treated as part of system administration rather than as a separate activity.

The general workflow is:

```text
1. Identify the symptom
2. Inspect the current state
3. Collect evidence
4. Identify the affected system layer
5. Form a cause hypothesis
6. Apply a controlled change
7. Verify recovery
```

The goal is not simply to make a command succeed.

The goal is to answer:

```text
What failed?
Why did it fail?
What evidence supports the cause?
Which system layer is affected?
What is the smallest safe change?
How can recovery be verified?
```

## Troubleshooting Examples

### Service

```text
Service failure
    ↓
systemctl status
    ↓
Runtime / enable / mask state
    ↓
Controlled recovery
    ↓
Verification
```

### Storage

```text
Storage not available
    ↓
Block device
    ↓
Partition
    ↓
LVM / RAID
    ↓
Filesystem
    ↓
Mount
```

### LVM

```text
Disk capacity increased
    ↓
PV
    ↓
VG
    ↓
LV
    ↓
Filesystem
    ↓
df verification
```

A change at one storage layer does not automatically update every higher layer.

### RAID

```text
Degraded array
    ↓
Identify failed member
    ↓
Fail
    ↓
Remove
    ↓
Add replacement
    ↓
Monitor rebuild
    ↓
Verify array state
```

### Memory

```text
Memory pressure
    ↓
free
    ↓
vmstat
    ↓
top
    ↓
pmap
```

The investigation moves from system-wide memory state toward individual processes.

### Boot

```text
Boot failure
    ↓
Firmware
    ↓
GRUB2
    ↓
Kernel
    ↓
systemd
    ↓
Target / Service
```

The failure should first be localized to a boot layer.

### Backup

```text
Create backup
    ↓
Inspect backup
    ↓
Restore test
    ↓
Verify recovered data
```

A completed backup command alone does not prove that data is recoverable.

### Logging

```text
Incident
   ↓
Identify time range
   ↓
Filter by severity
   ↓
Filter by process or service
   ↓
Inspect evidence
```

### Firewall

```text
Remote connection failure
        ↓
Application running?
        ↓
Port listening?
        ↓
Correct firewalld zone?
        ↓
Service / port allowed?
        ↓
Remote verification
```

### SELinux

```text
Application access denied
        ↓
DAC permissions
        ↓
SELinux mode
        ↓
Process context
        ↓
File context
        ↓
Boolean / policy
        ↓
Logs
        ↓
Verify in Enforcing mode
```

### Network

```text
Network failure
    ↓
Device
    ↓
IP Address
    ↓
Subnet
    ↓
Route
    ↓
Gateway
    ↓
DNS
    ↓
Listening Socket
    ↓
Firewall
    ↓
Application
```

## Runtime vs Persistent Configuration

A recurring theme across the labs is the distinction between current state and persistent configuration.

```text
systemctl start
≠
systemctl enable
```

```text
sysctl -w
≠
persistent sysctl configuration
```

```text
firewall-cmd --add-service
≠
firewall-cmd --permanent --add-service
```

```text
ip addr add
≠
NetworkManager connection configuration
```

Understanding this distinction prevents changes that appear to work temporarily but disappear after a restart or reload.

## Verification-First Documentation

Commands are not considered complete simply because they return without an obvious error.

Every change should be followed by verification.

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

Restore
  ↓
Verify
```

The exact verification command depends on the system layer.

Examples include:

```bash
systemctl status SERVICE
```

```bash
lsblk
```

```bash
df -hT
```

```bash
cat /proc/mdstat
```

```bash
free -h
```

```bash
ip addr
```

```bash
ip route
```

```bash
ss -nlp
```

```bash
firewall-cmd --list-all
```

```bash
getenforce
```

## Infrastructure Layer Awareness

A major goal of these labs is to understand which infrastructure layer is being modified.

For storage:

```text
Physical Disk
      ↓
Partition
      ↓
RAID or Physical Volume
      ↓
Volume Group
      ↓
Logical Volume
      ↓
Filesystem
      ↓
Mount Point
```

For network services:

```text
Application
      ↓
Process / Service
      ↓
Listening Socket
      ↓
SELinux Policy
      ↓
Firewall
      ↓
Network
```

For network connectivity:

```text
Interface
      ↓
IP Address
      ↓
Routing
      ↓
Gateway
      ↓
DNS
      ↓
Remote Service
```

Understanding these boundaries makes troubleshooting more systematic.

## Documentation Principles

### Hands-On First

Labs are based on direct practice in a Rocky Linux virtual machine.

### Verify Every Change

System state is checked after configuration changes.

### Collect Evidence Before Changing the System

Troubleshooting begins with inspection rather than immediately restarting services or modifying configuration.

### Do Not Fabricate Runtime Values

Values such as the following should come from the actual lab environment:

```text
PID
UID
GID
UUID
Disk names
Interface names
IP addresses
Kernel versions
Filesystem sizes
Package versions
Service states
Command output
```

### Use Disposable Resources for Destructive Labs

Potentially destructive operations are practiced only on dedicated lab resources.

Examples include:

```text
fdisk
parted
mkfs
xfs_repair
pvcreate
lvreduce
mdadm member failure tests
mkswap
GRUB configuration changes
route changes
firewall changes
```

### Understand Failures

Errors are treated as useful evidence.

```text
Symptom
   ↓
Evidence
   ↓
Root Cause
   ↓
Resolution
   ↓
Verification
```

## Learning Direction

These labs are building the Linux operating-system foundation required for cloud infrastructure engineering.

The current progression is:

```text
Linux Fundamentals
        ↓
System Administration
        ↓
Bash Automation
        ↓
Storage and System Operations
        ↓
Logging and Troubleshooting
        ↓
Linux Security
        ↓
Network Administration
        ↓
Cloud Infrastructure
```

Future labs will continue connecting Linux administration skills to cloud infrastructure, automation, and infrastructure troubleshooting.
