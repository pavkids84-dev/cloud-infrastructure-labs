# Kubernetes Controller Fundamentals Lab

## Objective

Understand how Kubernetes controllers compare desired resource configuration with observed state and perform reconciliation through the Kubernetes API.

The focus is on the controller types introduced in course pages 66–70, the Deployment–ReplicaSet–Pod relationship, and the distinction between a Pod, its controllers, and a Service. This document records course concepts and proposed observation steps, not a completed cluster experiment.

## Scope

```text
Controller
Desired State
Observed State
Reconciliation
Kubernetes API
spec
status
ReplicationController
ReplicaSet Controller
DaemonSet Controller
Job Controller
Deployment Controller
StatefulSet Controller
Node Controller
Service Controller
Endpoint Controller
Namespace Controller
PersistentVolume Controller
Deployment
ReplicaSet
Pod
Service
Controller Verification
```

---

# Controller and Reconciliation

The course describes a controller as a component that checks whether the system is converging toward its desired state and performs adjustments when necessary.

```text
Desired State (spec)
        ↓
Kubernetes API / Object
        ↓
Controller Observes State
        ↓
Compare Desired and Observed State
        ↓
Reconciliation Action, If Needed
        ↓
Observe Again
```

A controller does not make a one-time change and stop. The operational idea is to keep checking and reconciling the resources it manages. The course also notes that controllers work through the API server and that current state is recorded in resource status where applicable.

A `spec` expresses the intended configuration; a `status` reports the state observed by the system. An object can exist before its actual workload has reached the desired state.

---

# Controllers Introduced by the Course

Course page 66 lists several controllers:

```text
Replication Controller
ReplicaSet Controller
DaemonSet Controller
Job Controller
Deployment Controller
StatefulSet Controller
Service Controller
Endpoint Controller
Namespace Controller
PersistentVolume Controller
Node Controller
Other Controllers
```

These controllers do not all reconcile the same resource or solve the same operational problem. They are grouped here because the course introduces them together, not because all of them create Pods.

---

# ReplicaSet, DaemonSet, and Job Controllers

The course groups these controllers together on page 67 and relates their operation to replication management.

Their resource-specific roles should still be distinguished:

```text
ReplicaSet
→ Maintain a specified number of matching Pod replicas

DaemonSet
→ Manage the intended Pod placement across eligible nodes

Job
→ Manage Pods toward completion of a finite task
```

The short descriptions above clarify the course's grouped introduction. Detailed specifications and commands are outside pages 66–70 and are not recorded here as completed labs.

---

# Deployment Controller

The course explains that a Deployment controller rolls out new versions when the Deployment's Pod-template configuration changes. During an update, it adjusts old and new ReplicaSets according to the deployment strategy.

```text
Deployment / Desired Pod Template
                 ↓
        Deployment Controller
                 ↓
        ReplicaSet for Version A
        ReplicaSet for Version B
                 ↓
              Pods
```

A Deployment is not the Pod itself. The Deployment controller manages ReplicaSets; ReplicaSets maintain the desired number of Pods. This relationship was first observed in the preceding Object Template Generation Lab and is now connected to controller behavior.

The course's wording about a new version on every object modification should be read in the context of rollout changes to the Pod template. Do not assume that any metadata-only edit must create a new ReplicaSet.

---

# StatefulSet Controller

The course describes the StatefulSet controller as managing Pods according to its resource specification and addressing the PVCs associated with each Pod.

```text
StatefulSet Specification
          ↓
StatefulSet Controller
          ↓
Managed Pods and Their Storage Claims
```

The key point at this stage is that stateful workload management differs from merely keeping interchangeable Pod replicas. Detailed StatefulSet and PVC operations are later topics.

---

# Node Controller

The course introduces the Node controller as managing worker-node state and handling Pods when a node becomes unreachable.

```text
Node State
    ↓
Node Controller Observation
    ↓
Unreachable Node Handling
    ↓
Pod Lifecycle / Replacement May Be Affected
```

A node becoming unreachable should not be interpreted as an immediate, unconditional Pod deletion. Timing and behavior depend on Kubernetes conditions and configuration; the course slide does not establish exact timing.

---

# Service Controller

The course specifically describes cloud-provider integration for a Service of type `LoadBalancer`.

```text
Service / type: LoadBalancer
             ↓
Cloud-Integrated Service Reconciliation
             ↓
Cloud Load Balancer Provisioning or Release Request
```

This is not a statement that every Service creates a cloud load balancer. The course identifies a controller role associated with the `LoadBalancer` type. General Service networking is a later study area.

---

# PersistentVolume Controller

The course connects PersistentVolumeClaim (PVC) creation with binding to a suitable PersistentVolume (PV) and introduces reclaim behavior after claim deletion.

```text
PersistentVolumeClaim
         ↓
Suitable PersistentVolume
         ↓
Binding
         ↓
Storage Lifecycle / Reclaim Policy
```

Page 67 also gives historical details about ordering candidate volumes and recycling. Those details belong to the course's environment and should not be treated as a universal or current PV-selection algorithm or supported reclaim-policy list without separate verification.

---

# Pods and Controllers

Page 68 highlights four workload-controller resource types:

```text
Deployment
StatefulSet
DaemonSet
Job
```

This is an overview, not a complete walkthrough of these resources. It links the Pod concept from the preceding lab to the controllers that manage Pods for different operational purposes.

---

# Deployment, ReplicaSet, Pod, and Node

The diagram on page 69 shows a Deployment above multiple versioned ReplicaSets, each with Pods placed on nodes.

```text
                      Deployment
                          |
              +-----------+-----------+
              |           |           |
         ReplicaSet V1  ReplicaSet V2  ReplicaSet V3
              |           |           |
             Pods        Pods        Pods
               \          |          /
                   Worker Nodes
```

The diagram communicates versioned ReplicaSet ownership and Pod placement; it is a conceptual illustration rather than evidence that a live cluster contains exactly three ReplicaSets or six Pods.

The visual's key distinctions are:

```text
Deployment
→ Coordinates desired workload updates through ReplicaSets

ReplicaSet
→ Maintains the intended Pod replica count

Pod
→ Groups one or more containers as a scheduling unit

Node
→ Provides the host environment where scheduled Pods run
```

---

# Four Core Objects in This Section

Page 70 identifies:

```text
Pod
ReplicaSet
Deployment
Service
```

These resources serve different roles:

```text
Deployment → Workload update and ReplicaSet management
ReplicaSet → Pod replica management
Pod        → Scheduled workload unit
Service    → Network access abstraction for selected workloads
```

The Service is included among the course's core objects, but it is not another tier of Pod ownership beneath a ReplicaSet. Service routing and exposure are addressed in a later section.

---

# Controller Observation Workflow

The preceding template-generation lab already introduced inspecting a Deployment, ReplicaSet, and Pod after creating a resource. That observation can now be interpreted in terms of controller relationships.

```text
Read the Declared Configuration
            ↓
Identify the Owning Controller
            ↓
Observe Deployment / ReplicaSet / Pod
            ↓
Compare Desired and Available State
            ↓
Inspect Conditions / Events if They Differ
```

The following are **proposed read-only checks** for a permitted practice cluster, not commands executed for this document:

```bash
kubectl get deployments
kubectl get replicasets
kubectl get pods
```

Do not copy the course's sample names, counts, addresses, or rollout state into a personal lab report. Inspect the actual resources and distinguish a stated desired replica count from observed readiness or availability.

---

# Evidence Policy

The course's page-69 diagram and page-67 descriptions are educational material, not personal execution evidence.

Do not fabricate:

```text
Deployment Names
ReplicaSet Names
Pod Names
Node Names
Replica Counts
Rollout Revisions
Readiness or Availability
PVC Bindings
Cloud Load Balancer IDs
Command Output
```

Record the results of the proposed checks only after running them in an authorized environment. Do not assume that a demonstrated example or a controller concept proves a successful personal deployment.

---

# Verification Checklist

- Desired state, observed state, and reconciliation were distinguished.
- Controllers were connected to Kubernetes API resources and object lifecycle.
- The course's controller categories were identified without treating them as interchangeable.
- Deployment updates were connected to old and new ReplicaSets.
- StatefulSet, Node, Service, and PersistentVolume controller roles were introduced at the course's level of detail.
- The page-69 Deployment/ReplicaSet/Pod/Node diagram was interpreted as a conceptual model.
- Pod, ReplicaSet, Deployment, and Service were distinguished as separate core objects.
- Course screenshots and proposed commands were not presented as completed lab results.

## What I Learned

- Kubernetes controllers continually reconcile observed state toward the desired resource specification.
- A Deployment manages workload revisions through ReplicaSets, while a ReplicaSet maintains Pods.
- Controllers address different resource lifecycles, including nodes, storage, and cloud-integrated Services.
- Pod ownership and Service-based network access are different relationships.
- Verification requires actual resource state; a course diagram does not establish the state of my cluster.
