# Kubernetes Object Template Generation Lab

## Objective

Understand how to create reusable Kubernetes resource manifests by exporting an existing object or generating YAML with `--dry-run=client`.

The focus is on separating desired configuration from observed state, reviewing generated fields, and verifying the resources created from an edited manifest.

## Scope

```text
Kubernetes Resource Templates
kubectl get -o yaml
YAML Export
Server-Managed Metadata
Desired State and Observed State
Pod Manifest Reuse
kubectl create -f
kubectl create --dry-run=client
Deployment Manifest
Deployment Labels
Selector
Pod Template
ReplicaSet
Pod
Resource Verification
```

---

# Resource Templates

The course introduces two ways to prepare an editable resource definition:

```text
Existing Kubernetes Object
          ↓
kubectl get -o yaml
          ↓
Review and Edit YAML
          ↓
New Resource Manifest
```

```text
kubectl create --dry-run=client
          ↓
Generated YAML
          ↓
Review and Edit YAML
          ↓
New Resource Manifest
```

The two methods produce a starting point for a manifest. Neither command alone proves that a new workload has been created or is healthy.

---

# Export an Existing Pod

The course starts with a Pod named `mypod`:

```bash
kubectl get pod mypod -o yaml
```

To write the result to a file:

```bash
kubectl get pod mypod -o yaml > mypod.yaml
```

The export describes the object currently known to the Kubernetes API. It may include fields that did not appear in the original user-authored manifest.

The Pod must actually exist in the selected namespace before running this example. Its name is taken from the course, not from my own cluster.

---

# Server-Managed Metadata

The course's exported Pod contains fields such as:

```text
metadata.creationTimestamp
metadata.resourceVersion
metadata.selfLink
metadata.uid
```

It also contains a `status` section describing the observed Pod state.

A new resource should not inherit the old object's identity or observed state. Review and remove server-generated fields when preparing a new creation manifest.

```text
Exported Object
    ├── Desired Configuration
    ├── Server-Assigned Metadata
    └── Observed Status
                  ↓
         Review and Clean
                  ↓
       Reusable Manifest
```

The course's `selfLink` field and token-mount example come from its older environment. Do not assume that all Kubernetes versions return the same fields.

---

# Reuse the Pod Configuration

The course edits the exported Pod's name and removes lines that should not be carried into the new object, including `status`.

The following is a simplified example of a clean, standalone Pod manifest based on that idea:

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

This YAML is a teaching example rather than a literal copy of the course's full exported object.

When editing a real export, also review controller ownership, cluster-specific settings, mounted credentials, and fields assigned by admission or scheduling. A Pod managed by a Deployment or ReplicaSet should not be treated as an independent long-lived workload without checking its owner.

---

# Create and Inspect the New Pod

After saving the reviewed manifest as `mypod-modify.yaml`, the practice commands are:

```bash
kubectl create -f mypod-modify.yaml
kubectl get pod mypod-modify
kubectl describe pod mypod-modify
```

The course's screenshot shows an original Pod and a modified Pod existing together. Their recorded readiness, ages, and names belong to the course environment; they are not personal execution evidence.

Verify the actual Pod conditions and events. A successful create response alone does not mean the container is Ready.

---

# Client-Side Dry Run

The second template-generation method uses `--dry-run=client`.

The course creates a Deployment definition without submitting a Deployment creation request:

```bash
kubectl create deployment example --image=nginx --dry-run=client -o yaml > deploy_template.yaml
```

The relevant command parts are:

```text
kubectl create deployment
→ Prepare a Deployment definition

--image=nginx
→ Specify the container image

--dry-run=client
→ Generate a proposed object on the client

-o yaml
→ Print YAML

> deploy_template.yaml
→ Save the output to a file
```

Generating YAML is different from creating a live Deployment. The generated fields depend on the `kubectl` version and options.

---

# Edit the Deployment Template

The course copies the generated file and edits the copy:

```bash
cp deploy_template.yaml hhs.yaml
vi hhs.yaml
```

The example changes `example` to `hhs` and updates the corresponding labels.

A simplified Deployment manifest using the `apps/v1` API is:

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

This example conveys the intended configuration. It is not the literal YAML printed by the historical course version or a resource confirmed to exist in my cluster.

---

# Deployment Selector and Pod Labels

The Deployment selects its managed Pods through `spec.selector`.

```text
Deployment / hhs
       ↓
spec.selector.matchLabels
       ↓
app: hhs
       ↓
spec.template.metadata.labels
       ↓
app: hhs
```

The selector and Pod-template labels must match. Updating only `metadata.name` while leaving the old selector and labels in the file is not an appropriate rename of the intended workload.

The Deployment's own `metadata.labels` help describe the Deployment, but they are not a replacement for the selector and Pod-template label relationship.

---

# Deployment, ReplicaSet, and Pod

The course's final screenshot inspects the resources created after submitting `hhs.yaml`.

```text
Deployment
     ↓
ReplicaSet
     ↓
Pod
     ↓
Container
```

At this stage, the diagram connects the resource names seen in the course. Detailed reconciliation behavior is covered in the following Controller section.

---

# Create and Verify the Deployment

After reviewing the edited `hhs.yaml`, the course creates the Deployment:

```bash
kubectl create -f hhs.yaml
```

Then it inspects the related resources:

```bash
kubectl get deployments
kubectl get replicasets
kubectl get pods
```

The following combined view is an optional way to inspect the same resource types:

```bash
kubectl get deployment,replicaset,pod
```

Verification should confirm the real Deployment name, desired and available replicas, the resulting ReplicaSet, and the Pod's state. If a Pod fails to start, use the `kubectl describe` and event workflow from the earlier labs.

The course's example output is not reproduced as an actual result of these proposed commands.

---

# Template Verification Workflow

```text
Prepare or Export YAML
         ↓
Review Object Kind and API Version
         ↓
Review Names, Labels, and Selectors
         ↓
Remove Unwanted Server-Managed Fields
         ↓
Create the Resource in a Lab Cluster
         ↓
Inspect Deployment / ReplicaSet / Pod
         ↓
Check Conditions, Events, and Logs if Needed
```

For a real lab, verify both the resource definition and the observed workload state. Do not infer successful operation merely from the existence of a YAML file.

---

# Historical Course Context

The Deployment screenshot on p.64 uses `apps/v1beta1`. This document preserves that screenshot as historical course context while using `apps/v1` in the separate simplified teaching manifest.

The example Pod output, generated names, IP addresses, and ages on pp.61-65 also belong to the course environment. The exact generated YAML and resource names may differ in a different Kubernetes version or cluster.

---

# Evidence Policy

Course screenshots and commands are educational examples. Do not record them as completed personal experiments.

Do not fabricate:

```text
Cluster Names
Pod Names
Pod IP Addresses
Deployment Status
ReplicaSet Names
Readiness Counts
Command Output
Creation Events
```

Actual evidence must come from an authorized lab environment. Only record execution results if the corresponding commands were actually run.

---

# Verification Checklist

- Two resource-template generation methods were identified.
- Live-object YAML was distinguished from a reusable creation manifest.
- Server-assigned metadata and observed `status` were reviewed.
- `--dry-run=client` was distinguished from live resource creation.
- Deployment selectors and Pod-template labels were connected.
- The Deployment, ReplicaSet, and Pod relationship was introduced.
- Real resource state was identified as the basis for verification.

## What I Learned

- A YAML export can contain server-managed fields and observed state that should not be copied into a new object without review.
- Client-side dry run prepares an editable manifest without creating the target resource.
- Deployment selectors must match the labels on the Pod template.
- A created resource must be verified through actual cluster state, not assumed from a command example.
