# Docker and Container Infrastructure Labs

This directory documents my Docker and container-infrastructure studies as part of my cloud infrastructure engineering learning path.

The focus is not only on Docker commands, but on understanding how containers are built from Linux kernel features, how images become running workloads, how reproducible images are built and distributed, how containers communicate, and how multi-container applications are defined as repeatable infrastructure.

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
├── docker-networking-lab.md
└── docker-compose-lab.md
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

Multi-stage builds separate build tooling from the final runtime environment.

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

---

# 9. Docker Compose

File:

```text
docker-compose-lab.md
```

Topics include:

```text
Docker Compose
YAML
Compose Projects
Services
Images
Restart Policies
Ports
Volumes
Environment Variables
Service Discovery
Service Names
Multi-Container Applications
Compose Lifecycle Commands
WordPress
MySQL
Compose Troubleshooting
```

Compose changes the operational unit from an individual container to an application project.

```text
Compose Project
├── Application Service
├── Database Service
├── Network
└── Storage
```

The runtime definition can be represented as:

```text
compose.yaml
      ↓
docker compose up
      ↓
Multi-Container Application
```

Dockerfile and Compose solve different problems.

```text
Dockerfile
→ How an image is built
```

```text
Compose
→ How application services run together
```

Service-name-based communication avoids unnecessary dependence on runtime container IP addresses.

```text
Application Service
       ↓
Service Name
       ↓
Dependent Service
```

Compose also establishes an important foundation for later container orchestration.

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

These concepts are directly applied to:

```text
Docker Bridge Networks
Custom Container Networks
Container-to-Container Communication
Container Name Resolution
Port Publishing
Host Networking
Overlay Networking
Registry Connectivity
Compose Service Discovery
```

---

# Dockerfile, Registry, and Compose Relationship

The application-delivery workflow can now be represented as:

```text
Source Code
    ↓
Dockerfile
    ↓
Image Build
    ↓
Container Image
    ↓
Registry
    ↓
Compose Definition
    ↓
Multi-Container Application
```

Each component has a different responsibility.

```text
Dockerfile
→ Build artifact definition
```

```text
Registry
→ Artifact distribution
```

```text
Compose
→ Runtime application definition
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
Docker network state
Container addressing
Service name resolution
Routing
Port mappings
Volume configuration
Compose service state
Registry state
```

---

# Compose Troubleshooting

A multi-container application should be investigated as a project.

```text
Compose Definition Valid?
        ↓
Images Available?
        ↓
docker compose ps
        ↓
Which Service Failed?
        ↓
docker compose logs
        ↓
Service Discovery?
        ↓
Environment Configuration?
        ↓
Network?
        ↓
Storage?
        ↓
Port Publishing?
        ↓
Application Ready?
```

Do not assume that the user-facing container is the root cause.

A dependency service may be responsible for the visible failure.

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
Service Discovery
Published Ports
Mounted Storage
Resource Usage
Compose Dependency State
```

A successful image build does not prove that a containerized application will run or communicate correctly.

---

# Runtime vs Persistent Definition

Container infrastructure repeatedly reinforces:

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
Manual docker run Options
vs
Compose YAML
```

```text
Container Writable Layer
vs
Persistent Volume Data
```

```text
Expected Compose Services
vs
Observed Runtime State
```

This distinction is essential for reproducible infrastructure.

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
Runtime Definition
    ↓
Container Deployment
```

This connects directly to CI/CD and immutable-infrastructure practices.

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
docker compose ps
docker compose logs
```

Different tools answer different questions.

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
Compose Deployments
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

Multi-container applications should also define which services require persistent data rather than assuming container-local storage is permanent.

---

# Security Principles

Container security is treated as part of infrastructure design.

Important principles include:

```text
Use trusted base images.
Keep build contexts minimal.
Do not expose secrets in Dockerfiles.
Do not commit real secrets in Compose files.
Treat Docker daemon access as highly privileged.
Run applications with least privilege.
Avoid unnecessary build tools in runtime images.
Use multi-stage builds when appropriate.
Review exposed and published ports.
Use network modes intentionally.
Limit service connectivity to what is required.
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
Compose Service States
Database Connection Results
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
docker-compose standalone CLI
Compose version: "3"
MySQL 5.7 example
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
Docker Compose
Compose YAML
Compose Project Management
Compose Service Discovery
Compose Ports and Volumes
Compose Environment Configuration
Multi-Container WordPress / MySQL Architecture
Compose Troubleshooting
```

The next major topics are:

```text
Container Clustering
Docker Swarm
Service Discovery in Clusters
Cluster Scheduling
High Availability
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

The objective is to understand not only how to run containers, but how to build, connect, compose, inspect, distribute, diagnose, secure, and operate containerized infrastructure.
