# Kubernetes Infrastructure Labs

This directory documents my Kubernetes learning path as part of my cloud infrastructure engineering studies.

The focus is not only on `kubectl` commands, but on understanding Kubernetes as an API-driven desired-state platform built on Linux, networking, container runtimes, distributed control-plane components, declarative resources, and observable workload state.

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
Object Templates
        ↓
Controllers
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
├── kubeadm-cluster-bootstrap-lab.md
├── kubectl-basic-control-lab.md
└── pod-fundamentals-lab.md
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

---

# 4. kubectl Basic Control

File:

```text
kubectl-basic-control-lab.md
```

Topics include:

```text
kubectl
Kubernetes API Client
API Resources
API Versions
Resource Short Names
Resource Scope
Bash Completion
Imperative Pod Creation
kubectl get
kubectl describe
Kubernetes Events
kubectl logs
Basic Troubleshooting
```

The operational observation flow is:

```text
kubectl get
      ↓
Summary State
      ↓
kubectl describe
      ↓
Conditions / Events
      ↓
kubectl logs
      ↓
Application Evidence
```

Different commands expose different evidence and should not be treated as interchangeable.

---

# 5. Pod Fundamentals

File:

```text
pod-fundamentals-lab.md
```

Topics include:

```text
Pod
Scheduling Unit
Pod IP
Namespace
Multi-Container Pods
Shared Network Namespace
Pause / Sandbox Container
CNI
Pod Networking
Pod Storage
Volumes
PersistentVolume
PersistentVolumeClaim
ConfigMap
Secret
CSI
YAML
Pod Manifests
Pod Events
Pod Inspection
```

The Pod model is:

```text
Pod
├── Shared Network Environment
├── Volume Definitions
├── Container A
└── Container B
```

The Pod is the basic Kubernetes scheduling unit.

---

# Pod Networking

The course introduces four communication categories:

```text
Container-to-Container
Pod-to-Pod
Pod-to-Service
External-to-Service
```

Pod networking connects Kubernetes directly to earlier Linux and network studies.

```text
Linux Network Namespace
       ↓
Pod Network Namespace
       ↓
CNI
       ↓
Cluster Network
```

---

# Pod Storage

Pods can define volumes and mount them into containers.

```text
Pod
 ↓
Volume
 ↓
Container Mount
```

Storage concepts include:

```text
Ephemeral Volumes
PersistentVolume
PersistentVolumeClaim
ConfigMap
Secret
CSI
```

Detailed persistent-storage behavior is studied later.

---

# Kubernetes Object Model

Kubernetes manifests use API objects.

A common object skeleton is:

```yaml
apiVersion:
kind:
metadata:
spec:
```

Conceptually:

```text
apiVersion
→ API schema

kind
→ Resource type

metadata
→ Resource identity

spec
→ Desired configuration
```

This structure becomes reusable across Pods, Deployments, Services, and other Kubernetes resources.

---

# YAML

Kubernetes manifests commonly use YAML.

Important concepts include:

```text
Mappings
Lists
Indentation
Comments
Multi-Line Text
Nested Objects
```

YAML indentation represents data structure and should be treated as syntax rather than visual formatting.

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

The API server remains the central interface for cluster state management.

---

# Desired State and Reconciliation

A fundamental Kubernetes principle is:

```text
Desired State
!=
Current State
```

A manifest expresses desired configuration.

Cluster components work to make runtime state converge toward that configuration.

---

# Workload Creation Flow

The workload path can now be represented as:

```text
YAML / kubectl
      ↓
Kubernetes API
      ↓
Pod Object
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

Creating the API object and obtaining a healthy workload are separate verification stages.

---

# Kubernetes Events

Pod startup can generate lifecycle evidence such as:

```text
Scheduled
Pulling
Pulled
Created
Started
```

Events help locate the stage at which workload startup failed.

They should be correlated with resource state and application logs.

---

# Runtime Observation

A useful first-level workload investigation is:

```text
get
 ↓
describe
 ↓
events
 ↓
logs
```

If the evidence points below the Pod layer, continue into:

```text
Node
kubelet
Container Runtime
CNI
Linux
```

---

# Container Runtime Architecture

The conceptual execution path remains:

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

Kubernetes abstractions ultimately result in real container and Linux process activity.

---

# Kubernetes Networking Foundation

Cluster networking includes multiple domains.

```text
Node Network
Pod Network
Service Network
```

Pod networking is provided through the CNI architecture.

Service networking is studied later.

---

# Linux Foundations

Relevant Linux studies are documented under:

```text
../linux/
```

Important relationships include:

```text
Processes
Namespaces
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
Service Connectivity
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
Volumes
Multi-Container Applications
Container Clustering
```

Kubernetes extends these concepts into API-driven cluster orchestration.

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
Controller
Scheduler
Pod
Container
Worker Node
kubelet
Container Runtime
CNI
Network
Storage
Application
```

---

# Pod Troubleshooting

A practical starting workflow is:

```text
kubectl get pod
      ↓
kubectl describe pod
      ↓
Events
      ↓
kubectl logs
```

Potential evidence then determines whether investigation should continue into:

```text
Image / Registry
Scheduler
Node
Runtime
CNI
Application
```

---

# Runtime vs Desired State

Kubernetes distinguishes:

```text
Desired State
vs
Observed Runtime State
```

A YAML object describes intent.

Runtime evidence shows what actually happened.

This distinction is central to reliable Kubernetes administration.

---

# Security Approach

Security should be treated as part of Kubernetes architecture.

Current principles include:

```text
Do not publish bootstrap tokens.
Do not commit kubeconfig credentials.
Do not commit real application secrets.
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
Pod Names
Pod Addresses
Container IDs
API Server Addresses
Events
Runtime IDs
Scheduler Decisions
Node Status
Application Logs
Command Output
```

Actual evidence must come from an authorized lab environment.

---

# Historical Material Policy

The Kubernetes course contains historical installation procedures, runtime assumptions, API versions, and networking implementation details.

Examples include:

```text
Older Kubernetes repositories
Older Ubuntu / CentOS releases
Historical Docker runtime integration
docker0-based Pod diagrams
Historical kubelet CNI flags
Older Calico manifests
Heapster
rkt
Legacy Kubernetes API versions
```

These are preserved as course context while reusable Kubernetes architecture is documented separately.

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
CNI Installation
Worker Node Join
Node Ready Verification
kubectl Fundamentals
API Resource Discovery
API Version Discovery
Pod Creation
Pod Fundamentals
Pod Network Namespace
Kubernetes Network Communication Types
CNI Pod Networking
Pod Volume Introduction
PV / PVC Introduction
ConfigMap / Secret Volume Introduction
CSI Introduction
Kubernetes Object Structure
YAML Fundamentals
Pod Events
Pod Description
Pod Logs
Basic Pod Troubleshooting
```

The next major topics are:

```text
Pod Command Execution
Pod Connection
Detailed Pod YAML
Object YAML Inspection
Resource Templates
dry-run
Controllers
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
