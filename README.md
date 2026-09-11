# Cloud Infrastructure Labs

Hands-on infrastructure labs documenting my progress in Linux system administration, Bash automation, storage, recovery, observability, security, networking, and infrastructure troubleshooting.

This repository focuses on understanding how infrastructure components work together through direct practice, verification, controlled failure, and recovery rather than simple command memorization.

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

The Linux study path has progressed from basic operating-system usage into system operations, storage, recovery, observability, security, networking, network redundancy, remote file sharing, and troubleshooting methodology.

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
Logging and Observability
        ↓
Firewall and SELinux
        ↓
Network Administration
        ↓
SSH
        ↓
Network Teaming
        ↓
NFS
        ↓
Infrastructure Troubleshooting
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
- Remote Access: OpenSSH
- Network File Sharing: NFS
- Primary Area: Linux Infrastructure
- Learning Style: Hands-on labs, verification, troubleshooting, and recovery

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
    ├── network-teaming-lab.md
    ├── nfs-management-lab.md
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
SSH
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
RAID member failure and rebuild
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
Emergency and Rescue Targets
Installation-Media Rescue
chroot-based Recovery
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

### Network Services and Redundancy

```text
OpenSSH
Password and Public-Key Authentication
SCP
SFTP
Network Teaming
Active-Backup Failover
NFS Server and Client
NFS Exports
Remote Filesystem Mounting
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
- [SSH Fundamentals and Remote Access](./linux/ssh-basic-lab.md)
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
- [Network Teaming](./linux/network-teaming-lab.md)
- [NFS Management](./linux/nfs-management-lab.md)

## Troubleshooting Philosophy

Troubleshooting is treated as part of every infrastructure lab rather than as a separate topic.

The general workflow is:

```text
Symptom
   ↓
Scope
   ↓
Evidence
   ↓
Possible Causes
   ↓
Prioritize Hypotheses
   ↓
Controlled Change
   ↓
Verification
   ↓
Documentation
```

The first objective is not to change the system.

The first objective is to understand:

```text
What exactly is failing?
Who or what is affected?
When did the problem begin?
What changed recently?
What evidence exists?
Which infrastructure layer is involved?
```

## Scope Before Cause

A symptom should first be scoped.

```text
One user?
    ↓
Client or account issue


One server?
    ↓
System-specific issue


One service?
    ↓
Application or service issue


Multiple systems?
    ↓
Shared infrastructure issue
```

The symptom itself is not the root cause.

For example:

```text
"SSH does not work"
```

is a symptom.

Possible causes include:

```text
Network failure
Routing failure
Firewall rule
sshd failure
Authentication configuration
User account or key configuration
```

## Evidence Before Changes

Useful evidence can include:

```text
Error messages
System state
Service state
Socket state
Filesystem state
Network state
Logs
Recent configuration changes
```

Changes should normally be applied one at a time so that the effect of each change remains observable.

```text
Hypothesis
    ↓
One Controlled Change
    ↓
Observe Result
    ↓
Accept or Reject Hypothesis
```

## Troubleshooting Examples

### Service

```text
Service Failure
    ↓
systemctl status
    ↓
Runtime / Enabled / Masked State
    ↓
Dependencies
    ↓
Logs
    ↓
Controlled Recovery
    ↓
Verification
```

### Storage

```text
Storage Failure
    ↓
Block Device
    ↓
Partition
    ↓
RAID / LVM
    ↓
Filesystem
    ↓
Mount
```

### LVM

```text
Disk Capacity Changed
    ↓
PV
    ↓
VG
    ↓
LV
    ↓
Filesystem
    ↓
df
```

A change in one storage layer does not automatically update every higher layer.

### RAID

```text
Degraded Array
    ↓
Identify Failed Member
    ↓
Fail
    ↓
Remove
    ↓
Add Replacement
    ↓
Monitor Rebuild
    ↓
Verify Array State
```

### Memory

```text
Memory Pressure
    ↓
free
    ↓
vmstat
    ↓
top
    ↓
pmap
```

The investigation moves from system-wide resource state toward individual processes.

### Boot

```text
Boot Failure
    ↓
Firmware
    ↓
GRUB2
    ↓
Kernel
    ↓
systemd
    ↓
Target
    ↓
Service
```

When normal boot is unavailable, recovery can move into:

```text
Emergency / Rescue Target
```

or:

```text
Installation Media
    ↓
Rescue Environment
    ↓
/mnt/sysroot
    ↓
chroot
    ↓
Repair
```

### Backup

```text
Create Backup
    ↓
Inspect Backup
    ↓
Restore
    ↓
Verify Recovered Data
```

A successful backup command does not prove that data can actually be restored.

### Logging

```text
Incident
   ↓
Identify Time Range
   ↓
Filter Severity
   ↓
Filter Process / Service
   ↓
Inspect Evidence
```

### Firewall

```text
Remote Connection Failure
        ↓
Application Running?
        ↓
Port Listening?
        ↓
Correct Zone?
        ↓
Required Rule Present?
        ↓
Remote Verification
```

### SELinux

```text
Access Denied
    ↓
DAC Permissions
    ↓
SELinux Mode
    ↓
Process Context
    ↓
File Context
    ↓
Boolean / Policy
    ↓
Logs
    ↓
Verify in Enforcing Mode
```

### Network

```text
Network Failure
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

### SSH

```text
SSH Failure
    ↓
Network
    ↓
Route
    ↓
Firewall
    ↓
Listening Socket
    ↓
sshd
    ↓
Authentication Method
    ↓
User / Key
    ↓
Logs
```

### Network Teaming

```text
Team Failure
    ↓
Connection Profiles
    ↓
Physical Devices
    ↓
Team Runner
    ↓
Active Port
    ↓
Controlled Link Failure
    ↓
Failover Verification
```

### NFS

```text
NFS Mount Failure
    ↓
Client Network
    ↓
Server Reachability
    ↓
nfs-server
    ↓
/etc/exports
    ↓
exportfs
    ↓
Firewall
    ↓
showmount
    ↓
Client Mount
    ↓
Verification
```

## Runtime vs Persistent Configuration

A recurring theme across the labs is the distinction between current runtime state and persistent configuration.

### Services

```text
systemctl start
!=
systemctl enable
```

### Kernel Parameters

```text
sysctl -w
!=
persistent sysctl configuration
```

### Firewall

```text
firewall-cmd --add-service
!=
firewall-cmd --permanent --add-service
```

### Networking

```text
ip addr add
!=
NetworkManager connection configuration
```

### Filesystems

```text
mount
!=
/etc/fstab
```

### NFS

```text
mount -t nfs
!=
persistent NFS entry in /etc/fstab
```

Understanding this distinction prevents changes that work temporarily but disappear after a reload or reboot.

## Verification-First Documentation

Commands are not considered complete simply because they return without an obvious error.

Every important change should be independently verified.

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

Failover
  ↓
Verify
```

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

```bash
teamdctl team0 state
```

```bash
exportfs
```

```bash
showmount -e SERVER
```

The exact verification command depends on the infrastructure layer.

## Infrastructure Layer Awareness

A major goal of these labs is to identify the exact layer being inspected or changed.

### Storage

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

### Network Application

```text
Application
      ↓
Process / Service
      ↓
Listening Socket
      ↓
SELinux
      ↓
Firewall
      ↓
Network
```

### Network Connectivity

```text
Network Device
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

### NFS

```text
Server Storage
      ↓
Filesystem Permissions
      ↓
SELinux
      ↓
NFS Export
      ↓
NFS Service
      ↓
Firewall
      ↓
Network
      ↓
Client Mount
```

Understanding these boundaries makes troubleshooting more systematic.

## Recovery Environments

Some failures cannot be repaired from the normal operating environment.

Examples include:

```text
GRUB failure
Boot configuration failure
Invalid /etc/fstab entry
Root filesystem problems
Filesystem corruption
```

A recovery workflow can use:

```text
GRUB
  ↓
emergency.target / rescue.target
```

or:

```text
Installation Media
      ↓
Rescue Mode
      ↓
Installed System mounted under /mnt/sysroot
      ↓
chroot /mnt/sysroot
      ↓
Repair
```

Recovery commands must be selected according to the actual boot mode, filesystem type, and failure condition.

## Documentation Principles

### Hands-On First

Labs are based on direct practice or reproducible study workflows in a Rocky Linux virtual-machine environment.

### Verify Every Change

System state is checked after configuration changes.

### Collect Evidence Before Changing the System

Troubleshooting begins with inspection rather than immediately restarting services or modifying configuration.

### Change One Variable at a Time

Applying multiple unrelated changes at once makes it difficult to identify the actual cause.

### Do Not Fabricate Runtime Values

Values such as the following must come from the actual lab environment:

```text
PID
UID
GID
UUID
Disk names
Interface names
IP addresses
Gateway addresses
Kernel versions
Filesystem sizes
Package versions
Service states
RAID states
Active team ports
SSH fingerprints
Command output
```

### Use Disposable Resources for Destructive Labs

Potentially destructive or connectivity-breaking operations are practiced only on dedicated lab resources.

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
network-interface disconnect tests
NFS export tests
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

### Document the Result

A resolved incident should record enough information to make a similar future failure easier to diagnose.

## Learning Direction

These labs build the Linux operating-system foundation required for cloud infrastructure engineering.

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
Logging and Observability
        ↓
Linux Security
        ↓
Network Administration
        ↓
Network Services and Redundancy
        ↓
Infrastructure Troubleshooting
        ↓
Cloud Infrastructure
```

Future labs will connect these Linux fundamentals to cloud platforms, infrastructure automation, containers, monitoring, and cloud security.
