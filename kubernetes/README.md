# Kubernetes Infrastructure Labs

This directory documents my Kubernetes learning path as part of my cloud infrastructure engineering studies.

The focus is not only on `kubectl` commands, but on understanding Kubernetes as an API-driven desired-state platform built on Linux, networking, container runtimes, distributed control-plane components, declarative resources, observable workload state, and controller-based reconciliation.

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
Runtime Inspection
        ↓
Object YAML
        ↓
Resource Templates
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
├── pod-fundamentals-lab.md
└── resource-object-template-lab.md
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
```

```text
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

This section connects Kubernetes bootstrap directly to Linux administration, networking, systemd, and container runtime concepts.

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

The initial operational observation flow is:

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

Different commands expose different kinds of evidence and should not be treated as interchangeable.

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
Namespace
Pod IP
Multi-Container Pods
Shared Network Namespace
Pause / Sandbox Container
Container-to-Container Networking
Pod-to-Pod Networking
Pod-to-Service Networking
External-to-Service Networking
CNI
Pod Storage
Volumes
PersistentVolume
PersistentVolumeClaim
ConfigMap
Secret
CSI
YAML
Pod Manifests
Pod Conditions
Pod Events
Pod Inspection
Pod Logs
kubectl exec
Interactive Container Access
Container Environment
Exit Codes
Labels
spec
status
Live Object YAML Inspection
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

Storage concepts introduced so far include:

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

# Pod Runtime Inspection

A running Pod can be inspected beyond its summary state.

Useful evidence includes:

```text
Pod Conditions
Container State
Restart Count
Events
Logs
Environment
Exit Codes
```

The investigation flow can expand to:

```text
kubectl get pod
      ↓
kubectl describe pod
      ↓
Events
      ↓
kubectl logs
      ↓
kubectl exec
      ↓
Targeted Runtime Inspection
```

---

# `kubectl exec`

`kubectl exec` executes an additional process inside a running container.

Conceptually:

```text
Local Terminal
      ↓
kubectl
      ↓
Kubernetes API
      ↓
Running Pod
      ↓
Container Process
```

It should not be treated as SSH login.

For multi-container Pods, a target container can be selected explicitly.

Interactive sessions commonly use:

```text
-i
→ stdin
```

```text
-t
→ terminal
```

---

# Minimal Container Images

Application containers may not contain general-purpose Linux administration tools.

A container can lack commands such as:

```text
ps
ip
curl
ping
vi
```

This does not automatically indicate a Kubernetes failure.

The image may intentionally contain only the software required to run the application.

---

# Container Exit Codes

Container exit codes are useful runtime evidence.

For example, the course demonstrates a command-not-found case associated with exit code:

```text
127
```

Exit codes should be correlated with:

```text
Container State
Application Logs
Command Configuration
Runtime Events
```

rather than interpreted in isolation.

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
→ Resource identity and metadata

spec
→ Desired configuration
```

The live API object can also contain:

```text
status
```

which represents observed runtime state.

---

# `spec` vs `status`

One of the most important Kubernetes distinctions is:

```text
spec
→ Desired State
```

```text
status
→ Observed State
```

This provides the foundation for controller-based reconciliation.

```text
spec
      ↓
Controller
      ↓
Observed Runtime State
      ↓
status
```

When the two do not match, Kubernetes controllers can perform reconciliation work.

---

# Live Object YAML

A running resource can be inspected as YAML.

Conceptually:

```text
Kubernetes API Object
       ↓
kubectl get -o yaml
       ↓
Full Object Representation
```

This representation can contain both:

```text
User-defined desired configuration
```

and:

```text
Server-generated runtime information
```

Examples of server-managed information can include:

```text
creationTimestamp
resourceVersion
uid
nodeName
runtime annotations
status
```

A live-object export should therefore be reviewed before it is reused as a manifest.

---

# Labels

Pod metadata can include labels.

Conceptually:

```text
Kubernetes Object
       ↓
Label
       ↓
Key / Value Metadata
```

Labels later become important for:

```text
Selectors
Services
ReplicaSets
Deployments
```

Detailed label and selector behavior is studied later.

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

# 6. Resource Object Templates

File:

```text
resource-object-template-lab.md
```

Topics include:

```text
Object Templates
kubectl get -o yaml
Live Object Export
Server-Generated Metadata
Object Identity
spec
status
Manifest Cleanup
dry-run
dry-run=client
kubectl create
Deployment Template
Template Editing
Template Verification
```

Two template-generation approaches were introduced.

```text
Existing Object
      ↓
kubectl get -o yaml
      ↓
Clean and Edit
      ↓
Reusable Manifest
```

and:

```text
kubectl create
      +
--dry-run=client
      +
-o yaml
      ↓
Generated Manifest
```

---

# Exported Object vs Reusable Manifest

A live API object and a reusable manifest serve different purposes.

```text
Live Object YAML
→ What exists now?
```

```text
Reusable Manifest
→ What should be created?
```

A live object can contain transient or server-generated fields that should not be copied blindly into a new definition.

---

# Server-Generated Metadata

Fields associated with an existing resource can include:

```text
creationTimestamp
resourceVersion
uid
status
runtime annotations
assigned node information
```

A new Kubernetes object should receive its own runtime identity and observed state.

---

# Client-Side Dry Run

A resource template can be generated without creating the resource.

Conceptually:

```text
kubectl create ...
      ↓
--dry-run=client
      ↓
Generate Object Locally
      ↓
-o yaml
      ↓
Manifest Template
```

This is useful for preparing a clean starting point for version-controlled manifests.

---

# Historical Deployment API Context

The course demonstrates an older Deployment API version:

```text
apps/v1beta1
```

This should be treated as historical course context.

Modern Deployment manifests should be understood through:

```text
apps/v1
```

The reusable concept is the object-generation workflow rather than the historical beta API version.

---

# Deployment Resource Hierarchy Introduction

The template exercise introduces the first controller-managed resource hierarchy.

```text
Deployment
     ↓
ReplicaSet
     ↓
Pod
```

This forms the transition into the next course section on Kubernetes controllers.

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
Observed State
```

A manifest expresses desired configuration.

Cluster components observe runtime state and work toward the desired configuration.

The next controller section expands this model in detail.

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
```

Creating an API object and obtaining a healthy workload are separate verification stages.

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

A Kubernetes node remains a real operating-system environment.

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
Conditions / Events
      ↓
kubectl logs
      ↓
kubectl exec
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

# Desired Manifest vs Live Object

A useful configuration comparison is:

```text
Manifest
→ Intended configuration
```

```text
Live Object
→ API representation of current object
```

Comparing them helps distinguish:

```text
Desired Configuration
Server-Generated Metadata
Observed Runtime State
```

This becomes increasingly important as controller-managed resources are introduced.

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
Review exported object YAML before publishing it.
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
Exit Codes
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
apps/v1beta1 Deployment examples
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
Controller Manager Introduction
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
Imperative Pod Creation
kubectl get
kubectl describe
Kubernetes Events
kubectl logs

Pod Fundamentals
Pod Network Namespace
Pod IP
Kubernetes Network Communication Types
CNI Pod Networking
Pod Storage Introduction
PV / PVC Introduction
ConfigMap / Secret Volume Introduction
CSI Introduction

Kubernetes Object Structure
YAML Fundamentals
Pod Manifest Creation
Pod Conditions
Pod Events
Pod Description
Pod Logs
kubectl exec
Interactive Container Access
Container Environment Inspection
Exit Code Observation
Labels Introduction

Live Object YAML Inspection
spec vs status
Server-Generated Metadata
Resource Object Templates
kubectl get -o yaml
Manifest Cleanup
dry-run=client
Deployment Template Generation
Deployment → ReplicaSet → Pod Introduction
```

The current course position is:

```text
Completed through p.65
```

The next major topic is:

```text
Controllers
```

Upcoming concepts include:

```text
Controller Reconciliation
ReplicaSet
DaemonSet
Job
Deployment
StatefulSet
Node Controller
Service Controller
PersistentVolume Controller
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
