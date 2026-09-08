# Linux Infrastructure Labs

Hands-on Linux administration labs focused on building practical infrastructure fundamentals with Rocky Linux and Bash.

This directory documents my progression from basic Linux operations to system administration topics such as user management, package management, service control, job scheduling, storage, filesystems, and LVM.

The labs are designed around a simple workflow:

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

Rather than recording commands only, each lab focuses on understanding what changed in the system and how to verify the result.

---

## Environment

- OS: Rocky Linux
- Virtualization: VMware
- Shell: Bash
- Init System: systemd
- Package Manager: DNF / RPM
- Primary Goal: Cloud Infrastructure Fundamentals

---

## Learning Path

```text
Linux Fundamentals
        |
        v
Files and Permissions
        |
        v
Shell and Environment
        |
        v
Text Processing
        |
        v
Shell Scripting
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
LVM
```

---

## Lab Index

### 1. System Fundamentals

#### [System Information Lab](./system-information-lab.md)

Practice inspecting the Linux system environment.

Topics:

- Operating-system information
- Kernel information
- Hostname
- CPU and memory information
- System architecture
- Basic system inspection

---

### 2. Files, Directories, and Permissions

#### [File and Directory Permission Lab](./file-directory-permission-lab.md)

Practice Linux file ownership and permission management.

Topics:

- File and directory permissions
- Read, write, and execute permissions
- Symbolic and octal permission notation
- `chmod`
- `chown`
- `chgrp`
- Special permission concepts
- Permission verification

---

### 3. vi Editor

#### [vi Basic Lab](./vi-basic-lab.md)

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

### 4. Shell Fundamentals

#### [Shell Basics Lab](./shell-basics-lab.md)

Practice fundamental Bash shell behavior.

Topics:

- Shell commands
- Standard input and output
- Redirection
- Pipelines
- Command execution
- Basic shell behavior

---

### 5. Shell Environment

#### [Shell Environment Lab](./shell-environment-lab.md)

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

### 6. Search, Archive, and Compression

#### [Search, Archive, and Compression Lab](./search-archive-compression-lab.md)

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

### 7. Text Processing

#### [Text Processing Lab](./text-processing-lab.md)

Practice Linux text-processing tools.

Topics:

- `grep`
- Regular-expression matching
- `sed`
- `awk`
- Records and fields
- Field separators
- Pipelines
- Text filtering and transformation

---

### 8. Bash Shell Scripting

#### [Shell Script Labs](./shell-script/README.md)

Practice Bash scripting from basic syntax to reusable functions.

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

Shell script examples are stored under:

```text
linux/shell-script/
```

---

### 9. Process Management

#### [Process Management Lab](./process-management-lab.md)

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

### 10. Service Management

#### [Service Management Lab](./service-management-lab.md)

Practice systemd service and unit management.

Topics:

- systemd
- systemd units
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

---

### 11. SSH Fundamentals

#### [SSH Basic Lab](./ssh-basic-lab.md)

Practice basic remote Linux access with SSH.

Topics:

- SSH client and server concepts
- Remote login
- SSH service inspection
- Connection verification
- Basic SSH operations

---

### 12. Package Management

#### [Package Management Lab](./package-management-lab.md)

Practice software and repository management on Rocky Linux.

Topics:

- RPM packages
- `rpm -q`
- `rpm -qi`
- `rpm -ql`
- `rpm -qc`
- `rpm -qd`
- DNF
- Package search
- Package installation and removal
- Repository inspection
- `/etc/yum.repos.d/`
- DNF cache
- DNF transaction history
- Package groups
- RPM/DNF and DEB/APT comparison
- Snap concepts

---

### 13. User and Group Management

#### [User Management Lab](./user-management-lab.md)

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
- Authentication and authorization
- Login information

---

### 14. Time and Job Scheduling

#### [Time and Job Scheduling Lab](./job-scheduling-lab.md)

Practice Linux time synchronization and scheduled job management.

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
- `cron`
- `crond`
- `/etc/crontab`
- User crontabs
- Anacron
- `/etc/anacrontab`
- Scheduling access control

---

### 15. Storage and Partition Management

#### [Storage Management Lab](./storage-management-lab.md)

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
- Storage-change verification

The core storage relationship is:

```text
Disk
  ↓
Partition
```

---

### 16. Filesystem Management

#### [Filesystem Management Lab](./filesystem-management-lab.md)

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
- UUID-based filesystem identification
- `/etc/mtab`
- XFS allocation groups
- `xfs_info`
- `xfs_repair`
- Filesystem failure and recovery

The storage workflow becomes:

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

### 17. Logical Volume Management

#### [LVM Management Lab](./lvm-management-lab.md)

Practice flexible Linux storage management with LVM.

Topics:

- Physical Volume (PV)
- Volume Group (VG)
- Logical Volume (LV)
- Physical Extent (PE)
- Logical Extent (LE)
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

The LVM storage stack is:

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

## Linux Administration Progression

The labs build on one another rather than being isolated command exercises.

### System Administration

```text
Users
Packages
Processes
Services
Scheduling
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
Mount
```

### Troubleshooting Approach

Across the labs, I use the following troubleshooting process:

```text
1. Identify the symptom
2. Inspect the current state
3. Collect command output as evidence
4. Identify the affected system layer
5. Apply a controlled change
6. Verify the result
```

Examples include:

- Verifying process state after starting or terminating a process
- Distinguishing service runtime state from boot configuration
- Inspecting package history when software changes occur
- Checking system time and daemon state when scheduled jobs fail
- Identifying the correct block device before storage changes
- Diagnosing filesystem mount failures
- Repairing a disposable XFS filesystem and verifying recovery
- Checking each LVM layer when added storage is not visible to a filesystem

---

## Repository Structure

```text
linux/
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

---

## Documentation Principles

Each lab follows several documentation principles.

### 1. Commands Must Be Verified

A successful command is not assumed to mean that the intended system state was achieved.

Examples:

```text
Create
→ Verify

Modify
→ Verify

Repair
→ Verify
```

### 2. System Layers Must Be Distinguished

For example:

```text
Disk
≠ Partition
≠ Logical Volume
≠ Filesystem
≠ Mount Point
```

Understanding which layer is being modified is critical for infrastructure troubleshooting.

### 3. Real Environment Values Should Not Be Fabricated

Values such as:

```text
PID
UID
GID
UUID
Disk name
Filesystem size
Package version
Service output
```

should be recorded from the actual lab environment when documenting execution results.

### 4. Destructive Operations Use Disposable Resources

Commands that can modify or destroy storage are practiced only on dedicated lab devices.

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

### 5. Troubleshooting Is Part of the Lab

Failures are treated as useful evidence rather than simply avoided.

The goal is to understand:

```text
What failed?
Why did it fail?
What evidence supports the cause?
How was it corrected?
How was recovery verified?
```

---

## Current Focus

The current Linux study path is progressing from foundational administration toward infrastructure operations.

Current areas include:

```text
Linux fundamentals
Bash scripting
Process management
System services
User administration
Package management
Scheduled operations
Storage administration
Filesystem management
Logical Volume Management
```

These fundamentals will provide the base for later infrastructure topics such as advanced storage, networking, system security, containers, and cloud infrastructure.
