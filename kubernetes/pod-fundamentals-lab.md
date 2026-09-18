# Kubernetes Pod Fundamentals Lab

## Objective

Understand the Pod as the basic Kubernetes scheduling unit and learn how to define, observe, inspect, enter, and troubleshoot Pod workloads.

This lab connects Pod networking, storage, YAML definitions, runtime state, Kubernetes events, container command execution, and live API object inspection.

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
labels
spec
containers
command
Pod Creation
Pod Conditions
Pod Events
Pod Description
Pod Logs
kubectl exec
Container Runtime Inspection
Environment Inspection
Live Object YAML
kubectl get -o yaml
Manifest Reuse
Pod Troubleshooting
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

Kubernetes schedules the Pod rather than independently scheduling each container inside the same Pod.

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

Containers inside the same Pod follow the same Pod placement.

---

# Namespace Scope

Pods are namespaced Kubernetes resources.

Conceptually:

```text
Namespace
└── Pod
```

Namespace behavior and resource isolation are studied in more detail later in the Kubernetes learning path.

---

# Pod IP

A Pod receives a network identity.

Conceptually:

```text
Pod
└── Pod IP
```

Containers inside the same Pod participate in the shared Pod networking environment.

---

# Shared Network Namespace

Containers in the same Pod share the Pod networking environment.

```text
Pod Network Namespace
├── Container A
└── Container B
```

This allows cooperating containers to communicate through the same network namespace.

---

# Container-to-Container Communication

Containers in the same Pod can communicate through the shared network environment.

Conceptually:

```text
Container A
    ↕
localhost
    ↕
Container B
```

This is different from communication between separate Pods.

---

# Pause / Sandbox Container

The course introduces the pause container as infrastructure associated with the Pod namespace.

Conceptually:

```text
Pod Sandbox
    ↓
Network Namespace
   ┌───────┴───────┐
Container A    Container B
```

The important concept is the shared Pod sandbox and namespace rather than treating the pause process as an application workload.

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

---

# External-to-Service

```text
External Client
      ↓
Kubernetes Service Layer
      ↓
Application Pods
```

Detailed external exposure methods are studied later with Services and Ingress.

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

This connects Kubernetes directly to Linux and networking fundamentals.

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

Kubernetes networking remains dependent on Linux networking underneath the API abstraction.

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

Detailed PV/PVC behavior is studied later.

---

# ConfigMap and Secret Volume Sources

ConfigMaps and Secrets can be exposed to Pod containers through volume mounts.

Conceptually:

```text
Configuration / Secret
       ↓
Volume Projection
       ↓
Container Files
```

They should not be confused with persistent block or filesystem storage.

---

# Volume Types

The course lists multiple volume backends and sources, including:

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

Both support extensible infrastructure integration around Kubernetes workloads.

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

---

# `kind`

`kind` identifies the Kubernetes resource type.

Example:

```yaml
kind: Pod
```

---

# `metadata`

`metadata` identifies and describes the Kubernetes object.

Example:

```yaml
metadata:
  name: mypod
```

Metadata can also contain information such as:

```text
Labels
Annotations
Namespace
Ownership
```

---

# Labels

The course introduces labels in a Pod manifest.

Example:

```yaml
metadata:
  labels:
    app: myapp
```

Labels provide key/value metadata associated with Kubernetes objects.

Detailed label and selector behavior is studied later.

---

# `spec`

`spec` describes the desired resource configuration.

For a Pod:

```yaml
spec:
  containers:
```

defines the container workload Kubernetes should maintain.

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

# Pod Command

The course demonstrates defining a container command in the Pod manifest.

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

This overrides the runtime command used by the container for this Pod definition.

---

# Container Main Process

The command executed by a container is directly related to the container lifecycle.

Conceptually:

```text
Main Process Running
→ Container Running
```

```text
Main Process Exits
→ Container State Changes
```

The course uses `sleep` to keep the example workload running after producing output.

---

# YAML

Kubernetes manifests commonly use YAML.

Important concepts include:

```text
Mappings
Lists
Indentation
Comments
Multi-Line Text
Nested Objects
```

YAML indentation represents data structure and should be treated as syntax rather than visual formatting.

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

Detailed Pod inspection can expose conditions such as:

```text
Initialized
Ready
ContainersReady
PodScheduled
```

A Pod phase and individual conditions should not be treated as identical concepts.

For example:

```text
Running
```

does not by itself describe every readiness condition of the workload.

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
Mounts
Conditions
Events
```

This provides more operational context than a summary listing.

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

`kubectl exec` runs an additional command inside a container belonging to a running Pod.

Conceptually:

```text
Running Pod
    ↓
Selected Container
    ↓
Additional Process
```

It does not create another Pod or another container.

---

# `kubectl exec` Command Boundary

The command structure can be represented as:

```text
kubectl exec [kubectl options] POD -- COMMAND [arguments]
```

The `--` separator distinguishes kubectl arguments from the command that should execute inside the container.

---

# Interactive Container Access

Interactive execution can use:

```text
-i
→ Standard input
```

```text
-t
→ Terminal allocation
```

A common structure is:

```bash
kubectl exec -it POD_NAME -- /bin/bash
```

Actual shell availability depends on the container image.

---

# Multi-Container Pod Execution

If a Pod contains multiple containers, the target container can be selected.

Concept
