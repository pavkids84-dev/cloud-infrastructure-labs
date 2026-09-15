# Docker Engine Foundations Lab

## Objective

Understand the foundational architecture behind Docker before working with Docker images, containers, Dockerfiles, networking, registries, and Compose.

This lab focuses on Linux container isolation, Docker Engine architecture, Docker clients, the daemon, registries, and service-level installation concepts.

## Scope

```text
Containers
OS-Level Isolation
Namespaces
cgroups
System Containers
Application Containers
Docker
Docker Engine
Docker Client
Docker Daemon
Docker REST API
Images
Containers
Networks
Volumes
Registry
Docker Installation Concepts
systemd Service Management
```

---

# Virtual Machines and Containers

Virtual machines and containers provide isolation at different layers.

A simplified virtual-machine architecture is:

```text
Application
    ↓
OS Libraries
    ↓
Guest Kernel
    ↓
Virtual Hardware
    ↓
Hypervisor
    ↓
Physical Hardware
```

A simplified container architecture is:

```text
Application
    ↓
OS Libraries
    ↓
Container Runtime
    ↓
Shared Host Kernel
    ↓
Physical Hardware
```

The most important distinction is:

```text
Virtual Machine
→ Separate guest kernel
```

```text
Container
→ Shared host kernel
```

---

# Containers as Isolated Processes

A container should not simply be interpreted as a lightweight virtual machine.

A more useful model is:

```text
Container
→ Isolated process environment
```

Container processes still execute through the host operating-system kernel.

Linux kernel features provide the isolation that makes each container appear to have its own environment.

---

# OS-Level Isolation

The course introduces OS-level isolation for resources such as:

```text
Filesystem
Process Table
Network
Hostname
Shared Memory
```

Container isolation is built from operating-system mechanisms rather than full hardware virtualization.

---

# Linux Namespaces

Namespaces isolate what processes can observe.

Examples include:

```text
PID Namespace
→ Process ID space

Network Namespace
→ Network interfaces, addresses, routes, and sockets

Mount Namespace
→ Filesystem mount view

UTS Namespace
→ Hostname

IPC Namespace
→ Inter-process communication resources
```

A useful model is:

```text
Namespaces
→ Isolation and visibility
```

---

# cgroups

cgroups stands for:

```text
Control Groups
```

They provide resource accounting and control for processes.

Resources can include:

```text
CPU
Memory
I/O
Process Resources
```

A useful distinction is:

```text
Namespaces
→ What a process can see
```

```text
cgroups
→ How many resources a process can use
```

Namespaces and cgroups are fundamental Linux technologies behind container execution.

---

# System Containers and Application Containers

The course distinguishes between:

```text
System Container
Application Container
```

A system-container model can resemble a small operating-system environment containing multiple services.

Conceptually:

```text
System Container
├── init / system manager
├── service A
├── service B
└── service C
```

An application-container model focuses more narrowly on running an application or service.

Conceptually:

```text
Application Container
└── Application Process
```

Docker is commonly associated with the application-container model.

---

# Container Runtime Environment

The course describes containers as providing the runtime environment required by an application.

That environment can contain:

```text
Application Binary
Libraries
Configuration
User Information
Filesystem Content
```

while relying on the host kernel for operating-system execution.

---

# Docker

The course introduces Docker as an open-source container project originally released in 2013.

Historically, Docker used:

```text
LXC
```

and later introduced its own container-related runtime technology such as:

```text
libcontainer
```

This represents the historical development of Docker.

Modern container architectures have continued to evolve, so the historical runtime name should not be treated as the complete current Docker runtime architecture.

---

# Docker Platform Model

The main concept from the course is:

```text
Docker Engine
      ↓
Images and Containers
      ↓
Application Execution Environment
```

Docker provides tooling for packaging and executing applications as containers.

---

# Image and Container

Two core Docker objects are:

```text
Image
Container
```

A simplified relationship is:

```text
Image
→ Reusable execution template
```

```text
Container
→ Running or created instance based on an image
```

Detailed image and container lifecycle operations are covered in later labs.

---

# Docker and Container Technology

Docker and containers are related but are not identical concepts.

```text
Container
→ OS-level isolation and execution concept
```

```text
Docker
→ Platform for building, distributing, and managing containerized workloads
```

Container technology existed before Docker.

Examples referenced by the course include:

```text
Solaris Zones
FreeBSD Jails
OpenVZ
LXC
Docker
```

---

# Docker Image Distribution

The course emphasizes image creation and distribution.

Conceptually:

```text
Application
+
Libraries
+
Runtime Requirements
        ↓
Docker Image
        ↓
Multiple Container Instances
```

The same image can be used as the basis for multiple containers.

---

# Portability

Container images improve repeatability by packaging application runtime requirements into a reusable artifact.

Conceptually:

```text
Image
  ↓
Host A
Host B
Host C
```

Portability does not remove all compatibility requirements.

CPU architecture, kernel capabilities, and runtime environment can still matter.

---

# Immutable Infrastructure

The course associates Docker with immutable infrastructure.

The useful operational interpretation is:

```text
Do not repeatedly modify running infrastructure.
```

Instead:

```text
Change Definition
      ↓
Build New Image
      ↓
Deploy Replacement
      ↓
Remove Old Instance
```

This helps reduce configuration drift between instances.

---

# Image Filesystem Layers

Docker images use layered filesystem concepts.

A simplified model is:

```text
Read-Only Image Layer
        ↓
Read-Only Image Layer
        ↓
Writable Container Layer
```

Changes made while a container runs are separated from the underlying read-only image layers.

---

# Copy-on-Write

Copy-on-Write records changed data separately from unchanged base data.

Conceptually:

```text
Base Layers
    +
Changed Data
```

This allows image layers to be reused by multiple containers.

---

# Historical Storage Driver Note

The course references:

```text
AUFS
```

as a Copy-on-Write filesystem example.

This should be treated as historical course context.

The important concept is:

```text
Docker Images
→ Layered Filesystem
→ Copy-on-Write
```

rather than assuming Docker always uses one specific filesystem implementation.

---

# Privileged and Unprivileged Processes

The course also introduces the distinction between privileged and unprivileged execution.

Containers share the host kernel, so container permissions are a security-sensitive part of the architecture.

Container security can depend on factors such as:

```text
User Identity
Capabilities
Filesystem Access
Device Access
Network Access
Host Integration
```

A container should not automatically be treated as a complete security boundary.

---

# Docker Architecture

The course presents the Docker architecture using:

```text
Docker Client
Docker Host
Docker Daemon
Images
Containers
Registry
```

A simplified model is:

```text
Docker Client
      ↓
Docker Daemon
      ↓
Images / Containers
      ↕
Registry
```

---

# Docker Client

The Docker client receives commands from the user.

Examples introduced by the course include:

```text
docker build
docker pull
docker run
```

The client communicates with the Docker service rather than independently managing containers.

---

# Docker REST API

The course architecture shows:

```text
Docker CLI
    ↓
REST API
    ↓
Docker Daemon
```

The API separates the command-line client from the daemon that performs Docker operations.

---

# Docker Daemon

The Docker daemon manages Docker resources.

The course diagram identifies resources including:

```text
Containers
Images
Networks
Data Volumes
```

Conceptually:

```text
Docker Daemon
├── Containers
├── Images
├── Networks
└── Volumes
```

These resource types will be studied individually in later labs.

---

# Docker Registry

A Docker registry stores and distributes container images.

Conceptually:

```text
Registry
   ↓ pull
Docker Host
   ↓
Image
   ↓
Container
```

Images can also be pushed from a Docker host to a registry.

```text
Docker Host
   ↓ push
Registry
```

---

# Registry vs Repository

A useful distinction is:

```text
Registry
→ Image storage and distribution service
```

```text
Repository
→ Logical collection of related images within a registry
```

Docker Hub is introduced later in the course as a registry service.

---

# `docker pull` Architecture

Conceptually:

```text
docker pull
     ↓
Docker Client
     ↓
Docker Daemon
     ↓
Registry
     ↓
Image Download
```

The actual command behavior is covered in the Docker image lab.

---

# `docker run` Architecture

A simplified conceptual flow is:

```text
docker run
     ↓
Docker Daemon
     ↓
Locate Image
     ↓
Retrieve Image if Required
     ↓
Create Container
     ↓
Start Container Process
```

The detailed container lifecycle is covered later.

---

# `docker build` Architecture

Conceptually:

```text
Dockerfile
    ↓
Build Process
    ↓
Docker Image
```

Dockerfile syntax and image builds are covered in later sections.

---

# Docker Product Model

The course includes a historical comparison between:

```text
Docker Community Edition
Docker Enterprise Edition
```

This reflects the Docker product model used when the course material was created.

Product names, licensing, and packaging can change over time.

The important technical concepts in this lab are Docker Engine architecture, images, containers, registries, networking, and volumes.

---

# Docker Installation Platforms

The course references Docker installation on:

```text
Ubuntu
CentOS
RHEL
Fedora
Windows
macOS
```

It also references historical tools such as:

```text
Docker Toolbox
Boot2Docker
```

These should be treated as legacy course context rather than permanent Docker architecture requirements.

---

# Historical Version Requirements

The course includes historical requirements such as:

```text
Linux Kernel 3.10.x
Ubuntu 14.04
Docker 17.x
```

These values reflect the environment used by the training material.

Do not use them as current platform requirements without checking the documentation for the target Docker version and operating system.

---

# Linux Package Installation Models

The course demonstrates both distribution-provided packages and Docker-provided installation mechanisms.

These represent different package sources.

Conceptually:

```text
Distribution Repository
→ Distribution-maintained Docker package
```

```text
Docker Repository
→ Docker-maintained packages
```

The package source should be known before installing or troubleshooting Docker.

---

# Installation Script Safety

The course demonstrates piping a downloaded installation script directly to a shell.

Conceptually:

```text
Remote Script
    ↓
curl
    ↓
Shell
```

Executing remote scripts with elevated privileges should be done carefully.

Before using such a workflow in an infrastructure environment:

```text
Verify the source.
Review the script when practical.
Understand the package changes.
Use an authorized repository.
```

---

# Docker as a systemd Service

The course manages Docker through systemd.

Commands introduced include:

```text
systemctl enable docker
systemctl start docker
systemctl status docker
```

The important distinction is:

```text
start
→ Start the service now
```

```text
enable
→ Configure the service to start automatically during boot
```

```text
status
→ Inspect current service state
```

Runtime state and persistent startup configuration are separate concepts.

---

# Docker Daemon Verification

The course verifies Docker by checking service and package state.

A useful verification model is:

```text
Package Installed?
       ↓
Docker Service Running?
       ↓
Docker Daemon Available?
       ↓
Client Can Communicate With Daemon?
```

The exact package names and versions depend on the environment.

---

# Docker Troubleshooting Foundation

Docker troubleshooting should still begin with Linux system state.

For example:

```text
Docker command fails
      ↓
Package installed?
      ↓
docker.service running?
      ↓
dockerd running?
      ↓
Docker API/socket accessible?
      ↓
Image/container state?
```

Docker does not replace Linux administration fundamentals.

---

# Architecture Summary

A useful Docker model is:

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

Below the Docker layer:

```text
Linux Kernel
├── Namespaces
├── cgroups
├── Filesystem
└── Process Management
```

This relationship is the foundation for understanding Docker operations.

---

# Verification Checklist

- VM and container kernel models were distinguished.
- Containers were understood as isolated process environments rather than simply small VMs.
- OS-level isolation was reviewed.
- Namespaces were connected to isolation and visibility.
- cgroups were connected to resource control.
- System containers and application containers were distinguished conceptually.
- Docker was distinguished from container technology in general.
- Docker images and containers were introduced as different objects.
- Docker image portability was reviewed.
- Immutable infrastructure was interpreted as replace rather than continually modify.
- Copy-on-Write and image layers were reviewed.
- AUFS was treated as historical course context.
- Privileged execution was recognized as security-sensitive.
- Docker Client and Docker Daemon roles were distinguished.
- Docker REST API was identified between client and daemon.
- Containers, images, networks, and volumes were identified as Docker-managed resources.
- Registry and repository concepts were distinguished.
- `docker pull`, `docker run`, and `docker build` were connected to the Docker architecture.
- Historical CE / EE product information was not treated as permanent current product structure.
- Docker Toolbox and Boot2Docker were recognized as legacy material.
- Historical kernel and operating-system version requirements were not treated as current requirements.
- Runtime service state and boot-time enablement were distinguished.
- Docker installation verification was connected back to Linux system administration.

## What I Learned

- Docker builds on Linux kernel isolation rather than full hardware virtualization.
- Namespaces isolate process views while cgroups control resource usage.
- Docker provides a platform around images and container execution.
- Docker Client communicates with Docker Daemon through an API.
- Docker Daemon manages images, containers, networks, and volumes.
- Registries distribute reusable container images.
- Image layers use Copy-on-Write concepts.
- Immutable infrastructure favors rebuilding and replacing instances over manually modifying running systems.
- Docker installation and troubleshooting still depend heavily on Linux package, service, process, and permission knowledge.
