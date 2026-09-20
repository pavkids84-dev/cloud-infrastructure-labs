# Kubernetes Pod Fundamentals Lab

## Objective

Understand the Pod as the basic Kubernetes scheduling unit, including shared networking, shared volumes, Pod IP addressing, CNI networking, basic storage concepts, YAML resource definitions, and Pod runtime observation.

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
Pod Creation
Pod Events
Pod Description
Pod Logs
Pod Conditions
kubectl exec
Interactive Container Shell
Container Tool Availability
BusyBox Pod Manifest
Live Object YAML Inspection
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

The important concept is the shared Pod sandbox/network namespace rather than the pause process as an application workload.

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

Detailed PV/PVC behavior is studied later in the storage section.

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

Their primary role is application configuration or sensitive data delivery.

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
→ Container Networking Interface model
```

```text
CSI
→ Container Storage Interface model
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

Later topics add metadata such as:

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

# YAML Lists

A block-style list can be written as:

```yaml
items:
  - value1
  - value2
```

A flow-style representation can be:

```yaml
items: [value1, value2]
```

---

# YAML Objects

Nested mappings represent structured objects.

Example:

```yaml
metadata:
  name: mypod
```

Conceptually:

```text
metadata
└── name
```

---

# YAML Multi-Line Text

The course introduces:

```text
|
→ Preserve line-oriented text
```

and:

```text
>
→ Fold line-oriented text
```

These forms can later be useful for configuration and embedded scripts.

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

# Event-Based Failure Localization

Different event stages can suggest different investigation areas.

```text
Scheduling Failure
→ Node / scheduler / capacity investigation
```

```text
Image Pull Failure
→ Registry / image / network / credentials investigation
```

```text
Container Start Failure
→ Runtime / command / configuration investigation
```

The event itself is evidence, not automatic proof of the final root cause.

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
Mounts
Conditions
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

# Pod Conditions and Startup Events

The course continues its `kubectl describe pod` example with a summary of Pod conditions.

```text
Initialized       True
Ready             True
ContainersReady   True
PodScheduled      True
```

These values belong to the course example, not to an observed Pod in my own cluster.

Conditions describe different aspects of the Pod state. Scheduling, container readiness, and application-level service behavior must not be treated as identical.

The example also shows the following startup events:

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

The events help locate where startup succeeded or stalled. A `Started` event alone does not establish that the application is serving requests correctly.

---

# Execute Commands Inside a Pod

The course introduces `kubectl exec` to execute a command inside a container belonging to a Pod.

```bash
kubectl exec POD_NAME -- COMMAND
```

The `--` separates kubectl options from the command to run inside the container.

If the Pod has multiple containers, select the target container:

```bash
kubectl exec POD_NAME -c CONTAINER_NAME -- COMMAND
```

Example commands using the Pod defined later in this lab:

```bash
kubectl exec myapp-pod -- pwd
kubectl exec myapp-pod -c myapp-container -- ls /
```

The Pod name, container name, and executables must exist in the actual practice environment. These commands are examples, not recorded execution output.

---

# Interactive Container Shell

The course uses `-i` to connect standard input and `-t` to allocate a terminal.

```bash
kubectl exec -it myapp-pod -- /bin/sh
```

Conceptually:

```text
Local Terminal
      ↓
kubectl exec -it
      ↓
Container Shell
      ↓
Inspect the Container Environment
```

The course's screenshot uses `/bin/bash` for its example image. A different container image might provide `/bin/sh` without Bash. Choose a shell that actually exists inside the image.

Example commands for an interactive session:

```bash
pwd
env
ls /
exit
```

These commands run inside the container, not in the worker node's ordinary host environment.

---

# Container Tools and Exit Status

The course's container session shows that `ps` and `ip` are unavailable:

```text
ps: command not found
ip: command not found
```

The displayed session ends with exit code `127` after an unavailable command. The screenshot is course evidence, not my own execution result.

A missing command inside a container does not, by itself, mean that the worker node or Pod network has failed.

The useful investigation sequence is:

```text
Command Not Found
      ↓
Check the Error and Executable Path
      ↓
Check Which Utilities Exist in the Image
      ↓
Use an Available Command or Authorized Debug Method
      ↓
Verify the Actual Infrastructure Question
```

This connects container-image contents to practical Kubernetes troubleshooting.

---

# BusyBox Pod Manifest

The course defines a single-container Pod using BusyBox. The following YAML preserves its fields and command with valid indentation:

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
      command: ['sh', '-c', 'echo Hello Kubernetes! && sleep 3600']
```

The `command` prints a greeting and then keeps the container running for a limited period. This is an example manifest; it does not demonstrate that a Pod was created in an actual cluster.

The corresponding practice workflow is:

```bash
kubectl create -f myapp-pod.yaml
kubectl get pod myapp-pod
kubectl describe pod myapp-pod
kubectl logs myapp-pod
```

Save the YAML as `myapp-pod.yaml` before using these commands. The Pod can exit after the sleep period; its state must be observed rather than assumed.

---

# Inspect a Live Object as YAML

The course retrieves a Pod object in YAML format:

```bash
kubectl get pod POD_NAME -o yaml
```

To save an existing Pod object to a file:

```bash
kubectl get pod myapp-pod -o yaml > myapp-pod-export.yaml
```

A live-object export can contain more information than the original manifest:

```text
apiVersion
kind
metadata
spec
status
```

The course screenshot also includes annotations, ownership information, scheduling settings, tolerations, and volume-related fields from its example cluster. Those sample names, addresses, timestamps, and IDs must not be reused as personal evidence.

---

# Exported Object vs Reusable Manifest

The course illustrates saving an existing Pod as YAML and creating a Pod from an edited file. A raw export is not automatically a clean manifest for a new resource.

Before reusing a live-object export, review:

```text
metadata.name
metadata.uid
metadata.resourceVersion
metadata.creationTimestamp
metadata.ownerReferences
spec fields assigned or injected by the cluster
status
```

Keep the desired configuration, remove server-generated metadata and observed state where appropriate, and review controller ownership before creating a new resource.

Do not delete an existing application Pod merely to test YAML export. The next lab studies this template-cleanup workflow in detail.

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
- Historical kubelet CNI options were treated as course-version context.
- Pod volumes and container mounts were introduced.
- Ephemeral and persistent storage concepts were distinguished.
- PV and PVC were introduced.
- ConfigMap and Secret volume projection was distinguished from persistent storage.
- CSI was introduced.
- Pod object fields were reviewed.
- YAML indentation and collection syntax were reviewed.
- Manifest submission was distinguished from workload readiness.
- Pod startup events were connected to lifecycle observation.
- Pod description and application logs were distinguished.
- A layered Pod troubleshooting workflow was established.
- Pod conditions and startup events were distinguished.
- `kubectl exec` and interactive container-shell access were introduced.
- Unavailable commands inside a container were distinguished from host or network failures.
- The course BusyBox manifest and live-object YAML export were reviewed.

## What I Learned

- Kubernetes schedules Pods rather than individual containers inside a Pod.
- Containers in the same Pod share the Pod networking environment.
- CNI provides the integration model for Pod networking.
- Kubernetes volumes can provide both ephemeral and persistent-storage-related behavior depending on the volume type.
- YAML manifests describe the desired configuration of Kubernetes objects.
- Creating a Pod object and having a healthy running workload are separate states.
- Events, descriptions, and logs provide different layers of troubleshooting evidence.
- `kubectl exec` runs commands in a selected container, not on the worker host.
- Live-object YAML must be reviewed before it is reused as a new manifest.


---

# Pod Runtime Operations

## Checking Pod Status

Pod runtime state can be observed using:

```bash
kubectl describe pod <pod-name>
```

Important sections include:

```text
Conditions
Events
Containers
Volumes
```

The main Pod conditions include:

```text
Initialized
Ready
ContainersReady
PodScheduled
```

These conditions describe different stages of Pod preparation and workload readiness.

---

## Pod Events

Events provide a timeline of Kubernetes actions.

Example lifecycle:

```text
Scheduled
    ↓
Pulled
    ↓
Created
    ↓
Started
```

Events are especially useful during troubleshooting because they show whether failures occurred during scheduling, image retrieval, container creation, or startup.

---

# Executing Commands Inside Containers

`kubectl exec` allows commands to be executed inside a running container.

Basic syntax:

```bash
kubectl exec <pod-name> -- <command>
```

Example:

```bash
kubectl exec nginx-pod -- hostname
```

---

## Interactive Container Shell

A shell session can be opened with:

```bash
kubectl exec -it <pod-name> -- /bin/bash
```

Options:

```text
-i
Interactive stdin

-t
Allocate terminal
```

The command enters the container environment, not the Kubernetes Node operating system.

---

## Container Tool Availability

Not every container image includes debugging tools.

Examples:

```text
bash
ip
ps
netstat
```

may not exist inside minimal images.

For troubleshooting, tools should be considered according to the container image design.

---

# Pod YAML Manifest

Kubernetes objects are represented as YAML manifests.

Example:

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

Main object fields:

```text
apiVersion
kind
metadata
spec
```

---

# Inspecting Live Object YAML

The current Kubernetes object state can be viewed with:

```bash
kubectl get pod <pod-name> -o yaml
```

The generated YAML may contain Kubernetes-managed fields:

```text
uid
resourceVersion
creationTimestamp
status
```

Therefore:

```text
Created Manifest
        !=
Current Object Representation
```

---

# Object Template Generation

Kubernetes resource templates can be created using existing resources or dry-run generation.

## Method 1: Export Existing Object

```bash
kubectl get pod <pod-name> -o yaml > template.yaml
```

The exported YAML can be reviewed and adapted.

---

## Method 2: Use dry-run

Example:

```bash
kubectl create deployment nginx \
--image=nginx \
--dry-run=client \
-o yaml
```

`--dry-run=client` generates the manifest without creating the resource.

This is useful when building reusable Kubernetes YAML templates.

