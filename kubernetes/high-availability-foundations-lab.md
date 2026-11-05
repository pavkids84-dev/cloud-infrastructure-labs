# Kubernetes High Availability Foundations Lab

## Objective

Understand how Kubernetes availability depends on both running applications and the control plane, and how redundancy, failure detection, reconciliation, leader election, etcd quorum, and API server load balancing work together in a highly available cluster.

Compare stacked etcd and external etcd topologies from the course, and connect high availability to scheduling, storage, networking, operational verification, and recovery.

## Scope

```text
High Availability (HA)
Single Point of Failure (SPOF)
Workload Availability
Deployment and ReplicaSet
Desired and Observed State
Node Failure
Pod Replacement
Replica Distribution
Readiness and Liveness
PodDisruptionBudget
Control Plane Availability
kube-apiserver
kube-controller-manager
kube-scheduler
etcd
Raft and Quorum
Leader Election
Lease Objects
API Server Load Balancing
Stacked etcd Topology
External etcd Topology
Failure Domains
Stateful Application Considerations
Availability vs Recovery
HA Troubleshooting
Verification and Evidence Policy
```

---

# Why High Availability Matters

High availability reduces the effect of individual component failures on a service.

A single workload instance can become a single point of failure:

```text
Client
  ↓
Application Instance
  ↓
Backend
```

If the application instance fails, the service becomes unavailable unless another healthy instance can accept traffic.

A redundant topology can reduce this risk:

```text
Client
  ↓
Load Balancer
  ↓
Healthy Application Instances
```

However, adding application replicas does not automatically protect a load balancer, database, network path, storage backend, or control plane.

Availability must be examined across the full dependency path.

---

# Availability, Fault Tolerance, and Disaster Recovery

These terms describe related but different capabilities.

```text
High Availability
→ Minimize service disruption during component failures

Fault Tolerance
→ Continue service despite specified failures

Disaster Recovery
→ Restore service and data after larger failures
```

A highly available design does not imply zero downtime or unlimited fault tolerance.

Failure detection, leader election, Pod scheduling, startup, readiness, and traffic re-routing can each add recovery time.

---

# Application Availability with Replicas

The course introduces application HA through a Deployment controller and multiple replicas.

A Deployment expresses desired Pod replica count:

```text
Deployment
     ↓
ReplicaSet
     ↓
Pod A / Pod B / Pod C
```

For example:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-ha
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-ha
  template:
    metadata:
      labels:
        app: web-ha
    spec:
      containers:
        - name: web
          image: nginx:stable
          ports:
            - containerPort: 80
```

This is an illustrative manifest, not evidence of a deployment executed in a real cluster.

---

# Desired State and Replacement

The Deployment and ReplicaSet controllers reconcile desired and observed replica state.

```text
Desired Pods: 3
      ↓
Observed Pods: 2
      ↓
ReplicaSet Reconciliation
      ↓
Replacement Pod Requested
      ↓
Scheduler / kubelet / Runtime
      ↓
Healthy Replacement Pod
```

The replacement process is not instantaneous.

The cluster must detect the failure, satisfy scheduling constraints, start the workload, and determine readiness.

A running Pod is not necessarily an application-ready Pod.

---

# Container Failure vs Node Failure

A container crash and a worker-node failure have different recovery paths.

```text
Container Failure
      ↓
kubelet Restarts Container When Policy Allows
      ↓
Application Readiness Is Rechecked
```

```text
Worker Node Failure
      ↓
Node Health Becomes Unavailable
      ↓
Controllers and Node Lifecycle Logic React
      ↓
Replacement Pods May Be Created
      ↓
Healthy Nodes Must Have Capacity
```

Failure detection and eviction timing depend on configuration and failure conditions.

Replacement Pods are not guaranteed to become available if scheduling capacity, container images, networking, storage, or permissions are unavailable.

---

# Replicas Must Be Distributed

Multiple replicas on one worker node still depend on that node.

```text
Worker Node A
├── Pod A
├── Pod B
└── Pod C

Worker Node B
└── No Application Pod
```

If Worker Node A fails, all three replicas are affected.

A better failure-domain distribution can be:

```text
Worker Node A   Worker Node B   Worker Node C
    Pod A           Pod B           Pod C
      \               |               /
       +--------------+--------------+
                      ↓
                  Service
```

Workload placement can use:

```text
Pod Anti-Affinity
Topology Spread Constraints
Node Labels
Availability Zones
```

These constraints must be evaluated against the actual available nodes and failure domains.

---

# Topology Spread Example

An illustrative Deployment can request distribution across node hostnames:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: spread-demo
spec:
  replicas: 3
  selector:
    matchLabels:
      app: spread-demo
  template:
    metadata:
      labels:
        app: spread-demo
    spec:
      topologySpreadConstraints:
        - maxSkew: 1
          topologyKey: kubernetes.io/hostname
          whenUnsatisfiable: DoNotSchedule
          labelSelector:
            matchLabels:
              app: spread-demo
      containers:
        - name: web
          image: nginx:stable
```

The exact placement result depends on node availability, scheduling constraints, and cluster configuration.

With insufficient eligible nodes, strict constraints may leave some Pods Pending.

This example illustrates scheduling intent; it does not guarantee that every failure is tolerated.

---

# Readiness and Traffic Availability

A replacement Pod may exist before its application can safely handle requests.

```text
Pod Scheduled
     ↓
Container Starts
     ↓
Application Initializes
     ↓
Readiness Check Succeeds
     ↓
Service Routes Traffic to Ready Backend
```

An example readiness check for an HTTP server is:

```yaml
readinessProbe:
  httpGet:
    path: /
    port: 80
  initialDelaySeconds: 2
  periodSeconds: 5
```

Readiness determines whether the Pod should normally receive Service traffic.

Liveness checks serve a different purpose: they can trigger container restarts after a configured health failure.

An incorrectly designed probe can reduce availability rather than improve it.

---

# PodDisruptionBudget

A PodDisruptionBudget (PDB) can restrict voluntary evictions during operations such as node maintenance.

For three replicas, a possible example is:

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: web-ha-pdb
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: web-ha
```

Conceptually:

```text
Voluntary Eviction Requested
      ↓
Check PDB
      ↓
Allow Only If Budget Is Respected
```

A PDB does not prevent hardware failures or guarantee a minimum number of live Pods in every outage.

It is not a substitute for redundant Nodes, readiness checks, or valid recovery capacity.

---

# Stateful Applications and Leader Selection

The course mentions applications that cannot freely scale multiple writable instances.

A possible architecture has one write leader and additional read-oriented replicas:

```text
Application Instances
       │
       ├── Leader   → Writes
       ├── Follower → Reads
       └── Follower → Reads
```

A coordinator or sidecar can participate in coordination in some application-specific designs, as the course suggests.

This is not a generic Kubernetes feature that automatically makes any database highly available.

Correct leader election, data replication, split-brain prevention, consistency, and failover behavior depend on the application's architecture.

---

# Workload HA and Control Plane HA Are Different

A Kubernetes cluster has two important availability domains:

```text
Workload Availability
→ Application Pods and their dependencies can serve clients
```

```text
Control Plane Availability
→ Kubernetes can accept API requests and reconcile cluster state
```

A worker-node failure can remove application replicas.

A control-plane failure can stop scheduling, new API operations, and reconciliation while existing workloads on healthy worker nodes may continue to run.

A control-plane outage is therefore not necessarily an immediate shutdown of every container.

However, continued workload operation depends on existing runtime state and other components, and recovery capabilities are degraded.

---

# Kubernetes Control Plane Components

The course identifies the following components as relevant to HA:

```text
kube-apiserver
kube-controller-manager
kube-scheduler
etcd
```

Their roles are different:

```text
kube-apiserver
→ API request entry point

kube-controller-manager
→ Reconcile cluster state

kube-scheduler
→ Assign eligible Nodes to newly scheduled Pods

etcd
→ Persistent cluster state store
```

Duplicating the same server without addressing its dependent services and endpoint access does not provide complete control-plane availability.

---

# Kubernetes API and etcd

Kubernetes API objects are stored using etcd, a distributed key-value store.

Conceptually:

```text
kubectl / Controllers
         ↓
     API Server
         ↓
        etcd
         ↓
    Cluster State
```

This is a simplified representation. Authentication, authorization, admission, and validation also participate in API operations.

etcd can store information related to:

```text
Pods
Deployments
Services
ConfigMaps
Secrets
Nodes
Other Kubernetes API Objects
```

Because etcd stores cluster state, its availability and consistency are central to control-plane health.

---

# etcd Is a Distributed System

etcd supports a distributed cluster of members.

The members maintain a consistent view of their shared data through a consensus protocol based on Raft.

```text
          etcd Cluster
              │
      +-------+-------+
      |       |       |
      v       v       v
    etcd-1  etcd-2  etcd-3
```

A cluster of three members is not simply three independent databases that can each accept conflicting changes.

The members cooperate to agree on committed state updates.

---

# Quorum and Majority

Quorum is the minimum number of participating voting members required to make progress in a majority-based consensus system.

For an etcd cluster with N voting members:

```text
Quorum = floor(N / 2) + 1
```

| Members | Quorum | Failures Tolerated |
|---|---|---|
| 1 | 1 | 0 |
| 2 | 2 | 0 |
| 3 | 2 | 1 |
| 4 | 3 | 1 |
| 5 | 3 | 2 |

For three members:

```text
etcd-1 Healthy
etcd-2 Healthy
etcd-3 Failed
      ↓
2 Members Available
      ↓
Quorum Remains
```

If two out of three members become unavailable, normal consensus progress cannot continue.

Adding members does not always increase failure tolerance; odd-sized clusters are commonly preferred.

---

# Why Three Control Plane Nodes

The course illustrates a three-control-plane architecture.

Three control-plane nodes can support an HA stacked-etcd design in which one node fails but a two-member etcd quorum remains.

```text
Control Plane A   Control Plane B   Control Plane C
    etcd A           etcd B           etcd C
       \               |               /
        +--------------+--------------+
                    Quorum
```

Three nodes are not a universal guarantee of uninterrupted service.

The hosts should ideally be separated across appropriate failure domains, with a healthy load-balancer endpoint and operational network paths.

---

# API Server Availability

Multiple API server instances can be reached through a stable endpoint.

```text
kubectl / kubelets / Controllers
              ↓
       Stable API Endpoint
              ↓
          Load Balancer
              ↓
    +---------+---------+
    |         |         |
  API A     API B     API C
```

API servers can handle requests concurrently; they do not require a single elected API-server leader.

The load balancer should direct connections to healthy API servers.

If the load balancer itself is a single point of failure, multiplying API servers does not eliminate all control-plane entry-point risk.

Production designs must consider load-balancer redundancy, network reachability, TLS certificates, and the stable API endpoint used by kubelets and administrators.

---

# Controller Manager and Scheduler Leader Election

The course lists multiple controller-manager and scheduler instances across control-plane nodes.

These instances must avoid issuing conflicting active control decisions.

Kubernetes commonly uses Lease-based leader election so that one instance actively performs the relevant work while healthy peers can take over.

```text
Scheduler A       Scheduler B       Scheduler C
    Leader           Standby           Standby
       │
       └── Renews Lease
```

If the leader becomes unavailable, other instances can compete to become the new leader.

This differs from the API server's load-balanced model.

The precise implementation can evolve across Kubernetes releases; the reusable concept is coordinated control-plane leadership.

---

# Stacked etcd Topology

The course diagram on p.154 shows stacked etcd.

In this topology, each control-plane node runs both control-plane services and a local etcd member.

```text
               API Load Balancer
                      │
       +--------------+--------------+
       |              |              |
       v              v              v
  Control Plane A  Control Plane B  Control Plane C
  +-------------+  +-------------+  +-------------+
  | API Server  |  | API Server  |  | API Server  |
  | Controller  |  | Controller  |  | Controller  |
  | Scheduler   |  | Scheduler   |  | Scheduler   |
  | etcd A      |  | etcd B      |  | etcd C      |
  +-------------+  +-------------+  +-------------+
       |              |              |
       +--------------+--------------+
                 etcd Cluster
```

The Kubernetes kubeadm HA topology guide identifies this as the default kubeadm HA topology.

Advantages:

```text
Fewer Dedicated Hosts
Simpler Initial Topology
Control Plane and etcd Managed Together
```

Tradeoff:

```text
Control Plane Host Failure
       ↓
Control Plane Instance Lost
       +
etcd Member Lost
```

A failure of one host affects both layers at the same time.

---

# Stacked etcd Failure Scenario

Assume three healthy stacked nodes and an available API load balancer.

```text
Control Plane A  → Failed
Control Plane B  → Healthy
Control Plane C  → Healthy
```

Potential effects:

```text
API Server A Unavailable
Controller / Scheduler Instance A Unavailable
etcd Member A Unavailable
```

The remaining two etcd members can preserve quorum, and remaining control-plane instances can continue to provide service if networking and resources remain healthy.

The design tolerates the specified failure, but failover may still create short disruption.

---

# External etcd Topology

The course diagram on p.155 shows external etcd.

The control-plane hosts and etcd hosts are separated.

```text
               API Load Balancer
                      │
       +--------------+--------------+
       |              |              |
       v              v              v
  Control Plane A  Control Plane B  Control Plane C
  +-------------+  +-------------+  +-------------+
  | API Server  |  | API Server  |  | API Server  |
  | Controller  |  | Controller  |  | Controller  |
  | Scheduler   |  | Scheduler   |  | Scheduler   |
  +-------------+  +-------------+  +-------------+
       |              |              |
       +--------------+--------------+
                      │
             External etcd Cluster
       +--------------+--------------+
       |              |              |
     etcd A         etcd B         etcd C
     (Host A)       (Host B)       (Host C)
```

Advantages:

```text
Separated Failure Domains for Control Plane and etcd
Independent Resource and Operational Management
```

Tradeoffs:

```text
More Hosts
More Network Paths
More Operational Complexity
```

The official kubeadm guide presents a typical minimum of three control-plane hosts and three additional etcd hosts for this topology.

---

# Stacked vs External etcd

| Area | Stacked etcd | External etcd |
|---|---|---|
| etcd Location | On control-plane nodes | On separate etcd nodes |
| Example Control Plane Hosts | 3 | 3 |
| Example Additional etcd Hosts | 0 | 3 |
| Failure Coupling | Control plane and etcd share a host | Independent host groups |
| Operational Complexity | Lower | Higher |
| HA Dependency | Control plane plus etcd quorum | Control plane plus external etcd quorum |

Neither topology eliminates the need for healthy networking, backups, monitoring, or a redundant API endpoint.

---

# Architecture Selection Is a Tradeoff

Selecting a topology depends on more than node count.

Evaluate:

```text
Failure Domains
Hardware and VM Capacity
Operational Staffing
Storage and Disk Performance
Network Latency
Security Boundaries
Recovery and Backup Strategy
Load Balancer Reliability
```

An external etcd topology is not automatically more appropriate for every cluster.

A stacked topology can be a reasonable HA design when correctly provisioned and operated.

---

# Failure Domains and Availability Zones

Redundancy only helps when replicas do not all share the same failure domain.

Examples of shared failure domains include:

```text
Physical Server
Rack
Power Domain
Network Switch
Availability Zone
Underlying Storage Service
```

Three VMs on one physical host may still be vulnerable to a single host failure.

Similarly, three control-plane nodes behind one nonredundant network path may still share a network single point of failure.

Topology planning should distinguish logical replicas from independent infrastructure failure domains.

---

# Load Balancer Is Part of HA

A stable API endpoint is essential for control-plane clients.

```text
kubectl / kubelet
        ↓
API Endpoint DNS or VIP
        ↓
Load Balancer
        ↓
Healthy kube-apiserver
```

If the load balancer becomes unavailable, clients may lose API connectivity even if all API server instances are healthy.

Typical operational considerations include:

```text
Health Checks
Stable Endpoint Address
Redundant Load Balancing
Firewall and Routing
TLS Certificate Names
Port Reachability
```

The API server port in kubeadm deployments commonly uses TCP 6443, but actual configurations should be inspected rather than assumed.

---

# Control Plane Outage vs Running Workloads

If every API server becomes unavailable, existing containers on healthy worker nodes do not automatically terminate solely because the API is inaccessible.

However, API-dependent operations and reconciliation can fail or stall.

```text
Control Plane Unavailable
       ↓
No New API Operations
Scheduling and Reconciliation Degraded
       ↓
Existing Workloads May Continue Running
```

Application traffic may still work if existing Pods, network routing, and dependencies remain healthy.

This should not be confused with a fully healthy cluster or guaranteed application availability.

---

# etcd Availability Is Not Data Backup

Multiple etcd members improve fault tolerance for certain member failures.

Replication does not protect against every form of data loss or logical corruption.

```text
etcd Quorum
→ Availability of distributed cluster state

etcd Snapshot
→ Recovery point for cluster-state restoration
```

A complete operational strategy should include:

```text
Backup Creation
Backup Storage Protection
Restore Procedure
Restore Testing
Access Control
Recovery Ownership
```

etcd stores sensitive cluster data and should be protected with appropriately restricted access and encryption controls.

---

# Workload HA Does Not Guarantee Stateful Data HA

A Deployment with three replicas does not automatically replicate the data of a database used by the Pods.

```text
Web Pod A ─┐
Web Pod B ─┼── Database
Web Pod C ─┘
```

If the database is a single point of failure, the overall service can still fail.

Stateful applications require their own replication, consistency, leader-election, backup, and recovery design.

PersistentVolume and PVC availability also depend on the storage backend and topology.

The Volume concepts from the previous course unit are therefore relevant to HA.

---

# Availability and Recovery Objectives

Availability design is easier to discuss when recovery requirements are explicit.

```text
RTO (Recovery Time Objective)
→ Acceptable time to restore service

RPO (Recovery Point Objective)
→ Acceptable amount of data loss expressed as time
```

Redundant application replicas may reduce recovery time for compute failures.

They do not by themselves guarantee a suitable database recovery point.

---

# kubeadm HA Practice Context

The course introduces kubeadm HA topologies, not a complete step-by-step cluster deployment exercise.

An actual installation requires environment-specific planning for:

```text
Healthy Control Plane Hosts
Load Balancer Endpoint
Networking and DNS
Container Runtime
kubeadm and kubelet
Certificates and Trust
etcd Topology
Node Registration
Failure Domain Placement
```

Do not apply an invented HA bootstrap command sequence as if it had been validated in the user's environment.

The official kubeadm HA procedure is described at:

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/

---

# Inspect Control Plane Nodes

Useful read-only inspection commands include:

```bash
kubectl get nodes -o wide
kubectl describe nodes
```

These can help identify control-plane node count, Ready status, labels, taints, and node conditions.

The command output depends on the actual cluster and is not included as fabricated evidence.

---

# Inspect Control Plane Pods

In a kubeadm-based cluster, core control-plane components often appear as static Pods.

Useful inspections include:

```bash
kubectl get pods -n kube-system -o wide
kubectl get pods -n kube-system
```

When an API server is unavailable, kubectl may not work; host-level kubelet, runtime, and log inspection may be necessary.

Control-plane deployment mechanisms vary across Kubernetes distributions.

---

# Inspect Leader Election Leases

Kubernetes control-plane components can use Lease objects for leader election.

Read-only inspection:

```bash
kubectl get leases -n kube-system
```

A Lease can identify the current holder and renewal information, depending on component and version.

The presence of a Lease does not by itself prove all control-plane replicas or all application workloads are healthy.

---

# Inspect Workload Distribution

For a multi-replica Deployment:

```bash
kubectl get deployments
kubectl get replicasets
kubectl get pods -o wide
kubectl describe deployment web-ha
```

Inspect:

```text
Desired Replicas
Available Replicas
Ready Pods
Pod Node Placement
Deployment Conditions
Pod Events
```

Node and zone separation should be verified from observed placement rather than assumed from the replica count.

---

# Inspect Service Backends

A Deployment with multiple Pods also needs working traffic routing.

Useful checks include:

```bash
kubectl get services
kubectl get endpointslices
kubectl get pods -o wide
```

The checks should establish whether the Service selector identifies the intended Pods and whether ready endpoints are available.

A ReplicaSet that reports the desired count does not automatically prove application reachability.

---

# Control Plane Troubleshooting Workflow

When the Kubernetes API is unavailable:

```text
kubectl Connection Fails
       ↓
Client kubeconfig and Target Endpoint Correct?
       ↓
DNS / VIP / Load Balancer Reachable?
       ↓
Healthy kube-apiserver Backends?
       ↓
Control Plane Host and kubelet Health?
       ↓
etcd Reachability and Quorum?
       ↓
Certificates / Networking / Resource Pressure?
       ↓
Recheck API and Cluster Operations
```

A failed API connection should not immediately be blamed on etcd.

The investigation should distinguish the client, network, load balancer, API server, and etcd layers.

---

# etcd Troubleshooting Perspective

etcd failures require careful cluster-aware diagnosis.

Questions include:

```text
How Many Voting Members Are Configured?
How Many Are Healthy and Reachable?
Is Quorum Available?
Is Disk Space or I/O a Bottleneck?
Is Network Latency Affecting Consensus?
Are TLS Credentials Valid?
Has a Backup Been Verified?
```

Do not remove or add etcd members casually during an outage.

Incorrect membership changes can make quorum restoration harder.

Recovery should follow a documented procedure appropriate to the deployed etcd and Kubernetes versions.

---

# Failure Scenario: One Stacked Node Lost

A conceptual exercise:

```text
Before
Control Plane A: Healthy
Control Plane B: Healthy
Control Plane C: Healthy
etcd Quorum: 2 / 3

Failure
Control Plane A: Unavailable

Expected Potential Survivors
Control Plane B: Healthy
Control Plane C: Healthy
etcd Quorum: Still 2 / 3
```

The conclusion depends on all remaining dependencies functioning correctly.

To validate this in a real authorized lab, observe API availability, worker-node connectivity, leader-election continuity, and workload behavior.

No actual failure test or successful failover is claimed here.

---

# Failure Scenario: Two etcd Members Lost

In a three-member etcd cluster:

```text
Healthy Members: 1
Required Quorum: 2
      ↓
Quorum Unavailable
      ↓
Normal State Updates Cannot Proceed
```

A single healthy API server cannot compensate for loss of etcd quorum.

This illustrates why the etcd layer must be treated as an independent HA dependency.

---

# Failure Scenario: Workloads All on One Node

Suppose a Deployment has three replicas but all three run on one worker node.

```text
Replicas: 3
Distinct Worker Nodes Hosting Replicas: 1
      ↓
Single Node Failure
      ↓
All Replicas Affected
```

Possible corrective design actions include:

```text
Pod Anti-Affinity
Topology Spread Constraints
Additional Eligible Nodes
Resource Capacity Planning
Readiness Probe Verification
```

The appropriate action depends on the observed scheduling evidence and intended failure domain.

---

# HA Validation Checklist for a Real Cluster

A real HA test should verify more than resource existence.

```text
Control Plane Replicas Exist
        ↓
API Endpoint Has Healthy Backends
        ↓
etcd Quorum Is Healthy
        ↓
Controller and Scheduler Leadership Works
        ↓
Workload Replicas Are Distributed
        ↓
Traffic Uses Ready Backends
        ↓
Failure Injection in Authorized Lab
        ↓
Recovery Observed and Timed
        ↓
Application and Data Verified
```

High availability is a measured property of a working design, not a label inferred from a YAML file.

---

# Course Tutorial and Closing Slides

The course ends with links to Kubernetes tutorials and a Q&A slide on p.156-158.

These pages are navigation and closing material, not a complete demonstrated HA installation.

The examples above are conceptual explanations or suggested inspections, not claims that the PDF demonstrated successful cluster failover.

---

# Evidence Policy

Do not fabricate:

```text
Cluster Names
Control Plane Hostnames
Worker Node Names
IP Addresses
VIPs or Load Balancer Endpoints
etcd Member IDs
Quorum Health Output
Pod Placement
Replica and Readiness Output
Lease Holder Names
Certificates
Kubeconfig Files
Bootstrap Tokens
Failure Test Results
Recovery Times
Log Output
Command Output
```

Actual evidence must come from an authorized and observable environment.

Lab examples should remain clearly separated from deployment and failover results.

Never publish live cluster credentials, private key material, or sensitive etcd snapshots.

---

# Verification Checklist

- High availability was understood as reducing the impact of component failures rather than promising zero downtime.
- Single points of failure were identified across application, network, storage, and control-plane layers.
- Deployment and ReplicaSet reconciliation were connected to workload recovery.
- Replica count and failure-domain distribution were distinguished.
- Container restarts and worker-node failures were understood as different recovery scenarios.
- Readiness probes were connected to traffic routing.
- PodDisruptionBudget was understood as a voluntary-disruption control, not universal failure protection.
- Stateful application leadership was distinguished from stateless workload replication.
- Workload availability and control-plane availability were distinguished.
- API server, scheduler, controller manager, and etcd responsibilities were reviewed.
- etcd was understood as the distributed Kubernetes cluster-state store.
- Quorum and odd-sized etcd membership were introduced.
- Multiple API servers and a stable load-balanced endpoint were connected.
- Lease-based leader election was connected to scheduler and controller-manager HA.
- Stacked etcd and external etcd topologies were compared.
- Failure coupling in stacked etcd was distinguished from separated external etcd hosts.
- Failure domains, load-balancer reliability, networking, and backup were treated as separate HA dependencies.
- etcd replication was distinguished from backup and disaster recovery.
- Workload availability was not treated as proof of stateful data availability.
- Read-only inspection and troubleshooting workflows were introduced without inventing output.
- Course topology figures were distinguished from an actually deployed HA cluster.

## What I Learned

- Kubernetes HA has separate application, control-plane, and storage concerns.
- Controllers can recreate failed Pods only when control-plane functions, scheduling, and required resources are available.
- Three replicas on a single node do not protect against that node failing.
- etcd availability depends on quorum, not simply on one surviving member.
- API servers can serve requests behind a load balancer, while controller-manager and scheduler components coordinate active leadership.
- Stacked etcd is simpler but couples etcd and control-plane failures on the same hosts.
- External etcd separates failure domains but requires more infrastructure and operational work.
- A redundant topology still needs trustworthy health checks, failure-domain separation, backups, and observed application verification.
- High availability should be demonstrated with real failure observations and recovery evidence rather than assumed from replica counts.
