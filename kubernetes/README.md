# Kubernetes Infrastructure Labs

This directory documents my Kubernetes learning path as part of my cloud infrastructure engineering studies.

The focus is not only on `kubectl` commands, but on understanding Kubernetes as an API-driven desired-state system built on Linux, networking, containers, storage, and distributed control-plane components.

The learning path begins with:

```text
Docker and Containers
        ↓
Container Clustering
        ↓
Kubernetes Architecture
        ↓
Cluster Installation
        ↓
kubectl
        ↓
Pods
        ↓
Objects and Controllers
        ↓
Services
        ↓
Deployments
        ↓
Security
        ↓
Storage
        ↓
High Availability
```

---

# Directory Structure

Current files:

```text
kubernetes/
├── README.md
└── kubernetes-architecture-foundations-lab.md
```

Additional files will be added only after the corresponding Kubernetes topics are actually studied.

---

# 1. Kubernetes Architecture Foundations

File:

```text
kubernetes-architecture-foundations-lab.md
```

Topics include:

```text
Kubernetes
Container Orchestration
Desired State
Control Plane
Worker Nodes
kube-apiserver
etcd
kube-scheduler
kube-controller-manager
kubelet
kube-proxy
Container Runtime
CRI
containerd
CRI-O
runc
OCI
Cluster DNS
CNI
Ingress
High Availability
```

Core architecture:

```text
User
 ↓
Kubernetes API
 ↓
Control Plane
 ↓
Scheduling / Reconciliation
 ↓
Worker Nodes
 ↓
Container Runtime
 ↓
Containers
```

---

# API-Driven Architecture

Kubernetes infrastructure is managed through API objects.

```text
kubectl
Controllers
Automation
     ↓
kube-apiserver
     ↓
Kubernetes Objects
```

The API server should be treated as the central entry point for cluster state management.

---

# Desired State and Reconciliation

A fundamental Kubernetes principle is:

```text
Desired State
!=
Current State
```

Controllers continuously observe the cluster and attempt to reconcile differences.

```text
Observe
   ↓
Compare
   ↓
Act
   ↓
Observe Again
```

This reconciliation model is central to Kubernetes operations.

---

# Control Plane

The control plane contains cluster-management components such as:

```text
kube-apiserver
etcd
kube-scheduler
kube-controller-manager
```

A simplified responsibility model is:

```text
API Server
→ API access and cluster-state interface

etcd
→ Cluster state storage

Scheduler
→ Workload placement

Controllers
→ Desired-state reconciliation
```

---

# Worker Nodes

Worker nodes execute workloads.

Core node components include:

```text
kubelet
kube-proxy
Container Runtime
```

Conceptually:

```text
Control Plane
     ↓
Worker Node
     ↓
Pod
     ↓
Container
```

---

# Container Runtime Architecture

Kubernetes node execution should be understood through the Container Runtime Interface.

```text
kubelet
   ↓
CRI
   ↓
containerd / CRI-O
   ↓
OCI Runtime
   ↓
Linux Container
```

Docker images remain relevant even though Kubernetes does not require Docker Engine as its runtime integration layer.

---

# Linux Foundations

Kubernetes depends directly on concepts documented under:

```text
../linux/
```

Important relationships include:

```text
Processes
Namespaces
cgroups
systemd
Storage
Filesystems
Security
Networking
```

---

# Network Foundations

General network concepts are documented under:

```text
../network/
```

Important Kubernetes relationships include:

```text
IP Addressing
Routing
DNS
Ports
Packet Analysis
Service Connectivity
Cluster Networking
```

---

# Docker Foundations

Container concepts are documented under:

```text
../docker/
```

Important relationships include:

```text
Container Images
Container Runtime
Registry
Container Networking
Persistent Storage
Multi-Container Applications
Container Clustering
```

Kubernetes extends these concepts from host-level container operation into cluster orchestration.

---

# Learning Method

Each Kubernetes topic should progress through:

```text
Concept
   ↓
Architecture
   ↓
Object Definition
   ↓
API Interaction
   ↓
Runtime Observation
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

Kubernetes troubleshooting follows:

```text
Symptom
   ↓
Evidence
   ↓
Failing Layer
   ↓
Root Cause
   ↓
Resolution
   ↓
Verification
```

Potential layers include:

```text
Application
Container
Pod
Controller
Service
Network
Storage
Worker Node
Container Runtime
kubelet
Control Plane
Kubernetes API
```

---

# Runtime vs Desired State

Kubernetes introduces an especially important distinction:

```text
Desired State
vs
Observed Runtime State
```

A manifest can define the intended state while:

```text
kubectl get
kubectl describe
kubectl logs
Events
```

later provide evidence about what actually occurred.

---

# Security Approach

Security should be treated as part of Kubernetes architecture.

Future topics in this directory include:

```text
API Authentication
Authorization
RBAC
Service Accounts
Secrets
Least Privilege
Workload Security
```

Actual permissions and credentials must not be fabricated or committed to Git.

---

# Evidence Policy

Course screenshots and sample command output are educational examples.

Do not fabricate:

```text
Cluster IDs
Node Names
Node Addresses
Pod Addresses
Container IDs
API Server Addresses
Runtime IDs
Scheduler Decisions
RBAC Results
Storage IDs
Command Output
```

Actual evidence must come from an authorized lab environment.

---

# Historical Material Policy

The Kubernetes course contains historical versions, products, commands, and ecosystem components.

Examples can include:

```text
Older Kubernetes versions
Historical Docker runtime integration
Heapster
rkt
Older installation procedures
Legacy API versions
```

These should be preserved as course context while modern architectural concepts are distinguished when necessary.

---

# Current Learning Progress

Completed Kubernetes areas:

```text
Kubernetes Introduction
Container Orchestration
Control Plane Architecture
Worker Node Architecture
API Server
etcd
Scheduler
Controller Manager
kubelet
kube-proxy Introduction
Container Runtime Architecture
CRI
containerd
CRI-O
runc
OCI
CNI Introduction
Cluster DNS Introduction
Ingress Introduction
Control Plane HA Introduction
```

The next major topics are:

```text
Kubernetes Installation Methods
Minikube
kubeadm
Cluster Bootstrap
kubectl
Pods
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

The objective is to understand Kubernetes as a distributed infrastructure platform rather than only memorize resource commands.
