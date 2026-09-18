# Kubernetes Infrastructure Labs

This directory documents my Kubernetes learning path as part of my cloud infrastructure engineering studies.

The focus is not only on `kubectl` commands, but on understanding Kubernetes as an API-driven desired-state platform built on Linux, networking, container runtimes, distributed control-plane components, and declarative infrastructure.

The current learning path is:

```text
Docker and Containers
        ↓
Container Clustering
        ↓
Kubernetes Architecture
        ↓
Minikube
        ↓
kubeadm Cluster Bootstrap
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
├── minikube-local-cluster-lab.md
└── kubeadm-cluster-bootstrap-lab.md
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
Local Cluster
minikube start
minikube status
kubectl
kubeconfig
API Connectivity
Node Ready State
System Components
Kubernetes Dashboard
Local Cluster Troubleshooting
```

Minikube provides a local environment for Kubernetes learning.

```text
Minikube
→ Local Kubernetes environment

kubectl
→ Kubernetes API client
```

---

# 3. kubeadm Cluster Bootstrap

File:

```text
kubeadm-cluster-bootstrap-lab.md
```

Topics include:

```text
Linux Node Preparation
Control Plane Bootstrap
Worker Node Preparation
kubeadm
kubelet
kubectl
kubeconfig
Pod Network CIDR
CNI
Calico Course Example
kubeadm init
kubeadm join
Bootstrap Trust
Node Registration
Node Ready State
kube-system
System Component Inspection
Linux Process Inspection
```

The bootstrap workflow is:

```text
Prepare Nodes
      ↓
kubeadm init
      ↓
Configure kubeconfig
      ↓
Install CNI
      ↓
Verify Control Plane
      ↓
kubeadm join
      ↓
Verify Worker
```

This section connects Kubernetes cluster bootstrap directly to Linux administration and networking.

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

Controllers continuously observe the cluster and reconcile differences.

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

Core responsibilities include:

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

```text
Worker Node
├── kubelet
├── kube-proxy
├── Container Runtime
└── Workloads
```

A node must be both registered and operationally Ready before normal workload scheduling can be expected.

---

# Container Runtime Architecture

The conceptual execution path is:

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

# kubeadm Architecture

kubeadm is used for Kubernetes cluster bootstrap.

```text
Control Plane Node
      ↓
kubeadm init
```

```text
Worker Node
      ↓
kubeadm join
```

kubeadm should be distinguished from:

```text
kubelet
→ Node agent
```

and:

```text
kubectl
→ Kubernetes API client
```

---

# kubeconfig

Kubernetes client access is configured through kubeconfig.

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

Client configuration should be investigated separately from cluster runtime health.

---

# Kubernetes Networking Foundation

Cluster networking now includes multiple address domains.

```text
Node Network
Pod Network
Service Network
```

The course introduces Pod networking through a CNI implementation.

```text
Pod
 ↓
CNI
 ↓
Cluster Network
```

Detailed Kubernetes network behavior is studied later.

---

# CNI

The course uses Calico as its CNI example.

The architectural relationship is:

```text
Kubernetes
    ↓
CNI
    ↓
Pod Networking
```

Historical CNI manifest URLs from the course are not treated as current installation instructions.

---

# Cluster Verification

Cluster bootstrap is not considered complete merely because installation commands returned successfully.

A verification sequence is:

```text
API Reachable?
      ↓
Control Plane Running?
      ↓
CNI Running?
      ↓
Node Registered?
      ↓
Node Ready?
      ↓
System Workloads Running?
```

---

# Kubernetes and Linux

Kubernetes abstractions map back to real operating-system behavior.

```text
Kubernetes Object
       ↓
Pod
       ↓
Container
       ↓
Runtime
       ↓
Linux Process
```

Troubleshooting can therefore require:

```text
kubectl
systemd
Linux Logs
Processes
Networking
Filesystems
Container Runtime
```

---

# Linux Foundations

Relevant Linux studies are documented under:

```text
../linux/
```

Important relationships include:

```text
Processes
systemd
Users and Permissions
Networking
Routing
Storage
Filesystems
Firewall
SELinux
Logs
```

---

# Network Foundations

Networking fundamentals are documented under:

```text
../network/
```

Important Kubernetes relationships include:

```text
IP Addressing
Subnetting
Routing
DNS
Ports
Packet Analysis
Node Connectivity
Pod Networking
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

Kubernetes extends these concepts from host-level operation into cluster-level orchestration.

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
kubelet
Container Runtime
CNI
Pod
Controller
Service
Network
Storage
Application
```

---

# Node Troubleshooting

A node problem can be investigated as:

```text
Linux Host Healthy?
      ↓
Network Reachable?
      ↓
Container Runtime Healthy?
      ↓
kubelet Healthy?
      ↓
API Reachable?
      ↓
CNI Healthy?
      ↓
Node Conditions?
      ↓
Node Ready?
```

This preserves the same layered infrastructure troubleshooting method used throughout the repository.

---

# Runtime vs Desired State

Kubernetes introduces the distinction:

```text
Desired State
vs
Observed Runtime State
```

Configuration describes intent.

Runtime evidence proves what actually happened.

Useful evidence later includes:

```text
kubectl get
kubectl describe
kubectl logs
Events
Node Conditions
```

---

# Security Approach

Security should be treated as part of Kubernetes architecture.

Current principles include:

```text
Do not publish bootstrap tokens.
Do not commit kubeconfig credentials.
Do not broadly disable host security controls as a generic fix.
Use least privilege.
Protect Kubernetes API credentials.
```

Future topics include:

```text
Authentication
Authorization
RBAC
Service Accounts
Secrets
Workload Security
```

---

# Evidence Policy

Course screenshots and sample command output are educational examples.

Do not fabricate:

```text
Cluster IDs
Node Names
Node Addresses
Pod Addresses
Bootstrap Tokens
Certificate Hashes
Container IDs
API Server Addresses
Runtime IDs
Scheduler Decisions
Node Status
Command Output
```

Actual evidence must come from an authorized lab environment.

---

# Historical Material Policy

The Kubernetes course contains historical installation procedures, versions, runtimes, and ecosystem components.

Examples include:

```text
Older Kubernetes repositories
Older Ubuntu / CentOS releases
Historical Docker runtime integration
Older Calico manifests
Heapster
rkt
Legacy Kubernetes API versions
```

These are preserved as course context while architecture and modern concepts are distinguished where necessary.

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
Kubernetes Installation Methods
Minikube
Local Cluster Verification
kubeconfig Introduction
kubeadm Cluster Bootstrap
Linux Node Preparation
Control Plane Initialization
Pod Network CIDR
CNI Installation
Worker Node Join
Node Ready Verification
kube-system Introduction
Kubernetes Component Observation
Linux Process Correlation
```

The next major topics are:

```text
kubectl
API Resources
API Versions
kubectl Completion
Imperative Pod Creation
kubectl get
kubectl describe
Events
Logs
Pod Fundamentals
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
