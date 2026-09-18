# Cloud Infrastructure Labs

This repository documents my hands-on learning path toward cloud infrastructure engineering.

The current foundation consists of:

```text
Linux System Administration
        ↓
Network Fundamentals and Troubleshooting
        ↓
Containers and Docker
        ↓
Kubernetes
```

The focus is not simply on memorizing commands.

Each topic is approached through:

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

The long-term goal is to develop practical skills in infrastructure operation, automation, troubleshooting, and security.

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
├── docker/
│   ├── README.md
│   ├── virtualization-container-foundations-lab.md
│   ├── cloud-computing-cloud-native-foundations-lab.md
│   ├── docker-engine-foundations-lab.md
│   ├── image-container-lifecycle-lab.md
│   ├── dockerfile-image-build-lab.md
│   ├── container-management-lab.md
│   ├── registry-management-lab.md
│   ├── docker-networking-lab.md
│   ├── docker-compose-lab.md
│   └── container-clustering-foundations-lab.md
│
└── kubernetes/
    ├── README.md
    ├── kubernetes-architecture-foundations-lab.md
    ├── minikube-local-cluster-lab.md
    ├── kubeadm-cluster-bootstrap-lab.md
    ├── kubectl-basic-control-lab.md
    ├── pod-fundamentals-lab.md
    └── object-template-generation-lab.md
```

Future top-level directories should be created only after the corresponding areas are actually studied.

---

# Linux System Administration

Directory:

```text
linux/
```

Linux provides the operating-system foundation for infrastructure engineering.

Current areas include:

```text
System Fundamentals
Files and Permissions
Shell
Bash Scripting
Processes
systemd
OpenSSH
Packages
Users and Groups
Job Scheduling
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
Linux Networking
Network Teaming
NFS
Linux Bridge
AutoFS
Samba / CIFS
Apache
BIND / Unbound
Host Network Security
```

Linux administration remains the base layer for container and cloud infrastructure work.

---

# Network Fundamentals and Troubleshooting

Directory:

```text
network/
```

General networking theory is separated from operating-system-specific network administration.

Current areas include:

```text
OSI Model
Ethernet
IPv4
IPv6
ARP
Routing
Routing Protocols
DNS
Network Troubleshooting
Packet Analysis
```

The progression is:

```text
Protocol Theory
      ↓
Traffic Flow
      ↓
System Observation
      ↓
Packet Capture
      ↓
Stream / Flow Analysis
      ↓
Troubleshooting
```

This foundation supports Docker networking, Kubernetes networking, cloud networking, and security.

---

# Containers and Docker

Directory:

```text
docker/
```

The completed Docker learning path covers:

```text
Virtualization
Cloud Computing
Cloud Native
Linux Container Isolation
Docker Engine
Images and Containers
Dockerfile
Storage
Container Management
Registry
Docker Networking
Docker Compose
Container Clustering
```

Docker provides the direct container foundation for Kubernetes.

---

# Kubernetes

Directory:

```text
kubernetes/
```

Kubernetes expands container infrastructure from host-level operation toward API-driven cluster orchestration.

Current completed areas include:

```text
Kubernetes Architecture
Minikube
kubeadm Cluster Bootstrap
kubectl Fundamentals
Pod Fundamentals
Pod Networking
Pod Storage Introduction
Kubernetes YAML
Basic Pod Troubleshooting
Pod Conditions and Container Commands
Live Object YAML
Object Template Generation
Client-Side Dry Run
Deployment / ReplicaSet / Pod Observation
```

The core progression is:

```text
Container
    ↓
Pod
    ↓
Kubernetes API
    ↓
Scheduler / Controllers
    ↓
Worker Node
    ↓
Container Runtime
```

---

# Kubernetes API and kubectl

Kubernetes infrastructure is centered around API resources.

```text
User
 ↓
kubectl
 ↓
kubeconfig
 ↓
kube-apiserver
 ↓
Kubernetes Object
```

Useful operational evidence now includes:

```text
kubectl get
kubectl describe
Kubernetes Events
kubectl logs
```

These commands expose different layers of workload state.

---

# Kubernetes Pods

A Pod is the basic Kubernetes scheduling unit.

```text
Pod
├── Shared Network Environment
├── Volume Definitions
├── Container A
└── Container B
```

The Pod connects multiple previously studied infrastructure concepts.

```text
Linux Namespace
→ Pod isolation

Container Runtime
→ Container execution

CNI
→ Pod networking

Volumes / CSI
→ Storage integration

Scheduler
→ Node placement
```

---

# Kubernetes Networking

The current Kubernetes networking foundation includes:

```text
Container-to-Container
Pod-to-Pod
Pod-to-Service
External-to-Service
CNI
Pod Network Namespace
Pod IP
```

The relationship with previous studies is:

```text
Linux Networking
       ↓
Container Networking
       ↓
Docker Networking
       ↓
Kubernetes Pod Networking
```

---

# Kubernetes Object Definitions

Kubernetes resource definitions commonly use:

```yaml
apiVersion:
kind:
metadata:
spec:
```

These fields represent:

```text
API Schema
Resource Type
Object Identity
Desired Configuration
```

YAML therefore becomes part of the infrastructure definition model rather than merely a configuration-file format.

The [Object Template Generation Lab](./kubernetes/object-template-generation-lab.md) covers YAML export, client-side dry run, and review of Deployment labels and selectors.

---

# Desired State and Runtime State

Kubernetes extends the repository's recurring state-management principle.

Earlier infrastructure introduced:

```text
Runtime State
!=
Persistent Configuration
```

Kubernetes adds:

```text
Desired State
!=
Observed State
```

A manifest defines what should exist.

The cluster API and runtime evidence reveal what actually exists.

---

# Workload Creation Flow

The workload path can now be represented as:

```text
YAML / kubectl
      ↓
Kubernetes API
      ↓
Pod
      ↓
Scheduler
      ↓
Worker Node
      ↓
kubelet
      ↓
Container Runtime
      ↓
Container
```

A successful object creation request does not by itself prove application readiness.

---

# Linux, Network, Docker, and Kubernetes Relationship

The repository areas intentionally build on one another.

```text
Linux Processes
      ↓
Container Processes
      ↓
Kubernetes Workloads
```

```text
Linux Namespaces
      ↓
Container Isolation
      ↓
Pod Network Namespace
```

```text
IP / Routing / DNS
      ↓
Docker Networking
      ↓
Kubernetes CNI Networking
```

```text
Docker Images
      ↓
Registry
      ↓
Kubernetes Pod Containers
```

```text
Container Clustering
      ↓
Kubernetes Scheduling
      ↓
Desired-State Reconciliation
```

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

The first action should normally be observation rather than immediate configuration changes.

---

# Kubernetes Troubleshooting

A basic Pod investigation now follows:

```text
kubectl get pod
      ↓
Current State
      ↓
kubectl describe pod
      ↓
Conditions / Events
      ↓
kubectl logs
      ↓
Application Evidence
```

If required, investigation continues downward:

```text
Pod
 ↓
Container
 ↓
Container Runtime
 ↓
kubelet
 ↓
Worker Node
 ↓
Linux / Network
```

---

# Service State vs Reachability

A running process or Pod does not prove that an application is reachable.

```text
Pod Running
      ↓
Container Running
      ↓
Socket Listening
      ↓
Service / Network
      ↓
Application Protocol
```

This principle continues from Linux and Docker into Kubernetes.

---

# Security Approach

Security is treated as part of every infrastructure layer.

Current and upcoming areas include:

```text
Linux Permissions
SELinux
Firewall
SSH
Container Least Privilege
Registry Security
Kubernetes API Security
Authentication
Authorization
RBAC
Service Accounts
Secrets
```

Kubernetes manifests and kubeconfig files can contain sensitive infrastructure information and should be managed intentionally.

---

# Evidence Policy

Course screenshots and example output are educational examples.

They are not recorded as actual runtime evidence.

Do not fabricate:

```text
IP Addresses
MAC Addresses
Process IDs
Container IDs
Image IDs
Packet Captures
Registry Results
Node Names
Pod Names
Pod Addresses
Cluster IDs
Events
Scheduler Decisions
RBAC Results
Application Logs
Command Output
```

Actual evidence must come from the environment where the exercise was performed.

---

# Historical Material Policy

Training materials can contain historical commands, versions, products, and ecosystem terminology.

Examples encountered include:

```text
Legacy Linux Networking Commands
Docker Toolbox
Boot2Docker
Older Docker Models
Historical Docker Runtime Integration
rkt
Heapster
Older Kubernetes Versions
Legacy Kubernetes API Versions
docker0-Based Kubernetes Networking Examples
Historical kubelet CNI Options
Older Calico Installation Procedures
```

Historical material is preserved for context while reusable architectural concepts are documented separately.

---

# Current Progress

Completed major areas include:

```text
Linux Fundamentals
Linux System Administration
Linux Networking and Security

Network Fundamentals
Routing
DNS
Network Troubleshooting
Packet Analysis

Virtualization
Cloud Computing
Cloud-Native Concepts
Docker
Docker Networking
Docker Compose
Container Clustering

Kubernetes Introduction
Kubernetes Architecture
Minikube
kubeadm Cluster Bootstrap
kubectl Fundamentals
API Resource Discovery
Pod Fundamentals
Pod Networking
CNI
Pod Storage Introduction
Kubernetes YAML
Pod Events
Pod Description
Pod Logs
Basic Pod Troubleshooting
Pod Conditions and Container Commands
Live Object YAML
Object Template Generation
Client-Side Dry Run
Deployment / ReplicaSet / Pod Observation
```

The current learning area is:

```text
Kubernetes
```

The next topics are:

```text
Controllers
Services
Deployments
Security
Storage
High Availability
```

---

# Planned Expansion

Additional top-level areas should be created only after enough actual study exists.

Potential later areas include:

```text
aws/
terraform/
```

They should not exist only as placeholders.

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

The objective is to develop the ability to understand, operate, troubleshoot, automate, and secure infrastructure across each layer.

---

# What This Repository Demonstrates

This repository documents progression from operating-system fundamentals toward distributed cloud infrastructure reasoning.

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
   ↓
Orchestration
```

The central questions remain:

```text
What should happen?

What actually happened?

Which layer is responsible?

What evidence supports the conclusion?

What change resolves the issue?

How was recovery verified?

How should the same workload be defined, reproduced, observed, and operated at cluster scale?
```
