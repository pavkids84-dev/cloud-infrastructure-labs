# Kubernetes Controller Fundamentals Lab

## Objective

Understand Kubernetes controllers as reconciliation mechanisms that continuously compare desired state with observed state and take actions to make the cluster converge toward the declared configuration.

This lab connects Kubernetes object specifications to ReplicaSets, Deployments, scaling, ownership, cascading deletion, namespaces, and other controller-managed infrastructure.

## Scope

```text
Kubernetes Controllers
Reconciliation
Desired State
Observed State
spec
status
ReplicaSet
ReplicationController
Deployment
StatefulSet
DaemonSet
Job
Node Controller
Service Controller
PersistentVolume Controller
Owner References
Cascading Deletion
Scaling
Scale Out
Scale In
Namespaces
Resource Deletion
```

---

# Controller Model

Kubernetes controllers continuously compare the desired state of API objects with the observed state of the cluster.

Conceptually:

```text
Desired State
      ↓
Kubernetes API Object
      ↓
Controller
      ↓
Observe Current State
      ↓
Compare
      ↓
Reconcile
      ↓
Observe Again
```

A controller does not simply execute one command and stop.

It continuously works to make actual cluster state converge toward the desired configuration.

---

# `spec` and `status`

A useful Kubernetes state model is:

```text
spec
→ Desired configuration
```

```text
status
→ Observed state
```

Controllers operate around the difference between these two states.

```text
spec
 ↓
Controller
 ↓
Runtime State
 ↓
status
```

---

# API-Driven Reconciliation

Controllers interact with Kubernetes resources through the Kubernetes API.

Conceptually:

```text
Controller
    ↓
kube-apiserver
    ↓
Kubernetes Objects
```

The API server remains the central interface for cluster-state operations.

---

# Multiple Controllers

Kubernetes contains multiple controllers with different responsibilities.

The course introduces controller categories including:

```text
ReplicationController
ReplicaSet
DaemonSet
Job
Deployment
StatefulSet
Service
Endpoint
Namespace
PersistentVolume
Node
```

Each controller manages a specific class of Kubernetes state.

---

# ReplicaSet

A ReplicaSet maintains a desired number of matching Pods.

Conceptually:

```text
Desired Replicas = 3
Current Pods = 2
        ↓
ReplicaSet Controller
        ↓
Create One Pod
        ↓
Current Pods = 3
```

If too many matching Pods exist:

```text
Desired Replicas = 2
Current Pods = 3
        ↓
ReplicaSet Controller
        ↓
Reduce One Pod
```

---

# ReplicaSet and ReplicationController

The course presents ReplicaSet as an improved successor to ReplicationController.

Both are associated with maintaining Pod replicas.

ReplicaSet adds more expressive label-selector capabilities such as set-based matching.

Modern workload management should focus primarily on:

```text
Deployment
     ↓
ReplicaSet
     ↓
Pod
```

rather than direct ReplicationController use.

---

# Deployment

A Deployment manages application rollout through ReplicaSets.

Conceptually:

```text
Deployment
     ↓
ReplicaSet
     ↓
Pods
```

A Deployment should not be understood as directly managing individual Pod processes.

It manages the desired workload through lower-level controller resources.

---

# Deployment Reconciliation

A Deployment update can create a new workload revision.

Conceptually:

```text
Deployment Template Change
        ↓
New ReplicaSet
        ↓
New Pods
```

The Deployment controller can adjust old and new ReplicaSets according to the deployment strategy.

---

# Deployment Manifest Structure

Important Deployment fields introduced by the course include:

```text
replicas
selector
strategy
template
revisionHistoryLimit
```

Conceptually:

```text
Deployment
│
├── replicas
├── selector
├── strategy
├── revisionHistoryLimit
└── template
     └── Pod Definition
```

---

# Replica Count

The `replicas` field expresses the desired number of workload replicas.

```text
replicas: N
      ↓
Desired Pod Count
```

The controller works to maintain that count.

---

# Selector

A Deployment uses a selector to identify the Pods associated with its workload.

Conceptually:

```text
Deployment Selector
        ↓
Labels
        ↓
Managed Pod Set
```

The selector and Pod-template labels must represent the intended relationship.

---

# Pod Template

A Deployment contains a Pod template describing the Pods that should be created.

Conceptually:

```text
Deployment
     ↓
Pod Template
     ↓
ReplicaSet
     ↓
Pods
```

Changing the Pod template can result in a new workload revision.

---

# RollingUpdate Introduction

The course shows a Deployment using:

```text
RollingUpdate
```

with fields such as:

```text
maxSurge
maxUnavailable
```

The conceptual goal is gradual replacement:

```text
Old Pods
   ↓
Controlled Replacement
   ↓
New Pods
```

Detailed rolling-update behavior is studied later.

---

# Revision History

Deployment revision history supports versioned rollout management.

Conceptually:

```text
Revision 1
    ↓
Revision 2
    ↓
Revision 3
```

This later supports rollout inspection and rollback workflows.

---

# Owner References

Kubernetes resources can contain ownership information.

Conceptually:

```text
Deployment
    ↓ owns
ReplicaSet
    ↓ owns
Pods
```

Owner references help Kubernetes understand resource dependencies.

---

# Resource Hierarchy

A common workload hierarchy is:

```text
Deployment
     ↓
ReplicaSet
     ↓
Pod
     ↓
Container
     ↓
Linux Process
```

Each layer has a different operational responsibility.

---

# Pod Deletion Under a Controller

Deleting a Pod managed by a ReplicaSet does not necessarily reduce the desired workload count permanently.

Example:

```text
Desired Replicas = 3
Current Pods = 3
        ↓
Delete One Managed Pod
        ↓
Current Pods = 2
        ↓
ReplicaSet Controller
        ↓
Create Replacement Pod
        ↓
Current Pods = 3
```

The controller restores the desired count.

---

# Replacement vs Resurrection

A deleted Pod should not be thought of as being resurrected.

The controller creates a replacement workload to satisfy the desired state.

```text
Deleted Pod
!=
Restored Identical Pod Object
```

The replacement can have a different identity.

---

# Self-Healing Model

Controller reconciliation provides the foundation for Kubernetes self-healing behavior.

```text
Failure
   ↓
Observed State Changes
   ↓
Controller Detects Difference
   ↓
Reconciliation
   ↓
Desired State Restored
```

The exact recovery behavior depends on the resource and failure type.

---

# Controller vs Scheduler

Controllers and the scheduler solve different problems.

```text
Controller
→ How many workloads should exist?
```

```text
Scheduler
→ Which node should run a new Pod?
```

Example:

```text
ReplicaSet Controller
→ One more Pod is required
        ↓
Scheduler
→ Select Worker Node
        ↓
kubelet
→ Run the Pod on that node
```

---

# Controller vs kubelet

The kubelet is a node-level agent.

```text
Controller
→ Cluster desired-state reconciliation
```

```text
Scheduler
→ Pod placement
```

```text
kubelet
→ Node-level Pod execution and state
```

These responsibilities should remain distinct during troubleshooting.

---

# StatefulSet

The course introduces StatefulSet as a controller that manages Pods according to the resource specification and also coordinates persistent storage claims for the workload.

Conceptually:

```text
StatefulSet
├── Stable Workload Identity
├── Pod Lifecycle
└── Persistent Storage Relationship
```

Detailed StatefulSet behavior is outside this controller-introduction section.

---

# DaemonSet

DaemonSet is introduced as another Pod controller.

A useful conceptual model is:

```text
Eligible Node A
→ Daemon Pod

Eligible Node B
→ Daemon Pod

Eligible Node C
→ Daemon Pod
```

This differs from a fixed replica-count model.

DaemonSets are commonly associated with node-level agents.

---

# Job

A Job manages workloads that are expected to complete.

Conceptually:

```text
Start Work
    ↓
Run Task
    ↓
Successful Completion
```

This differs from controllers that normally maintain continuously running application replicas.

---

# Node Controller

The Node controller manages node-related cluster state.

Conceptually:

```text
Worker Node
     ↓
Health / Reachability
     ↓
Node Controller
```

Node failures can eventually affect workload placement and recovery.

The exact timing and eviction behavior depends on Kubernetes configuration and should not be reduced to an immediate-delete rule.

---

# Service Controller

The course connects the Service controller to cloud load balancers for `LoadBalancer` type Services.

Conceptually:

```text
Service
type: LoadBalancer
        ↓
Controller
        ↓
Cloud Infrastructure
        ↓
External Load Balancer
```

Detailed Service behavior is studied in the next section.

---

# PersistentVolume Controller

The course connects the PersistentVolume controller to PVC and PV binding.

Conceptually:

```text
PersistentVolumeClaim
       ↓
Storage Requirements
       ↓
PersistentVolume Controller
       ↓
Suitable PersistentVolume
       ↓
Binding
```

Matching can involve storage capacity and access requirements.

---

# Persistent Volume Reclaim Context

The course references storage reclaim behavior after claim deletion.

The important reusable concept is:

```text
PVC / PV Lifecycle
        ↓
Reclaim Policy
        ↓
Storage Handling
```

Historical reclaim mechanisms in older course material should not automatically be treated as current Kubernetes recommendations.

---

# Scaling

Controller-managed workloads can change their desired replica count.

```text
Desired Replica Count
        ↓
Controller
        ↓
Actual Pod Count
```

Scaling is therefore a desired-state operation rather than continuous manual Pod creation and deletion.

---

# Scale Out

Scale out increases the desired replica count.

Example:

```text
Current = 1
Desired = 3
      ↓
Controller
      ↓
Create Additional Pods
```

The scheduler then selects nodes for newly created Pods.

---

# Scale In

Scale in decreases the desired replica count.

Example:

```text
Current = 3
Desired = 1
      ↓
Controller
      ↓
Reduce Replicas
```

The controller manages the resource count according to the new desired state.

---

# Manual Scaling vs Autoscaling

Changing a replica count is not automatically the same as metric-driven autoscaling.

Conceptually:

```text
Manual Scaling
→ Desired replicas changed explicitly
```

```text
Autoscaling
→ Another control mechanism changes desired capacity according to policy or metrics
```

Autoscaling is outside the main scope of this controller section.

---

# Cascading Deletion

Resource ownership affects deletion behavior.

Conceptually:

```text
Deployment
    ↓
ReplicaSet
    ↓
Pods
```

Deleting an owner can trigger deletion of dependent resources.

Kubernetes garbage collection manages these ownership relationships.

---

# Cascade Strategies

The course uses historical `--cascade` terminology.

The reusable concept is that dependent-resource handling can vary.

Conceptually:

```text
Delete Owner
    ↓
Dependent Resource Strategy
```

Possible modern concepts include:

```text
Foreground
Background
Orphan
```

Exact command syntax should be verified against the Kubernetes version being used.

---

# Namespace

Most application resources exist in a namespace.

Conceptually:

```text
Cluster
├── Namespace A
│   ├── Deployment
│   ├── ReplicaSet
│   ├── Pod
│   └── Service
│
└── Namespace B
    ├── Deployment
    ├── Pod
    └── Service
```

Namespaces provide logical resource scope and grouping.

---

# Namespaced vs Cluster-Scoped Resources

Not every Kubernetes resource belongs to a namespace.

Conceptually:

```text
Namespaced
→ Pod
→ Deployment
→ Service
```

```text
Cluster Scoped
→ Node
→ PersistentVolume
```

Actual resource scope can be inspected through Kubernetes API resource discovery.

---

# Namespace Deletion

Deleting a namespace can remove resources contained within that namespace.

This operation has a much larger blast radius than deleting a single Pod or Deployment.

Conceptually:

```text
Namespace Deletion
       ↓
Namespaced Resources
       ↓
Deletion
```

Namespace deletion should therefore be treated as a high-impact operation.

---

# Namespace and Service DNS

Namespaces can participate in Kubernetes Service DNS naming.

Conceptually:

```text
Service Name
+
Namespace
+
Cluster DNS Domain
```

This is studied in more detail with Kubernetes Services.

---

# Resource Group Deletion

The course introduces multiple deletion scopes.

Examples conceptually include:

```text
Manifest-Based Deletion
Namespace Deletion
All Resources of a Selected Type
Package / Release Removal
```

Each operation has a different blast radius.

---

# Shell Pipe Warning

Course notation such as:

```text
po|deploy|rs
```

should not be entered literally as a resource name.

In a shell:

```text
|
```

is the pipeline operator.

The notation should be interpreted as selecting one resource type, for example:

```bash
kubectl delete pod --all
```

or:

```bash
kubectl delete deployment --all
```

---

# Helm Context

The course briefly references Helm release deletion.

Helm is introduced here only as another resource-group management mechanism.

Detailed Helm architecture and commands should be studied in the later Helm section.

---

# Troubleshooting Perspective

Controller-managed workloads should be investigated through the resource hierarchy.

Example:

```text
Application Failure
      ↓
Pod State
      ↓
ReplicaSet State
      ↓
Deployment State
      ↓
Events
      ↓
Node / Runtime if required
```

Do not assume that a failed Pod automatically means the Deployment controller itself is broken.

---

# Scaling Troubleshooting

If the desired replica count is not reached:

```text
Desired Replicas Correct?
       ↓
Controller Resource State?
       ↓
ReplicaSet State?
       ↓
Pods Created?
       ↓
Scheduling Successful?
       ↓
Node Capacity?
       ↓
Container Startup?
```

This separates reconciliation failures from scheduling and runtime failures.

---

# Desired State Troubleshooting

A useful general model is:

```text
What does spec request?
        ↓
What does status report?
        ↓
What resources currently exist?
        ↓
What events explain the difference?
```

This becomes increasingly important as Kubernetes workloads move from direct Pods to controller-managed resources.

---

# Evidence Policy

Course screenshots and example values are educational examples.

Do not fabricate:

```text
Replica Counts
Pod Names
ReplicaSet Names
Deployment Names
Owner UIDs
Revision Numbers
Node Names
Pod IP Addresses
Events
Scaling Results
Deletion Results
Command Output
```

Actual evidence must come from an authorized Kubernetes lab environment.

---

# Verification Checklist

- Controllers were understood as reconciliation mechanisms.
- `spec` and `status` were connected to desired and observed state.
- Controllers were understood as API-driven components.
- ReplicaSet was connected to replica-count maintenance.
- ReplicationController and ReplicaSet were distinguished.
- Deployment was connected to ReplicaSet management.
- Deployment selectors and Pod templates were introduced.
- RollingUpdate configuration was introduced.
- Revision history was connected to workload versions.
- Owner references were connected to resource hierarchy.
- Managed Pod deletion was connected to reconciliation.
- Replacement Pod creation was distinguished from Pod resurrection.
- Controller, scheduler, and kubelet responsibilities were distinguished.
- StatefulSet, DaemonSet, and Job roles were introduced.
- Node, Service, and PersistentVolume controllers were introduced.
- Scale out and scale in were connected to desired replica counts.
- Manual scaling was distinguished from autoscaling.
- Cascading deletion and ownership were introduced.
- Namespaced and cluster-scoped resources were distinguished.
- Namespace deletion was recognized as a high-impact operation.
- Course pipe notation was not confused with literal kubectl syntax.
- Course output was not treated as actual lab evidence.

## What I Learned

- Kubernetes controllers continuously reconcile observed state with desired state.
- ReplicaSets maintain a desired number of Pods.
- Deployments manage ReplicaSets and provide workload revision and rollout behavior.
- Deleting a controller-managed Pod does not permanently reduce the desired replica count.
- Scaling changes desired state and lets controllers adjust actual workload capacity.
- Controllers, the scheduler, and kubelets solve different infrastructure problems.
- Owner references define important relationships among Kubernetes resources.
- Namespaces provide logical scope and can create large deletion boundaries.
- Controller-based reconciliation is one of the central mechanisms behind Kubernetes self-healing and workload management.
