# Kubernetes Resource Object Template Lab

## Objective

Understand how reusable Kubernetes resource manifests can be derived from existing API objects or generated with client-side dry-run operations.

The focus is on separating desired configuration from server-generated runtime metadata and creating clean YAML templates that can be version controlled and reused.

## Scope

```text
Kubernetes Object Templates
kubectl get -o yaml
Live Object Export
Server-Generated Metadata
spec
status
Resource Identity
YAML Cleanup
dry-run
dry-run=client
kubectl create
Deployment Template
Manifest Editing
Template Verification
```

---

# Resource Object Templates

The course introduces two approaches for creating Kubernetes resource templates.

```text
1. Export an existing resource with `get -o yaml`
2. Generate a manifest with `--dry-run`
```

Both approaches can produce YAML that can be reviewed and modified before creating another resource.

---

# Method 1: Export an Existing Object

A live Kubernetes object can be displayed as YAML.

```bash
kubectl get pod POD_NAME -o yaml
```

It can also be redirected into a file.

```bash
kubectl get pod POD_NAME -o yaml > pod-template.yaml
```

Conceptually:

```text
Existing API Object
       ↓
kubectl get -o yaml
       ↓
YAML File
       ↓
Review and Edit
       ↓
Reusable Manifest
```

---

# Live Object Representation

A live Kubernetes object contains more information than the original desired-state manifest.

It can include:

```text
User-Defined Configuration
Server-Generated Metadata
Controller-Generated State
Scheduler Information
Runtime Status
```

The exported YAML should therefore be reviewed before reuse.

---

# Desired State and Observed State

The object model distinguishes:

```text
spec
→ Desired configuration
```

from:

```text
status
→ Observed runtime state
```

A reusable resource definition should focus on desired configuration rather than copying the observed state of an existing object.

---

# Server-Generated Metadata

A live object can include fields such as:

```text
creationTimestamp
resourceVersion
uid
runtime-generated annotations
nodeName
status
```

These values are associated with the existing API object or its current runtime state.

They should not automatically be copied into a new reusable manifest.

---

# Object Identity

A new Kubernetes object should receive its own identity.

Conceptually:

```text
Existing Object
├── Name
├── UID
└── Resource Version
```

is different from:

```text
New Object
├── New Name
├── New UID
└── New Resource Version
```

Kubernetes manages server-generated identity information for the new object.

---

# Cleaning an Exported Manifest

The course demonstrates editing an exported YAML document before creating a new object.

The cleanup includes:

```text
Change the resource name.
Remove server-generated metadata.
Remove status.
Keep the required desired-state configuration.
```

Conceptually:

```text
Live Object YAML
       ↓
Remove Runtime-Specific Data
       ↓
Keep Desired Configuration
       ↓
Change Identity
       ↓
Reusable Template
```

---

# `status`

The course explicitly removes `status` from the reusable template.

This follows the Kubernetes state model:

```text
spec
→ What should exist?
```

```text
status
→ What currently exists?
```

Observed state should not be copied as if it were the desired definition of a new object.

---

# Recreating from a Clean Manifest

After cleanup, the manifest can be submitted as a new object.

Conceptually:

```text
Clean YAML
    ↓
kubectl create
    ↓
Kubernetes API
    ↓
New Resource
```

The resulting object should then be verified through normal Kubernetes observation.

---

# Method 2: Client-Side Dry Run

The course also introduces client-side dry run.

A general example is:

```bash
kubectl create deployment example \
  --image nginx \
  --dry-run=client \
  -o yaml
```

This generates YAML without creating the resource in the cluster.

---

# `--dry-run=client`

Conceptually:

```text
kubectl Command
       ↓
Generate Object Locally
       ↓
Do Not Create Resource
       ↓
Output Manifest
```

This is useful for preparing a clean starting template.

---

# Output as YAML

The generated definition can be redirected to a file.

```bash
kubectl create deployment example \
  --image nginx \
  --dry-run=client \
  -o yaml > deployment-template.yaml
```

This creates a manifest template rather than runtime evidence.

---

# Template Editing

A generated template can be copied and edited.

Conceptually:

```text
Generated Template
       ↓
Copy
       ↓
Edit Name / Image / Configuration
       ↓
Final Manifest
```

This provides a repeatable alternative to manually writing every field from memory.

---

# Export vs Dry Run

The two template approaches serve different purposes.

```text
kubectl get -o yaml
→ Start from an existing live object
```

```text
--dry-run=client -o yaml
→ Generate a new object definition without creating it
```

A useful operational distinction is:

```text
Existing Resource Analysis
→ get -o yaml
```

```text
New Manifest Preparation
→ dry-run
```

---

# Historical Deployment API Version

The course screenshot shows an older Deployment API version.

This should be treated as historical Kubernetes course context.

Modern Deployment manifests should be understood through:

```text
apps/v1
```

rather than preserving the legacy beta API shown by the old course environment.

---

# Deployment Template Relationship

A Deployment manifest introduces a controller-managed workload hierarchy.

Conceptually:

```text
Deployment
     ↓
ReplicaSet
     ↓
Pod
```

The template generated in this section therefore provides the transition from direct Pod management into Kubernetes controllers.

---

# Creating a Deployment from the Template

After editing the generated manifest:

```text
Deployment Manifest
       ↓
Kubernetes API
       ↓
Deployment
       ↓
ReplicaSet
       ↓
Pod
```

The resulting resources should be observed independently.

A successful manifest submission alone does not prove that the managed Pod is healthy.

---

# Template Verification

A reusable template should be reviewed for:

```text
Correct apiVersion
Correct kind
Correct Resource Name
Correct Labels and Selectors
Correct Image
Required Desired-State Fields
Absence of Unnecessary Runtime Status
Absence of Existing Object Identity Fields
```

The exact required fields depend on the resource type and Kubernetes API version.

---

# Version-Control Perspective

A clean manifest is more appropriate for version control than a raw live-object dump containing transient runtime metadata.

Conceptually:

```text
Reusable Desired-State Manifest
        ↓
Git
        ↓
Review
        ↓
Repeatable Deployment
```

This connects Kubernetes YAML to configuration-as-code and later GitOps workflows.

---

# Troubleshooting Perspective

A live-object export and a reusable template answer different questions.

```text
kubectl get -o yaml
→ What does the API object look like now?
```

```text
Clean Manifest
→ What configuration do I intend to deploy?
```

Comparing the two can help identify differences between intended and observed state.

---

# Evidence Policy

Course object values are educational examples.

Do not fabricate or reuse environment-specific values as personal lab evidence.

Do not fabricate:

```text
UIDs
Resource Versions
Creation Timestamps
Pod IP Addresses
Node Names
Deployment Names
ReplicaSet Names
Runtime Status
Command Output
```

Actual runtime evidence should come from an authorized Kubernetes environment.

---

# Verification Checklist

- Two resource-template creation approaches were identified.
- Live-object YAML export was understood.
- Desired-state fields were distinguished from runtime-generated fields.
- `spec` and `status` were distinguished.
- Server-generated metadata was identified as unsuitable for blind reuse.
- New resource identity was distinguished from existing object identity.
- Exported YAML cleanup was reviewed.
- `--dry-run=client` was understood as non-creating client-side generation.
- YAML output redirection was reviewed.
- Existing-object export and dry-run generation were distinguished.
- Historical Deployment API versions were not treated as current requirements.
- Deployment templates were connected to Deployment -> ReplicaSet -> Pod ownership.
- Runtime evidence was not fabricated.

## What I Learned

- A live Kubernetes object contains both desired configuration and runtime-managed information.
- Raw `get -o yaml` output should be reviewed before reuse as a manifest.
- `status` represents observed state rather than reusable desired configuration.
- Client-side dry run can generate clean resource templates without modifying the cluster.
- Kubernetes manifests can be version-controlled as reusable desired-state definitions.
- Deployment manifests introduce controller-managed resource hierarchies.
