# Linux Administration Labs

This directory documents my Linux system administration studies and hands-on infrastructure labs.

The learning path progresses from Linux fundamentals into system administration, storage, security, networking, network services, and operational troubleshooting.

The objective is not only to know Linux commands.

The objective is to understand:

```text
System State
    ↓
Configuration
    ↓
Service Behavior
    ↓
Evidence
    ↓
Troubleshooting
    ↓
Recovery
```

---

# Scope

This directory focuses on:

```text
Linux Operating-System Administration
Linux Service Management
Linux Storage
Linux Security
Linux Network Configuration
Linux Network Services
Linux Troubleshooting
```

General networking theory is documented separately under:

```text
../network/
```

The distinction is:

```text
network/
→ Protocol and networking fundamentals

linux/
→ Linux implementation and administration
```

---

# Directory Structure

```text
linux/
├── README.md
├── system-information-lab.md
├── file-directory-permission-lab.md
├── vi-basic-lab.md
├── shell-basics-lab.md
├── shell-environment-lab.md
├── search-archive-compression-lab.md
├── text-processing-lab.md
├── shell-script/
│   └── README.md
├── process-management-lab.md
├── service-management-lab.md
├── ssh-basic-lab.md
├── package-management-lab.md
├── user-management-lab.md
├── job-scheduling-lab.md
├── storage-management-lab.md
├── filesystem-management-lab.md
├── lvm-management-lab.md
├── raid-management-lab.md
├── memory-swap-management-lab.md
├── boot-kernel-management-lab.md
├── backup-recovery-lab.md
├── log-management-lab.md
├── firewall-management-lab.md
├── selinux-management-lab.md
├── network-management-lab.md
├── network-teaming-lab.md
├── nfs-management-lab.md
├── linux-bridge-lab.md
├── autofs-management-lab.md
├── samba-cifs-management-lab.md
├── apache-httpd-management-lab.md
├── dns-bind-unbound-management-lab.md
└── host-network-security-hardening-lab.md
```

---

# Learning Roadmap

```text
Linux Fundamentals
      ↓
Shell and Text Processing
      ↓
Processes and Services
      ↓
Packages and Users
      ↓
Storage and Filesystems
      ↓
LVM and RAID
      ↓
Memory and Boot
      ↓
Backup and Logs
      ↓
Firewall and SELinux
      ↓
Linux Networking
      ↓
Remote Access
      ↓
Network File Services
      ↓
Web and DNS Services
      ↓
Host Security Hardening
      ↓
Troubleshooting and Operations
```

---

# 1. System Fundamentals

File:

```text
system-information-lab.md
```

Topics include:

```text
Linux System Information
Kernel Information
Hostname
CPU
Memory
Storage
OS Release
Basic System Inspection
```

The goal is to establish a reliable system baseline before changing configuration.

---

# 2. Files and Permissions

File:

```text
file-directory-permission-lab.md
```

Topics include:

```text
Files
Directories
Ownership
Groups
Read Permission
Write Permission
Execute Permission
chmod
chown
chgrp
Special Permissions
```

A key principle is that filesystem permissions should be understood in terms of:

```text
Owner
Group
Others
```

and:

```text
File Permission
Directory Permission
```

which have different operational effects.

---

# 3. vi

File:

```text
vi-basic-lab.md
```

Topics include:

```text
vi Modes
Navigation
Insertion
Deletion
Search
Save
Quit
Editing Configuration Files
```

Configuration editing is treated as part of system administration rather than as an isolated editor exercise.

---

# 4. Shell Fundamentals

File:

```text
shell-basics-lab.md
```

Topics include:

```text
Shell
Commands
Arguments
Metacharacters
Pipelines
Redirection
Quoting
Command Substitution
Variables
```

The shell is treated as the administrator interface to Linux services and processes.

---

# 5. Shell Environment

File:

```text
shell-environment-lab.md
```

Topics include:

```text
Shell Variables
Environment Variables
export
PATH
Aliases
Startup Files
Parent and Child Shells
```

A key concept is:

```text
Shell Variable
!=
Exported Environment Variable
```

Child processes inherit exported environment variables, not arbitrary unexported parent-shell variables.

---

# 6. Search, Archive, and Compression

File:

```text
search-archive-compression-lab.md
```

Topics include:

```text
find
locate
tar
gzip
bzip2
xz
Archive Creation
Archive Extraction
Compression
```

The focus is on safe data inspection and repeatable archive operations.

---

# 7. Text Processing

File:

```text
text-processing-lab.md
```

Topics include:

```text
grep
Regular Expressions
cut
sort
uniq
tr
sed
awk
Text Pipelines
```

These tools form the foundation for Linux log analysis and automation.

---

# 8. Bash Scripting

Directory:

```text
shell-script/
```

Detailed roadmap:

[Shell Script Labs](shell-script/README.md)

Topics include:

```text
Shell Scripts
Variables
Arguments
Conditionals
Loops
Functions
Input
Debugging
Utilities
Automation
```

Bash scripting is used to automate repetitive infrastructure operations and diagnostics.

---

# 9. Process Management

File:

```text
process-management-lab.md
```

Topics include:

```text
Processes
PID
Parent / Child Processes
Foreground
Background
Jobs
Signals
ps
top
kill
Process Inspection
```

The goal is to distinguish:

```text
Process exists
Process is healthy
Process is serving the expected workload
```

as separate questions.

---

# 10. Service Management

File:

```text
service-management-lab.md
```

Topics include:

```text
systemd
systemctl
Service Units
start
stop
restart
reload
enable
disable
mask
unmask
Service Status
```

A recurring principle is:

```text
Runtime State
!=
Boot-Time Configuration
```

For example:

```text
systemctl start
→ Runtime

systemctl enable
→ Persistent boot behavior
```

---

# 11. OpenSSH

File:

```text
ssh-basic-lab.md
```

Topics include:

```text
OpenSSH Client
sshd
Remote Login
Password Authentication
Public-Key Authentication
SSH Host Keys
known_hosts
authorized_keys
ssh-keygen
ssh-copy-id
~/.ssh/config
/etc/ssh/sshd_config
SCP
SFTP
Local Port Forwarding
SSH Tunneling
SSH Troubleshooting
```

Important distinctions include:

```text
Host Key
→ Authenticates the SSH server
```

```text
User Key
→ Authenticates the SSH user
```

and:

```text
known_hosts
→ Client-side server identity
```

```text
authorized_keys
→ Server-side user public-key authorization
```

SSH configuration changes are treated as lockout-sensitive operations.

---

# 12. Package Management

File:

```text
package-management-lab.md
```

Topics include:

```text
RPM
DNF
Package Installation
Package Removal
Package Queries
Repositories
Dependency Management
Updates
```

Package state is treated as part of infrastructure inventory and security maintenance.

---

# 13. User and Group Management

File:

```text
user-management-lab.md
```

Topics include:

```text
Users
Groups
UID
GID
/etc/passwd
/etc/shadow
/etc/group
useradd
usermod
userdel
groupadd
Password Management
Supplementary Groups
```

Identity and authorization are treated as separate administrative concepts.

---

# 14. Time and Job Scheduling

File:

```text
job-scheduling-lab.md
```

Topics include:

```text
System Time
Time Zones
cron
crontab
at
Scheduled Jobs
```

The focus is on repeatable system operations rather than manually repeating administrative tasks.

---

# 15. Storage and Partition Management

File:

```text
storage-management-lab.md
```

Topics include:

```text
Block Devices
Disk Inspection
Partitions
Partition Tables
lsblk
fdisk
Storage Layout
```

Storage operations are treated as potentially destructive and should begin with device identification and evidence collection.

---

# 16. Filesystem Management

File:

```text
filesystem-management-lab.md
```

Topics include:

```text
Filesystems
mkfs
mount
umount
df
du
Filesystem Identification
Persistent Mounting
/etc/fstab
```

The recurring principle is:

```text
mount
→ Runtime state

/etc/fstab
→ Persistent configuration
```

---

# 17. LVM

File:

```text
lvm-management-lab.md
```

Topics include:

```text
Physical Volumes
Volume Groups
Logical Volumes
LVM Creation
LVM Extension
Filesystem Growth
LVM Inspection
```

A key operational distinction is:

```text
Logical Volume Size
!=
Filesystem Size
```

Extending an LV does not automatically prove that the filesystem has also been expanded.

---

# 18. RAID

File:

```text
raid-management-lab.md
```

Topics include:

```text
RAID Concepts
mdadm
RAID Creation
RAID Status
Failure
Recovery
Rebuild Concepts
```

RAID is treated as an availability mechanism rather than as a substitute for backup.

---

# 19. Memory and Swap

File:

```text
memory-swap-management-lab.md
```

Topics include:

```text
Physical Memory
Swap
free
vmstat
top
pmap
Swap Files
Swap Partitions
```

Memory troubleshooting is approached using multiple views rather than relying on one number from one command.

---

# 20. Boot and Kernel

File:

```text
boot-kernel-management-lab.md
```

Topics include:

```text
Linux Boot Process
GRUB
Kernel
systemd Boot Targets
Kernel Inspection
Kernel Packages
Boot Configuration
```

Boot troubleshooting is approached by identifying which stage failed:

```text
Firmware
   ↓
Bootloader
   ↓
Kernel
   ↓
systemd
   ↓
Services
```

Detailed recovery-environment procedures should be documented in this lab only after the corresponding recovery exercise is incorporated into the file.

---

# 21. Backup and Recovery

File:

```text
backup-recovery-lab.md
```

Topics include:

```text
Backup Concepts
tar
rsync
Data Copy
Recovery
Restore Verification
```

A key principle is:

```text
Backup Created
!=
Recovery Verified
```

A backup is useful only when the required data can actually be restored.

---

# 22. Log Management

File:

```text
log-management-lab.md
```

Topics include:

```text
systemd Journal
journalctl
Service Logs
Log Inspection
Log Filtering
Follow Mode
Troubleshooting Evidence
```

Logs are treated as evidence for explaining failures rather than something checked only after random configuration changes.

---

# 23. Firewall Management

File:

```text
firewall-management-lab.md
```

Topics include:

```text
Netfilter
firewalld
firewall-cmd
Zones
Services
Ports
Runtime Rules
Permanent Rules
```

Important principle:

```text
Service Running
!=
Service Reachable
```

A service can be healthy locally while its traffic is blocked by a firewall.

---

# 24. SELinux Management

File:

```text
selinux-management-lab.md
```

Topics include:

```text
SELinux
DAC
MAC
Enforcing
Permissive
Security Contexts
Booleans
File Contexts
Port Labels
chcon
semanage
restorecon
Troubleshooting
```

SELinux should not be disabled as a generic fix.

The preferred workflow is:

```text
Observe Denial
      ↓
Collect Evidence
      ↓
Identify Required Policy
      ↓
Apply Correct Context / Boolean / Port Mapping
      ↓
Verify
```

---

# 25. Linux Network Management

File:

```text
network-management-lab.md
```

Topics include:

```text
NetworkManager
nmcli
Network Devices
Connection Profiles
IPv4 Addressing
Default Gateway
DNS Configuration
ip addr
ip route
ss
Runtime Configuration
Persistent Configuration
Netplan Overview
```

This file focuses on how Linux implements network configuration.

General protocol theory is documented under:

```text
../network/
```

---

# 26. Network Teaming

File:

```text
network-teaming-lab.md
```

Topics include:

```text
Linux Network Teaming
Logical Interfaces
Team Ports
Active-Backup
Round Robin
Broadcast
Load Balancing
LACP
Failover
teamdctl
NetworkManager
```

Important distinction:

```text
Active-Backup
→ Availability / Failover
```

It should not automatically be interpreted as doubling network throughput.

---

# 27. NFS

File:

```text
nfs-management-lab.md
```

Topics include:

```text
NFS Server
NFS Client
nfs-utils
/etc/exports
Export Options
exportfs
showmount
NFS Mounting
/etc/fstab
NFS Troubleshooting
```

A useful troubleshooting path is:

```text
Server Storage
      ↓
Filesystem Permission
      ↓
SELinux
      ↓
Export
      ↓
NFS Service
      ↓
Firewall
      ↓
Network
      ↓
Client Mount
```

---

# 28. Linux Bridge

File:

```text
linux-bridge-lab.md
```

Topics include:

```text
Linux Bridge
Layer 2 Forwarding
NetworkManager Bridge
Bridge Ports
br0
STP
Legacy brctl
Virtualization Networking Concepts
```

Important distinction:

```text
Bridge
→ Layer 2 forwarding
```

```text
Router
→ Layer 3 forwarding
```

and:

```text
Bridge
→ Connects Layer 2 interfaces
```

```text
Team
→ Link redundancy / aggregation
```

---

# 29. AutoFS

File:

```text
autofs-management-lab.md
```

Topics include:

```text
AutoFS
Master Maps
Direct Maps
Indirect Maps
Wildcard Keys
& Substitution
NFS Automount Concepts
```

Important distinction:

```text
Direct Map
→ Full mount path is defined in the map
```

```text
Indirect Map
→ Child keys are managed beneath a parent path
```

---

# 30. Samba and CIFS

File:

```text
samba-cifs-management-lab.md
```

Topics include:

```text
SMB
Samba
smb Service
/etc/samba/smb.conf
Linux Users
Samba Users
smbpasswd
SMB Shares
Share Permissions
Linux Filesystem Permissions
cifs-utils
mount -t cifs
/etc/fstab
```

Important distinction:

```text
SMB
→ Protocol family

Samba
→ Linux / Unix SMB implementation

CIFS mount interface
→ Linux SMB client filesystem interface
```

Share configuration and Linux filesystem permissions must both allow the intended operation.

---

# 31. Apache HTTP Server

File:

```text
apache-httpd-management-lab.md
```

Topics include:

```text
httpd
Apache Service Management
DocumentRoot
Directory Policies
firewalld
curl
Virtual Hosting
ServerName
Apache Logs
Modules
mod_ssl
mod_php
mod_wsgi
SELinux Considerations
```

A useful web-service troubleshooting path is:

```text
Content
   ↓
Apache Configuration
   ↓
httpd
   ↓
Listening Socket
   ↓
Firewall
   ↓
Network
   ↓
DNS
   ↓
Client
```

---

# 32. BIND and Unbound

File:

```text
dns-bind-unbound-management-lab.md
```

Topics include:

```text
BIND
named.conf
Authoritative Zones
Forward Zones
Reverse Zones
SOA
NS
A
PTR
Zone Transfers
Unbound
Caching Resolver
Forwarding Resolver
firewalld
dig
DNS Troubleshooting
```

General DNS protocol fundamentals remain under:

```text
../network/dns-fundamentals-lab.md
```

This Linux lab focuses on implementing and operating DNS services.

---

# 33. Host Network Security Hardening

File:

```text
host-network-security-hardening-lab.md
```

Topics include:

```text
Package Inventory
Service Inventory
Listening Ports
Attack Surface Reduction
SSH Hardening
PermitRootLogin
PasswordAuthentication
AllowUsers
AllowGroups
firewalld
SELinux
SELinux Port Labels
TLS
Self-Signed Certificates
Security Updates
CVE Awareness
```

The focus is defense in depth.

```text
Software Minimization
        ↓
Service Minimization
        ↓
Remote Access Control
        ↓
Firewall
        ↓
SELinux
        ↓
TLS
        ↓
Patch Management
```

No single security control is treated as sufficient on its own.

---

# Linux Troubleshooting Method

Troubleshooting across the Linux labs follows:

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

The objective is to avoid:

```text
Random Restart
Random Reconfiguration
Disabling Security Controls
Changing Several Layers at Once
```

before evidence has been collected.

---

# Service Troubleshooting

A service should be investigated across multiple layers.

```text
Process
   ↓
systemd Service
   ↓
Listening Socket
   ↓
Firewall
   ↓
Network
   ↓
SELinux
   ↓
Authentication
   ↓
Application
```

For example:

```text
systemctl status SERVICE
```

showing:

```text
active
```

does not automatically prove that a remote client can reach or use the service.

---

# Runtime vs Persistent Configuration

This distinction appears throughout Linux administration.

```text
Runtime State
!=
Persistent Configuration
```

Examples:

```text
systemctl start
vs
systemctl enable
```

```text
ip addr
vs
NetworkManager profile
```

```text
mount
vs
/etc/fstab
```

```text
firewalld runtime
vs
firewalld permanent
```

```text
sysctl -w
vs
persistent sysctl configuration
```

Infrastructure changes should always be evaluated in both contexts.

---

# Linux Network Administration vs Network Fundamentals

Linux-specific networking remains in this directory.

Examples:

```text
network-management-lab.md
network-teaming-lab.md
linux-bridge-lab.md
ssh-basic-lab.md
nfs-management-lab.md
samba-cifs-management-lab.md
dns-bind-unbound-management-lab.md
```

General networking concepts remain under:

```text
../network/
```

Examples:

```text
OSI
Ethernet
IPv4
IPv6
ARP
Routing
Routing Protocols
DNS Fundamentals
Network Troubleshooting
```

This prevents protocol theory and Linux implementation from being mixed into one large topic.

---

# Security Principles

The Linux labs follow several security principles.

```text
Do not disable SELinux as a generic fix.

Do not disable firewalls merely to restore connectivity.

Do not expose unnecessary services.

Do not commit passwords or authentication secrets.

Do not commit SSH private keys.

Do not commit TLS private keys.

Verify another SSH login method before disabling password authentication.

Keep a recovery path when modifying remote network or SSH configuration.
```

---

# Evidence Policy

Course screenshots and example output are not actual lab evidence.

Do not fabricate:

```text
PIDs
IP addresses
MAC addresses
UUIDs
Interface names
Routes
SSH fingerprints
Service output
DNS responses
Logs
```

Environment-specific values should be recorded only after they are observed on the actual lab system.

---

# Legacy and Modern Tools

Some course materials use legacy Linux commands.

They remain useful for understanding older environments.

Modern alternatives are documented where appropriate.

```text
ifconfig
→ ip addr / ip link

route
→ ip route

arp
→ ip neigh

netstat
→ ss

network-scripts
→ NetworkManager / nmcli

brctl
→ ip / NetworkManager tools
```

The purpose is to understand both the training material and current Linux administration practice.

---

# Current Linux Progress

The current Linux administration path includes:

```text
Linux Fundamentals
Shell
Bash Automation
Processes
Services
Packages
Users and Groups
Scheduled Jobs
Storage
Filesystems
LVM
RAID
Memory and Swap
Boot and Kernel
Backup and Recovery
Logs
Firewall
SELinux
NetworkManager
OpenSSH
Network Teaming
NFS
Linux Bridge
AutoFS
Samba / CIFS
Apache HTTP Server
BIND / Unbound
Host Security Hardening
```

The next networking study continues under:

```text
../network/
```

with packet analysis after the current network-troubleshooting material.

---

# What This Directory Demonstrates

This directory is intended to demonstrate progression from basic Linux usage toward infrastructure operations.

```text
Linux Commands
      ↓
System Administration
      ↓
Service Configuration
      ↓
Security Controls
      ↓
Network Services
      ↓
Troubleshooting
      ↓
Operational Reasoning
```

The target is not:

```text
"I know this command."
```

The target is:

```text
"I understand what this component should do,
how to inspect its actual state,
how to identify why it failed,
and how to verify recovery."
```
