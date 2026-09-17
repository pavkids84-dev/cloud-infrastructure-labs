# Kubernetes Architecture Foundations Lab

## Objective

Understand why Kubernetes is used for container orchestration and how its control plane, worker nodes, API-driven architecture, and container runtime layers work together.

This lab connects previously studied Docker, Linux, and networking concepts to Kubernetes cluster architecture.

## Scope

```text
Kubernetes
Container Orchestration
Control Plane
Worker Node
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
CNI
Cluster DNS
Ingress
High Availability
```

---

# Kubernetes

Kubernetes is a container orchestration platform.

It expands container management from individual hosts toward cluster-level workload operation.

Conceptually:

```text
Container Runtime
       ↓
Multiple Containers
       ↓
Multiple Nodes
       ↓
Scheduling
Discovery
State Management
Failure Handling
       ↓
Kubernetes
```

Kubernetes should therefore be understood as a cluster-management and orchestration layer rather than as a replacement for container images or Linux container technology.

---

# Desired State

A central Kubernetes concept is convergence toward a desired state.

```text
Desired State
      ↓
Controller Observation
      ↓
Current State
      ↓
Difference Detected
      ↓
Reconciliation
      ↓
Desired State Restored
```

For example:

```text
Desired Pods = 3
Current Pods = 2
```

requires additional reconciliation until the requested state is restored.

---

# Cluster Architecture

A simplified Kubernetes cluster contains:

```text
Kubernetes Cluster
│
├── Control Plane
│   ├── kube-apiserver
│   ├── etcd
│   ├── kube-scheduler
│   └── kube-controller-manager
│
└── Worker Nodes
    ├── kubelet
    ├── kube-proxy
    ├── Container Runtime
    └── Workloads
```

The control plane makes cluster-management decisions.

Worker nodes execute application workloads.

---

# Control Plane

The control plane manages cluster state and coordinates workload operation.

Conceptually:

```text
User Request
     ↓
Kubernetes API
     ↓
Cluster State
     ↓
Controllers / Scheduler
     ↓
Worker Nodes
```

It should be treated as the cluster-management layer rather than the normal application workload layer.

---

# kube-apiserver

The API server is the central API entry point for Kubernetes.

Conceptually:

```text
kubectl
Controllers
Scheduler
Kubelets
Other API Clients
       ↓
kube-apiserver
```

Kubernetes components interact with cluster state through the API server rather than treating the underlying state store as a general-purpose database interface.

---

# API-Driven Infrastructure

`kubectl` should be understood as an API client.

```text
kubectl
   ↓
Kubernetes API
   ↓
API Objects
```

This API-driven architecture later supports additional automation technologies and controllers.

A command is therefore not the architecture itself.

It is one client interface to the Kubernetes API.

---

# etcd

`etcd` stores Kubernetes cluster state.

Conceptually:

```text
Kubernetes API
      ↓
etcd
      ↓
Cluster State
```

Cluster-state information can include Kubernetes object and configuration state managed through the API.

Components should not be designed around directly modifying etcd instead of using the Kubernetes API.

---

# kube-scheduler

The scheduler selects a node for a workload that requires placement.

```text
Unscheduled Pod
      ↓
kube-scheduler
      ↓
Node Selection
```

The scheduler does not represent the container runtime itself.

Its primary concern is workload placement.

---

# kube-controller-manager

Controllers continuously reconcile cluster state.

```text
Desired State
      ↓
Controller
      ↓
Observe Current State
      ↓
Take Reconciliation Action
```

Examples of controller responsibilities later in the Kubernetes learning path include:

```text
Replica Management
Deployment Management
Node Management
Service Management
Persistent Volume Management
```

---

# Reconciliation

Reconciliation is a core Kubernetes operating model.

```text
Observe
  ↓
Compare
  ↓
Act
  ↓
Observe Again
```

This differs from a purely imperative model where an administrator manually performs every runtime action.

---

# Worker Node

Worker nodes provide the environment where workloads execute.

Important components include:

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
Containers
```

---

# kubelet

The kubelet is a node-level agent.

Conceptually:

```text
Kubernetes API
      ↓
Desired Pod State
      ↓
kubelet
      ↓
Container Runtime
      ↓
Containers
```

The kubelet is responsible for maintaining the expected workload state on its node.

---

# kube-proxy

`kube-proxy` is associated with Kubernetes Service networking on each node.

Its detailed traffic-handling behavior is covered later with Kubernetes Services.

At the architecture level:

```text
Service Networking
       ↓
Node-Level Traffic Handling
       ↓
Pod Endpoints
```

is the important relationship.

---

# Container Runtime

Worker nodes require a runtime capable of executing containers.

The conceptual runtime path is:

```text
kubelet
   ↓
Container Runtime Interface
   ↓
Container Runtime
   ↓
OCI Runtime
   ↓
Linux Kernel
```

The runtime layer connects Kubernetes workload definitions to Linux container execution.

---

# CRI

CRI means:

```text
Container Runtime Interface
```

It provides the interface between Kubernetes node management and supported container runtimes.

Conceptually:

```text
Kubernetes
    ↓
kubelet
    ↓
CRI
 ┌──┴────────┐
containerd  CRI-O
```

This helps Kubernetes avoid being tightly coupled to one specific high-level container engine.

---

# containerd

`containerd` provides container lifecycle and runtime functionality used by container platforms.

A simplified stack is:

```text
Kubernetes
   ↓
CRI
   ↓
containerd
   ↓
OCI Runtime
   ↓
Container
```

Docker environments can also use containerd internally.

Docker knowledge therefore remains relevant when moving into Kubernetes.

---

# CRI-O

CRI-O is designed around Kubernetes CRI and OCI-compatible container runtimes.

Conceptually:

```text
Kubernetes
   ↓
CRI
   ↓
CRI-O
   ↓
OCI Runtime
   ↓
Container
```

It represents another runtime path without requiring Docker Engine as the Kubernetes runtime integration layer.

---

# runc

`runc` is an OCI-compatible low-level container runtime.

Conceptually:

```text
Higher-Level Runtime
       ↓
runc
       ↓
Linux Namespaces
Linux cgroups
       ↓
Container Process
```

This directly connects Kubernetes back to the Linux container fundamentals studied earlier.

---

# OCI

OCI stands for:

```text
Open Container Initiative
```

The container ecosystem uses standards around container images and runtime behavior.

This enables interoperability across multiple container tools and runtimes.

---

# Docker and Kubernetes Runtime Context

Older Kubernetes environments could use Docker Engine through a Kubernetes integration layer.

Modern Kubernetes runtime architecture should be understood through CRI.

The important distinction is:

```text
Docker Image Support
!=
Docker Engine Required as Kubernetes Runtime
```

Docker-compatible OCI images remain useful even when Kubernetes nodes use containerd or CRI-O.

---

# Add-On Components

The course introduces cluster add-ons such as:

```text
Cluster DNS
Dashboard
Monitoring Components
CNI Plugins
Ingress
```

These provide capabilities beyond the core control-plane and node components.

---

# Cluster DNS

Dynamic workloads should not depend only on temporary IP addresses.

Conceptually:

```text
Service Name
     ↓
Cluster DNS
     ↓
Kubernetes Service
```

This provides a foundation for service discovery inside the cluster.

---

# CNI

CNI means:

```text
Container Network Interface
```

A simplified relationship is:

```text
Pod Creation
    ↓
CNI Plugin
    ↓
Pod Network Interface
IP Address
Network Connectivity
```

CNI connects Kubernetes workload networking to Linux and network infrastructure concepts.

---

# Ingress

Ingress is associated with managing external HTTP/HTTPS access toward applications in a Kubernetes cluster.

Its detailed architecture is studied after Kubernetes Service fundamentals.

At this stage:

```text
External HTTP / HTTPS
        ↓
Ingress Layer
        ↓
Cluster Application
```

is sufficient as a conceptual model.

---

# Historical Monitoring Context

The course references Heapster.

Heapster should be treated as historical Kubernetes monitoring context.

Modern resource-metric study should focus on the monitoring components introduced later in the Kubernetes material, including Metrics Server.

---

# High-Availability Control Plane

A production-oriented Kubernetes architecture can use multiple control-plane instances.

Conceptually:

```text
Clients
   ↓
Load Balancer
   ↓
Control Plane 1
Control Plane 2
Control Plane 3
```

Multiple API servers can process API traffic.

Scheduler and controller-manager instances use coordination so that one active leader performs the primary reconciliation role for a given control-plane function.

---

# etcd High Availability

`etcd` should be treated as a distributed cluster state store.

Avoid reducing its architecture to a generic database "active-active" label.

The important infrastructure concepts are:

```text
Distributed State
Consensus
Quorum
Availability
```

Detailed etcd operations should be studied when the Kubernetes material covers cluster high availability.

---

# Control Plane Request Flow

A simplified request path is:

```text
User
 ↓
kubectl
 ↓
kube-apiserver
 ↓
Object State
 ↓
Controllers / Scheduler
 ↓
Worker Node
 ↓
kubelet
 ↓
Container Runtime
 ↓
Container
```

This model provides the foundation for later Kubernetes troubleshooting.

---

# Troubleshooting Perspective

Kubernetes adds several layers beyond Docker.

A future troubleshooting model becomes:

```text
Application
    ↓
Container
    ↓
Pod
    ↓
kubelet / Runtime
    ↓
Worker Node
    ↓
Network / Storage
    ↓
Control Plane
    ↓
Kubernetes API
```

Do not immediately assume a failed application means the container image itself is the root cause.

---

# Linux Relationship

Kubernetes ultimately depends on Linux infrastructure concepts.

```text
Processes
→ Container workloads

Namespaces
→ Container isolation

cgroups
→ Resource control

Networking
→ Pod and Service connectivity

Storage
→ Kubernetes volume backends

systemd
→ Node service management
```

---

# Docker Relationship

Docker study provides the immediate foundation for Kubernetes.

```text
Docker Image
→ Kubernetes workload image

Container Runtime
→ Pod container execution

Docker Networking Concepts
→ Pod networking foundation

Registry
→ Kubernetes image distribution

Compose
→ Multi-container application thinking

Docker Cluster Concepts
→ Kubernetes orchestration motivation
```

Kubernetes expands these concepts to cluster-level desired-state management.

---

# Evidence Policy

Course screenshots and example runtime data are educational examples.

Do not fabricate:

```text
Cluster Names
Node Names
Node IP Addresses
Pod IP Addresses
Container IDs
Runtime IDs
API Server Addresses
etcd Members
Scheduler Decisions
CNI Interfaces
Command Output
```

Actual evidence should come from an authorized Kubernetes lab environment.

---

# Verification Checklist

- Kubernetes was understood as a container orchestration platform.
- Desired state and current state were distinguished.
- Control plane and worker nodes were distinguished.
- `kube-apiserver` was identified as the central Kubernetes API entry point.
- `etcd` was identified as the cluster state store.
- `kube-scheduler` was connected to workload placement.
- `kube-controller-manager` was connected to reconciliation.
- `kubelet` was connected to node-level workload execution.
- `kube-proxy` was identified as a Service-networking-related node component.
- CRI was distinguished from Docker Engine.
- `containerd`, CRI-O, and runc were placed into the runtime architecture.
- Docker image compatibility was distinguished from the historical Docker runtime integration.
- CNI was connected to Pod networking.
- Cluster DNS and Ingress were introduced.
- Heapster was treated as historical course context.
- High-availability control-plane architecture was introduced.
- Course screenshots were not treated as actual runtime evidence.

## What I Learned

- Kubernetes manages desired workload state across a cluster rather than only starting individual containers.
- The API server is the central control-plane interface.
- Controllers continuously reconcile current state with desired state.
- The scheduler chooses where workloads should run.
- Kubelets manage workloads on worker nodes.
- Kubernetes uses CRI-compatible container runtimes to execute containers.
- Linux namespaces, cgroups, networking, and container standards remain fundamental underneath Kubernetes.
- The Docker learning path provides the direct foundation for Kubernetes orchestration.
