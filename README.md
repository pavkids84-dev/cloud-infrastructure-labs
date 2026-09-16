# Cloud Infrastructure Labs

This repository documents my hands-on learning path toward cloud infrastructure engineering.

The repository is organized around three current foundations:

```text
Linux System Administration
        ↓
Network Fundamentals and Troubleshooting
        ↓
Containers and Docker
```

The focus is not simply on memorizing commands.

Each topic is studied through:

```text
Concept
   ↓
Architecture
   ↓
Configuration
   ↓
Observable State
   ↓
Troubleshooting
   ↓
Verification
```

The long-term goal is to build practical infrastructure skills that can later extend into:

```text
Kubernetes
Cloud Platforms
Infrastructure as Code
Observability
Automation
Cloud Security
```

---

# Repository Structure

```text
cloud-infrastructure-labs/
│
├── README.md
│
├── linux/
│   ├── README.md
│   ├── system-information-lab.md
│   ├── file-directory-permission-lab.md
│   ├── vi-basic-lab.md
│   ├── shell-basics-lab.md
│   ├── shell-environment-lab.md
│   ├── search-archive-compression-lab.md
│   ├── text-processing-lab.md
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
│   ├── host-network-security-hardening-lab.md
│   └── shell-script/
│       └── README.md
│
├── network/
│   ├── README.md
│   ├── osi-model-lab.md
│   ├── network-types-protocols-lab.md
│   ├── ethernet-lab.md
│   ├── ipv4-addressing-lab.md
│   ├── ipv6-addressing-lab.md
│   ├── arp-rarp-lab.md
│   ├── routing-fundamentals-lab.md
│   ├── routing-protocols-lab.md
│   ├── network-standards-lab.md
│   ├── dns-fundamentals-lab.md
│   ├── network-troubleshooting-lab.md
│   └── packet-analysis-lab.md
│
└── docker/
    ├── README.md
    ├── virtualization-container-foundations-lab.md
    ├── cloud-computing-cloud-native-foundations-lab.md
    ├── docker-engine-foundations-lab.md
    ├── image-container-lifecycle-lab.md
    ├── dockerfile-image-build-lab.md
    ├── container-management-lab.md
    └── registry-management-lab.md
```

Future directories will be added only after the corresponding topics are actually studied or reproduced.

---

# Linux System Administration

Directory:

```text
linux/
```

The Linux section establishes the operating-system foundation required for infrastructure engineering.

Topics currently covered include:

```text
System Information
Files and Directories
Permissions
vi
Shell Fundamentals
Shell Environment
Search
Archive and Compression
Text Processing
Bash Scripting
Processes
systemd Services
OpenSSH
Package Management
Users and Groups
Job Scheduling
Disk and Partition Management
Filesystems
LVM
RAID
Memory and Swap
Boot and Kernel
Backup and Recovery
Logging
firewalld
SELinux
Linux Networking
Network Teaming
NFS
Linux Bridge
AutoFS
Samba / CIFS
Apache HTTP Server
BIND / Unbound
Host Network Security Hardening
```

The section emphasizes the difference between:

```text
Runtime State
and
Persistent Configuration
```

Examples include:

```text
systemctl start
vs
systemctl enable

ip addr
vs
NetworkManager configuration

mount
vs
/etc/fstab

firewalld runtime rules
vs
permanent rules
```

Linux administration is treated as the base layer for later container and cloud infrastructure work.

---

# Network Fundamentals and Troubleshooting

Directory:

```text
network/
```

General networking theory is intentionally separated from Linux-specific network administration.

The network section covers:

```text
OSI Model
Network Types and Protocols
Ethernet
IPv4
IPv6
ARP
Routing
Dynamic Routing Protocols
Network Standards
DNS
Network Troubleshooting
Packet Analysis
```

The networking model progresses from protocol theory toward observable traffic.

```text
OSI Model
    ↓
Ethernet
    ↓
IP
    ↓
Routing
    ↓
DNS
    ↓
Transport
    ↓
Troubleshooting
    ↓
Packet Capture
```

Packet analysis introduces practical use of concepts such as:

```text
Ethernet Headers
IPv4 / IPv6 Headers
TCP Flags
Sequence and Acknowledgment Numbers
ARP Request / Reply
ICMP
IGMP
Wireshark Filters
Follow Stream
Flow Graph
Latency Analysis
```

This section provides the networking foundation required for Docker networking, Kubernetes networking, cloud VPCs, load balancers, and network security.

---

# Containers and Docker

Directory:

```text
docker/
```

The Docker section extends the Linux and networking foundations into containerized infrastructure.

The current learning path covers:

```text
Virtualization
    ↓
VM vs Container
    ↓
Cloud Computing
    ↓
Cloud-Native Architecture
    ↓
Linux Container Foundations
    ↓
Docker Engine
    ↓
Images
    ↓
Containers
    ↓
Dockerfile
    ↓
Image Build
    ↓
Persistent Data
    ↓
Container Management
    ↓
Registry
```

---

# Virtualization Foundations

The Docker learning path begins with virtualization concepts including:

```text
Emulation
QEMU
KVM
Hypervisors
Full Virtualization
Paravirtualization
libvirt
RAW
QCOW2
Snapshots
VM Migration
```

The key architectural distinction is:

```text
Virtual Machine
→ Hardware virtualization
→ Separate guest kernel
```

```text
Container
→ OS-level isolation
→ Shared host kernel
```

This provides the foundation for understanding why containers behave differently from virtual machines.

---

# Cloud-Native Foundations

The Docker section also connects containers to cloud architecture.

Topics include:

```text
IaaS
PaaS
SaaS
Cloud Responsibility Models
Private Cloud
Public Cloud
Hybrid Cloud
Microservices
REST / HTTP APIs
DevOps
CI/CD
Infrastructure as Code
Serverless
Containers
```

A simplified progression is:

```text
Cloud Infrastructure
        ↓
Cloud-Native Application
        ↓
Decoupled Services
        ↓
Containers
        ↓
Automated Delivery
```

Containers are studied as part of a wider cloud-native architecture rather than as an isolated Docker technology.

---

# Linux Container Foundations

Docker builds directly on Linux kernel concepts.

```text
Namespaces
→ Isolation and visibility
```

```text
cgroups
→ Resource accounting and control
```

Examples include:

```text
PID Namespace
Network Namespace
Mount Namespace
UTS Namespace
IPC Namespace
```

This reinforces an important principle:

```text
Container
!=
Small Virtual Machine
```

A container is better understood as an isolated process environment using the host kernel.

---

# Docker Engine Architecture

The Docker architecture studied so far is:

```text
User
 ↓
Docker CLI
 ↓
Docker API
 ↓
Docker Daemon
 ├── Images
 ├── Containers
 ├── Networks
 └── Volumes
       ↕
    Registry
```

This architecture connects Docker commands to the actual objects being managed.

---

# Image and Container Lifecycle

Docker images and containers are treated as separate objects.

```text
Image
→ Reusable artifact
```

```text
Container
→ Runtime instance created from an image
```

The relationship is:

```text
Registry
   ↓
Image
   ↓
Container
   ↓
Main Process
```

A fundamental runtime rule is:

```text
Main Process Running
→ Container Running
```

```text
Main Process Exits
→ Container Exits
```

This process model is important for both Docker and later Kubernetes troubleshooting.

---

# Dockerfile and Image Build

Dockerfiles are used to create reproducible images.

```text
Project Files
     ↓
.dockerignore
     ↓
Build Context
     ↓
Dockerfile
     ↓
docker build
     ↓
Image Layers
     ↓
Docker Image
```

Instructions currently studied include:

```text
FROM
RUN
COPY
ADD
ENV
USER
EXPOSE
ENTRYPOINT
CMD
VOLUME
```

Important distinctions include:

```text
RUN
→ Build time
```

```text
CMD / ENTRYPOINT
→ Container runtime
```

and:

```text
EXPOSE
→ Port metadata
```

```text
-p
→ Host-to-container port publishing
```

---

# Image Build Optimization

Docker image construction is also studied from an operational perspective.

Topics include:

```text
Build Context
.dockerignore
Image Layers
Build Cache
Instruction Ordering
Multi-Stage Builds
Least-Privilege Runtime Users
Minimal Runtime Images
```

A multi-stage build separates build tools from the final runtime image.

```text
Build Environment
      ↓
Application Artifact
      ↓
Runtime Environment
```

Potential benefits include:

```text
Smaller Images
Reduced Build Tooling
Reduced Attack Surface
Clear Build / Runtime Separation
```

---

# Persistent Data

Container runtime and persistent application data have separate lifecycles.

```text
Container
→ Replaceable runtime
```

```text
Volume / External Storage
→ Persistent data
```

Concepts currently introduced include:

```text
Dockerfile VOLUME
Bind Mounts
Shared Container Data
Image vs Data Lifecycle
```

Persistent data should not depend only on a disposable container writable layer.

---

# Container Management and Troubleshooting

Docker container state is investigated using evidence before destructive recovery actions.

Relevant tools currently include:

```text
docker ps
docker inspect
docker logs
docker events
docker top
docker stats
docker diff
docker cp
docker system df
```

A useful investigation sequence is:

```text
Container Problem
      ↓
docker ps -a
      ↓
docker inspect
      ↓
docker logs
      ↓
docker top
      ↓
docker stats
      ↓
docker diff
```

Additional evidence can be collected before restarting, rebuilding, or removing the failed container.

---

# Container and Image Archives

Docker provides different archive workflows.

```text
docker export
docker import
→ Container filesystem workflow
```

```text
docker save
docker load
→ Docker image workflow
```

These operations should not be treated as equivalent.

---

# Docker Registry

Container images can be distributed through registries.

```text
Source Code
    ↓
Dockerfile
    ↓
docker build
    ↓
Image
    ↓
docker tag
    ↓
docker push
    ↓
Registry
    ↓
docker pull
    ↓
Deployment Host
```

Current registry topics include:

```text
Docker Hub
Public Repositories
Private Repositories
Image References
Tags
Digests
docker login
docker push
docker pull
Private Registry
Multi-Host Image Distribution
```

Registry infrastructure is also connected to future CI/CD and Kubernetes workflows.

---

# Linux, Network, and Docker Relationship

The three current repository areas are intentionally connected.

```text
Linux
→ Processes
→ Filesystems
→ Users
→ Services
→ Storage
→ Security

Network
→ Ethernet
→ IP
→ Routing
→ DNS
→ Ports
→ Packet Analysis

Docker
→ Namespaces
→ cgroups
→ Images
→ Containers
→ Storage
→ Registries
```

For example:

```text
Linux Process Management
        ↓
Container Process Model
```

```text
Linux Bridge
        ↓
Docker Bridge Networking
```

```text
Linux Users and Permissions
        ↓
Docker USER / Least Privilege
```

```text
Network Ports
        ↓
Container Port Publishing
```

```text
DNS and Routing
        ↓
Container and Registry Connectivity
```

The goal is to understand Docker as an extension of Linux and networking concepts rather than as an isolated command-line tool.

---

# Troubleshooting Method

Infrastructure troubleshooting throughout this repository follows:

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

The process begins by observing state rather than immediately changing configuration.

---

# Layered Troubleshooting

A general infrastructure troubleshooting model is:

```text
Physical / Host
      ↓
Operating System
      ↓
Network
      ↓
Service / Runtime
      ↓
Container
      ↓
Application
```

For network-oriented failures:

```text
Interface
   ↓
Address
   ↓
Neighbor
   ↓
Route
   ↓
DNS
   ↓
Port
   ↓
Service
   ↓
Application
```

For Docker-oriented failures:

```text
Docker Service
      ↓
Docker Daemon
      ↓
Image
      ↓
Container State
      ↓
Main Process
      ↓
Network / Storage
      ↓
Application
```

---

# Service Troubleshooting

A running service is not automatically reachable.

A useful model is:

```text
Process Running
      ↓
Socket Listening
      ↓
Firewall
      ↓
Routing / Network Path
      ↓
Security Policy
      ↓
Application Protocol
```

This principle applies to Linux services, Docker containers, and later cloud workloads.

---

# Runtime vs Persistent Configuration

A recurring infrastructure principle is:

```text
Runtime State
!=
Persistent Definition
```

Examples include:

```text
systemctl start
vs
systemctl enable
```

```text
ip addr
vs
NetworkManager configuration
```

```text
mount
vs
/etc/fstab
```

```text
Running Container
vs
Dockerfile / Image
```

```text
Container Writable Layer
vs
Persistent Volume Data
```

Understanding which state survives restart or recreation is essential for reliable infrastructure operations.

---

# Immutable Infrastructure

Container infrastructure reinforces the idea of rebuilding and replacing workloads instead of repeatedly modifying them in place.

```text
Definition Change
      ↓
New Image
      ↓
Validation
      ↓
Deployment
      ↓
Replacement
```

This helps reduce configuration drift and improves reproducibility.

---

# Security Approach

Security is treated as part of infrastructure operation rather than as a separate final step.

Current principles include:

```text
Least Privilege
Minimal Installed Software
Trusted Package and Image Sources
Restricted Service Exposure
Firewall Enforcement
SELinux
SSH Hardening
Non-Root Container Execution
Minimal Runtime Images
Protected Secrets
Protected Registry Credentials
Trusted Container Images
```

Containers should not automatically be assumed to provide a complete security boundary.

---

# Evidence Policy

Course screenshots and example command output are educational examples.

They are not recorded as real lab evidence.

This repository does not fabricate:

```text
IP Addresses
MAC Addresses
Process IDs
Container IDs
Image IDs
Image Digests
Network IDs
Volume IDs
Routes
Packet Captures
Registry Results
Exit Codes
Resource Metrics
Command Output
```

Actual environment-specific evidence should come from the system where the exercise was performed.

---

# Historical Material Policy

Training materials can contain historical commands, versions, products, and terminology.

Examples encountered so far include:

```text
ifconfig
route
arp
netstat
Docker Toolbox
Boot2Docker
Older Docker CE / EE models
Older Docker version requirements
Historical Docker storage drivers
MAINTAINER
Historical Docker Hub policies
```

Historical material is preserved for context while modern concepts and alternatives are distinguished where relevant.

---

# Current Progress

Completed major areas include:

```text
Linux Fundamentals
Linux System Administration
Linux Service Administration
Linux Storage
Linux Security
Linux Networking
Network Fundamentals
IPv4 / IPv6
ARP
Routing
DNS
Network Troubleshooting
Packet Analysis
Virtualization Foundations
Cloud Computing Foundations
Cloud-Native Concepts
Linux Container Foundations
Docker Engine Architecture
Docker Image Lifecycle
Docker Container Lifecycle
Dockerfile
Image Build and Cache
Multi-Stage Builds
Persistent Storage Fundamentals
Docker Container Management
Docker Registry Fundamentals
```

The next Docker topics are:

```text
Docker Networking
Custom Networks
Shared Network Namespaces
Host Networking
Docker Compose
YAML
Multi-Container Applications
Docker Clustering
Docker Swarm
Kubernetes Introduction
```

---

# Planned Expansion

As the learning path continues, additional top-level areas can be created when enough actual study and lab evidence exists.

Potential future areas include:

```text
kubernetes/
aws/
terraform/
```

They should not be created only as placeholders.

---

# Long-Term Infrastructure Path

The current learning path is:

```text
Linux
   ↓
Networking
   ↓
Containers
   ↓
Docker
   ↓
Kubernetes
   ↓
Cloud Infrastructure
   ↓
Infrastructure as Code
   ↓
Cloud Security
```

The objective is to develop the ability to understand, operate, troubleshoot, automate, and secure infrastructure rather than only memorize individual tools.

---

# What This Repository Demonstrates

This repository documents progression from basic operating-system knowledge toward infrastructure-level reasoning.

```text
Theory
   ↓
Configuration
   ↓
Runtime Observation
   ↓
Failure Analysis
   ↓
Troubleshooting
   ↓
Verification
   ↓
Automation
```

The central questions throughout the repository are:

```text
What should happen?

What actually happened?

Which layer is responsible?

What evidence supports the conclusion?

What change resolves the issue?

How was recovery verified?
```
