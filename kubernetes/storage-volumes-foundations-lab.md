# Kubernetes Storage and Volumes Foundations Lab

## Objective

Understand how Kubernetes makes data available to containers through volumes and how persistent storage is requested, provisioned, bound, mounted, and reclaimed.

Connect Pod volume behavior to Linux filesystems, container writable layers, network storage, cloud block storage, Kubernetes scheduling, and application configuration.

## Scope

```text
Container Writable Layer
Pod Volumes
volumeMounts
emptyDir
Memory-Backed emptyDir
hostPath
NFS
Cloud Block Storage
CSI
PersistentVolume (PV)
PersistentVolumeClaim (PVC)
Static Provisioning
Dynamic Provisioning
PV / PVC Binding
Volume Capacity
Volume Modes
Access Modes
StorageClass
VolumeBindingMode
Reclaim Policies
ConfigMap
Secret
ServiceAccount Token Projection
Storage Troubleshooting
Security and Evidence Policy
```

---

# Why Kubernetes Needs Volumes

A container typically has a writable filesystem layer above its image layers.

```text
Image Layers
     ↓
Container Writable Layer
     ↓
Application Files
```

Data stored only in this writable layer is not a reliable persistence mechanism when the container is removed and replaced.

Kubernetes controllers may replace Pods as part of reconciliation, updates, scheduling, and failure recovery.

Application availability and data persistence are therefore different requirements.

```text
Workload Controller
       ↓
Replace Pod
       ↓
New Container
       ↓
Old Writable Layer Is Not Reattached
```

A volume provides a defined storage source that is mounted into one or more containers.

Not every Kubernetes volume is persistent across Pod removal.

---

# Linux Mounts and Kubernetes volumeMounts

A Kubernetes container sees storage through a mount point, much like a Linux process accesses a filesystem through a mounted directory.

```text
Storage Source
      ↓
Pod Volume Definition
      ↓
Container volumeMount
      ↓
Filesystem Path
```

Two manifest locations must be distinguished:

```text
spec.volumes
→ Defines a Pod-level volume source

spec.containers[].volumeMounts
→ Selects a defined volume and a path for a specific container
```

Each container that needs access must mount the volume explicitly.

---

# emptyDir

An `emptyDir` is created for a Pod when that Pod is assigned to a node.

It is useful for temporary work areas, caches, and file sharing among containers in the same Pod.

```text
Pod
├── Writer Container ── /shared
├── Reader Container ── /data
└── emptyDir Volume
```

The two containers may use different `mountPath` values while sharing the same Pod volume.

The volume survives ordinary container restarts within the same Pod, but its data is removed when the Pod is removed from the node.

A memory-backed variant is possible:

```yaml
volumes:
  - name: temporary-cache
    emptyDir:
      medium: Memory
```

Memory-backed storage uses node memory and can contribute to memory pressure and container memory accounting.

---

# emptyDir Example

A sample Pod can write content from one container and read it from another:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: shared-volume-demo
spec:
  containers:
    - name: writer
      image: busybox:1.36
      command:
        - sh
        - -c
        - |
          while true; do
            date > /shared/index.html
            sleep 5
          done
      volumeMounts:
        - name: shared-data
          mountPath: /shared
    - name: web
      image: nginx:stable-alpine
      volumeMounts:
        - name: shared-data
          mountPath: /usr/share/nginx/html
  volumes:
    - name: shared-data
      emptyDir: {}
```

This is a reusable example, not evidence that the Pod has been deployed.

Possible inspection commands:

```bash
kubectl apply -f emptydir-demo.yaml
kubectl get pod shared-volume-demo
kubectl describe pod shared-volume-demo
kubectl exec shared-volume-demo -c web -- cat /usr/share/nginx/html/index.html
```

Remove the disposable Pod after inspection:

```bash
kubectl delete -f emptydir-demo.yaml
```

---

# hostPath

A `hostPath` volume gives a Pod access to a path on the worker node's filesystem.

```text
Worker Node A
├── /data/application
└── Pod
    └── Container /app/data
          ↓
        hostPath
```

The storage is tied to the selected node.

If a replacement Pod runs on Worker Node B, it does not automatically inherit files stored on Worker Node A.

Common system-level use cases include node log collection or controlled access to host resources.

`hostPath` should not be treated as general shared cluster storage.

Host filesystem access can expose sensitive files and sockets, so `hostPath` requires strict access and privilege review.

---

# NFS

Network File System provides a remotely shared filesystem.

The Linux NFS concept carries over to Kubernetes:

```text
NFS Server
    │
    ├── Worker Node A → Pod A
    │
    └── Worker Node B → Pod B
```

NFS can be used for workloads that need shared files across nodes, subject to server export permissions, network reachability, mount configuration, and storage reliability.

It introduces network and NFS-server failure dependencies.

Shared storage does not automatically provide high availability unless the underlying storage system is designed for it.

---

# Cloud Block Storage

Cloud platforms can provide persistent block devices to workloads.

A typical cloud block volume is not the same as a cluster-wide shared filesystem.

For example, an AWS EBS volume is subject to attachment, access-mode, and Availability Zone constraints.

The course shows the historical `awsElasticBlockStore` in-tree volume example.

Modern AWS Kubernetes storage commonly uses the EBS CSI driver and a `StorageClass` with a CSI provisioner such as `ebs.csi.aws.com`.

The legacy in-tree example should be retained as course context rather than copied unchanged into a modern deployment.

---

# PersistentVolume (PV)

A PersistentVolume represents storage capacity and properties made available to the Kubernetes cluster.

A PV is a cluster-scoped API object.

It is not identical to a physical disk; it describes Kubernetes-managed access to an underlying storage resource.

The course introduces:

```text
PersistentVolume
├── Capacity
├── Volume Mode
├── Access Modes
├── Storage Class
├── Reclaim Policy
└── Backing Storage
```

An administrator can create a PV directly, or a storage provisioner can create it dynamically.

---

# PersistentVolumeClaim (PVC)

A PersistentVolumeClaim represents a request for storage.

A PVC is namespaced, while a PV is cluster-scoped.

A claim typically describes:

```text
Requested Capacity
Access Modes
Volume Mode
StorageClass
Optional Selector
```

For example, requesting 5Gi does not imply that a new 5Gi disk always exists immediately.

The cluster must find or provision a compatible volume.

---

# PV and PVC Binding

The basic lifecycle is:

```text
Existing PV or Storage Provisioner
               │
               ▼
      PVC Requests Storage
               │
               ▼
    Match / Provision Volume
               │
               ▼
         PV ↔ PVC Bound
               │
               ▼
   Pod References PVC by Name
               │
               ▼
       kubelet Mounts Volume
               │
               ▼
    Container Accesses mountPath
```

A PV is typically bound to one PVC at a time.

Multiple Pods referencing the same claim may still be restricted by access modes and the storage backend.

---

# PV and PVC Namespaces

The following distinction is important:

```text
PersistentVolume
→ Cluster-scoped

PersistentVolumeClaim
→ Namespace-scoped

Pod
→ Namespace-scoped
```

A Pod refers to a PVC in its own namespace.

A claim with the same name in a different namespace is a different Kubernetes object.

---

# Access Modes

Kubernetes uses access modes to describe requested and supported volume attachment behavior.

```text
ReadWriteOnce (RWO)
→ Read-write mount by one node

ReadOnlyMany (ROX)
→ Read-only mount by multiple nodes

ReadWriteMany (RWX)
→ Read-write mount by multiple nodes

ReadWriteOncePod (RWOP)
→ Read-write mount restricted to one Pod, for supported CSI environments
```

RWO means one node, not necessarily one Pod.

Multiple Pods on the same node may be able to use an RWO volume, depending on the storage and workload.

Access modes do not substitute for filesystem permissions, application authorization, or security policy.

Not every storage backend supports every access mode.

---

# Volume Modes

The course distinguishes:

```text
Filesystem
→ A filesystem is mounted at a directory

Block
→ A raw block device is exposed to a container
```

`volumeMode: Filesystem` is suitable for ordinary file-based application storage.

`volumeMode: Block` is used when an application needs direct block-device access and the underlying storage supports it.

Raw block access differs from a conventional directory mount and requires appropriate container device mapping.

---

# PVC Example

This example requests persistent filesystem storage:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: app-data
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 5Gi
  storageClassName: example-storage-class
```

`example-storage-class` is a placeholder name. Replace it with an actual class present in the authorized cluster.

The claim can remain `Pending` if no matching PV or working provisioner is available.

Do not assume that applying this example creates storage successfully.

---

# Pod Using a PVC

A Pod accesses a claim through the Pod volume definition:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-with-volume
spec:
  containers:
    - name: app
      image: busybox:1.36
      command: ["sh", "-c", "sleep 3600"]
      volumeMounts:
        - name: data
          mountPath: /data
  volumes:
    - name: data
      persistentVolumeClaim:
        claimName: app-data
```

Here `data` is the Pod-local volume name and `app-data` is the PVC name.

The Pod and claim must be in the same namespace.

The container reads and writes at `/data`, but the durability and sharing behavior depend on the bound volume.

---

# Static Provisioning

With static provisioning, an administrator first makes suitable storage available and creates a matching PV object.

```text
Administrator
     ↓
Prepare Storage
     ↓
Create PV
     ↓
User Creates PVC
     ↓
Bind
```

The PDF shows an NFS-backed PV with `capacity`, `accessModes`, `storageClassName`, and `persistentVolumeReclaimPolicy`.

Before using such an example, the NFS export must exist and be reachable from the nodes.

A YAML object alone does not create the NFS server or its shared directory.

---

# Dynamic Provisioning

With dynamic provisioning, a storage provisioner creates a backing volume when a compatible PVC requests storage.

```text
Developer Creates PVC
        ↓
StorageClass Selection
        ↓
Provisioner / CSI Driver
        ↓
Backing Storage Created
        ↓
PersistentVolume Created
        ↓
PV / PVC Bound
```

This reduces the need to pre-create a PV for each application claim.

Dynamic provisioning depends on an installed and functioning storage provisioner and supported storage infrastructure.

---

# StorageClass

A StorageClass describes a storage-provisioning category, including which provisioner to use and applicable storage parameters.

```text
StorageClass
├── Provisioner
├── Parameters
├── Reclaim Policy
└── Volume Binding Mode
```

Different classes can represent different storage performance, cost, topology, or lifecycle characteristics.

The course shows historical built-in provisioners such as `kubernetes.io/aws-ebs` and `kubernetes.io/gce-pd`.

Modern deployments commonly rely on CSI drivers with driver-specific provisioner names.

A StorageClass does not itself guarantee that a compatible CSI controller is installed or healthy.

---

# StorageClass and Scheduling

`volumeBindingMode` changes when a volume is bound or provisioned.

```text
Immediate
→ Provision or bind when PVC is created

WaitForFirstConsumer
→ Delay the decision until a consuming Pod participates in scheduling
```

`WaitForFirstConsumer` is useful when storage is constrained by topology, such as a cloud Availability Zone.

Conceptually:

```text
Pod Scheduling Requirements
             +
          PVC Request
             ↓
    Select Compatible Topology
             ↓
     Provision / Bind Storage
             ↓
        Pod Scheduling
```

Scheduling constraints and storage placement must be compatible.

---

# Storage Reclaim Policy

A PV reclaim policy controls what happens to storage after its claim is released.

```text
Retain
→ Keep underlying storage for manual handling

Delete
→ Delete underlying storage when supported by its provisioner

Recycle
→ Historical and deprecated behavior
```

`Retain` does not automatically make the released PV reusable: data protection and manual reclamation are still required.

`Delete` can remove real storage and data. It must be reviewed before deleting claims.

A dynamically provisioned PV normally inherits the StorageClass reclaim policy; if unset, the default is typically `Delete`.

The `Recycle` policy shown in the course should not be recommended for new production design.

---

# Storage Lifecycle Is Not Backup

A persistent volume can survive Pod replacement without providing a backup.

```text
Persistent Storage
        !=
Backup
        !=
Disaster Recovery
```

Production storage design should separately consider snapshots, backups, retention, restore tests, encryption, access control, and storage costs.

A `Retain` reclaim policy alone is not a recovery plan.

---

# ConfigMap

A ConfigMap stores non-sensitive configuration data separately from the container image.

The course calls this decoupling:

```text
Container Image
     +
ConfigMap Values
     ↓
Application Runtime Configuration
```

Applications may receive ConfigMap values as environment variables or files mounted through a volume.

Useful sources for creating a ConfigMap include literals, individual files, and directories.

---

# Creating ConfigMaps

The course demonstrates literal values:

```bash
kubectl create configmap dev-map --from-literal=A=10 --from-literal=B=20
```

Other forms include:

```bash
kubectl create configmap file-map --from-file=./app.properties
kubectl create configmap directory-map --from-file=./config/
```

These commands create actual Kubernetes objects when executed against a configured, authorized cluster.

They are educational examples, not recorded execution evidence.

---

# ConfigMap as Environment Variables

A container can consume all keys with `envFrom`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: config-env-demo
spec:
  containers:
    - name: app
      image: busybox:1.36
      command: ["sh", "-c", "env | grep '^APP_' && sleep 3600"]
      envFrom:
        - prefix: APP_
          configMapRef:
            name: dev-map
```

Given the earlier sample ConfigMap, the intended variables would be named `APP_A` and `APP_B`.

This is an intended mapping, not observed command output.

A single key can alternatively be referenced with `valueFrom.configMapKeyRef`.

---

# ConfigMap as Volume Files

The same configuration can be projected into a container directory:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: config-file-demo
spec:
  containers:
    - name: app
      image: busybox:1.36
      command: ["sh", "-c", "sleep 3600"]
      volumeMounts:
        - name: settings
          mountPath: /etc/app-config
          readOnly: true
  volumes:
    - name: settings
      configMap:
        name: dev-map
```

Conceptually:

```text
ConfigMap Keys
      ↓
Projected Files
      ↓
/etc/app-config/A
/etc/app-config/B
```

---

# ConfigMap Update Behavior

The PDF introduces configuration updates without restarting an application.

This requires a distinction:

```text
ConfigMap as Environment Variables
→ Running process variables do not update automatically
→ Pod replacement is required to receive new values

ConfigMap as Mounted Files
→ Files can update eventually
→ Application must notice or reload the changed configuration
```

Updates to a ConfigMap mounted via `subPath` do not propagate automatically.

Therefore, an update to the ConfigMap object is not proof that the running application has adopted the new settings.

---

# Secret

A Secret is a Kubernetes object intended for sensitive data such as passwords, certificates, and tokens.

```text
Secret
├── Database Credentials
├── TLS Certificate Material
├── API Tokens
└── Other Sensitive Configuration
```

Secrets can be consumed by Pods as environment variables or files, depending on the application design.

The PDF introduces Base64-encoded values.

Base64 encoding is not encryption and does not itself make the value confidential.

---

# Secret Example

For learning purposes, a Secret can be defined using `stringData`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: demo-secret
type: Opaque
stringData:
  username: example-user
  password: example-only-do-not-reuse
```

These literal strings are intentionally non-production placeholders.

Never commit real passwords, tokens, private keys, or production endpoints to the repository.

The API server converts `stringData` into the Secret's stored data representation.

A running application can reference a specific key using `secretKeyRef` or mount the Secret as files.

---

# Secret as a Mounted Volume

A Secret can be projected as files:

```yaml
volumes:
  - name: credentials
    secret:
      secretName: demo-secret
```

And mounted into the intended container:

```yaml
volumeMounts:
  - name: credentials
    mountPath: /run/app-credentials
    readOnly: true
```

A mounted Secret is not automatically secure merely because it is a volume.

Pod permissions, API access, application behavior, host compromise, audit logging, and secret lifecycle all matter.

---

# Secrets and Kubernetes Security

Secrets can be stored in etcd and are not automatically protected by Base64 encoding.

Production security should consider:

```text
Encryption at Rest
RBAC Least Privilege
Namespace Isolation
Secret Rotation
External Secret Management
No Sensitive Git Commits
No Secret Values in Logs
```

Avoid treating a Kubernetes Secret object as equivalent to a dedicated secrets-management system.

---

# ServiceAccount Token Historical Context

The PDF says that every Pod is automatically connected to a Secret volume.

That describes older ServiceAccount token behavior and should not be generalized to current clusters.

Modern Kubernetes typically makes a short-lived ServiceAccount token available through projected volumes and the TokenRequest mechanism, subject to Pod and ServiceAccount configuration.

```text
Pod ServiceAccount
        ↓
Projected Token
        ↓
Authorized API Requests
```

A ServiceAccount token is an API credential. It should be protected and not published as lab evidence.

---

# PVC Troubleshooting Workflow

A PVC in `Pending` state is not automatically a storage-capacity problem.

Investigate:

```text
PVC Pending
    ↓
PVC Events
    ↓
Requested StorageClass Exists?
    ↓
Compatible PV or CSI Provisioner?
    ↓
Capacity / Access Mode Compatible?
    ↓
Binding Mode and Pod Scheduling?
    ↓
Storage Backend / IAM / Topology?
    ↓
Provisioning or Binding Error?
```

Useful commands:

```bash
kubectl get pvc -A
kubectl get pv
kubectl get storageclass
kubectl describe pvc PVC_NAME -n NAMESPACE
kubectl get events -n NAMESPACE --sort-by=.metadata.creationTimestamp
```

Interpret actual Events rather than assuming the missing component.

---

# Pod Volume Mount Troubleshooting

A PVC can be `Bound` while a Pod still cannot start.

```text
PVC Bound?
    ↓
Pod Scheduled?
    ↓
Volume Attach Successful?
    ↓
Volume Mount Successful?
    ↓
Filesystem Permissions Correct?
    ↓
Application Uses Intended Path?
```

Useful commands:

```bash
kubectl get pod POD_NAME -n NAMESPACE -o wide
kubectl describe pod POD_NAME -n NAMESPACE
kubectl describe pvc PVC_NAME -n NAMESPACE
kubectl get events -n NAMESPACE --sort-by=.metadata.creationTimestamp
```

A failure can occur in the scheduler, CSI controller, CSI node plugin, kubelet, network, mount operation, or application process.

---

# Volume Data Verification

Do not treat a Pod in `Running` state as proof of durable storage.

A real persistence test should be designed around the workload's data requirements:

```text
Write Test Data
      ↓
Verify Data in Mounted Path
      ↓
Replace Pod Safely
      ↓
Verify Pod Uses Same Claim
      ↓
Read Test Data Again
      ↓
Record Actual Evidence
```

Deletion and replacement procedures depend on the workload controller, reclaim policy, data sensitivity, and storage backend.

Never test data retention by deleting valuable production storage.

---

# Security and Operational Perspective

The storage path crosses multiple responsibility boundaries:

```text
Application
    ↓
Container Mount
    ↓
Pod / PVC
    ↓
PV / StorageClass
    ↓
CSI or Storage Integration
    ↓
Node / Network / Cloud Storage
```

Review the relevant layer before changing access permissions or storage configuration.

Critical concerns include:

```text
Filesystem Permissions
Storage Backend Access
Sensitive Data Exposure
Volume Deletion Policy
Encryption
Backup and Restore
Multi-Node Access Constraints
Cloud Storage Cost
```

Storage should be selected to match application behavior rather than by capacity alone.

---

# Historical Course Material

The training slides include older API and platform assumptions.

Preserve the concepts while avoiding unsafe or obsolete defaults:

```text
awsElasticBlockStore in-tree example
→ Use an appropriate CSI driver in modern clusters

kubernetes.io/aws-ebs StorageClass provisioner
→ Historical built-in plugin context

Recycle reclaim policy
→ Deprecated; do not adopt as a modern default

Every Pod automatically mounts a ServiceAccount token Secret
→ Historical description; modern token projection differs

ConfigMap update without restart
→ Depends on whether consumed as a volume or environment variable

Base64 in Secret.data
→ Encoding, not encryption
```

---

# Evidence Policy

Do not fabricate or publish:

```text
Real StorageClass Names
PV and PVC Resource Identifiers
Cloud Volume IDs
NFS Server Addresses
Node Names
Namespace Names from Actual Labs
Sensitive Mount Paths
Real Secret Values
ServiceAccount Tokens
API Credentials
Pod Events
Provisioning Results
Mount Results
Command Output
Data Persistence Test Results
Billing Values
```

Course screenshots, example manifests, and explanatory diagrams are not evidence of a completed deployment.

Actual verification requires an authorized Kubernetes environment and observed results.

---

# Verification Checklist

- Container writable-layer data was distinguished from volume-backed data.
- `volumes` and `volumeMounts` were distinguished.
- `emptyDir` was understood as Pod-lifetime storage.
- `medium: Memory` was connected to memory-backed temporary storage.
- `hostPath` was recognized as node-specific and security-sensitive.
- NFS was understood as network filesystem storage.
- Cloud block storage was distinguished from shared filesystems.
- PV was understood as a cluster-scoped storage resource.
- PVC was understood as a namespaced storage request.
- PV/PVC binding and Pod claim reference were connected.
- Access modes RWO, ROX, RWX, and RWOP were distinguished.
- RWO was not incorrectly interpreted as one-Pod-only access.
- Filesystem and raw Block volume modes were distinguished.
- Static and dynamic provisioning were distinguished.
- StorageClass was connected to the provisioner and binding mode.
- `WaitForFirstConsumer` was connected to scheduling and topology.
- `Retain`, `Delete`, and deprecated `Recycle` were distinguished.
- Volume persistence was separated from backup and disaster recovery.
- ConfigMap environment-variable and mounted-file usage were understood.
- ConfigMap update behavior was distinguished by consumption method.
- Secret Base64 encoding was not mistaken for encryption.
- ServiceAccount token projection was distinguished from historical Secret mounts.
- PVC Pending and Pod mount failures were connected to evidence-based troubleshooting.
- No example commands or resources were treated as executed lab results.

## What I Learned

- Kubernetes separates application processes from underlying storage implementation through volumes and claim-based storage interfaces.
- PV represents available persistent storage, PVC requests it, and StorageClass can automate its provisioning.
- Storage attachment and data persistence depend on the backend, access mode, topology, and lifecycle policy.
- PVC `Bound` state and Pod `Running` state do not independently prove that an application can safely persist or recover its data.
- `emptyDir`, `hostPath`, NFS, and cloud block storage have different sharing, portability, and failure characteristics.
- ConfigMaps and Secrets separate runtime configuration from container images, but they differ in sensitivity and required handling.
- Kubernetes Secret objects still need encryption, access-control, rotation, and operational safeguards.
- Persistent storage must be verified with observed data, not inferred from successful API operations alone.
