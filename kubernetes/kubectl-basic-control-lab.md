# kubectl Basic Control Lab

## Objective

Understand `kubectl` as a Kubernetes API client and establish a basic resource-observation workflow using `get`, `describe`, events, logs, API resource discovery, and API version discovery.

The focus is on understanding the relationship between commands, Kubernetes resources, API objects, and runtime evidence rather than memorizing command syntax.

## Scope

```text
kubectl
Kubernetes API Client
Commands
Resources
API Resources
API Versions
Namespaced Resources
Short Names
Bash Completion
kubectl run
kubectl get
kubectl describe
kubectl get events
kubectl logs
Basic Kubernetes Troubleshooting
```

---

# kubectl

`kubectl` is a client for interacting with the Kubernetes API.

Conceptually:

```text
User
 ↓
kubectl
 ↓
kubeconfig
 ↓
kube-apiserver
 ↓
Kubernetes Resources
```

It should not be treated as a tool that directly manages Linux processes on worker nodes.

---

# Command Model

A common kubectl structure is:

```text
kubectl <verb> <resource> <name>
```

Conceptually:

```text
Verb
→ What action should be performed?

Resource
→ Which Kubernetes resource type?

Name
→ Which object instance?
```

Examples include:

```bash
kubectl get pod
kubectl describe pod POD_NAME
```

---

# Resource-Oriented Administration

Kubernetes administration is strongly resource-oriented.

Examples include:

```text
Pod
Node
Namespace
Service
Deployment
ReplicaSet
DaemonSet
StatefulSet
PersistentVolume
PersistentVolumeClaim
Secret
ServiceAccount
```

The operator should first identify the resource being investigated and then select the appropriate action.

---

# API Resources

The course introduces:

```bash
kubectl api-resources
```

as a way to discover resources supported by the API server.

Relevant resource information can include:

```text
Name
Short Name
API Group
Namespaced Scope
Kind
```

This helps identify the actual Kubernetes object model exposed by the cluster.

---

# Resource Name and Kind

A Kubernetes resource can have multiple related identifiers.

Conceptually:

```text
Resource Name
→ CLI/API resource collection name

Short Name
→ Convenient CLI abbreviation

Kind
→ Object type represented in manifests
```

For example:

```text
pods
→ Resource

po
→ Short Name

Pod
→ Kind
```

---

# Namespaced Resources

Some resources exist inside namespaces.

```text
Pod
→ Namespaced
```

Other resources represent cluster-wide infrastructure.

```text
Node
→ Cluster scoped
```

This scope distinction becomes important for object lookup, access control, and troubleshooting.

---

# API Versions

The course introduces Kubernetes API versions.

Examples can follow structures such as:

```text
v1
apps/v1
batch/v1
rbac.authorization.k8s.io/v1
```

Conceptually:

```text
API Group
+
Version
```

identify the schema used for a Kubernetes resource.

The exact API versions available depend on the Kubernetes cluster.

---

# API Discovery

Useful discovery commands include:

```text
api-resources
→ Which resource types does the server expose?

api-versions
→ Which API group/version combinations does the server expose?
```

This is preferable to assuming every cluster supports the same historical API versions.

---

# Bash Completion

The course demonstrates Bash completion for kubectl.

A session can enable completion using:

```bash
source <(kubectl completion bash)
```

Completion can reduce typing errors and help discover command and resource names.

Shell startup configuration can be used when persistent completion is desired.

---

# Creating a Pod Imperatively

The course introduces an imperative Pod creation example:

```bash
kubectl run POD_NAME --image IMAGE
```

Conceptually:

```text
Pod Name
+
Container Image
      ↓
Kubernetes API
      ↓
Pod Object
```

This provides a quick way to introduce the relationship between an image and a Kubernetes Pod.

---

# Image to Pod Relationship

The container model can now be expanded as:

```text
Container Image
      ↓
Container
      ↓
Pod
```

Kubernetes schedules and manages the Pod as the basic workload unit.

---

# `kubectl get`

`get` provides a concise current-state view.

Conceptually:

```text
Kubernetes API
      ↓
Resource Summary
```

For Pods, useful summary information can include:

```text
Name
Ready
Status
Restarts
Age
```

The exact output depends on the requested resource and output format.

---

# `kubectl describe`

`describe` provides detailed runtime and object information.

For a Pod, useful areas can include:

```text
Namespace
Node
IP
Container State
Image
Ready State
Restart Count
Conditions
Mounts
Events
```

It is useful when `get` shows an abnormal state but does not explain why.

---

# Events

Kubernetes events provide evidence about actions and state transitions around resources.

A conceptual Pod startup sequence can include:

```text
Scheduled
   ↓
Pulling
   ↓
Pulled
   ↓
Created
   ↓
Started
```

Events are especially useful for identifying where workload startup failed.

---

# Events vs Logs

Events and application logs answer different questions.

```text
Events
→ What did Kubernetes attempt or observe?
```

```text
Logs
→ What did the application container output?
```

They should not be treated as interchangeable evidence sources.

---

# `kubectl logs`

`logs` retrieves container application output.

Conceptually:

```text
Pod
 ↓
Container
 ↓
stdout / stderr
```

If a container never started, useful application logs may not exist.

In that situation, resource state, conditions, and events can be more useful.

---

# Basic Troubleshooting Workflow

A useful initial Pod troubleshooting workflow is:

```text
kubectl get pod
      ↓
Identify Current State
      ↓
kubectl describe pod
      ↓
Inspect Conditions / Events
      ↓
kubectl logs
      ↓
Inspect Application Output
```

If the failure originates below the Pod layer, continue into:

```text
Worker Node
kubelet
Container Runtime
CNI
Linux Networking
Linux Host
```

---

# Failure-Layer Examples

A scheduling failure can indicate investigation around:

```text
Scheduler
Node Availability
Resource Capacity
Scheduling Constraints
```

An image-pull failure can indicate investigation around:

```text
Image Reference
Registry
Network Reachability
Authentication
```

A container that starts and then exits can indicate investigation around:

```text
Application Command
Configuration
Application Logs
Runtime State
```

Evidence should determine which layer is investigated next.

---

# Kubernetes and Docker Observation

The Docker operational model introduced similar distinctions.

```text
docker ps
→ Container state

docker inspect
→ Runtime metadata

docker events
→ Runtime lifecycle events

docker logs
→ Application output
```

Kubernetes expands the same evidence-based thinking into:

```text
kubectl get
kubectl describe
Kubernetes Events
kubectl logs
```

---

# Evidence Policy

Course output is educational evidence from the training material.

Do not record it as personal lab evidence.

Do not fabricate:

```text
Pod Names
Pod Status
Pod IP Addresses
Node Names
Events
Image Pull Results
Container IDs
Restart Counts
Application Logs
Command Output
```

Actual evidence must come from an authorized Kubernetes environment.

---

# Verification Checklist

- `kubectl` was understood as a Kubernetes API client.
- Verb, resource, and object name were distinguished.
- Kubernetes administration was treated as resource-oriented.
- API resource discovery was introduced.
- Resource names, short names, and Kinds were distinguished.
- Namespaced and cluster-scoped resources were distinguished.
- API group/version discovery was introduced.
- Bash completion was reviewed.
- Imperative Pod creation was introduced.
- `get` was connected to summary state.
- `describe` was connected to detailed runtime state.
- Kubernetes events were distinguished from application logs.
- `logs` was connected to container stdout/stderr.
- A layered Pod troubleshooting workflow was established.
- Course output was not treated as personal runtime evidence.

## What I Learned

- kubectl is one client of the Kubernetes API.
- Kubernetes operations are organized around resources and actions.
- API discovery helps determine what the current cluster actually supports.
- `get`, `describe`, events, and logs provide different kinds of operational evidence.
- Troubleshooting should begin with observable resource state and move toward lower layers only when evidence supports it.
