# Docker and Container Infrastructure Labs

This directory documents my Docker and container-infrastructure studies as part of my cloud infrastructure engineering learning path.

The focus is not only on Docker commands, but on understanding how containers are built from Linux kernel features, how images become running workloads, how reproducible images are built and distributed, and how container infrastructure connects to cloud-native application delivery.

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
├── dockerfile-image-build-lab.md
├── container-management-lab.md
└── registry-management-lab.md
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

Multi-stage builds separate build tooling from the final runtime image.

```text
Build Stage
    ↓
Artifact
    ↓
Runtime Stage
```

---

# 6. Docker Container Management

File:

```text
container-management-lab.md
```

Topics include:

```text
docker cp
docker diff
docker commit
docker inspect
docker events
docker logs
docker export
docker import
docker save
docker load
docker top
docker stats
docker system df
```

The operational troubleshooting model is:

```text
Container Failure
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

Additional evidence can be collected using:

```text
docker events
docker cp
Linux system logs
Host resource state
```

Container evidence should be collected before destructive recovery actions when root-cause analysis is required.

A fundamental archive distinction is:

```text
export / import
→ Container filesystem workflow
```

```text
save / load
→ Docker image workflow
```

---

# 7. Docker Registry Management

File:

```text
registry-management-lab.md
```

Topics include:

```text
Docker Registry
Docker Hub
Repositories
Image References
docker tag
docker login
docker push
docker pull
Private Registry
Multi-Host Image Distribution
CI/CD Context
Registry Security
```

The image distribution workflow is:

```text
Dockerfile
    ↓
Build
    ↓
Image
    ↓
Tag
    ↓
Push
    ↓
Registry
    ↓
Pull
    ↓
Deployment Host
    ↓
Container
```

A registry separates image build from image execution and provides a common distribution point for multiple hosts.

This concept becomes especially important in Kubernetes and other container-orchestration environments.

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

Linux Storage
→ Docker host storage

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
Registry Connectivity
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
Docker events
Container filesystem changes
Process state
Resource usage
Network configuration
Port mappings
Volume configuration
Registry state
```

Do not immediately recreate, restart, or rebuild a failing workload before collecting useful evidence.

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
Container State
Exit Code
Application Logs
Process State
Published Ports
Mounted Storage
Resource Usage
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
Source Code
    ↓
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

# Container Evidence

A container should be treated as an observable runtime object.

Useful evidence sources include:

```text
docker inspect
docker logs
docker events
docker diff
docker top
docker stats
docker cp
```

Different tools answer different questions.

```text
inspect
→ What is the configured/runtime state?

logs
→ What did the application report?

events
→ What lifecycle actions occurred?

diff
→ What changed in the writable filesystem?

top
→ What processes are running?

stats
→ What resources are being consumed?

cp
→ What files can be preserved for investigation?
```

---

# Image Archive Models

Docker provides different archive workflows.

```text
docker export / import
→ Container filesystem
```

```text
docker save / load
→ Docker image
```

The selected workflow should match the Docker object that needs to be preserved or transferred.

---

# Registry-Based Delivery

Container images can be treated as deployable artifacts.

```text
Build
 ↓
Image
 ↓
Registry
 ↓
Deployment
```

The registry becomes a dependency for:

```text
Image Distribution
Versioned Deployment
CI/CD
Multi-Host Infrastructure
Container Orchestration
```

---

# Registry Security

Registry infrastructure is part of the application software supply chain.

Important areas include:

```text
Authentication
Authorization
TLS
Credential Management
Trusted Image Sources
Image Digests
Image Scanning
Access Logging
Storage Protection
```

Registry credentials must not be committed to Git.

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
Protect registry credentials.
Use trusted registry sources.
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
Registry Addresses
Registry Authentication Results
Push / Pull Results
Exit Codes
Image Sizes
Resource Metrics
Command Output
```

Actual environment-specific evidence must come from the lab environment.

---

# Historical Material Policy

The Docker course contains historical terminology, products, versions, installation methods, and service policies.

Examples include:

```text
Docker Toolbox
Boot2Docker
Old Docker CE / EE models
Older Linux kernel requirements
Older Docker versions
Historical parent/child image terminology
Historical storage drivers
MAINTAINER
Historical Docker Hub repository quotas
```

These are preserved as course context.

Current infrastructure concepts should be distinguished from historical product policies.

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
Image Distribution Basics
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
Container File Transfer
Container Filesystem Diff
Container Commit
Container Inspection
Container Logs and Events
Container Export / Import
Image Save / Load
Container Process Monitoring
Container Resource Monitoring
Docker Storage Usage
Docker Hub
Image Tagging and Push
Private Registry Fundamentals
```

The next major topics are:

```text
Docker Networking
Bridge Network
Custom Network
Shared Container Network Namespace
Host Network
Docker Compose
YAML
Multi-Container Applications
Container Clustering
Docker Swarm
Kubernetes Introduction
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

The objective is to understand not only how to run containers, but how to build, inspect, distribute, diagnose, secure, and operate containerized infrastructure.
