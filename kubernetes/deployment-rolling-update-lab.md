# Kubernetes Deployment and Rolling Update Lab

## Objective

Understand how Kubernetes Deployments update application versions through ReplicaSets, how rollout history and rollback work, and how RollingUpdate, Recreate, and Blue/Green deployment concepts differ.

## Scope

```text
Deployment
Image Update
ReplicaSet Revision
RollingUpdate
Recreate
OnDelete Context
kubectl set image
kubectl edit
kubectl apply
kubectl rollout
Rollout History
Rollback
Rollout Status
Pause
Resume
Restart
Blue/Green Deployment
Troubleshooting
```

---

# Deployment Updates

The course introduces application image updates through a Deployment.

Three update approaches are shown:

```text
kubectl set image
kubectl edit
kubectl apply
```

All three can change the desired Deployment configuration, but they represent different operational workflows.

---

# `kubectl set image`

`kubectl set image` changes the container image referenced by a workload.

Conceptually:

```text
Deployment Pod Template
        ↓
Image Changed
        ↓
New ReplicaSet Revision
        ↓
New Pods
```

A Deployment update is therefore not simply an in-place modification of existing container processes.

---

# `kubectl edit`

`kubectl edit` modifies the live API object interactively.

Conceptually:

```text
Current API Object
      ↓
Interactive Edit
      ↓
Updated Desired State
      ↓
Deployment Reconciliation
```

Because the live object is changed directly, this should be used carefully in environments where manifests in version control are intended to remain the authoritative configuration.

---

# `kubectl apply`

`kubectl apply` updates the resource from a manifest.

Conceptually:

```text
Version-Controlled YAML
        ↓
kubectl apply
        ↓
Updated Desired State
        ↓
Deployment Reconciliation
```

This workflow aligns naturally with configuration-as-code practices.

---

# Deployment and ReplicaSet Revisions

A Deployment manages ReplicaSets representing workload revisions.

Conceptually:

```text
Deployment
├── ReplicaSet Revision A
│   └── Old Pods
└── ReplicaSet Revision B
    └── New Pods
```

Changing the Pod template can cause a new ReplicaSet to be created.

---

# RollingUpdate

The course introduces RollingUpdate as a deployment strategy.

Conceptually:

```text
Old Pods
   ↓
Gradual Replacement
   ↓
New Pods
```

The goal is to replace workload instances in a controlled sequence rather than stop the entire application first.

---

# RollingUpdate Relationship

A simplified flow is:

```text
Deployment updated
      ↓
New ReplicaSet created
      ↓
New ReplicaSet scales up
      ↓
Old ReplicaSet scales down
      ↓
New revision becomes active
```

The exact sequence depends on Deployment strategy settings.

---

# Recreate

The course also introduces the `Recreate` strategy.

Conceptually:

```text
Old Pods Stop
      ↓
New Pods Start
```

This can create application downtime.

The operational difference from RollingUpdate is important:

```text
RollingUpdate
→ controlled overlap can occur
```

```text
Recreate
→ old workload is removed before new workload is started
```

---

# OnDelete Context

The course lists `OnDelete` in the update-strategy discussion and associates it with DaemonSet behavior.

This should not be treated as a normal Deployment update strategy.

The reusable concept is:

```text
Different workload controllers
can support different update strategies
```

---

# Rollout History

The course introduces:

```bash
kubectl rollout history deployment DEPLOYMENT_NAME
```

Conceptually:

```text
Deployment
      ↓
Revision History
      ↓
Previous Pod Template Versions
```

Revision history provides the basis for inspecting previous rollout states.

---

# Inspecting a Revision

A specific revision can be inspected.

Conceptually:

```bash
kubectl rollout history deployment DEPLOYMENT_NAME --revision=REVISION
```

The revision value must come from the actual Deployment history.

Do not copy revision numbers from course screenshots into personal evidence.

---

# Rollback

The course demonstrates rollback with:

```bash
kubectl rollout undo deployment DEPLOYMENT_NAME --to-revision=REVISION
```

Conceptually:

```text
Current Revision Has Problem
        ↓
Choose Previous Revision
        ↓
Rollout Undo
        ↓
Deployment Desired State Reverted
        ↓
Controller Reconciles
```

Rollback must still be verified after execution.

---

# Rollout Status

A rollout should be observed rather than assumed successful.

Conceptually:

```bash
kubectl rollout status deployment DEPLOYMENT_NAME
```

Useful verification also includes:

```text
Deployment state
ReplicaSet state
Pod state
Events
Application behavior
```

A successful command response alone does not prove the application is healthy.

---

# Pause and Resume

The course lists rollout controls such as:

```text
pause
resume
```

Conceptually:

```text
pause
→ temporarily stop rollout progression
```

```text
resume
→ continue rollout progression
```

These controls are useful when managing staged Deployment changes.

---

# Restart

The course also lists rollout restart behavior.

Conceptually:

```text
Deployment
      ↓
Restart Trigger
      ↓
New Pod Replacement Cycle
```

This should be distinguished from changing the application image version.

---

# Course Rolling Update Exercise

The course exercise follows this sequence:

```text
Create Deployment
      ↓
Scale to multiple replicas
      ↓
Inspect Deployment / ReplicaSet / Pods
      ↓
Change image
      ↓
Inspect rollout history
      ↓
Inspect workload image state
      ↓
Rollback
      ↓
Verify rollout status
```

This sequence is useful because it observes the controller hierarchy rather than only issuing the update command.

---

# Deprecated `--record` Context

The course exercise uses:

```text
--record
```

with `kubectl set image`.

This reflects older kubectl usage.

The important reusable concept is:

```text
Track Deployment revision history
and verify what changed
```

rather than memorizing the historical `--record` option.

---

# Shell Pipe Context

The course uses commands such as:

```bash
kubectl describe deployment DEPLOYMENT_NAME | grep -i image
```

The pipe:

```text
|
```

is a shell pipeline operator.

It sends the output of the command on the left into `grep` on the right.

This should not be confused with Kubernetes syntax.

---

# Blue/Green Deployment

The course introduces Blue/Green deployment conceptually.

A simple model is:

```text
Blue
→ Current production version

Green
→ New candidate version
```

Both environments can exist separately.

Traffic is switched only after the new environment is considered ready.

Conceptually:

```text
Users
  ↓
Service / Traffic Selector
  ↓
Blue
```

then later:

```text
Users
  ↓
Service / Traffic Selector
  ↓
Green
```

---

# Blue/Green vs RollingUpdate

These strategies solve deployment change differently.

```text
RollingUpdate
→ gradually replace instances
```

```text
Blue/Green
→ maintain separate old and new environments, then switch traffic
```

The course page introduces Blue/Green at a conceptual level rather than providing a full implementation lab.

---

# Rollout Troubleshooting

If an update does not complete:

```text
Deployment desired state
      ↓
ReplicaSet state
      ↓
New Pods created?
      ↓
Pods scheduled?
      ↓
Images pulled?
      ↓
Containers started?
      ↓
Pods Ready?
      ↓
Application healthy?
```

This preserves the layered troubleshooting method used throughout the repository.

---

# Revision Troubleshooting

Useful evidence can include:

```text
Deployment revision
ReplicaSets
Pod images
Events
Rollout status
Application response
```

Do not assume that a new ReplicaSet existing means the rollout is healthy.

---

# Image Update Failure Layers

Possible failure layers include:

```text
Invalid Image Reference
Registry Access
Image Pull Failure
Container Startup Failure
Readiness Failure
Application Failure
Scheduling Failure
Resource Constraint
```

Actual root cause must be determined from cluster evidence.

---

# Deployment vs Pod Modification

A controller-managed workload should normally be changed through its desired-state owner.

Conceptually:

```text
Deployment Template Change
      ↓
Controller Reconciliation
      ↓
New Pods
```

Directly modifying individual Pods does not provide a durable Deployment-level configuration change.

---

# Configuration-as-Code Perspective

For reproducible infrastructure:

```text
Manifest
   ↓
Version Control
   ↓
Review
   ↓
kubectl apply
   ↓
Rollout Observation
```

This provides a clearer change history than relying only on ad-hoc interactive changes.

---

# Evidence Policy

Course screenshots and example values are educational examples.

Do not fabricate:

```text
Deployment Names
ReplicaSet Names
Pod Names
Revision Numbers
Image Versions
Rollout Results
Events
Command Output
Application Responses
```

Actual evidence must come from an authorized Kubernetes environment.

---

# Verification Checklist

- Deployment image updates were connected to Pod-template changes.
- `set`, `edit`, and `apply` were distinguished as different update workflows.
- Deployment revisions were connected to ReplicaSets.
- RollingUpdate was understood as gradual replacement.
- Recreate was distinguished from RollingUpdate.
- OnDelete was recognized as workload-controller-specific context.
- Rollout history was introduced.
- Specific revisions were understood as observable Deployment history.
- Rollback was connected to restoring a previous desired workload revision.
- Rollout status was treated as evidence that must still be followed by workload verification.
- Pause, resume, and restart concepts were introduced.
- Blue/Green deployment was distinguished from RollingUpdate.
- Historical `--record` usage was not treated as a modern requirement.
- Shell pipelines were distinguished from Kubernetes syntax.
- Course values were not treated as actual lab evidence.

## What I Learned

- Deployment updates create new desired workload revisions rather than simply editing running containers in place.
- ReplicaSets represent important Deployment revision boundaries.
- RollingUpdate gradually shifts capacity from an old revision to a new revision.
- Rollout history and rollback provide operational control over Deployment changes.
- Blue/Green deployment keeps separate old and new environments and switches traffic between them.
- Deployment changes should be verified through controller, ReplicaSet, Pod, event, and application evidence.
