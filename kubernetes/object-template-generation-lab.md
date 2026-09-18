# Kubernetes Object Template Generation Lab

## Objective

Understand how to prepare reusable Kubernetes manifests from existing objects or client-side generated YAML, edit them carefully, and verify the resulting resource relationships.

This learning note covers the course's "Major Objects Template" section (pp. 60-65). Commands and output shown in the course are examples, not evidence of execution in my own cluster.

## Scope

```text
Existing Object Export
kubectl get -o yaml
Server-Managed Metadata
Clean Resource Manifests
Client-Side Dry Run
Deployment Manifest Generation
Metadata, Selector, and Pod Template Labels
Deployment / ReplicaSet / Pod Relationship
Verification
```

---

# Two Template Creation Methods

The course presents two paths:

```text
Method A: Existing Resource
  kubectl get ... -o yaml > file.yaml
                 ↓
           Review / Edit
                 ↓
          Reusable Manifest

Method B: Generate a Resource Definition
  kubectl create ... --dry-run=client -o yaml > file.yaml
                 ↓
           Review / Edit
                 ↓
          Reusable Manifest
```

The first method requires an existing object; the second prepares a candidate manifest without creating the target object as part of that command.

---

# Method A: Export an Existing Pod (Course pp. 61-63)

The course exports the Pod named `mypod`:

```bash
kubectl get pod mypod -o yaml > mypod.yaml
```

The resulting document can include user-specified configuration and information added by the API server or other cluster components.

Examples visible in the course's older Pod export include:

```text
metadata.creationTimestamp
metadata.resourceVersion
metadata.selfLink
metadata.uid
spec.nodeName
spec.volumeMounts
spec.volumes
status
```

These are observations from the *course example*, not expected identical fields in every Kubernetes version or environment.

## Prepare a Clean New Manifest

The course changes the resource name and removes server-managed metadata and `status` before creating another Pod. A minimal standalone example following the same idea is:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod-modify
spec:
  containers:
    - name: hhs
      image: nginx
```

This is a proposed manifest for learning, not an export from a live cluster.

When cleaning a real export, review rather than blindly copy:

- Replace `metadata.name` with an unused name if creating an independent object.
- Remove server-generated `metadata` fields such as `uid`, `resourceVersion`, `creationTimestamp`, and `managedFields` if present.
- Remove `status`, which describes observed state rather than a reusable desired-state definition.
- Review cluster-specific assignments, automatically injected fields, and identity or credential references rather than copying them uncritically.
- If an object is controlled by another resource, inspect `ownerReferences` and use the correct parent resource instead of cloning the managed child without understanding its ownership.

The exact cleanup depends on the object and the cluster. The course screenshot's `selfLink` and automatically mounted legacy ServiceAccount token reflect its older environment.

## Create and Verify the New Pod

With an edited manifest saved as `mypod-modify.yaml`, the corresponding *proposed* lab commands are:

```bash
kubectl create -f mypod-modify.yaml
kubectl get pod mypod-modify
kubectl describe pod mypod-modify
```

Confirm the object name, scheduling, container status, and relevant events. A successful create response alone does not establish application readiness.

The course's separate example uses `kubectl create -f mypod.yaml` after editing its exported file. There is no requirement to delete the original Pod merely to demonstrate manifest reuse.

---

# Method B: Client-Side Dry Run (Course pp. 64-65)

The course generates a Deployment manifest and then makes a copy for editing:

```bash
kubectl create deployment example --image=nginx --dry-run=client -o yaml > deploy_template.yaml
cp deploy_template.yaml hhs.yaml
```

`--dry-run=client` generates the proposed object locally rather than submitting a create request for that Deployment. `-o yaml` prints the generated definition; `>` saves the output in a file.

To review the generated manifest without redirecting output:

```bash
kubectl create deployment example --image=nginx --dry-run=client -o yaml
```

The generated fields depend on the installed `kubectl` version and flags. The course screenshot shows an older `apps/v1beta1` Deployment; it must not be copied unchanged as a current-version manifest. The following illustrative template uses `apps/v1`, with an explicit selector that matches the Pod template's label:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hhs
  labels:
    app: hhs
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hhs
  template:
    metadata:
      labels:
        app: hhs
    spec:
      containers:
        - name: hhs
          image: nginx
```

This is a *teaching example*, not the literal output of the historical screenshot or a file already deployed to my cluster.

## Keep Deployment Labels Consistent

The course edits the generated Deployment from `example` to `hhs`. When editing an actual generated manifest, check the related names and selector labels rather than replacing just one occurrence:

```text
metadata.name: hhs
          |
spec.selector.matchLabels.app: hhs
          |
spec.template.metadata.labels.app: hhs
```

The selector and Pod-template labels must match. A Deployment's own `metadata.labels` can be used for organization but is not a substitute for the selector/template relationship.

## Validate and Inspect (Proposed Practice)

Before creating a resource, inspect the edited file:

```bash
cat hhs.yaml
kubectl apply --dry-run=client -f hhs.yaml
```

A client-side dry run does not prove a container image can be pulled or that the workload will become Ready; validation behavior can vary by client and cluster.

For an authorized disposable lab environment only, continue with the course's create-and-observe sequence:

```bash
kubectl create -f hhs.yaml
kubectl get deployments
kubectl get replicasets
kubectl get pods
kubectl get deployment,replicaset,pod
kubectl describe deployment hhs
```

The course's screenshot illustrates a Deployment named `hhs`, a ReplicaSet created for it, and a Pod. Resource names, pod suffixes, counters, ages, and readiness must be read from the actual lab rather than copied from that screenshot.

```text
Deployment / hhs
       ↓ manages
ReplicaSet / generated name
       ↓ maintains
Pod / generated name
```

The detailed controller behavior is introduced in the *next* course section, starting at p. 66.

---

# Operational Comparison

| Question | Export an existing object | Generate with client-side dry run |
| --- | --- | --- |
| Starting point | An object already in the cluster | A `kubectl create` command |
| Typical command | `kubectl get pod mypod -o yaml` | `kubectl create deployment example --image=nginx --dry-run=client -o yaml` |
| Main review task | Remove or reconsider observed/server-managed and environment-specific fields | Review generated object schema, names, and labels |
| Creates the target resource immediately? | No: a `get` reads existing state | No: client-side dry run does not submit this create request |
| Follow-up | Edit and create/apply separately | Edit and create/apply separately |

---

# Evidence Policy

All YAML blocks and shell commands in this note are either course-derived examples or clearly identified proposed practice. Do not claim a Pod or Deployment was created, Ready, or verified without actual command output from an authorized environment.

If the practice is performed, capture only genuine evidence: the resulting manifest, command output, relevant conditions/events, and any troubleshooting/recovery steps.

## Verification Checklist

- [ ] Explain the two template-generation methods.
- [ ] Distinguish exported observed state from a clean desired-state manifest.
- [ ] Identify metadata and `status` fields that require review before reuse.
- [ ] Explain what `--dry-run=client` does and does not do.
- [ ] Confirm that Deployment selectors match Pod-template labels.
- [ ] Distinguish a Deployment, its ReplicaSet, and its Pods.
- [ ] Record real execution evidence only if the proposed lab was actually performed.

## What I Learned

A live-object YAML export is not automatically a reusable source manifest. Client-side dry-run generation offers another starting point, but the generated configuration must still be reviewed. After applying an edited manifest in a real lab, verify the actual API objects and workload state rather than relying only on the create response.
