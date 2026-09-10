# Linux Infrastructure Labs

Hands-on Linux administration labs focused on building practical infrastructure fundamentals with Rocky Linux and Bash.

This directory documents my progression from basic Linux operations into system administration, storage, recovery, observability, security, networking, and troubleshooting.

The labs follow a consistent workflow:

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

Rather than recording commands only, each lab focuses on understanding what changed, which system layer was affected, and how the result can be verified.

---

## Environment

- OS: Rocky Linux
- Virtualization: VMware
- Shell: Bash
- Init System: systemd
- Package Manager: DNF / RPM
- Network Manager: NetworkManager
- Firewall: firewalld
- Security: SELinux
- Primary Goal: Cloud Infrastructure Fundamentals

---

## Learning Path

```text
Linux Fundamentals
        ↓
Files and Permissions
        ↓
Shell and Environment
        ↓
Text Processing
        ↓
Bash Scripting
        ↓
Processes and Services
        ↓
Users and Packages
        ↓
Time and Job Scheduling
        ↓
Storage and Partitions
        ↓
Filesystems
        ↓
LVM
        ↓
RAID
        ↓
Memory and Swap
        ↓
Boot and Kernel
        ↓
Backup and Recovery
        ↓
Log Management
        ↓
Firewall
        ↓
SELinux
        ↓
Network Management
```

---

# Lab Index

## 1. System Fundamentals

### [System Information Lab](./system-information-lab.md)

Practice inspecting the Linux system environment.

Topics:

- Operating-system information
- Kernel information
- Hostname
- CPU and memory information
- System architecture
- Basic system inspection

---

## 2. Files, Directories, and Permissions

### [File and Directory Permission Lab](./file-directory-permission-lab.md)

Practice Linux file ownership and permission management.

Topics:

- File and directory permissions
- Read, write, and execute permissions
- Symbolic and octal notation
- `chmod`
- `chown`
- `chgrp`
- Special permissions
- Permission verification

---

## 3. vi Editor

### [vi Basic Lab](./vi-basic-lab.md)

Practice basic text editing with `vi`.

Topics:

- Normal mode
- Insert mode
- Command mode
- Navigation
- Editing
- Search
- Save and quit operations

---

## 4. Shell Fundamentals

### [Shell Basics Lab](./shell-basics-lab.md)

Practice fundamental Bash shell behavior.

Topics:

- Shell commands
- Standard input and output
- Redirection
- Pipelines
- Command execution
- Basic shell behavior

---

## 5. Shell Environment

### [Shell Environment Lab](./shell-environment-lab.md)

Practice shell variables and environment management.

Topics:

- Shell variables
- Environment variables
- `export`
- Parent and child processes
- Variable expansion
- Shell configuration
- Command environment

---

## 6. Search, Archive, and Compression

### [Search, Archive, and Compression Lab](./search-archive-compression-lab.md)

Practice locating files and managing archives.

Topics:

- `find`
- File search conditions
- `tar`
- Archive creation
- Archive extraction
- Compression
- Archive verification

---

## 7. Text Processing

### [Text Processing Lab](./text-processing-lab.md)

Practice Linux text-processing tools.

Topics:

- `grep`
- Regular expressions
- `sed`
- `awk`
- Records and fields
- Field separators
- Pipelines
- Text filtering
- Text transformation

---

## 8. Bash Shell Scripting

### [Shell Script Labs](./shell-script/README.md)

Practice Bash scripting from basic syntax to reusable administration logic.

Topics:

- Variables
- Arguments
- Positional parameters
- Exit status
- Conditional statements
- File tests
- `case`
- `for`
- `while`
- `until`
- `shift`
- `read`
- Functions
- Local variables
- Here documents
- Process arguments
- Execution scope

Shell scripts are stored under:

```text
linux/shell-script/
```

---

## 9. Process Management

### [Process Management Lab](./process-management-lab.md)

Practice inspecting and controlling Linux processes.

Topics:

- Process inspection
- PID
- Parent and child processes
- `ps`
- `pgrep`
- Background processes
- Foreground and background jobs
- Signals
- Process termination
- Job control

---

## 10. Service Management

### [Service Management Lab](./service-management-lab.md)

Practice systemd service and unit management.

Topics:

- systemd
- Units
- `.service`
- `.socket`
- `.target`
- `systemctl status`
- `start`
- `stop`
- `restart`
- `reload`
- `enable`
- `disable`
- `mask`
- `unmask`
- Runtime state vs boot configuration
- Default targets
- Unit dependencies
- Socket activation
- Service troubleshooting

---

## 11. SSH Fundamentals

### [SSH Basic Lab](./ssh-basic-lab.md)

Practice basic remote Linux access with SSH.

Topics:

- SSH client and server concepts
- Remote login
- SSH service inspection
- Connection verification
- Basic SSH operations

---

## 12. Package Management

### [Package Management Lab](./package-management-lab.md)

Practice software and repository management on Rocky Linux.

Topics:

- RPM packages
- `rpm`
- DNF
- Package search
- Package installation
- Package removal
- Repository inspection
- `/etc/yum.repos.d/`
- DNF cache
- Transaction history
- Package groups
- Repository troubleshooting
- RPM/DNF and DEB/APT comparison

---

## 13. User and Group Management

### [User Management Lab](./user-management-lab.md)

Practice Linux account lifecycle management.

Topics:

- UID and GID
- Primary and supplementary groups
- `/etc/passwd`
- `/etc/shadow`
- `/etc/group`
- `/etc/gshadow`
- `useradd`
- `usermod`
- `userdel`
- `groupadd`
- Password management
- Password aging with `chage`
- Account lock and unlock
- `su`
- `sudo`
- Authentication
- Authorization
- Login information

---

## 14. Time and Job Scheduling

### [Time and Job Scheduling Lab](./job-scheduling-lab.md)

Practice Linux time synchronization and scheduled-job management.

Topics:

- `timedatectl`
- Time zones
- NTP
- Chrony
- `chronyd`
- `chronyc`
- `at`
- `batch`
- `atq`
- `atrm`
- Cron
- `crond`
- `/etc/crontab`
- User crontabs
- Anacron
- Scheduling access control
- Scheduling troubleshooting

---

## 15. Storage and Partition Management

### [Storage Management Lab](./storage-management-lab.md)

Practice block-device and partition administration.

Topics:

- `lsblk`
- Disk and partition device names
- SCSI disk rescanning
- `sg3_utils`
- MBR
- GPT
- `fdisk`
- `parted`
- Partition creation
- Partition-table inspection
- Newly attached disk troubleshooting
- Storage-change verification

Core relationship:

```text
Disk
  ↓
Partition
```

---

## 16. Filesystem Management

### [Filesystem Management Lab](./filesystem-management-lab.md)

Practice creating, mounting, inspecting, and repairing Linux filesystems.

Topics:

- ext4
- XFS
- Filesystem structure
- Superblocks
- Inodes
- `stat`
- `mkfs`
- `mount`
- `umount`
- `df`
- `/etc/fstab`
- Mount options
- UUID-based identification
- `/etc/mtab`
- XFS allocation groups
- `xfs_info`
- `xfs_repair`
- Filesystem failure and recovery

Storage relationship:

```text
Disk
  ↓
Partition
  ↓
Filesystem
  ↓
Mount Point
  ↓
Files
```

---

## 17. Logical Volume Management

### [LVM Management Lab](./lvm-management-lab.md)

Practice flexible Linux storage management with LVM.

Topics:

- Physical Volume
- Volume Group
- Logical Volume
- Physical Extent
- Logical Extent
- `pvcreate`
- `vgcreate`
- `lvcreate`
- `vgextend`
- `lvextend`
- `resize2fs`
- `e2fsck`
- `lvreduce`
- `lvresize`
- Online filesystem growth
- Offline filesystem shrinking
- LVM snapshots
- Snapshot-based backup workflow
- LVM layer troubleshooting

Storage stack:

```text
Physical Disk
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

---

## 18. RAID Management

### [RAID Management Lab](./raid-management-lab.md)

Practice Linux software RAID concepts, creation, inspection, failure simulation, and recovery.

Topics:

- RAID 0
- RAID 1
- RAID 5
- RAID 6
- RAID 10
- Striping
- Mirroring
- Parity
- `mdadm`
- `/proc/mdstat`
- RAID array inspection
- Failed-member handling
- Member removal
- Replacement-device addition
- Rebuild monitoring
- RAID vs backup

RAID recovery workflow:

```text
Detect degradation
       ↓
Identify failed member
       ↓
Fail member
       ↓
Remove member
       ↓
Add replacement
       ↓
Monitor rebuild
       ↓
Verify array
```

---

## 19. Memory and Swap Management

### [Memory and Swap Management Lab](./memory-swap-management-lab.md)

Practice Linux memory inspection and swap administration.

Topics:

- Physical memory information
- Virtual memory concepts
- `free`
- `vmstat`
- `/proc/meminfo`
- `top`
- VIRT and RES
- `pmap`
- Swap partitions
- Swap files
- `mkswap`
- `swapon`
- `swapoff`
- `/etc/fstab`
- `swappiness`
- Swap-file permissions
- Memory troubleshooting

Investigation workflow:

```text
free
  ↓
vmstat
  ↓
top
  ↓
pmap
```

---

## 20. Boot and Kernel Management

### [Boot and Kernel Management Lab](./boot-kernel-management-lab.md)

Practice Linux boot-process inspection and kernel-management concepts.

Topics:

- BIOS
- UEFI
- MBR
- GPT
- EFI System Partition
- GRUB2
- Kernel images
- Default boot kernel
- Root-password recovery concepts
- Kernel parameters
- `sysctl`
- Kernel modules
- `lsmod`
- `modprobe`
- `modinfo`
- systemd targets
- Shutdown and reboot
- Boot troubleshooting

Boot model:

```text
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
Services
```

---

## 21. Backup and Recovery

### [Backup and Recovery Lab](./backup-recovery-lab.md)

Practice Linux backup, restore, and synchronization concepts.

Topics:

- Full backup
- Incremental backup
- Differential backup
- Backup levels
- `dump`
- `restore`
- `xfsdump`
- `xfsrestore`
- `rsync`
- Remote synchronization
- Trailing-slash behavior
- `--delete`
- `-u`
- Dry runs
- Restore verification

Backup workflow:

```text
Create Backup
      ↓
Inspect Backup
      ↓
Restore
      ↓
Verify Recovered Data
```

---

## 22. Log Management

### [Log Management Lab](./log-management-lab.md)

Practice Linux logging, filtering, and troubleshooting.

Topics:

- rsyslog
- `/etc/rsyslog.conf`
- Syslog Facility
- Syslog Severity
- `/var/log`
- `logger`
- systemd-journald
- `journalctl`
- Journal metadata
- Time-based filtering
- Priority filtering
- Process filtering
- Persistent journals
- Volatile journals
- logrotate

Troubleshooting model:

```text
Incident
   ↓
Time Range
   ↓
Severity
   ↓
Process / Service
   ↓
Evidence
```

---

## 23. Firewall Management

### [Firewall Management Lab](./firewall-management-lab.md)

Practice Linux firewall administration with firewalld.

Topics:

- Netfilter concepts
- iptables concepts
- firewalld
- `firewall-cmd`
- Zones
- Interfaces
- Sources
- Service-based rules
- Port-based rules
- Runtime rules
- Permanent rules
- Reload behavior
- Custom zones
- Firewall troubleshooting

Connectivity troubleshooting:

```text
Application
    ↓
Listening Port
    ↓
Zone
    ↓
Firewall Rule
    ↓
Remote Connectivity
```

---

## 24. SELinux Management

### [SELinux Management Lab](./selinux-management-lab.md)

Practice SELinux access-control inspection and troubleshooting.

Topics:

- DAC and MAC
- Enforcing
- Permissive
- Disabled
- `getenforce`
- `sestatus`
- `setenforce`
- Security contexts
- Process contexts
- File contexts
- SELinux users
- SELinux Booleans
- `getsebool`
- `setsebool`
- `chcon`
- `semanage fcontext`
- `restorecon`
- SELinux troubleshooting

Troubleshooting model:

```text
Access Failure
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

---

## 25. Network Management

### [Network Management Lab](./network-management-lab.md)

Practice Linux network configuration, inspection, and troubleshooting.

Topics:

- IPv4 addressing
- Network and host addresses
- CIDR
- NetworkManager
- `nmcli`
- Network devices
- Connection profiles
- `ip addr`
- Multiple IP addresses
- Routing
- Default gateway
- `ip route`
- DNS
- `/etc/resolv.conf`
- Traffic statistics
- `ss`
- Listening sockets
- LISTEN and ESTABLISHED
- Runtime vs persistent network configuration
- Network troubleshooting

Troubleshooting model:

```text
Network Device
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

---

# Linux Administration Progression

The labs build on one another rather than being isolated command exercises.

## System Administration

```text
Users
Packages
Processes
Services
Scheduling
```

## Storage Administration

```text
Disk
  ↓
Partition
  ↓
RAID / LVM
  ↓
Filesystem
  ↓
Mount
```

## System Operations

```text
Memory
  ↓
Boot
  ↓
Kernel
  ↓
Backup
  ↓
Logging
```

## Security

```text
DAC Permissions
      ↓
SELinux
      ↓
Firewall
```

## Networking

```text
Device
  ↓
IP
  ↓
Routing
  ↓
Gateway
  ↓
DNS
  ↓
Socket
  ↓
Firewall
  ↓
Application
```

---

# Troubleshooting Approach

Across the labs, troubleshooting follows a consistent process:

```text
1. Identify the symptom
2. Inspect the current state
3. Collect command output as evidence
4. Identify the affected system layer
5. Form a cause hypothesis
6. Apply a controlled change
7. Verify the result
```

The objective is not merely to make the system work again.

The objective is to understand:

```text
What failed?
Why did it fail?
What evidence supports that conclusion?
Which infrastructure layer is affected?
What change is required?
How can recovery be verified?
```

## Examples

### Service Failure

```text
systemctl status
       ↓
Runtime State
       ↓
Enable / Mask State
       ↓
Dependencies
       ↓
Recovery
       ↓
Verification
```

### Filesystem Failure

```text
Mount Failure
     ↓
Inspect Filesystem
     ↓
Unmount Safely
     ↓
Repair
     ↓
Remount
     ↓
Verify Data
```

### LVM Capacity Problem

```text
Disk
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

### RAID Failure

```text
/proc/mdstat
     ↓
Failed Member
     ↓
Remove
     ↓
Replace
     ↓
Rebuild
     ↓
Verify
```

### Memory Pressure

```text
free
 ↓
vmstat
 ↓
top
 ↓
pmap
```

### Boot Failure

```text
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

### Log Investigation

```text
Incident Time
      ↓
Priority
      ↓
Process / Service
      ↓
Relevant Evidence
```

### Firewall Failure

```text
Service Running?
      ↓
Port Listening?
      ↓
Zone Correct?
      ↓
Rule Present?
      ↓
Remote Test
```

### SELinux Failure

```text
DAC
 ↓
Mode
 ↓
Process Context
 ↓
File Context
 ↓
Boolean
 ↓
Log
 ↓
Verification
```

### Network Failure

```text
Device
 ↓
Address
 ↓
Route
 ↓
Gateway
 ↓
DNS
 ↓
Socket
 ↓
Firewall
 ↓
Application
```

---

# Runtime vs Persistent Configuration

A recurring concept across Linux administration is that current runtime state and persistent configuration are not the same thing.

## Services

```text
systemctl start
!=
systemctl enable
```

## Kernel Parameters

```text
sysctl -w
!=
persistent sysctl configuration
```

## Firewall

```text
firewall-cmd --add-service
!=
firewall-cmd --permanent --add-service
```

## Networking

```text
ip addr add
!=
NetworkManager connection configuration
```

Recognizing this difference is essential when a configuration works temporarily but disappears after restart or reload.

---

# Documentation Principles

## 1. Commands Must Be Verified

A successful command does not automatically prove that the intended system state was achieved.

```text
Create
→ Verify

Modify
→ Verify

Repair
→ Verify

Restore
→ Verify
```

## 2. System Layers Must Be Distinguished

For example:

```text
Disk
!=
Partition
!=
RAID
!=
Logical Volume
!=
Filesystem
!=
Mount Point
```

For network applications:

```text
Service
!=
Process
!=
Socket
!=
Firewall
!=
Network
```

Understanding the layer being changed is critical for infrastructure troubleshooting.

## 3. Evidence Comes Before Changes

When a problem occurs, collect the current state before changing configuration.

```text
Symptom
   ↓
Evidence
   ↓
Cause
   ↓
Change
   ↓
Verification
```

This makes troubleshooting reproducible and easier to document.

## 4. Real Environment Values Must Not Be Fabricated

Values such as:

```text
PID
UID
GID
UUID
Disk name
Interface name
IP address
Gateway
Kernel version
Filesystem size
Package version
Service output
Command output
```

must come from the actual lab environment.

## 5. Destructive Operations Use Disposable Resources

Potentially destructive operations are practiced only on dedicated lab devices or disposable virtual machines.

Examples include:

```text
fdisk
parted
mkfs
xfs_repair
pvcreate
lvreduce
mdadm failure tests
mkswap
GRUB changes
route changes
firewall changes
```

## 6. Troubleshooting Is Part of the Lab

Failures are treated as useful evidence rather than something to hide.

The goal is to understand:

```text
What failed?
Why did it fail?
What evidence supports the cause?
How was it corrected?
How was recovery verified?
```

---

# Current Focus

The Linux study path has progressed from foundational administration toward infrastructure operations.

Current areas include:

```text
Linux Fundamentals
Bash Automation
Process and Service Management
User and Package Administration
Time and Scheduled Operations
Storage and Filesystem Administration
LVM and RAID
Memory and Swap
Boot and Kernel Management
Backup and Recovery
Logging and Observability
Firewall Management
SELinux
Network Administration
Infrastructure Troubleshooting
```

These labs provide the Linux foundation for later work in cloud infrastructure, infrastructure automation, containers, and cloud security.
