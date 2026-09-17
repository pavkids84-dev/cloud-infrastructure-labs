# Docker and Container Infrastructure Labs

This directory documents my Docker and container-infrastructure studies as part of my cloud infrastructure engineering learning path.

The focus is not only on Docker commands, but on understanding how Linux container isolation becomes an image-based application platform and how that platform expands from individual containers to multi-container applications and cluster orchestration.

The completed Docker learning path is:

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
Images and Containers
    ↓
Dockerfile
    ↓
Image Build
    ↓
Storage
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
    ↓
Kubernetes
```

---

# Directory Structure

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
├── docker-compose-lab.md
└── container-clustering-foundations-lab.md
```

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
Hypervisors
QEMU
KVM
libvirt
RAW
QCOW2
Snapshots
VM Migration
VM vs Container
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
Cloud Responsibility Models
Private / Public / Hybrid Cloud
Cloud Native
Microservices
REST / HTTP APIs
DevOps
CI/CD
Infrastructure as Code
Serverless
Containers
```

This section establishes the architectural context in which container platforms are commonly used.

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
Docker Engine
Docker Client
Docker Daemon
REST API
Images
Containers
Networks
Volumes
Registry
systemd Service Management
```

Core architecture:

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
Images
Layers
Repositories
Tags
Digests
Image Pull / Removal
Container Creation
Container Lifecycle
Container PID 1
Interactive / Detached Containers
docker exec
```

Core relationship:

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
Build Cache
Image Layers
Multi-Stage Builds
docker history
```

Build workflow:

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
Image
```

Build-time and runtime instructions are treated separately.

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

Operational troubleshooting emphasizes evidence collection before destructive recovery.

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
Image References
Tags
Digests
docker login
docker push
docker pull
Private Registry
Multi-Host Distribution
Registry Security
CI/CD Context
```

Image-delivery workflow:

```text
Dockerfile
    ↓
Image
    ↓
Registry
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
Network Namespaces
Bridge Networks
Custom Networks
Container Name Communication
Shared Network Namespaces
Host Networking
None Network
Macvlan
Overlay Networking
Docker Network Troubleshooting
```

Docker networking directly reuses Linux and general networking concepts.

```text
Linux Network Namespace
→ Container Network Isolation

Linux Bridge
→ Docker Bridge Network

IP / Routing
→ Container Reachability

DNS / Naming
→ Container Name Communication

TCP / UDP Ports
→ Container Services
```

---

# 9. Docker Compose

File:

```text
docker-compose-lab.md
```

Topics include:

```text
Compose Projects
YAML
Services
Images
Ports
Volumes
Environment Variables
Service Discovery
Service Names
Restart Policies
Multi-Container Applications
Compose Troubleshooting
```

Dockerfile and Compose have different responsibilities.

```text
Dockerfile
→ How one image is built
```

```text
Compose
→ How multiple services run together
```

The delivery path becomes:

```text
Source
 ↓
Dockerfile
 ↓
Image
 ↓
Registry
 ↓
Compose
 ↓
Multi-Container Application
```

---

# 10. Container Clustering Foundations

File:

```text
container-clustering-foundations-lab.md
```

Topics include:

```text
Multi-Host Clusters
Scale-Out
Discovery
Scheduling
High Availability
Docker Swarm
Cluster Management
Container Orchestration
Kubernetes Introduction
```

The cluster-management problem is:

```text
Multiple Hosts
      ↓
Discovery
      ↓
Scheduling
      ↓
Workload Placement
      ↓
Failure Handling
```

The Docker course concludes by transitioning from container clustering into Kubernetes.

---

# Linux Foundations Behind Docker

Docker directly reuses Linux concepts documented under:

```text
../linux/
```

Important relationships include:

```text
Processes
→ Container processes

Namespaces
→ Container isolation

cgroups
→ Resource control

Users / Permissions
→ Container identity and filesystem access

systemd
→ Docker daemon management

Storage
→ Container host and persistent storage

Linux Bridge
→ Docker bridge networking

Routing
→ Container reachability

Logs
→ Runtime troubleshooting
```

Docker administration extends Linux administration rather than replacing it.

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

These concepts are applied to:

```text
Container Networks
Service Discovery
Port Publishing
Registry Connectivity
Compose Networking
Overlay Networking
Cluster Connectivity
```

---

# Learning Method

Each topic follows:

```text
Concept
   ↓
Architecture
   ↓
Configuration
   ↓
Runtime State
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
Docker daemon state
Image state
Container state
Exit codes
Logs
Events
Process state
Resource usage
Network state
Storage state
Registry state
Compose service state
```

As infrastructure expands into clusters, additional evidence will be required at the node, scheduler, and cluster-state layers.

---

# Build-Time vs Runtime

Docker builds and running containers represent different failure domains.

```text
Build-Time
→ Dockerfile
→ Build Context
→ Base Image
→ Build Cache
→ Package / File Availability
```

```text
Runtime
→ Main Process
→ Environment
→ User
→ Network
→ Port
→ Storage
→ Dependencies
```

A successful build does not prove runtime correctness.

---

# Runtime vs Persistent Definition

A recurring infrastructure principle is:

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

Reproducible infrastructure requires intentional persistent definitions.

---

# Security Principles

Important principles include:

```text
Use trusted base images.
Keep build contexts minimal.
Do not embed secrets in Dockerfiles.
Do not commit real secrets in Compose files.
Treat Docker daemon access as highly privileged.
Use least-privilege container users.
Minimize runtime image content.
Review published ports.
Use network modes intentionally.
Protect persistent data.
Protect registry credentials.
Use trusted registries.
Do not assume a container is a complete security boundary.
```

---

# Evidence Policy

Course output and screenshots are educational examples.

Do not fabricate:

```text
Container IDs
Image IDs
Image Digests
Process IDs
Network IDs
IP Addresses
MAC Addresses
Routes
Volume IDs
Registry Results
Compose States
Node Names
Cluster IDs
Scheduling Results
Failover Results
Command Output
```

Actual environment-specific evidence must come from an authorized lab environment.

---

# Historical Material Policy

The course includes historical Docker ecosystem material.

Examples include:

```text
Docker Toolbox
Boot2Docker
Older Docker CE / EE models
Historical storage drivers
MAINTAINER
docker-compose standalone CLI
Compose version: "3"
Historical Docker Hub policies
Older cluster-management ecosystem references
CoreOS-related material
```

These are preserved as course context while architectural concepts remain the primary learning objective.

---

# Completed Docker Course

The Docker course now covers:

```text
Virtualization Foundations
VM vs Container
Cloud Computing
Cloud Native
Linux Container Isolation
Docker Engine
Images
Containers
Container Lifecycle
Dockerfile
Build Context
Build Cache
Multi-Stage Builds
Storage Fundamentals
Container Management
Registry Management
Docker Networking
Docker Compose
Container Clustering
Docker Swarm Introduction
Kubernetes Transition
```

The Docker foundation is complete.

The next major learning area is:

```text
Kubernetes
```

---

# Long-Term Infrastructure Path

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

The objective is to understand how containerized infrastructure is built, distributed, connected, observed, troubleshot, secured, and eventually orchestrated across multiple hosts.
