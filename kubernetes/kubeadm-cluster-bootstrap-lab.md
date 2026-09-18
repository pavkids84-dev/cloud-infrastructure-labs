# kubeadm Cluster Bootstrap Lab

## Objective

Understand how kubeadm bootstraps a Kubernetes control plane, prepares worker nodes, configures Kubernetes API access, installs pod networking, and joins additional nodes to the cluster.

This lab focuses on the architecture and verification workflow behind cluster bootstrap rather than preserving version-specific package repository commands from the course.

## Scope

```text
kubeadm
Control Plane Bootstrap
Worker Node Preparation
Linux Node Prerequisites
Hostname and Addressing
Swap Course Requirement
Container Runtime
kubelet
kubectl
kubeconfig
kubeadm init
Pod Network CIDR
CNI
Calico Course Example
kubeadm join
Bootstrap Token
CA Certificate Hash
Node Registration
Node Ready State
kube-system
Control Plane Components
Linux Process Inspection
Cluster Verification
```

---

# Cluster Model

The course builds a Kubernetes cluster using:

```text
Control Plane Node
        +
Worker Node
        ↓
Kubernetes Cluster
```

The course uses the historical term:

```text
Master
```

for the control-plane node.

This lab uses:

```text
Control Plane
```

as the primary architectural term.

---

# Minikube vs kubeadm

Minikube provides a local Kubernetes learning environment.

```text
Local Computer
      ↓
Minikube
      ↓
Kubernetes Cluster
```

kubeadm introduces a node-oriented cluster bootstrap workflow.

```text
Linux Node A
→ Control Plane

Linux Node B
→ Worker
```

This exposes more of the Linux, runtime, networking, and node-management layers underneath Kubernetes.

---

# Node Preparation

The course prepares Linux nodes before running kubeadm.

Conceptually:

```text
Linux Installation
      ↓
Hostname
      ↓
IP Addressing
      ↓
Host Name Resolution
      ↓
Host Resources
      ↓
Container Runtime
      ↓
Kubernetes Components
```

Cluster bootstrap should not be treated as starting only with `kubeadm init`.

---

# Host Identity

The course configures distinct hostnames for cluster nodes.

Conceptually:

```text
Control Plane
→ Unique Hostname

Worker
→ Unique Hostname
```

The Kubernetes Node object later exposes the node identity through the cluster API.

---

# Name Resolution

The course modifies `/etc/hosts` as part of node preparation.

Conceptually:

```text
Hostname
   ↕
IP Address
```

Host-level name resolution is part of the infrastructure beneath Kubernetes.

A Kubernetes-looking failure can still originate from the Linux host or network layer.

---

# Static Addressing Course Context

The course uses stable addressing for its cluster nodes.

The important infrastructure concept is:

```text
Cluster Nodes
→ Predictable Reachability
```

The exact addressing method depends on the target infrastructure.

Cloud, virtual-machine, and physical environments can use different mechanisms.

---

# Swap Course Requirement

The course disables swap before cluster bootstrap.

This should be recorded as:

```text
Course kubeadm environment
→ Swap disabled
```

rather than treated as a permanent version-independent Kubernetes rule.

Actual swap support and requirements should be verified against the Kubernetes version and kubelet configuration used by the target environment.

---

# Firewall and Security Course Context

The course disables firewall enforcement and changes SELinux behavior to simplify the lab.

These steps should not be generalized as production Kubernetes requirements.

A production-oriented infrastructure design should intentionally configure:

```text
Required Ports
Network Policy
Host Firewall
Host Security Policy
```

rather than broadly disabling security controls only to make cluster communication work.

---

# Linux Bridge and Netfilter Configuration

The course configures Linux bridge-related sysctl values.

Conceptually:

```text
Pod Traffic
     ↓
Linux Networking
     ↓
Bridge / Netfilter Processing
```

This reinforces that Kubernetes networking depends on Linux kernel networking behavior.

---

# Kubernetes Node Components

The course installs:

```text
kubelet
kubeadm
kubectl
```

These components have different responsibilities.

```text
kubeadm
→ Cluster bootstrap
```

```text
kubelet
→ Node-level Kubernetes agent
```

```text
kubectl
→ Kubernetes API client
```

They should not be treated as interchangeable tools.

---

# kubelet

The kubelet runs as a Linux node service.

Conceptually:

```text
Linux systemd
      ↓
kubelet
      ↓
Kubernetes Node
      ↓
Pod Runtime
```

Kubernetes node troubleshooting can therefore require both:

```text
kubectl
```

and:

```text
Linux service / log inspection
```

---

# Container Runtime Context

The course installs Docker as part of its historical cluster environment.

The architectural requirement should be understood more generally as:

```text
Worker Node
      ↓
CRI-Compatible Container Runtime
      ↓
Containers
```

Docker Engine should not be treated as a permanent Kubernetes runtime requirement.

---

# Historical Package Installation

The course contains older Kubernetes package repository URLs and package-signing procedures.

These should be treated as historical course context.

This repository intentionally records the architecture:

```text
Install kubelet
Install kubeadm
Install kubectl
```

rather than presenting historical repository commands as current installation instructions.

---

# `kubeadm init`

The control-plane bootstrap begins with:

```text
kubeadm init
```

Conceptually:

```text
Prepared Control Plane Node
        ↓
kubeadm init
        ↓
Control Plane Bootstrap
        ↓
Kubernetes Cluster State
```

The exact command options depend on the cluster design and Kubernetes version.

---

# Pod Network CIDR

The course initializes the cluster using a pod-network CIDR.

Conceptually:

```text
Node Network
!=
Pod Network
```

The pod network uses its own address space for workload communication.

```text
Worker Node
├── Pod A → Pod IP
└── Pod B → Pod IP
```

Understanding CIDR and routing is therefore directly relevant to Kubernetes cluster networking.

---

# `kubeadm init` Output

Successful initialization provides information required for subsequent cluster setup.

Important categories include:

```text
kubectl Access Configuration
Worker Join Information
```

Bootstrap output should therefore be preserved when it contains information needed for the next cluster step.

Do not commit real bootstrap credentials or tokens to Git.

---

# kubeconfig

The course copies:

```text
/etc/kubernetes/admin.conf
```

into the user's kubeconfig location.

Conceptually:

```text
Admin Cluster Configuration
       ↓
~/.kube/config
       ↓
kubectl
       ↓
Kubernetes API Server
```

kubeconfig determines which cluster and identity a Kubernetes client uses.

---

# Client Configuration

A useful kubeconfig model is:

```text
Cluster
+
User
+
Context
       ↓
kubectl
       ↓
Kubernetes API
```

Client configuration and cluster runtime state should be investigated separately during troubleshooting.

---

# CNI Installation

Control-plane bootstrap alone does not provide the complete pod-network environment.

The course next installs a CNI implementation.

Conceptually:

```text
kubeadm init
     ↓
Control Plane
     ↓
CNI Plugin
     ↓
Pod Network
```

---

# Calico Course Example

The course uses Calico as its CNI implementation.

```text
Kubernetes
    ↓
CNI
    ↓
Calico
    ↓
Pod Networking
```

The exact Calico URLs and version shown by the course are historical.

Do not treat those manifest locations as current installation instructions.

---

# Cluster Verification

After network configuration, the course verifies cluster resources.

Conceptually:

```text
Control Plane Created?
       ↓
System Workloads Running?
       ↓
Node Registered?
       ↓
Node Ready?
```

Useful Kubernetes object categories include:

```text
Nodes
Pods
Namespaces
System Workloads
```

Verification is a separate step from installation.

---

# Worker Node Preparation

Worker nodes require the same underlying infrastructure preparation:

```text
Linux
Networking
Container Runtime
kubelet
kubeadm
```

The worker does not create a new independent Kubernetes cluster.

It joins the existing control plane.

---

# `kubeadm join`

The worker join workflow is:

```text
Prepared Worker Node
       ↓
kubeadm join
       ↓
Control Plane Endpoint
       ↓
Bootstrap Trust
       ↓
Node Registration
       ↓
Cluster Membership
```

Do not hardcode course tokens, addresses, or certificate hashes into reusable Git documentation.

---

# Bootstrap Token

The course join command contains a bootstrap token.

Treat this as credential-like runtime data.

Documentation should use placeholders:

```text
<BOOTSTRAP_TOKEN>
```

rather than copying actual cluster values.

---

# Discovery CA Certificate Hash

The join command also contains a discovery CA certificate hash.

Conceptually:

```text
Worker Node
      ↓
Validate Cluster Trust
      ↓
Join Control Plane
```

Joining a Kubernetes cluster is therefore more than simply knowing the API server address.

---

# Watching Node State

The course uses continuous node observation after the worker joins.

Conceptually:

```text
Worker Join
     ↓
Node Registration
     ↓
Node State Changes
     ↓
Ready
```

Watching resource state is useful because Kubernetes objects can transition asynchronously.

---

# Node Ready State

A node can exist as a Kubernetes object without yet being ready to accept normal workloads.

```text
Node Registered
!=
Node Ready
```

The node state should therefore be verified after bootstrap.

---

# kubeadm and Administrative Privilege

The course emphasizes that kubeadm bootstrap operations require administrative privilege.

This is distinct from normal API interactions with `kubectl`.

```text
kubeadm
→ Host / Cluster bootstrap administration
```

```text
kubectl
→ Kubernetes API object management
```

---

# Cluster Components

After bootstrap, the architecture can be observed as:

```text
Control Plane
├── kube-apiserver
├── etcd
├── kube-scheduler
└── kube-controller-manager

Worker Node
├── kubelet
├── kube-proxy
└── Container Runtime
```

The course reconnects this runtime environment to the Kubernetes architecture introduced earlier.

---

# `kube-system`

Kubernetes system workloads are commonly observed in:

```text
kube-system
```

This separates cluster infrastructure workloads from normal application workloads.

Detailed Namespace behavior is studied later.

---

# System Pod Inspection

The course inspects system Pods with additional node information.

The operational questions include:

```text
Is the Pod running?

Which node runs it?

Which IP is associated with it?

Is the system workload distributed as expected?
```

This connects cluster architecture to observable runtime objects.

---

# Kubernetes Objects and Linux Processes

The course also inspects Kubernetes-related Linux processes.

This demonstrates two views of the same infrastructure.

```text
Kubernetes View
→ Pods / Objects
```

```text
Linux View
→ Processes / Services
```

Kubernetes abstraction does not remove the underlying operating-system processes.

---

# Runtime Layer Model

A useful mental model is:

```text
Kubernetes Object
       ↓
Pod
       ↓
Container
       ↓
Container Runtime
       ↓
Linux Process
```

This provides a path for troubleshooting from the Kubernetes API down to the node.

---

# Cluster Bootstrap Workflow

The complete course workflow can be represented as:

```text
Prepare Linux Nodes
       ↓
Configure Host Networking
       ↓
Prepare Container Runtime
       ↓
Install Kubernetes Components
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
Verify Worker Registration
       ↓
Verify Node Ready State
       ↓
Inspect System Components
```

---

# Troubleshooting Workflow

If a node does not become Ready:

```text
Linux Node Healthy?
       ↓
Hostname / Network Correct?
       ↓
Container Runtime Healthy?
       ↓
kubelet Healthy?
       ↓
API Server Reachable?
       ↓
Join Completed?
       ↓
CNI Healthy?
       ↓
Node Conditions?
```

Kubernetes troubleshooting should continue to use layered infrastructure reasoning.

---

# Evidence Policy

Course values and screenshots are educational examples.

Do not fabricate or copy course-specific runtime evidence as personal lab evidence.

Do not fabricate:

```text
Node Names
Node IP Addresses
Pod IP Addresses
Bootstrap Tokens
Certificate Hashes
Container IDs
Process IDs
CNI Addresses
Node Status
Command Output
```

Actual evidence must come from an authorized lab environment.

---

# Verification Checklist

- Minikube and kubeadm cluster models were distinguished.
- Linux node preparation was connected to Kubernetes bootstrap.
- Hostname and name resolution were recognized as infrastructure dependencies.
- The course swap requirement was not generalized beyond its environment.
- Firewall and SELinux disabling were recognized as lab simplifications rather than generic production solutions.
- kubelet, kubeadm, and kubectl responsibilities were distinguished.
- Historical package repositories were not treated as current installation instructions.
- `kubeadm init` was connected to control-plane bootstrap.
- Pod network CIDR was distinguished from node addressing.
- kubeconfig was connected to Kubernetes API access.
- CNI installation was connected to Pod networking.
- Calico was recognized as the course's CNI example.
- `kubeadm join` was connected to worker-node registration.
- Bootstrap tokens and CA certificate hashes were treated as sensitive runtime values.
- Node registration and Node Ready state were distinguished.
- `kube-system` workloads were introduced.
- Kubernetes objects were connected back to Linux processes.
- Cluster verification was treated as a separate step from installation.

## What I Learned

- kubeadm bootstraps Kubernetes infrastructure but still depends on correctly prepared Linux nodes.
- The control plane is initialized before worker nodes join the cluster.
- Kubernetes API access is configured through kubeconfig.
- Pod networking requires a CNI implementation.
- Worker nodes join an existing cluster using authenticated bootstrap information.
- A registered node is not necessarily a Ready node.
- Kubernetes abstractions ultimately map to container runtime activity and Linux processes.
- Kubernetes troubleshooting requires Linux, networking, container-runtime, and Kubernetes API knowledge together.
