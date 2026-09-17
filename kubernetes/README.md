# Kubernetes Infrastructure Labs

This directory documents my Kubernetes learning path as part of my cloud infrastructure engineering studies.

The focus is not only on `kubectl` commands, but on understanding Kubernetes as an API-driven desired-state platform built on Linux, networking, container runtimes, distributed control-plane components, and declarative infrastructure.

The learning path currently progresses through:

```text
Docker and Containers
        ↓
Container Clustering
        ↓
Kubernetes Architecture
        ↓
Local Cluster with Minikube
        ↓
Cluster Bootstrap with kubeadm
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
Helm
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
├── kubernetes-architecture-foundations-lab.md
└── minikube-local-cluster-lab.md
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

# 2. Minikube Local Cluster

File:

```text
minikube-local-cluster-lab.md
```

Topics include:

```text
Kubernetes Installation Methods
Minikube
Local Kubernetes Clusters
minikube start
minikube status
kubectl
kubeconfig
kubectl cluster-info
Kubernetes Nodes
Node Ready State
Minikube Host Access
System Components
Kubernetes Dashboard
Local Cluster Troubleshooting
```

The local-cluster workflow is:

```text
Install Minikube
      ↓
Start Cluster
      ↓
Verify Minikube
      ↓
Verify API Access
      ↓
Verify Node
      ↓
Inspect System Components
```

Minikube, Kubernetes, and `kubectl` have separate responsibilities.

```text
Minikube
→ Local cluster environment
```

```text
Kubernetes
→ Orchestration platform
```

```text
kubectl
→ API client
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

The API server is the central interface for cluster state management.

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

---

# Control Plane

The core control-plane responsibilities include:

```text
kube-apiserver
→ Kubernetes API

etcd
→ Cluster state storage

kube-scheduler
→ Workload placement

kube-controller-manager
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

Kubernetes node execution is understood through the Container Runtime Interface.

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

Docker images remain relevant even when Docker Engine is not the Kubernetes runtime integration layer.

---

# kubeconfig and Client Context

`kubectl` requires connection configuration.

```text
kubectl
   ↓
kubeconfig
   ↓
Cluster
User
Context
   ↓
API Server
```

Client configuration and cluster health should be treated as separate troubleshooting layers.

---

# Cluster Verification

A local-cluster verification sequence is:

```text
Environment Running?
      ↓
API Reachable?
      ↓
Node Registered?
      ↓
Node Ready?
      ↓
System Components Running?
      ↓
Application Workloads
```

Do not start application troubleshooting before confirming cluster foundations.

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

A Kubernetes node remains a real operating-system environment.

---

# Network Foundations

General networking concepts are documented under:

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
Client Configuration
Kubernetes API
Control Plane
Worker Node
Container Runtime
Pod
Controller
Service
Network
Storage
Application
```

---

# Local Cluster Troubleshooting

A Minikube-focused troubleshooting sequence is:

```text
Minikube Environment
       ↓
minikube status
       ↓
kubeconfig / Context
       ↓
kubectl cluster-info
       ↓
kubectl get nodes
       ↓
Node Ready
       ↓
System Components
       ↓
Application
```

This separates local-environment failures from Kubernetes workload failures.

---

# Runtime vs Desired State

Kubernetes introduces an important distinction:

```text
Desired State
vs
Observed Runtime State
```

A manifest describes intent.

Runtime observation determines what actually occurred.

Relevant evidence can later include:

```text
kubectl get
kubectl describe
kubectl logs
Events
Node State
```

---

# Security Approach

Security should be treated as part of Kubernetes architecture.

Future topics include:

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
Minikube Addresses
Dashboard URLs
Scheduler Decisions
RBAC Results
Storage IDs
Command Output
```

Actual evidence must come from an authorized lab environment.

---

# Historical Material Policy

The Kubernetes course contains historical versions, tools, commands, and ecosystem components.

Examples include:

```text
Older Kubernetes versions
Older Minikube versions
VirtualBox-based Minikube examples
Historical Docker runtime integration
Heapster
rkt
Legacy Kubernetes API versions
```

These are preserved as course context while current architectural concepts are distinguished when necessary.

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
Kubernetes Installation Methods Overview
Minikube
Local Cluster Startup
kubeconfig Introduction
Cluster API Verification
Node Verification
Minikube Host Inspection
System Component Observation
Kubernetes Dashboard Introduction
```

The next major topics are:

```text
kubeadm
Node Preparation
Control Plane Bootstrap
CNI Installation
Worker Join
Cluster Component Verification
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
