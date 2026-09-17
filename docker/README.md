# Docker and Container Infrastructure Labs

This directory documents my Docker and container-infrastructure studies as part of my cloud infrastructure engineering learning path.

The focus is not only on Docker commands, but on understanding how containers are built from Linux kernel features, how images become running workloads, how reproducible images are built and distributed, and how container networking connects Linux networking to cloud-native application delivery.

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
├── registry-management-lab.md
└── docker-networking-lab.md
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

Container evidence should be collected before destructive recovery actions when root-cause analysis is required.

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

---

# 8. Docker Networking

File:

```text
docker-networking-lab.md
```

Topics include:

```text
Docker Network Drivers
Linux Network Namespaces
Bridge Networking
Custom Bridge Networks
Container Name Communication
Container Network Namespace Sharing
Host Networking
None Network
Macvlan
Overlay Networking
Docker Network Troubleshooting
```

The default conceptual model is:

```text
Container
    ↓
Network Namespace
    ↓
Virtual Interface
    ↓
Docker Bridge
    ↓
Host Network
```

Docker networking directly reuses Linux and general networking concepts.

```text
Linux Network Namespace
→ Container Network Isolation

Linux Bridge
→ Docker Bridge Networking

IP Subnet
→ Docker Network Addressing

Gateway / Routing
→ Container Reachability

DNS / Naming
→ Container Name Communication

TCP / UDP Ports
→ Container Services
```

A custom network can group related containers into an intentional communication domain.

```text
Custom Docker Network
       │
       ├── Container A
       └── Container B
```

Docker also supports intentionally sharing network namespaces.

```text
Container A
      ┐
      ├── Shared Network Namespace
Container B
      ┘
```

Host networking instead uses:

```text
Container Process
      ↓
Host Network Namespace
```

Overlay networking introduces the concept of container communication across multiple Docker hosts.

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

Linux Bridge
→ Docker bridge networking

Routing
→ Container reachability

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
Subnetting
Routing
DNS
Ports
Linux Bridges
Packet Analysis
```

These concepts are now directly applied to:

```text
Docker Bridge Networks
Custom Container Networks
Container-to-Container Communication
Container Name Resolution
Port Publishing
Host Networking
Overlay Networking
Registry Connectivity
```

Docker networking should be understood as an application of existing networking fundamentals.

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
Docker network state
Container addressing
Routing
Port mappings
Volume configuration
Registry state
```

Do not immediately recreate, restart, or rebuild a failing workload before collecting useful evidence.

---

# Docker Network Troubleshooting

A container network problem should be investigated layer by layer.

```text
Container Running?
      ↓
Correct Docker Network?
      ↓
Correct Network Driver?
      ↓
Network Attachment Present?
      ↓
Container Addressing Correct?
      ↓
Route / Gateway Correct?
      ↓
Name Resolution Works?
      ↓
Socket Listening?
      ↓
Port Published if Required?
      ↓
Application Responding?
```

Useful tools can include:

```text
docker network ls
docker network inspect
docker inspect
docker ps
ip
ss
curl
nc
Packet Capture
```

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
Docker Network
Container Addressing
Name Resolution
Published Ports
Mounted Storage
Resource Usage
```

A successful image build does not prove that a containerized application will run or communicate correctly.

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

```text
Runtime Network Attachment
vs
Declared Multi-Container Configuration
```

```text
Container Writable Layer
vs
Persistent Volume Data
```

This distinction becomes increasingly important when Docker Compose is introduced.

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
docker network inspect
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

network inspect
→ How is the workload connected?
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
Use network modes intentionally.
Do not use host networking only to bypass troubleshooting.
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
Routes
Gateway Addresses
Volume IDs
Registry Addresses
Registry Authentication Results
Push / Pull Results
Exit Codes
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
Historical network terminology
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
Docker Network Drivers
Custom Bridge Networks
Container Name Communication
Container Network Namespace Sharing
Host Networking
Macvlan Fundamentals
Overlay Network Fundamentals
Docker Network Troubleshooting
```

The next major topics are:

```text
Docker Compose
YAML
Multi-Container Applications
Compose Networking
Compose Storage
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

The objective is to understand not only how to run containers, but how to build, connect, inspect, distribute, diagnose, secure, and operate containerized infrastructure.
