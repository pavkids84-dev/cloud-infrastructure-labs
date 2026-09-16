# Docker and Container Infrastructure Labs

This directory documents my Docker and container-infrastructure studies as part of my cloud infrastructure engineering learning path.

The focus is not only on Docker commands, but on understanding how containers are built from Linux kernel features, how images become running workloads, how reproducible images are built, and how container infrastructure connects to cloud-native application delivery.

The learning path currently progresses through:

```text
Virtualization
    ↓
Virtual Machines
    ↓
Containers
    ↓
Cloud Computing
    ↓
Cloud-Native Architecture
    ↓
Docker Engine
    ↓
Docker Images
    ↓
Container Lifecycle
    ↓
Dockerfile
    ↓
Image Build and Layers
    ↓
Multi-Stage Builds
    ↓
Persistent Storage
    ↓
Container Management
    ↓
Registry
    ↓
Docker Networking
    ↓
Docker Compose
    ↓
Container Clustering
```

---

# Directory Structure

Current files:

```text
docker/
├── README.md
├── virtualization-container-foundations-lab.md
├── cloud-computing-cloud-native-foundations-lab.md
├── docker-engine-foundations-lab.md
├── image-container-lifecycle-lab.md
└── dockerfile-image-build-lab.md
```

Additional files will be added only after the corresponding topics are studied.

---

# 1. Virtualization and Container Foundations

File:

```text
virtualization-container-foundations-lab.md
```

Topics include:

```text
Emulation
Virtualization
Type 1 Hypervisors
Type 2 Hypervisors
QEMU
KVM
Full Virtualization
Paravirtualization
libvirt
virsh
virt-manager
RAW
QCOW2
Copy-on-Write
Snapshots
VM Migration
Virtual Machines
Containers
Namespaces
cgroups
```

The core distinction is:

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

---

# 2. Cloud Computing and Cloud-Native Foundations

File:

```text
cloud-computing-cloud-native-foundations-lab.md
```

Topics include:

```text
IaaS
PaaS
SaaS
Management Responsibility
Private Cloud
Community Cloud
Public Cloud
Hybrid Cloud
Cloud Native
DevOps
REST / HTTP APIs
Microservices
CI/CD
Containers
Infrastructure as Code
Serverless
```

This section establishes why containers are commonly used in modern cloud-native application delivery.

---

# 3. Docker Engine Foundations

File:

```text
docker-engine-foundations-lab.md
```

Topics include:

```text
OS-Level Isolation
Namespaces
cgroups
System Containers
Application Containers
Docker Engine
Docker Client
Docker Daemon
REST API
Images
Containers
Networks
Volumes
Registry
Docker Installation Concepts
systemd Service Management
```

The central Docker architecture is:

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

---

# 4. Docker Image and Container Lifecycle

File:

```text
image-container-lifecycle-lab.md
```

Topics include:

```text
Docker Images
Image Layers
Repositories
Tags
Image IDs
Digests
Docker Hub
Image Pull and Removal
Containers
Container Creation
Container State
Container PID 1
Interactive Containers
Detached Containers
Container Start / Stop / Restart
Pause / Unpause
Container Removal
docker exec
Image vs Container Lifecycle
```

The core relationship is:

```text
Registry
   ↓
Image
   ↓
Container
   ↓
Main Process
```

A fundamental runtime principle is:

```text
Main Process Running
→ Container Running
```

```text
Main Process Exits
→ Container Exits
```

---

# 5. Dockerfile and Image Build

File:

```text
dockerfile-image-build-lab.md
```

Topics include:

```text
Dockerfile
Build Context
.dockerignore
docker build
FROM
CMD
ENTRYPOINT
ENV
EXPOSE
COPY
ADD
RUN
USER
Image Layers
Build Cache
Multi-Stage Builds
VOLUME
Persistent Data
docker history
```

The image build workflow is:

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

Runtime behavior is separated from build behavior.

```text
RUN
→ Build time
```

```text
CMD / ENTRYPOINT
→ Container runtime
```

Multi-stage builds separate build tooling from the final runtime image.

```text
Build Stage
    ↓
Artifact
    ↓
Runtime Stage
```

This can reduce runtime image size and unnecessary software.

---

# Linux Foundations Behind Docker

Docker depends heavily on Linux concepts already studied under:

```text
../linux/
```

Important relationships include:

```text
Linux Processes
→ Container processes

PID Namespaces
→ Container process isolation

Network Namespaces
→ Container network isolation

Mount Namespaces
→ Filesystem isolation

cgroups
→ Container resource control

Users and Groups
→ Container execution identity

Filesystem Permissions
→ Container filesystem access

systemd
→ Docker service management

Networking
→ Container networking

Linux Bridge
→ Container bridge-network concepts

Logs
→ Container troubleshooting
```

Docker administration therefore extends Linux system administration rather than replacing it.

---

# Network Foundations Behind Docker

General networking concepts are documented under:

```text
../network/
```

Important relationships include:

```text
Ethernet
IP Addressing
Routing
DNS
Ports
Bridges
Packet Analysis
```

These concepts become important when studying:

```text
Docker Bridge Networks
Port Publishing
Container-to-Container Communication
DNS-Based Service Discovery
Host Networking
Overlay Networking
```

---

# Learning Method

Each Docker topic should progress through:

```text
Concept
   ↓
Architecture
   ↓
Definition
   ↓
Build / Runtime Action
   ↓
Observable State
   ↓
Failure Scenario
   ↓
Troubleshooting
   ↓
Verification
```

Commands alone are not considered sufficient evidence of understanding.

---

# Troubleshooting Method

Docker troubleshooting follows:

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

Relevant evidence can include:

```text
Linux service state
Docker daemon state
Build output
Image history
Image state
Container state
Container exit state
Container logs
Network configuration
Port mappings
Volume configuration
Resource usage
```

Do not immediately recreate or rebuild a failing workload before collecting useful evidence.

---

# Build-Time vs Runtime Troubleshooting

Docker image builds and container runtime failures are different problem domains.

Build-time investigation can include:

```text
Dockerfile Instruction
Build Context
.dockerignore
Base Image
Package Availability
File Paths
Permissions
Build Cache
```

Runtime investigation can include:

```text
ENTRYPOINT
CMD
Environment Variables
Container User
Published Ports
Mounted Storage
Application Logs
Process Exit State
```

A successful image build does not prove that a containerized application will run correctly.

---

# Runtime vs Persistent State

Container infrastructure reinforces the distinction:

```text
Runtime State
!=
Persistent Definition
```

Examples include:

```text
Running Container
vs
Dockerfile / Image
```

and:

```text
Container Writable Layer
vs
Persistent Volume Data
```

Container-local runtime changes can disappear when a container is removed and recreated unless state is intentionally persisted.

---

# Image-Based Infrastructure

Docker introduces an image-based deployment model.

```text
Dockerfile
    ↓
Image
    ↓
Registry
    ↓
Container Deployment
```

This supports repeatable deployment and connects directly to CI/CD and immutable-infrastructure practices.

---

# Build Context Discipline

Only files required for the image build should be included in the build context.

Use `.dockerignore` to reduce:

```text
Unnecessary Files
Large Artifacts
Version-Control Metadata
Temporary Content
Sensitive Local Files
```

Build contexts should be intentionally designed rather than treated as arbitrary directory uploads.

---

# Dockerfile Instruction Model

The main Dockerfile instructions studied so far are:

```text
FROM
→ Base image

RUN
→ Build-time command

COPY / ADD
→ Add content to image

ENV
→ Environment configuration

USER
→ Execution identity

EXPOSE
→ Port metadata

ENTRYPOINT
→ Primary runtime executable

CMD
→ Default runtime command / arguments

VOLUME
→ Persistent-data mount point
```

---

# Build Cache

Dockerfile ordering can affect rebuild performance.

A useful strategy is:

```text
Stable Dependencies
       ↓
Stable Configuration
       ↓
Frequently Changing Application Content
```

The goal is to preserve useful cache layers without sacrificing correctness or readability.

---

# Multi-Stage Builds

Multi-stage builds separate build-time requirements from runtime requirements.

```text
Build Environment
      ↓
Application Artifact
      ↓
Minimal Runtime Environment
```

Potential benefits include:

```text
Smaller Runtime Images
Reduced Build Tooling in Production
Reduced Attack Surface
Clear Build and Runtime Separation
```

---

# Persistent Data

Container runtime and application data should have intentionally designed lifecycles.

```text
Container
→ Replaceable runtime
```

```text
Volume / External Storage
→ Persistent application data
```

Host-path bind mounts and Docker-managed volumes are conceptually different and should be selected intentionally.

---

# Security Principles

Container security is treated as part of infrastructure design.

Important principles include:

```text
Use trusted base images.
Keep build contexts minimal.
Do not expose secrets in Dockerfiles.
Treat Docker daemon access as highly privileged.
Run applications with least privilege.
Avoid unnecessary build tools in runtime images.
Use multi-stage builds when appropriate.
Review exposed and published ports.
Keep persistent data separate from replaceable containers.
Do not assume a container is a complete security boundary.
```

---

# Evidence Policy

Course screenshots and example command output are educational examples.

Do not record them as actual lab evidence.

Do not fabricate:

```text
Container IDs
Image IDs
Image Digests
Layer IDs
Build Cache Results
Process IDs
IP Addresses
MAC Addresses
Network IDs
Volume IDs
File Ownership
Registry Results
Exit Codes
Image Sizes
Command Output
```

Actual environment-specific evidence must come from the lab environment.

---

# Historical Material Policy

The Docker course contains historical terminology, products, versions, and installation methods.

Examples can include:

```text
Docker Toolbox
Boot2Docker
Old Docker CE / EE models
Older Linux kernel requirements
Older Docker versions
Historical parent/child image terminology
Historical storage drivers
MAINTAINER
```

These are preserved as course context.

Current infrastructure concepts should be distinguished from historical implementation details.

---

# Current Learning Progress

Completed Docker-related areas:

```text
Virtualization Foundations
VM vs Container
Cloud Computing
Cloud Service Models
Cloud-Native Architecture
Microservices Context
Linux Container Foundations
Docker Engine Architecture
Docker Client / Daemon / Registry
Docker Installation Concepts
Docker Images
Image Layers
Image Distribution
Container Creation
Container Lifecycle
Container PID 1
Interactive / Detached Containers
docker exec
Dockerfile
Build Context
.dockerignore
Dockerfile Runtime Instructions
Dockerfile Build Instructions
Image Build Cache
Container User
Multi-Stage Builds
Volume Fundamentals
Image History
```

The next major topics are:

```text
Container Management
File Copy and Filesystem Changes
Container Commit
Inspection
Logs and Events
Image Export / Import
Image Save / Load
Resource Statistics
Docker Hub
Private Registry
Docker Networking
Docker Compose
Docker Clustering
```

---

# Long-Term Infrastructure Path

This Docker learning path connects to:

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

The objective is to understand not only how to run containers, but how to build, diagnose, secure, and operate containerized infrastructure.
