# Kubernetes Pod Fundamentals Lab

## Objective

Understand the Pod as the basic Kubernetes scheduling unit, including shared networking, shared volumes, Pod IP addressing, CNI networking, YAML resource definitions, runtime inspection, container command execution, and evidence-based Pod troubleshooting.

## Scope

```text
Pod
Scheduling Unit
Namespace
Pod IP
Multi-Container Pod
Shared Network Namespace
Pause / Sandbox Container
Container-to-Container Networking
Pod-to-Pod Networking
Pod-to-Service Networking
External-to-Service Networking
CNI
Pod Volumes
PersistentVolume
PersistentVolumeClaim
ConfigMap
Secret
CSI
YAML
apiVersion
kind
metadata
spec
status
Pod Creation
Pod Conditions
Pod Events
Pod Description
Pod Logs
kubectl exec
Interactive Container Access
Container Environment
Container Exit Codes
Object YAML Inspection
```

---

# Pod

A Pod is the basic Kubernetes workload and scheduling unit.

The course describes a Pod as a set of containers that can share networking and storage.

Conceptually:

```text
Pod
├── Container A
└── Container B
```

A Pod can contain one container or multiple cooperating containers.

---

# Pod vs Container

A Pod is not identical to a container.

```text
Container
!=
Pod
```

The relationship is:

```text
Pod
   ↓
One or More Containers
```

Kubernetes scheduling operates on the Pod rather than independently scheduling each container inside the same Pod.

---

# Scheduling Unit

The Pod is the minimum scheduling unit.

Conceptually:

```text
Pod
   ↓
Scheduler
   ↓
Worker Node
```

Containers inside the same Pod are associated with the same scheduled Pod placement.

---

# Namespace Scope

Pods are namespaced Kubernetes resources.

Conceptually:

```text
Namespace
└── Pod
```

Namespace behavior and resource isolation are studied in more detail later in the learning path.

---

# Pod IP

The course introduces the principle that a Pod receives an IP address.

Conceptually:

```text
Pod
└── Pod IP
```

Containers inside the Pod participate in the Pod networking environment rather than each being treated as an independently scheduled Pod endpoint.

---

# Shared Network Namespace

Containers in the same Pod share the Pod networking environment.

Conceptually:

```text
Pod Network Namespace
├── Container A
└── Container B
```

This means cooperating containers can communicate through the shared network namespace.

---

# Container-to-Container Communication

Containers in the same Pod can communicate using the shared Pod network environment.

Conceptually:

```text
Container A
    ↕
localhost
    ↕
Container B
```

This differs from communication between separate Pods.

---

# Pause / Sandbox Container

The course introduces a pause container as an infrastructure container associated with the Pod's namespace.

Conceptually:

```text
Pod Sandbox
    ↓
Network Namespace
   ┌───────┴───────┐
Container A    Container B
```

The important concept is the shared Pod sandbox and network namespace rather than the pause process as an application workload.

---

# Historical docker0 Diagram

The course includes a Pod networking diagram that uses `docker0`.

This should be treated as historical Docker-based course context.

The reusable Kubernetes concept is:

```text
Pod
→ Network Namespace
→ CNI-Managed Pod Networking
```

Do not assume that every Kubernetes cluster implements Pod networking through `docker0`.

---

# Kubernetes Network Communication Types

The course introduces four communication categories:

```text
Container-to-Container
Pod-to-Pod
Pod-to-Service
External-to-Service
```

These provide a useful framework for later Kubernetes networking study.

---

# Container-to-Container

```text
Same Pod
   ↓
Shared Network Namespace
   ↓
Container A ↔ Container B
```

The shared Pod environment handles communication between cooperating containers.

---

# Pod-to-Pod

```text
Pod A
  ↕
Cluster Network
  ↕
Pod B
```

Pod-to-Pod connectivity can span worker nodes and depends on the Kubernetes network implementation.

---

# Pod-to-Service

```text
Pod
 ↓
Service
 ↓
Backend Pod
```

Detailed Service behavior is studied later.

At this stage, the important concept is that workloads can address a stable service abstraction rather than directly depend on individual backend Pod identities.

---

# External-to-Service

```text
External Client
      ↓
Kubernetes Service Layer
      ↓
Application Pods
```

Detailed external exposure methods are studied later with Kubernetes Services and Ingress.

---

# CNI

CNI stands for:

```text
Container Network Interface
```

Kubernetes can use CNI plugins for Pod networking.

The course references examples such as:

```text
Calico
Canal
Flannel
Weave Net
Kube-router
Romana
```

The specific product list reflects course context.

---

# CNI Architecture

A simplified Pod networking path is:

```text
Pod Creation
    ↓
Pod Sandbox
    ↓
CNI
    ↓
Network Interface
IP Address
Routing / Connectivity
```

This connects Kubernetes directly to previously studied Linux and networking concepts.

---

# Historical kubelet Network Option

The course references the historical kubelet option:

```text
--network-plugin=cni
```

This should be treated as course-version-specific implementation context.

The reusable architectural concept is the integration among:

```text
Kubernetes Node
Container Runtime
CNI Configuration
Pod Network
```

rather than memorizing the historical kubelet option.

---

# Network Verification

The course combines Kubernetes and Linux observation after network plugin installation.

Useful investigation layers include:

```text
Kubernetes Node State
Pod State
System Pods
Linux Interfaces
IP Addressing
```

This reinforces that Kubernetes networking remains dependent on Linux networking underneath the API abstraction.

---

# Pod Storage

Pods can define volumes and mount them into containers.

Conceptually:

```text
Pod
│
├── Volume
│
├── Container A
│      ↕
└── Container B
       ↕
     Volume
```

This allows containers in a Pod to use explicitly defined storage.

---

# Volume Mounts

A Pod volume becomes available inside a container through a mount.

Conceptually:

```text
Pod Volume
    ↓
volumeMount
    ↓
Container Path
```

The volume lifecycle and backing implementation depend on the selected volume type.

---

# Ephemeral and Persistent Storage

The course describes volumes as primarily persistent, but its example uses `emptyDir`.

A more useful distinction is:

```text
Pod Volumes
├── Ephemeral Storage
└── Persistent Storage Integration
```

`emptyDir` is associated with the Pod lifecycle and should not be treated as persistent storage beyond that lifecycle.

---

# PersistentVolume and PersistentVolumeClaim

The course introduces:

```text
PersistentVolume
PersistentVolumeClaim
```

as Kubernetes persistent-storage concepts.

A simplified relationship is:

```text
Application Storage Requirement
       ↓
PersistentVolumeClaim
       ↓
PersistentVolume / Storage Backend
```

Detailed PV and PVC behavior is studied later in the storage section.

---

# ConfigMap and Secret Volume Sources

ConfigMaps and Secrets can be exposed to Pod containers through volume mounts.

They should not be confused with persistent block or filesystem storage.

Conceptually:

```text
Configuration / Secret
       ↓
Volume Projection
       ↓
Container Files
```

Their primary role is application configuration or sensitive-data delivery.

---

# Volume Types

The course lists multiple volume backends and sources, including concepts such as:

```text
emptyDir
hostPath
nfs
persistentVolumeClaim
configMap
secret
CSI
Cloud Provider Storage
```

The exact historical provider list is less important than understanding the storage categories.

---

# CSI

CSI stands for:

```text
Container Storage Interface
```

It can be remembered alongside:

```text
CNI
→ Container networking integration
```

```text
CSI
→ Container storage integration
```

Both support extensible infrastructure integrations around Kubernetes workloads.

---

# Kubernetes Object Schema

The course uses:

```bash
kubectl explain pods
```

to inspect the Pod resource schema.

A Kubernetes Pod object contains core fields such as:

```text
apiVersion
kind
metadata
spec
```

These fields form the foundation of Kubernetes manifest structure.

---

# `apiVersion`

`apiVersion` identifies the Kubernetes API schema used by the object.

Example:

```yaml
apiVersion: v1
```

API versions should be selected according to the resource and Kubernetes version being used.

---

# `kind`

`kind` identifies the Kubernetes resource type.

Example:

```yaml
kind: Pod
```

Conceptually:

```text
API Version
+
Kind
```

tell the API server how the submitted object should be interpreted.

---

# `metadata`

`metadata` identifies and describes the Kubernetes object.

A minimal example can include:

```yaml
metadata:
  name: mypod
```

Additional metadata can include:

```text
Labels
Annotations
Namespace
Ownership
```

---

# `spec`

`spec` describes the desired resource configuration.

For a Pod:

```yaml
spec:
  containers:
```

defines the container workload that Kubernetes should maintain for the Pod.

This connects manifest configuration directly to the desired-state model.

---

# Minimal Pod Manifest

A minimal learning example can be represented as:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
    - name: app
      image: nginx
```

This is an example definition, not evidence that a Pod was successfully created in an actual environment.

---

# YAML

Kubernetes manifests commonly use YAML.

Important course syntax includes:

```text
key: value
Indentation
Lists
Objects
Comments
Document Markers
Multi-Line Text
```

Indentation represents hierarchy.

Tabs should not be used for YAML indentation.

---

# Declarative Pod Creation

A manifest can be submitted to Kubernetes.

Conceptually:

```text
YAML Manifest
      ↓
kubectl
      ↓
Kubernetes API
      ↓
Pod Object
```

Submitting the object does not mean the workload is instantly ready.

---

# Asynchronous Pod Startup

After Pod creation, the workload can transition through runtime states.

Conceptually:

```text
Object Created
      ↓
Scheduling
      ↓
Image Preparation
      ↓
Container Creation
      ↓
Container Start
      ↓
Running
```

A successful API creation request and a healthy running application are different verification steps.

---

# Pod Conditions

A Pod exposes multiple conditions rather than only one summary status.

Examples can include:

```text
Initialized
Ready
ContainersReady
PodScheduled
```

These conditions provide more detailed evidence about workload state.

```text
Pod Running
```

should not automatically be treated as sufficient proof that every readiness condition is satisfied.

---

# Pod Events

The course demonstrates a startup event sequence such as:

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

Events provide evidence about what Kubernetes attempted during Pod startup.

---

# Pod Description

Detailed Pod inspection can expose information such as:

```text
Namespace
Node
Status
Pod IP
Container Image
Container State
Ready State
Restart Count
Conditions
Volumes
Mounts
Events
```

This provides significantly more operational context than a summary listing.

---

# Pod Logs

Container logs provide application-level evidence.

```text
Pod
 ↓
Container
 ↓
stdout / stderr
```

Logs should be correlated with Kubernetes state and events.

---

# `kubectl exec`

The course introduces `kubectl exec` for executing commands inside a container of a running Pod.

A general structure is:

```bash
kubectl exec POD_NAME -- COMMAND
```

For a multi-container Pod, a target container can be selected.

```bash
kubectl exec POD_NAME -c CONTAINER_NAME -- COMMAND
```

---

# Interactive Container Access

The course demonstrates interactive execution using:

```bash
kubectl exec -it POD_NAME -- /bin/bash
```

Conceptually:

```text
Local Terminal
      ↕
kubectl
      ↕
Kubernetes API
      ↕
Running Container Process
```

This is process execution inside the running container and should not be confused with SSH login.

---

# `-i` and `-t`

For interactive execution:

```text
-i
→ Keep stdin connected
```

```text
-t
→ Allocate a terminal
```

They are commonly combined for an interactive shell session.

---

# Command Separator

The `--` separator distinguishes kubectl options from the command that should execute inside the container.

```text
kubectl options
      ↓
--
      ↓
container command
```

This makes command parsing boundaries explicit.

---

# Container Environment

The course inspects the environment inside a running container.

Useful categories can include:

```text
HOSTNAME
PATH
Application Environment
Kubernetes-Related Service Environment
```

The container environment is distinct from the host environment.

---

# Minimal Container Images

The course demonstrates commands such as `ps` and `ip` being unavailable inside an application container.

This reinforces:

```text
Container Image
!=
Complete General-Purpose Linux Host
```

An application image may intentionally exclude administrative utilities.

A missing diagnostic command should not automatically be interpreted as a Kubernetes failure.

---

# Exit Code 127

The course example shows a failed command followed by exit code `127`.

This is commonly associated with a command that could not be found.

Exit codes are useful runtime evidence.

Conceptually:

```text
Container Command Failure
       ↓
Exit Code
       ↓
Application / Runtime Investigation
```

---

# Pod Command Example

The course provides a Pod manifest using BusyBox and a shell command.

Conceptually:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
spec:
  containers:
    - name: myapp-container
      image: busybox
      command:
        - sh
        - -c
        - echo Hello Kubernetes! && sleep 3600
```

The example demonstrates explicit container command configuration.

---

# Main Process Lifetime

The Pod example keeps the container process alive using a sleep command.

This connects directly to the container lifecycle principle:

```text
Main Process Running
→ Container Running
```

```text
Main Process Exits
→ Container Exits
```

Kubernetes orchestration does not remove the underlying container-process lifecycle.

---

# Labels

The Pod example introduces metadata labels.

Conceptually:

```text
Pod
└── Label
    └── app=myapp
```

Labels provide metadata used to classify and later select Kubernetes resources.

Detailed label and selector behavior is studied later.

---

# Object YAML Inspection

The course demonstrates:

```bash
kubectl get pod POD_NAME -o yaml
```

to inspect the full API representation of a Pod.

This exposes significantly more data than the default summary output.

---

# Desired and Observed State

The full object representation helps reveal an important distinction:

```text
spec
→ Desired configuration
```

```text
status
→ Observed runtime state
```

This distinction is central to Kubernetes resource management.

---

# Server-Generated Object Data

A live Kubernetes object can contain fields that were not written in the original manifest.

Examples can include:

```text
creationTimestamp
resourceVersion
uid
nodeName
runtime annotations
status
```

These fields reflect API-server, controller, scheduler, or runtime-managed state.

They should not automatically be treated as reusable desired-state configuration.

---

# Exporting Object YAML

A live object can be written to a file.

Conceptually:

```bash
kubectl get pod POD_NAME -o yaml > pod.yaml
```

This can be useful for:

```text
Inspection
Troubleshooting
Learning Object Structure
Template Preparation
```

A live-object export should be reviewed before it is reused as a new manifest.

---

# Pod Troubleshooting Workflow

A useful initial workflow is:

```text
kubectl get pod
      ↓
Pod Status
      ↓
kubectl describe pod
      ↓
Conditions / Events
      ↓
kubectl logs
      ↓
Application Evidence
      ↓
kubectl exec
      ↓
Targeted Runtime Inspection
```

If Kubernetes-level evidence points downward, continue into:

```text
Worker Node
kubelet
Container Runtime
CNI
Linux Networking
Host Resources
```

---

# Infrastructure Relationship

Pod operation combines several previously studied infrastructure domains.

```text
Linux Namespace
→ Pod isolation

Container Runtime
→ Container execution

CNI
→ Pod networking

CSI / Volumes
→ Storage integration

Scheduler
→ Node placement

kubelet
→ Node-level workload management

Linux Process Lifecycle
→ Container lifecycle
```

---

# Evidence Policy

Course screenshots and sample runtime values are educational examples.

Do not record them as actual personal lab evidence.

Do not fabricate:

```text
Pod Names
Pod IP Addresses
Node Assignments
Container IDs
Image IDs
Events
Restart Counts
Exit Codes
Environment Values
Volume Mount Results
CNI Addresses
Application Logs
Command Output
```

Actual evidence must come from an authorized Kubernetes environment.

---

# Verification Checklist

- Pod and container were distinguished.
- The Pod was understood as the basic scheduling unit.
- Pod namespace scope was introduced.
- Pod IP addressing was introduced.
- Multi-container Pod networking was connected to a shared network namespace.
- The pause/sandbox container concept was reviewed.
- The historical `docker0` diagram was not generalized to all Kubernetes networking.
- Four Kubernetes communication categories were identified.
- CNI was connected to Pod networking.
- Pod volumes and container mounts were introduced.
- Ephemeral and persistent storage concepts were distinguished.
- PV and PVC were introduced.
- ConfigMap and Secret volume projection was distinguished from persistent storage.
- CSI was introduced.
- Pod object fields were reviewed.
- YAML manifest structure was reviewed.
- Manifest submission was distinguished from workload readiness.
- Pod conditions and startup events were connected to runtime observation.
- Pod description and application logs were distinguished.
- `kubectl exec` was connected to in-container process execution.
- Interactive execution options were reviewed.
- Minimal container images were distinguished from full Linux hosts.
- Exit codes were recognized as runtime evidence.
- Labels were introduced.
- `spec` and `status` were distinguished.
- Live-object YAML inspection was introduced.
- Server-generated fields were distinguished from reusable desired-state configuration.
- A layered Pod troubleshooting workflow was established.

## What I Learned

- Kubernetes schedules Pods while containers remain the underlying runtime processes.
- Pod conditions provide more detailed evidence than a single summary status.
- `kubectl exec` provides targeted runtime inspection inside a running container.
- Application containers may not contain general Linux diagnostic tools.
- Container exit codes provide useful troubleshooting evidence.
- `kubectl get -o yaml` exposes the full Kubernetes object representation.
- `spec` represents desired configuration while `status` represents observed state.
- Live-object YAML can contain server-generated fields that should be reviewed before reuse.
