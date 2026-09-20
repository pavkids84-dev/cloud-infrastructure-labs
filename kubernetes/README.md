# Kubernetes Infrastructure Labs

This directory documents my Kubernetes learning path as part of my cloud infrastructure engineering studies.

The focus is on understanding Kubernetes as an API-driven desired-state platform built on Linux, networking, container runtimes, declarative resources, controller reconciliation, and service networking.

## Learning Path

```text
Containers
   ↓
Kubernetes Architecture
   ↓
Minikube
   ↓
kubeadm
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
Labels and Selectors
   ↓
Deployments and Rolling Updates
   ↓
Monitoring
   ↓
Security / RBAC
   ↓
Helm
   ↓
Storage
   ↓
High Availability
```

## Directory Structure

```text
kubernetes/
├── README.md
├── kubernetes-architecture-foundations-lab.md
├── minikube-local-cluster-lab.md
├── kubeadm-cluster-bootstrap-lab.md
├── kubectl-basic-control-lab.md
├── pod-fundamentals-lab.md
├── resource-object-template-lab.md
├── controller-fundamentals-lab.md
└── service-fundamentals-lab.md
```

Additional files should be added only after the related topics are actually studied.

## 1. Kubernetes Architecture Foundations

File:

```text
kubernetes-architecture-foundations-lab.md
```

Covers:

```text
Container Orchestration
Control Plane
Worker Nodes
kube-apiserver
etcd
Scheduler
Controller Manager
kubelet
kube-proxy
CRI
containerd
CRI-O
OCI Runtime
CNI
Cluster DNS
Ingress Introduction
High Availability Introduction
```

## 2. Minikube Local Cluster

File:

```text
minikube-local-cluster-lab.md
```

Covers local Kubernetes startup, kubeconfig, API connectivity, node readiness, system-component inspection, and Dashboard context.

## 3. kubeadm Cluster Bootstrap

File:

```text
kubeadm-cluster-bootstrap-lab.md
```

Covers Linux node preparation, control-plane bootstrap, CNI installation, worker join, node readiness, kube-system observation, and the relationship between Kubernetes objects and Linux processes.

## 4. kubectl Basic Control

File:

```text
kubectl-basic-control-lab.md
```

Covers resource discovery, API versions, imperative Pod creation, `get`, `describe`, events, logs, and the first Kubernetes troubleshooting workflow.

## 5. Pod Fundamentals

File:

```text
pod-fundamentals-lab.md
```

Covers:

```text
Pod Scheduling
Pod IP
Shared Network Namespace
Pause / Sandbox Context
CNI
Pod Volumes
PV / PVC Introduction
ConfigMap / Secret Volume Sources
CSI Introduction
YAML
Pod Conditions
Events
Logs
kubectl exec
Container Environment
Exit Codes
Labels Introduction
Live Object YAML
spec vs status
```

A practical Pod investigation starts with:

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

## 6. Resource Object Templates

File:

```text
resource-object-template-lab.md
```

Covers the difference between:

```text
kubectl get -o yaml
→ derive from an existing live object
```

and:

```text
--dry-run=client -o yaml
→ generate a new manifest without creating it
```

Live-object state and reusable desired-state manifests should not be treated as identical.

## 7. Controller Fundamentals

File:

```text
controller-fundamentals-lab.md
```

Covers:

```text
Reconciliation
Desired State
Observed State
ReplicaSet
Deployment
StatefulSet
DaemonSet
Job
Node Controller
Service Controller
PersistentVolume Controller
Owner References
Cascading Deletion
Scale Out
Scale In
Namespaces
```

Core model:

```text
spec
 ↓
Controller
 ↓
Observed State
 ↓
Reconciliation
 ↓
status
```

A common workload hierarchy is:

```text
Deployment
     ↓
ReplicaSet
     ↓
Pod
```

## 8. Service Fundamentals

File:

```text
service-fundamentals-lab.md
```

Covers:

```text
Service
Stable Service Identity
Labels and Selectors
Service DNS
port
targetPort
ClusterIP
NodePort
LoadBalancer
ExternalName
Endpoints
EndpointSlice Context
kubectl expose
kube-proxy
iptables
IPVS
Service Troubleshooting
```

Core networking model:

```text
Client
   ↓
Service
   ↓
Selected Backends
   ↓
Pods
```

Services provide stable network and name identities in front of dynamic Pod backends.

## API-Driven Architecture

```text
kubectl / Automation
        ↓
kube-apiserver
        ↓
Kubernetes Objects
```

The API server remains the central interface for desired-state management.

## Desired State and Reconciliation

```text
Desired State
      ↓
Controller
      ↓
Observe Current State
      ↓
Reconcile Difference
```

This model is now visible in workload replica management, deployment revisions, and controller-managed resources.

## Kubernetes Networking

Current networking concepts include:

```text
Node Network
Pod Network
Service Network
CNI
Cluster DNS
Service Selectors
Backend Endpoints
kube-proxy
iptables
IPVS
```

The Service path should be reasoned about separately from direct Pod access.

## Service Types

```text
ClusterIP
→ Cluster-internal Service identity
```

```text
NodePort
→ Node address plus exposed node port
```

```text
LoadBalancer
→ External load-balancer integration where supported
```

```text
ExternalName
→ DNS mapping toward an external name
```

## Linux Relationship

Kubernetes still depends on Linux fundamentals:

```text
Processes
Namespaces
systemd
Networking
Routing
Netfilter
Storage
Filesystems
Security
Logs
```

## Network Relationship

Relevant networking foundations include:

```text
IP Addressing
Subnetting
Routing
DNS
TCP / UDP
Ports
Load Balancing
Packet Analysis
```

These remain necessary for Pod and Service troubleshooting.

## Docker Relationship

Docker studies provide the immediate container foundation:

```text
Images
Container Processes
Runtime
Networking
Volumes
Registry
Multi-Container Applications
Clustering
```

Kubernetes adds API-driven scheduling and reconciliation.

## Troubleshooting Method

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

Potential Kubernetes layers now include:

```text
Application
Container
Pod
Controller
Service
Backend Endpoints
kube-proxy / Dataplane
CNI
Worker Node
Container Runtime
kubelet
Control Plane
Kubernetes API
```

## Service Troubleshooting

A useful Service workflow is:

```text
Application listening?
      ↓
Pod Ready?
      ↓
Pod labels correct?
      ↓
Service selector correct?
      ↓
Backend endpoints present?
      ↓
port / targetPort correct?
      ↓
Service type correct?
      ↓
Node / external path reachable?
```

## Security Principles

Current principles include:

```text
Do not publish kubeconfig credentials.
Do not publish bootstrap tokens.
Do not commit real application secrets.
Use least privilege.
Do not disable host security controls as a generic fix.
Review exported live-object YAML before publishing it.
```

## Evidence Policy

Course screenshots and example values are educational examples.

Do not fabricate:

```text
Node Names
Pod Names
Pod IP Addresses
Service IP Addresses
NodePort Values
Endpoint Addresses
Container IDs
Events
Logs
DNS Results
iptables Rules
IPVS Tables
Command Output
```

Actual evidence must come from an authorized lab environment.

## Historical Material Policy

The course contains historical implementation details.

Examples encountered include:

```text
Older Kubernetes package repositories
Historical Docker runtime integration
Heapster
rkt
docker0-based diagrams
Historical kubelet CNI flags
Older Calico manifests
apps/v1beta1 Deployment examples
Endpoints-focused Service material
```

Historical source material should be preserved while reusable architecture and newer concepts are clearly distinguished.

## Current Learning Progress

Completed through Kubernetes PDF:

```text
p.94
```

Completed areas include:

```text
Kubernetes Architecture
Minikube
kubeadm
kubectl
Pods
CNI
Pod Storage Introduction
YAML
Pod Runtime Inspection
Live Object Inspection
Resource Templates
Controller Reconciliation
ReplicaSet
Deployment Introduction
Scaling
Namespaces
Service Fundamentals
Service Types
Endpoints
kube-proxy
iptables
IPVS
```

Next topic:

```text
Labels and Selectors
```

The course continues from:

```text
p.95
```

## Long-Term Infrastructure Path

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
