# kubectl Basic Control Lab

## Objective

Understand `kubectl` as a Kubernetes API client and establish a resource-management workflow using API discovery, `get`, `describe`, events, logs, reusable YAML manifests, namespace scope, and safe resource deletion.

The focus is on understanding the relationship between commands, Kubernetes resources, API objects, and runtime evidence rather than memorizing command syntax.

This lab also consolidates the course topics on object-template generation (pp.60–65) and namespace/resource scope (pp.79–80). These additions are source-based explanations and proposed practice steps, not claims of completed personal lab execution.

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
Namespace
Cluster-Scoped Resources
kubectl create namespace
kubectl run --namespace
kubectl get --namespace
Namespace Deletion
Manifest-Based Deletion
Resource-Type Deletion
kubectl delete --all
Helm Release Deletion (Course Reference)
Deletion Scope and Verification
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

# Namespace

The course introduces a namespace as a way to group most Kubernetes resources. A namespace determines the scope in which namespaced objects are created and looked up.

```text
Cluster
├── Namespace: default
│   └── Namespaced workloads
└── Namespace: sky
    └── Namespaced workloads
```

The course's word "most" matters: namespaces do not contain every Kubernetes resource. Nodes, for example, are cluster-scoped. A namespace is a logical resource scope, not a separate physical cluster or an automatic security boundary.

---

# Proposed Namespace Exercise

Page 79 shows a namespace named `sky` and an Nginx workload created in it. The following is an exercise sequence, not a report of completed execution:

```bash
kubectl create namespace sky
kubectl run nginx --image=nginx --namespace=sky
kubectl get namespaces
kubectl get pods --namespace=sky
kubectl get pods --namespace=default
```

Check the Pod in the namespace where it was created. An unqualified `kubectl get pods` uses the current namespace from the active kubectl context (typically `default` in simple course examples), not every namespace automatically.

To query namespaced Pods across namespaces, use:

```bash
kubectl get pods --all-namespaces
```

That cross-namespace option is supplementary context; page 79 primarily demonstrates `--namespace=sky`.

---

# Namespace and Service Naming

The course associates namespace scope with Service domain names. The namespace can form part of the DNS name used to reach a Service within the cluster.

Conceptually:

```text
Service name
    +
Namespace
    ↓
Namespaced Service DNS identity
```

The course does not demonstrate a DNS query on page 79, so no successful name resolution is recorded here.

---

# Deleting a Namespace

Page 79 deletes the example namespace:

```bash
kubectl delete namespace sky
```

Namespace deletion also removes namespaced resources in that namespace. It can affect many workloads at once; do not run it against a shared or production namespace as a casual cleanup operation.

For a disposable practice namespace, verify the selected target before deletion and observe cleanup afterward:

```bash
kubectl get namespace sky
kubectl get pods --namespace=sky
# Only after confirming that sky is a disposable lab namespace:
kubectl delete namespace sky
kubectl get namespaces
```

The course screenshots are historical examples, not evidence of these commands being run in this repository's environment.

---

# Resource Deletion Scopes

Page 80 lists different ways to remove resource groups. They have different scopes and must not be treated as interchangeable.

| Course command | Intended scope |
| --- | --- |
| `kubectl delete -f sample-demo.yaml` | Resources identified by the manifest |
| `kubectl delete namespace test-ns` | A namespace and its namespaced contents |
| `kubectl delete pods --all` | All Pods of the selected resource type in the selected namespace |
| `kubectl delete deployments --all` | All Deployments of the selected resource type in the selected namespace |
| `kubectl delete replicasets --all` | All ReplicaSets of the selected resource type in the selected namespace |
| `helm uninstall release-name` | Resources managed by the specified Helm release, subject to Helm and resource retention behavior |

The course also shows the historical `helm delete` spelling. Helm installation and release management are later study topics; this example is included only to preserve the page's scope comparison.

`--all` does **not** mean "delete every resource type in every namespace." The resource type, namespace, and current context still matter. Deleting a Deployment may also lead to deletion of its dependent ReplicaSets and Pods according to its deletion behavior, which was studied on pages 71–78.

---

# Deletion Safety and Verification

Before a deletion, identify exactly which cluster, namespace, resource kind, and objects will be affected.

```bash
kubectl config current-context
kubectl get namespaces
kubectl get pods --namespace=sky
```

After a deliberately authorized cleanup, inspect the specific target again. A command's success message does not by itself prove that all dependent resources have finished terminating.

```text
Identify Target
    ↓
Confirm Cluster / Namespace / Kind
    ↓
Review Existing Resources
    ↓
Perform Authorized Change
    ↓
Verify Remaining Objects
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

Additional fields that must not be invented:

```text
Cluster Names
Deployment Status
ReplicaSet Names
Readiness Counts
Creation Events
```

Course screenshots and commands are educational examples. Do not record them as completed personal experiments.

Actual evidence must come from an authorized lab environment. Only record execution results if the corresponding commands were actually run.

Course screenshots and example names are instructional only. No personal creation, deletion, namespace inventory, or resulting Pod state is claimed. Actual observations should be added only after execution in an authorized lab environment; do not commit credentials or sensitive kubeconfig contents.

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
- Two resource-template generation methods were identified.
- Live-object YAML was distinguished from a reusable creation manifest.
- Server-assigned metadata and observed `status` were reviewed.
- `--dry-run=client` was distinguished from live resource creation.
- Deployment selectors and Pod-template labels were connected.
- The Deployment, ReplicaSet, and Pod relationship was introduced.
- Real resource state was identified as the basis for verification.
- [ ] Explain why namespaces apply to most, but not all, Kubernetes resources.
- [ ] Distinguish namespace-specific Pod queries from cross-namespace queries.
- [ ] Explain the namespace's role in Service names.
- [ ] Identify the target scope of `delete -f`, namespace deletion, and resource-type `--all` deletion.
- [ ] Explain why deletion requires target confirmation and post-change verification.
- [ ] Record real output only if the exercise was actually run.

---

## What I Learned

- kubectl is one client of the Kubernetes API.
- Kubernetes operations are organized around resources and actions.
- API discovery helps determine what the current cluster actually supports.
- `get`, `describe`, events, and logs provide different kinds of operational evidence.
- Troubleshooting should begin with observable resource state and move toward lower layers only when evidence supports it.
- A YAML export can contain server-managed fields and observed state that should not be copied into a new object without review.
- Client-side dry run prepares an editable manifest without creating the target resource.
- Deployment selectors must match the labels on the Pod template.
- A created resource must be verified through actual cluster state, not assumed from a command example.
- A namespace groups namespaced API resources within a cluster.
- The current kubectl namespace determines the scope of unqualified namespaced queries.
- Namespace deletion has a wider impact than deleting a single Pod.
- Safe cleanup begins with identifying the cluster, namespace, kind, and target objects.
