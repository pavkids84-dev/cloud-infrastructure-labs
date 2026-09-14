# Cloud Infrastructure Labs

Hands-on infrastructure engineering labs focused on Linux administration, networking, troubleshooting, automation, and the foundations required for cloud infrastructure engineering.

This repository documents my learning process through:

```text
Theory
   ↓
Hands-On Practice
   ↓
System Observation
   ↓
Troubleshooting
   ↓
Evidence
   ↓
Recovery
   ↓
Infrastructure Engineering
```

The goal is not to collect commands.

The goal is to understand:

```text
How the system should work
What actually happened
How to collect evidence
How to identify the failing layer
How to recover safely
How to verify the result
```

---

# Repository Structure

```text
cloud-infrastructure-labs/
├── README.md
├── linux/
│   ├── README.md
│   ├── system-information-lab.md
│   ├── file-directory-permission-lab.md
│   ├── vi-basic-lab.md
│   ├── shell-basics-lab.md
│   ├── shell-environment-lab.md
│   ├── search-archive-compression-lab.md
│   ├── text-processing-lab.md
│   ├── shell-script/
│   ├── process-management-lab.md
│   ├── service-management-lab.md
│   ├── ssh-basic-lab.md
│   ├── package-management-lab.md
│   ├── user-management-lab.md
│   ├── job-scheduling-lab.md
│   ├── storage-management-lab.md
│   ├── filesystem-management-lab.md
│   ├── lvm-management-lab.md
│   ├── raid-management-lab.md
│   ├── memory-swap-management-lab.md
│   ├── boot-kernel-management-lab.md
│   ├── backup-recovery-lab.md
│   ├── log-management-lab.md
│   ├── firewall-management-lab.md
│   ├── selinux-management-lab.md
│   ├── network-management-lab.md
│   ├── network-teaming-lab.md
│   ├── nfs-management-lab.md
│   ├── linux-bridge-lab.md
│   ├── autofs-management-lab.md
│   ├── samba-cifs-management-lab.md
│   ├── apache-httpd-management-lab.md
│   ├── dns-bind-unbound-management-lab.md
│   └── host-network-security-hardening-lab.md
└── network/
    ├── README.md
    ├── osi-model-lab.md
    ├── network-types-protocols-lab.md
    ├── ethernet-lab.md
    ├── ipv4-addressing-lab.md
    ├── ipv6-addressing-lab.md
    ├── arp-rarp-lab.md
    ├── routing-fundamentals-lab.md
    ├── routing-protocols-lab.md
    ├── network-standards-lab.md
    ├── dns-fundamentals-lab.md
    └── network-troubleshooting-lab.md
```

---

# Main Learning Areas

The repository is currently organized into two major infrastructure foundations:

```text
Linux Administration
        +
Network Fundamentals
        ↓
Cloud Infrastructure Engineering
```

---

# Linux

Directory:

```text
linux/
```

Detailed roadmap:

[Linux Administration Labs](linux/README.md)

The Linux section focuses on operating-system administration and infrastructure services.

Major areas include:

```text
Linux Fundamentals
File and Directory Permissions
Shell Environment
Bash Scripting
Process Management
systemd Services
Package Management
Users and Groups
Scheduled Jobs
Storage
Filesystems
LVM
RAID
Memory and Swap
Boot and Kernel
Backup and Recovery
Logging
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

Linux networking content focuses on:

```text
How Linux configures and operates networking
```

rather than general network-protocol theory.

---

# Network

Directory:

```text
network/
```

Detailed roadmap:

[Network Fundamentals and Troubleshooting](network/README.md)

The networking section focuses on protocol behavior and infrastructure-level network reasoning.

Major areas currently include:

```text
OSI Model
Network Types
TCP/IP Model
Ethernet
IPv4
IPv6
ARP
Routing
Dynamic Routing Protocols
Network Standards
DNS Fundamentals
Network Troubleshooting
```

The next major networking topic is:

```text
Packet Analysis
```

It will be added only after the corresponding material and labs are actually completed.

---

# Linux vs Network Scope

The repository deliberately separates general networking theory from Linux-specific network administration.

## `network/`

Examples:

```text
Why ARP exists
How Ethernet forwarding works
How routing decisions are made
How DNS resolution works
How network layers interact
How network failures are isolated
```

## `linux/`

Examples:

```text
NetworkManager configuration
Linux routing configuration
Linux bridge configuration
Network teaming
OpenSSH administration
firewalld
SELinux networking policy
NFS
Samba
Apache
BIND / Unbound
```

This keeps protocol fundamentals separate from operating-system implementation.

---

# Learning Method

Each lab is intended to follow a progression similar to:

```text
Understand
    ↓
Configure
    ↓
Inspect
    ↓
Break or Observe Failure
    ↓
Collect Evidence
    ↓
Recover
    ↓
Verify
```

Commands are treated as tools for investigating infrastructure state rather than as isolated syntax to memorize.

---

# Troubleshooting Method

Troubleshooting work follows:

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

## Symptom

Describe exactly what failed.

## Evidence

Collect observable system or network state.

Examples include:

```text
systemctl
journalctl
ss
ip
dig
lsof
tcpdump
```

## Root Cause

Identify the actual failed layer or configuration.

## Resolution

Apply the smallest controlled change required to correct the problem.

## Verification

Repeat the original test and confirm normal operation.

A configuration change is not considered successful until it has been verified.

---

# Layered Troubleshooting

A common infrastructure troubleshooting path is:

```text
Application
     ↑
Service
     ↑
Listening Socket
     ↑
Firewall / Security Policy
     ↑
Routing
     ↑
IP Addressing
     ↑
Neighbor / Ethernet
     ↑
Interface / Link
```

This allows failures to be localized instead of changing unrelated configuration.

---

# Runtime vs Persistent Configuration

A recurring infrastructure principle throughout the repository is:

```text
Runtime State
!=
Persistent Configuration
```

Examples:

```text
systemctl start
→ Runtime service state

systemctl enable
→ Boot-time service configuration
```

```text
ip addr
→ Runtime network state

NetworkManager profile
→ Persistent network configuration
```

```text
mount
→ Runtime filesystem mount

/etc/fstab
→ Persistent mount configuration
```

```text
firewalld runtime rule
→ Current firewall state

firewalld permanent rule
→ Persistent firewall configuration
```

```text
sysctl -w
→ Runtime kernel parameter

sysctl configuration
→ Persistent kernel configuration
```

Understanding this distinction is essential for infrastructure operations.

---

# Service Troubleshooting Model

A service can be running while still being unreachable.

A useful model is:

```text
Process
   ↓
Service State
   ↓
Listening Socket
   ↓
Firewall
   ↓
Network Route
   ↓
Security Policy
   ↓
Authentication
   ↓
Application
```

For example:

```text
systemctl says active
```

does not automatically prove:

```text
Remote clients can use the service.
```

---

# Security Approach

Security labs focus on layered controls rather than disabling protections to make a service work.

Examples include:

```text
Package and Service Minimization
SSH Authentication
User / Group Access Restrictions
firewalld
SELinux
TLS
Security Updates
CVE Awareness
```

General rule:

```text
Do not disable security controls
without first identifying why the intended operation is blocked.
```

---

# Evidence Policy

Course screenshots and example values are not treated as actual runtime evidence.

The repository should not fabricate:

```text
IP addresses
MAC addresses
Interface names
PIDs
UUIDs
Routes
DNS responses
SSH fingerprints
Packet captures
Service output
Port-scan results
```

Environment-specific evidence should come from the system where the lab was actually performed.

---

# Secret Management

The following must never be committed:

```text
Passwords
SSH Private Keys
TLS Private Keys
Cloud Credentials
API Tokens
Authentication Secrets
Sensitive Packet Payloads
```

Public repositories should contain only sanitized and intentional evidence.

---

# Legacy and Modern Linux Commands

Some training materials include older Linux tools.

The repository preserves the concepts while also documenting current alternatives.

Examples:

```text
ifconfig
→ ip addr / ip link

route
→ ip route

arp
→ ip neigh

netstat
→ ss
```

The goal is to recognize legacy environments while building current Linux administration skills.

---

# Current Progress

Completed infrastructure foundations currently include:

```text
Linux Fundamentals
Bash and Shell Automation
Linux System Administration
Storage and Filesystems
Linux Security Controls
Linux Networking
Remote Access
Network File Services
Web Services
Linux DNS Services
Network Fundamentals
IP Addressing
ARP
Routing
DNS Fundamentals
Network Troubleshooting
```

The networking study is currently moving toward:

```text
Packet Analysis
```

---

# Future Expansion

Future top-level areas can be added when the corresponding hands-on study begins.

Possible areas include:

```text
docker/
kubernetes/
aws/
terraform/
```

These directories should not be created only for roadmap appearance.

They should be added when there is real study material, configuration, troubleshooting, or project evidence to document.

---

# Long-Term Infrastructure Path

The current learning progression is:

```text
Linux
   ↓
Networking
   ↓
Packet Analysis
   ↓
Containers
   ↓
Kubernetes
   ↓
Cloud Infrastructure
   ↓
Infrastructure as Code
   ↓
Operations and Observability
   ↓
Cloud Security
```

The repository will evolve as those areas are actually studied and practiced.

---

# Repository Goal

This repository is intended to demonstrate more than command familiarity.

The target capability is:

```text
Understand the architecture
        ↓
Observe real system state
        ↓
Identify failures
        ↓
Explain the root cause
        ↓
Recover safely
        ↓
Verify the result
```

That operational reasoning is the core skill being developed throughout these labs.
