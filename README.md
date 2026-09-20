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

The long-term goal is to develop practical skills in infrastructure operation, automation, troubleshooting, orchestration, and security.

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
    └── resource-object-template-lab.md
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
Network Types
Ethernet
IPv4
IPv6
ARP
Routing
Routing Protocols
Network Standards
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

Packet analysis includes:

```text
Ethernet Headers
IPv4 / IPv6 Headers
TCP Headers and Flags
ARP
ICMP
IGMP
Wireshark
Follow Stream
Flow Graph
Latency Analysis
Capture Filters
Display Filters
TCP Analysis Filters
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

```text
Image
   ↓
Container Runtime
   ↓
Container
```

Kubernetes expands these concepts into multi-node desired-state orchestration.

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
Pod Runtime Inspection
Live Object Inspection
Resource Object Templates
Client-Side Dry Run
```

The current progression is:

```text
Container
    ↓
Pod
    ↓
Kubernetes API
    ↓
Desired State
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

Operational evidence currently includes:

```text
kubectl get
kubectl describe
Kubernetes Events
kubectl logs
kubectl exec
kubectl get -o yaml
```

Each exposes a different part of resource or runtime state.

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

# Pod Runtime Observation

Pod state should not be reduced to only:

```text
Running
```

Useful evidence also includes:

```text
Conditions
Container State
Ready State
Restart Count
Events
Logs
Exit Codes
```

A practical investigation can progress through:

```text
kubectl get
      ↓
kubectl describe
      ↓
Events
      ↓
kubectl logs
      ↓
kubectl exec
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

# Kubernetes Storage Introduction

The current Kubernetes storage foundation includes:

```text
Pod Volumes
emptyDir
PersistentVolume
PersistentVolumeClaim
ConfigMap
Secret
CSI
```

A key distinction is:

```text
Pod Volume
!=
Automatically Persistent Storage
```

Volume lifecycle depends on the selected storage type.

Detailed storage management is studied later.

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

A live API object can additionally contain:

```text
status
```

representing observed state.

---

# `spec` and `status`

Kubernetes introduces a central desired-state distinction.

```text
spec
→ What should exist?
```

```text
status
→ What currently exists?
```

This relationship provides the foundation for controller reconciliation.

```text
Desired State
      ↓
Controller
      ↓
Observe Runtime State
      ↓
Reconcile Difference
```

The controller implementation is the next major study area.

---

# Live Object Inspection

A live Kubernetes object can be inspected as YAML.

```text
API Object
    ↓
kubectl get -o yaml
    ↓
Full Object Representation
```

This can include:

```text
Desired Configuration
Server-Generated Metadata
Scheduler Information
Runtime Annotations
Observed Status
```

Live-object YAML should therefore be reviewed before it is reused as a new manifest.

---

# Kubernetes Resource Templates

Two resource-template workflows have been introduced.

Existing object:

```text
Existing Kubernetes Object
        ↓
kubectl get -o yaml
        ↓
Remove Runtime-Specific Fields
        ↓
Edit
        ↓
Reusable Manifest
```

New object:

```text
kubectl create
        ↓
--dry-run=client
        ↓
-o yaml
        ↓
Manifest Template
```

The distinction is:

```text
get -o yaml
→ Inspect or derive from an existing object
```

```text
dry-run
→ Generate a new definition without creating it
```

---

# Deployment Hierarchy Introduction

The resource-template exercise introduces:

```text
Deployment
     ↓
ReplicaSet
     ↓
Pod
```

This is the transition from directly managing a Pod toward controller-managed workloads.

The next course section expands controller behavior in detail.

---

# Desired State and Runtime State

The repository's recurring state-management principle evolves through each layer.

Linux and Docker introduced:

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

A manifest describes intent.

The Kubernetes API and runtime evidence show what actually exists.

Controllers reconcile the difference.

---

# Workload Creation Flow

The workload path can now be represented as:

```text
YAML / kubectl
      ↓
Kubernetes API
      ↓
Pod or Controller Object
      ↓
Scheduler / Controllers
      ↓
Worker Node
      ↓
kubelet
      ↓
Container Runtime
      ↓
Container
      ↓
Linux Process
```

A successful API request does not by itself prove application readiness.

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

A basic workload investigation now follows:

```text
kubectl get
      ↓
Current State
      ↓
kubectl describe
      ↓
Conditions / Events
      ↓
kubectl logs
      ↓
Application Evidence
      ↓
kubectl exec
      ↓
Targeted Runtime Inspection
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

# Configuration as Code

Kubernetes manifests introduce another infrastructure-definition layer.

```text
Desired Configuration
       ↓
YAML Manifest
       ↓
Git
       ↓
API Submission
       ↓
Runtime State
```

A clean desired-state manifest is more appropriate for version control than a raw API object containing transient runtime metadata.

This forms a foundation for later automation and GitOps concepts.

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

Current Kubernetes security principles include:

```text
Do not commit kubeconfig credentials.
Do not publish bootstrap tokens.
Do not commit real application secrets.
Review exported object YAML before publishing it.
Use least privilege.
Do not disable host security controls as a generic troubleshooting solution.
```

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
Exit Codes
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
apps/v1beta1 Deployment Examples
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
Pod Conditions
Pod Events
Pod Description
Pod Logs
kubectl exec
Container Runtime Inspection
Live Object YAML Inspection
spec vs status
Resource Object Templates
dry-run
Deployment Resource Hierarchy Introduction
```

The current Kubernetes course position is:

```text
Completed through p.65
```

The current learning area is:

```text
Kubernetes
```

The next topic is:

```text
Controllers
```

Upcoming areas include:

```text
Controller Reconciliation
ReplicaSet
DaemonSet
Job
Deployment
StatefulSet
Services
Labels / Selectors
Rolling Updates
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

They should not exist only as empty placeholders.

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
