# Kubernetes Labels, Selectors, and Node Scheduling Lab

## Objective

Understand how Kubernetes labels and selectors organize resources, how changing labels can alter controller membership, and how `nodeSelector` can constrain Pod scheduling to nodes with matching labels.

## Scope

```text
Labels
Selectors
Resource Organization
kubectl label
kubectl get --show-labels
Controller Membership
Node Labels
nodeSelector
Scheduling Constraints
Troubleshooting
```

---

# Labels

Labels are key-value metadata attached to Kubernetes objects.

Conceptually:

```text
Resource
   ↓
Label
   ↓
key=value
```

Labels help Kubernetes users and controllers identify groups of related resources.

Examples can include:

```text
app=web
tier=frontend
environment=dev
disktype=ssd
```

These are examples only and are not runtime evidence.

---

# Labels Across Kubernetes Resources

The course explains labels as applicable across Kubernetes resource types.

Labels can be used with resources such as:

```text
Pods
Nodes
Deployments
ReplicaSets
Services
```

The exact labels chosen depend on the workload and operational model.

---

# Viewing Labels

The course introduces:

```bash
kubectl get nodes --show-labels
```

to display labels attached to nodes.

The same observation principle applies to other label-aware resources.

The important operational habit is:

```text
Observe labels
before
debugging selectors or scheduling
```

---

# Adding a Label

The course demonstrates node labeling with a command such as:

```bash
kubectl label node NODE_NAME disktype=ssd
```

This associates the node with:

```text
disktype=ssd
```

The node name must come from the actual cluster.

Do not hardcode course node names into personal lab evidence.

---

# Labels and Controller Membership

The course notes that labels can be changed immediately.

This matters because controller relationships can depend on selectors.

Conceptually:

```text
ReplicaSet selector
       ↓
Matching Pod labels
       ↓
Managed Pod Set
```

If a Pod label changes so that it no longer matches the ReplicaSet selector:

```text
Pod
→ no longer matches selector
→ leaves the controller's matching set
```

The ReplicaSet can then create another Pod to restore its desired replica count.

---

# Label Change Is Not Just Cosmetic

Changing a label can change operational behavior.

Labels can affect:

```text
Controller membership
Service backend selection
Scheduling constraints
Resource queries
Operational grouping
```

This is why label changes should be treated as configuration changes rather than simple annotations.

---

# Selectors

Selectors identify resources based on labels.

Conceptually:

```text
Selector
   ↓
Matching Labels
   ↓
Resource Set
```

Examples already encountered include:

```text
Deployment
→ selects Pods through labels

ReplicaSet
→ selects Pods through labels

Service
→ selects backend Pods through labels
```

---

# Selector Consistency

A useful troubleshooting question is:

```text
Does the selector match the intended resource labels?
```

If not:

```text
Resource exists
+
Target object exists
+
Selector mismatch
=
Relationship broken
```

This can affect Services, ReplicaSets, Deployments, and scheduling logic.

---

# Node Labels

Nodes can also carry labels.

Conceptually:

```text
Node A
disktype=ssd

Node B
disktype=hdd
```

A workload can use node labels as a simple placement constraint.

---

# `nodeSelector`

The course introduces `nodeSelector` inside the Pod specification.

Example:

```yaml
spec:
  containers:
    - name: app
      image: busybox
  nodeSelector:
    disktype: ssd
```

This expresses:

```text
Pod
requires node label
disktype=ssd
```

The scheduler considers only nodes that satisfy the requested label match.

---

# Scheduling Flow

Conceptually:

```text
Pod Created
    ↓
nodeSelector evaluated
    ↓
Candidate Nodes Filtered
    ↓
Scheduler selects eligible node
```

A node without the required label is not eligible for that Pod under the simple `nodeSelector` constraint.

---

# Controller vs Scheduler

Labels can influence multiple Kubernetes components, but their responsibilities remain different.

```text
Controller
→ maintains desired workload state
```

```text
Scheduler
→ selects a node for a Pod
```

With `nodeSelector`:

```text
Controller
→ creates Pod requirement
      ↓
Scheduler
→ finds matching node
```

---

# Scheduling Failure Scenario

A Pod can remain unscheduled if no node matches the requested label.

Conceptually:

```text
Pod requires
disktype=ssd
      ↓
No node has
disktype=ssd
      ↓
No eligible node
      ↓
Pod remains Pending
```

The exact scheduler event should be verified from the actual environment.

---

# Troubleshooting Workflow

For a Pod affected by node label selection:

```text
Pod Pending?
      ↓
Inspect Pod specification
      ↓
Check nodeSelector
      ↓
Inspect node labels
      ↓
Check scheduler events
      ↓
Correct label or workload requirement
      ↓
Verify scheduling
```

Useful commands can include:

```bash
kubectl describe pod POD_NAME
kubectl get nodes --show-labels
```

Actual output must come from the user's lab environment.

---

# `nodeSelector` Scope

`nodeSelector` is a simple exact-match scheduling mechanism.

It should not be treated as the entire Kubernetes scheduling model.

More advanced mechanisms can include:

```text
Node Affinity
Pod Affinity
Pod Anti-Affinity
Taints
Tolerations
Topology Constraints
```

These are outside the scope of this course section.

---

# Labels and Services

The previous Service section introduced:

```text
Service selector
      ↓
Pod labels
```

A label mismatch can therefore produce:

```text
Service exists
Pod exists
but
No matching backend
```

Labels are part of Service troubleshooting as well as controller and scheduling behavior.

---

# Labels and ReplicaSets

ReplicaSets maintain the desired count of Pods that match their selector.

Conceptually:

```text
ReplicaSet
selector: app=web
        ↓
Matching Pods
```

If a managed Pod stops matching:

```text
Matching Count Drops
        ↓
ReplicaSet Reconciliation
        ↓
Replacement Pod May Be Created
```

This connects labels directly to the desired-state model.

---

# Evidence Policy

Do not fabricate:

```text
Node Names
Node Labels
Pod Names
Scheduler Events
Scheduling Results
Resource Outputs
```

Commands and example manifests are documentation examples only.

Actual evidence must come from an authorized Kubernetes environment.

---

# Verification Checklist

- Labels were understood as key-value resource metadata.
- Selectors were connected to matching resource sets.
- Label changes were recognized as operationally significant.
- ReplicaSet membership was connected to selector matching.
- Service backend selection was connected to labels.
- Node labels were introduced.
- `nodeSelector` was connected to scheduler filtering.
- Missing matching nodes were recognized as a possible scheduling failure.
- Controller and scheduler responsibilities remained distinct.
- Example values were not treated as actual lab evidence.

## What I Learned

- Labels organize Kubernetes resources and can directly affect runtime relationships.
- Selectors connect controllers and Services to matching resources.
- Changing labels can alter which controller or Service considers a Pod part of its managed set.
- Node labels and `nodeSelector` provide a simple way to constrain Pod placement.
- Scheduling problems should be investigated by comparing Pod requirements with actual node labels and scheduler evidence.
