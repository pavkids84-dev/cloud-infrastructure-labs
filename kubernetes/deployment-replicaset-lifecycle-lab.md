# Deployment and ReplicaSet Lifecycle Lab

## Objective

Understand how a Deployment and its ReplicaSet manage Pods through object specifications, ownership, Pod replacement, cascading deletion, and replica scaling.

This lab follows the course's pages 71–78. It records the resource model and **proposed exercises**, not evidence that these commands were run in a personal cluster.

## Scope

```text
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

All names, ages, replica counts, and terminal outputs in the PDF are examples from the course environment. The commands in this document are **proposed** and have not been executed for this document.

Do not fabricate:

```text
Deployment Names
ReplicaSet Names
Pod Names
Pod UIDs
Owner References
Node Assignments
Replica Counts
Readiness / Availability
Rollout Revisions
Event Messages
Pod Deletion Results
Scale Results
Command Output
```

Record actual results only after completing approved experiments and collecting evidence in the real cluster. Distinguish intentional scale-to-zero from an unexpected workload failure.

---

# Verification Checklist

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

## What I Learned

- A Deployment maintains its workload through ReplicaSets and Pod templates.
- A ReplicaSet reconciles the requested number of Pods, including after deletion of a managed Pod.
- Ownership and cascade behavior determine which dependent resources are removed together.
- Scaling changes the desired replica count; actual Pod creation, termination, and readiness must be observed separately.
- Verification depends on the cluster's observed resource state, not on sample output in the course PDF.
