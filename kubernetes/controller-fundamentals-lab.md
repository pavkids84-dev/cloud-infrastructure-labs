# Kubernetes Controller Fundamentals Lab

## Objective

Understand how Kubernetes controllers compare desired resource configuration with observed state and perform reconciliation through the Kubernetes API.

The focus is on the controller types introduced in course pages 66–70, the Deployment–ReplicaSet–Pod relationship, and the distinction between a Pod, its controllers, and a Service. This document records course concepts and proposed observation steps, not a completed cluster experiment.

This lab also consolidates the Deployment and ReplicaSet operational material from course pp.71–78. Commands for deletion and scaling are proposed controlled exercises; actual outcomes are not claimed.

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
Deployment Object
apps/v1
Deployment Metadata
Revision Annotation
replicas
revisionHistoryLimit
RollingUpdate
maxSurge
maxUnavailable
Pod Template
Label Selector
ReplicaSet Object
ownerReferences
pod-template-hash
Pod Replacement
Standalone Pod
Cascading Deletion
Orphaned Resources
kubectl scale
Scale Out
Scale In
Desired vs Current vs Ready
Resource Verification
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

# Deployment Object

Course page 71 shows a Deployment object with the `apps/v1` API and a Pod template based on an Nginx image.

An illustrative, simplified definition is:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: example
  labels:
    app: example
spec:
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: example
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
  template:
    metadata:
      labels:
        app: example
    spec:
      containers:
        - name: nginx
          image: nginx
```

This is a teaching example derived from the course's fields, **not** a verbatim export of its historical cluster object or a personal deployment result.

The course shows these read-only inspection commands in its Deployment example:

```bash
kubectl get deployment
kubectl describe deployment example
kubectl get events
```

Replace `example` with the name of an existing Deployment when using a real practice cluster.

---

# Deployment Configuration and Rollout Fields

Relevant fields from page 71 include:

```text
metadata.name
metadata.labels
metadata.annotations
spec.replicas
spec.revisionHistoryLimit
spec.selector.matchLabels
spec.strategy.type
spec.strategy.rollingUpdate.maxSurge
spec.strategy.rollingUpdate.maxUnavailable
spec.template.metadata.labels
spec.template.spec.containers
```

The meanings are:

- `replicas`: the requested number of Pod replicas.
- `revisionHistoryLimit`: how many old ReplicaSets to retain for rollout history, subject to normal cleanup behavior.
- `selector.matchLabels`: the label condition used to identify the Deployment's Pods.
- `template`: the definition used to create its Pods.
- `strategy`: the method used to update the workload.
- `maxSurge` and `maxUnavailable`: RollingUpdate settings that constrain additional and temporarily unavailable replicas during rollout.

The Deployment selector must match the Pod-template labels. A Deployment revision annotation such as `deployment.kubernetes.io/revision` appears in the course's exported metadata; it is controller-managed observation, not a required field to copy into a new manifest.

A Deployment rollout should be understood through changes to its **Pod template**, not as a claim that every metadata edit creates a new ReplicaSet.

---

# ReplicaSet Object

Course page 72 introduces a ReplicaSet as the resource responsible for maintaining a specified number of matching Pods.

The important relationship is:

```text
Deployment
    ↓ manages
ReplicaSet
    ↓ maintains
Pods
```

The course's ReplicaSet YAML includes:

```text
apiVersion: apps/v1
kind: ReplicaSet
metadata.labels
metadata.ownerReferences
spec.replicas
spec.selector.matchLabels
spec.template
```

`ownerReferences` in the example identifies the parent Deployment. The `pod-template-hash` label appears on the ReplicaSet and its Pod template, linking a rollout's matching resources in the illustrated case.

**Course-output limitation:** Page 72 juxtaposes a desired-replicas annotation of `1` with a `spec.replicas` value of `2`. These fields should not be combined into a single asserted live state. Read the actual values from the same object and moment when doing a real lab.

---

# Read the Ownership Chain

Use a permitted cluster containing a Deployment before attempting these proposed read-only checks:

```bash
kubectl get deployments
kubectl get replicasets
kubectl get pods
kubectl get deployment,replicaset,pod --show-labels -o wide
```

Then inspect the actual Deployment and ReplicaSet names returned in your environment:

```bash
kubectl describe deployment DEPLOYMENT_NAME
kubectl describe replicaset REPLICASET_NAME
kubectl get replicaset REPLICASET_NAME -o yaml
```

Look for the Deployment's selector, the ReplicaSet's `ownerReferences`, and the labels of the Pods. Do not infer ownership from a similar-looking name alone.

---

# Pod Deletion and Reconciliation

Pages 73–74 show a Pod owned through the Deployment/ReplicaSet chain being deleted. A replacement Pod then appears with a different generated name while the controller continues to maintain the requested replica count.

Conceptually:

```text
Desired Replicas: 1
          ↓
Delete One Managed Pod
          ↓
Observed Replicas Below Desired
          ↓
ReplicaSet Reconciliation
          ↓
Replacement Pod Created
```

The course also deletes independently created Pods such as `mypod` and its copies. These Pods do not have the same ReplicaSet ownership, so their deletion is not followed by automatic replacement by that ReplicaSet.

**Proposed controlled lab only:** On an isolated, disposable practice Deployment, first determine the actual owned Pod from the ReplicaSet/Pod information. If deletion is explicitly acceptable for that environment, delete that particular Pod and observe the controller's response:

```bash
kubectl get deployment,replicaset,pod
kubectl delete pod MANAGED_POD_NAME
kubectl get deployment,replicaset,pod
```

Do not use the course's generated Pod names in your cluster, and do not perform this failure test against a production service. A replacement may take time to become Ready; creation of the Pod object alone does not establish application health.

---

# Deleting a Deployment and Cascading Resources

Page 75 contrasts normal Deployment deletion with a deletion that does not automatically remove its dependent resources.

The course shows:

```bash
kubectl delete deployment hhs
kubectl get deployment,replicaset,pod
```

and a historical example of:

```bash
kubectl delete deployment example --cascade=false
```

The second example intends to retain the descendant ReplicaSet and Pod rather than deleting them together with the Deployment. The course's `--cascade=false` syntax is version-specific; do not assume that exact flag value is valid for every installed `kubectl` version. Verify the current command help and semantics before performing a real orphaning experiment.

Conceptually:

```text
Normal Cascading Deletion
Deployment Deleted
       ↓
Dependent ReplicaSet / Pods Removed
```

```text
Orphaning Behavior
Deployment Deleted
       ↓
Dependent ReplicaSet / Pods Retained
```

The retained resources may still need deliberate cleanup. In a practice environment, confirm what remains through read-only resource inspection and avoid destructive deletion without a clear scope and recovery plan.

---

# Scale Out

Pages 76–77 introduce `kubectl scale` for changing the requested replica count. The course gives examples for ReplicaSets, Deployments, replication controllers, and StatefulSets; its Deployment example changes `hhs` to three replicas.

An example **to run only on an authorized disposable Deployment** is:

```bash
kubectl scale deployment/hhs --replicas=3
kubectl get deployment,replicaset,pod
```

The expected control flow is:

```text
Deployment spec.replicas = 3
            ↓
ReplicaSet Desired Replicas = 3
            ↓
Create Additional Pod Objects
            ↓
Schedule / Start / Check Readiness
```

The PDF shows three Pods in its example output. That is the course's demonstration, not a claim that three Pods are running in the current personal cluster.

---

# Scale In and Restore

Page 78 demonstrates scaling the same Deployment down to zero replicas, checking resources, and then scaling it back to one.

**Proposed commands for an isolated workload only:**

```bash
kubectl scale deployment/hhs --replicas=0
kubectl get deployment,replicaset,pod

kubectl scale deployment/hhs --replicas=1
kubectl get deployment,replicaset,pod
```

Setting replicas to zero expresses a desire for zero Pods. It is not the same as deleting the Deployment or the ReplicaSet. During scale-down, a Pod may temporarily appear as `Terminating`; readiness and available counts need to be checked again after the operation settles.

Scaling back to one requests a Pod again, but successful scheduling, container startup, and application readiness still require separate verification.

If `hhs` does not exist, use the real Deployment name; do not create or mutate objects merely to reproduce a screenshot.

---

# Replica and Workload Verification

Resource listings can show several different numbers:

```text
DESIRED
CURRENT
READY
AVAILABLE
```

They answer different questions. A desired replica count is the target, while the other fields help show whether the controller and workload have caught up. The columns displayed vary by resource and `kubectl` version.

An initial observation workflow is:

```text
Inspect Deployment Specification
              ↓
Inspect ReplicaSet and Owner Reference
              ↓
Compare Desired / Current / Ready
              ↓
Inspect Pods and Nodes
              ↓
Check Conditions / Events if Needed
              ↓
Verify Workload Readiness
```

Useful proposed commands include:

```bash
kubectl get deployment,replicaset,pod -o wide
kubectl describe deployment DEPLOYMENT_NAME
kubectl describe replicaset REPLICASET_NAME
kubectl get events
```

A successful `kubectl scale` response alone is not evidence of a successful, healthy service.

---

# Historical Course Context

The screenshots include older resource labels such as `deployment.extensions` and `replicaset.extensions`, as well as `--cascade=false`. Preserve these as version-specific course output rather than generalizing them into a current installation guide.

The central concepts remain object specifications, controller ownership, replacement of managed Pods, cascading deletion behavior, and replica reconciliation.

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

Additional fields that must not be invented:

```text
Pod UIDs
Owner References
Node Assignments
Readiness / Availability
Event Messages
Pod Deletion Results
Scale Results
```

All names, ages, replica counts, and terminal outputs in the PDF are examples from the course environment. The commands in this document are **proposed** and have not been executed for this document.

Record actual results only after completing approved experiments and collecting evidence in the real cluster. Distinguish intentional scale-to-zero from an unexpected workload failure.

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
- The Deployment's desired replica count, selector, Pod template, and RollingUpdate fields were identified.
- Deployment revision annotations were distinguished from user-defined configuration.
- The ReplicaSet's ownership relationship with the Deployment was identified.
- ReplicaSet and Pod label/selector relationships were understood.
- The course's inconsistent ReplicaSet replica values were not treated as one verified live state.
- Managed-Pod replacement was distinguished from deletion of standalone Pods.
- Normal cascading deletion was distinguished from the course's orphaning example.
- Scale-out and scale-in were understood as changes to desired replica counts.
- `replicas: 0` was distinguished from deleting the Deployment.
- Proposed commands and PDF screenshots were not represented as executed personal lab evidence.

---

## What I Learned

- Kubernetes controllers continually reconcile observed state toward the desired resource specification.
- A Deployment manages workload revisions through ReplicaSets, while a ReplicaSet maintains Pods.
- Controllers address different resource lifecycles, including nodes, storage, and cloud-integrated Services.
- Pod ownership and Service-based network access are different relationships.
- Verification requires actual resource state; a course diagram does not establish the state of my cluster.
- A Deployment maintains its workload through ReplicaSets and Pod templates.
- A ReplicaSet reconciles the requested number of Pods, including after deletion of a managed Pod.
- Ownership and cascade behavior determine which dependent resources are removed together.
- Scaling changes the desired replica count; actual Pod creation, termination, and readiness must be observed separately.
- Verification depends on the cluster's observed resource state, not on sample output in the course PDF.

---

# Object Template Generation and Controller Relationship

## Generating Templates from Existing Objects

Kubernetes objects can be exported as YAML templates using:

```bash
kubectl get <resource> <name> -o yaml > template.yaml
```

Example:

```bash
kubectl get pod mypod -o yaml > mypod.yaml
```

The exported YAML represents the current object representation stored in Kubernetes. Before reuse, runtime-generated fields should be reviewed and removed.

Common fields that should not be copied into reusable templates:

```yaml
metadata:
  creationTimestamp:
  resourceVersion:
  uid:

status:
```

The difference between desired and observed state is important:

```text
spec
 ↓
Desired State defined by user

status
 ↓
Observed State maintained by Kubernetes
```

---

# Creating Templates with --dry-run

A resource manifest can also be generated without creating the resource.

Example:

```bash
kubectl create deployment nginx \
--image=nginx \
--dry-run=client \
-o yaml
```

The command only outputs YAML.

Workflow:

```text
kubectl command
        ↓
--dry-run=client
        ↓
Generated YAML
        ↓
Review / Modify
        ↓
 kubectl apply
```

This workflow is commonly used when preparing Kubernetes manifests for Git-based deployment workflows.

---

# Controller Reconciliation Loop

Kubernetes controllers continuously compare the desired state with the observed state.

```text
Desired State
(spec)

      ↓

Controller

      ↓

Observed State
(status)

      ↓

Difference Detection

      ↓

Corrective Action
```

The controller does not simply execute a command once. It continuously watches resources and attempts to keep the cluster state aligned with the declared configuration.

---

# Deployment, ReplicaSet, and Pod Relationship

The most important controller relationship is:

```text
Deployment
      ↓
ReplicaSet
      ↓
Pod
      ↓
Container
```

Deployment manages ReplicaSets.

ReplicaSet maintains the required number of Pods.

Pods execute containers.

Example:

```yaml
spec:
  replicas: 3
```

means the controller attempts to maintain three matching Pods.

If one Pod fails:

```text
Current State:
2 Pods

Desired State:
3 Pods

Controller Action:
Create 1 Pod
```

---

# Deployment Rollout Concept

When the Pod template changes, Deployment creates a new ReplicaSet version.

Example:

```text
Deployment

 ├── ReplicaSet v1
 │       └── Pods
 │
 └── ReplicaSet v2
         └── New Pods
```

During RollingUpdate:

```text
Old ReplicaSet scale down

New ReplicaSet scale up

Application transition completed
```

This enables controlled application updates without replacing all Pods simultaneously.

---

# Controller Types Summary

| Controller | Purpose |
|---|---|
| ReplicaSet Controller | Maintain Pod replica count |
| Deployment Controller | Manage ReplicaSet rollout |
| StatefulSet Controller | Manage stateful Pods and storage relationships |
| DaemonSet Controller | Maintain Pod placement across nodes |
| Job Controller | Manage batch workload completion |
| Node Controller | Monitor node lifecycle |
| Service Controller | Handle Service-related reconciliation |
| PersistentVolume Controller | Manage storage binding lifecycle |

---

# What I Learned

- Kubernetes does not directly manage containers through user commands.
- Controllers continuously reconcile desired state and current state.
- Deployment manages ReplicaSet, and ReplicaSet manages Pods.
- YAML templates should remove Kubernetes-generated runtime fields before reuse.
- `--dry-run=client -o yaml` is useful for generating manifests safely.
- Understanding controllers is essential for troubleshooting Kubernetes workloads.
