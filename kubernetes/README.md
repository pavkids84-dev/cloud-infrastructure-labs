# Kubernetes Infrastructure Labs

This directory documents my Kubernetes learning path as part of my cloud infrastructure engineering studies.

The focus is on understanding Kubernetes as an API-driven desired-state platform built on Linux, networking, container runtimes, declarative resources, reconciliation, service networking, scheduling metadata, and controlled application rollouts.

## Learning Path

```text
Containers
   ↓
Kubernetes Architecture
   ↓
Minikube
   ↓
kubeadm
   ↓
kubectl
   ↓
Pods
   ↓
Object Templates
   ↓
Controllers
   ↓
Services
   ↓
Labels and Selectors
   ↓
Deployment Updates
   ↓
Rolling Updates
   ↓
Monitoring
   ↓
Security / RBAC
   ↓
Helm
   ↓
Storage
   ↓
High Availability
```

## Directory Structure

```text
kubernetes/
├── README.md
├── kubernetes-architecture-foundations-lab.md
├── minikube-local-cluster-lab.md
├── kubeadm-cluster-bootstrap-lab.md
├── kubectl-basic-control-lab.md
├── pod-fundamentals-lab.md
├── resource-object-template-lab.md
├── controller-fundamentals-lab.md
├── service-fundamentals-lab.md
├── label-selector-scheduling-lab.md
├── deployment-rolling-update-lab.md
├── monitoring-dashboard-foundations-lab.md
└── api-security-rbac-foundations-lab.md
```

Additional files should be added only after the related topics are actually studied.

## Kubernetes Architecture

Architecture topics include:

```text
Control Plane
Worker Nodes
kube-apiserver
etcd
Scheduler
Controller Manager
kubelet
kube-proxy
CRI
CNI
Cluster DNS
```

## Cluster Bootstrap

The repository covers both:

```text
Minikube
→ local learning environment
```

and:

```text
kubeadm
→ multi-node cluster bootstrap
```

## kubectl and Pod Fundamentals

Current operational observation includes:

```text
kubectl get
kubectl describe
Kubernetes Events
kubectl logs
kubectl exec
kubectl get -o yaml
```

Pod topics include:

```text
Scheduling Unit
Pod IP
Shared Network Namespace
CNI
Volumes
YAML
Conditions
Events
Logs
Container Execution
spec vs status
```

## Resource Object Templates

Resource templates can be prepared from:

```text
Existing Object
→ kubectl get -o yaml
```

or generated through:

```text
--dry-run=client -o yaml
```

Live runtime objects and reusable desired-state manifests should not be treated as identical.

## Controller Fundamentals

Core model:

```text
spec
 ↓
Controller
 ↓
Observed State
 ↓
Reconciliation
 ↓
status
```

Controller topics include:

```text
ReplicaSet
Deployment
StatefulSet
DaemonSet
Job
Scaling
Owner References
Cascading Deletion
Namespaces
```

## Service Fundamentals

Service networking covers:

```text
ClusterIP
NodePort
LoadBalancer
ExternalName
Service Selectors
Backend Endpoints
Cluster DNS
kube-proxy
iptables
IPVS
```

Core model:

```text
Client
   ↓
Service
   ↓
Selected Backends
   ↓
Pods
```

## Labels, Selectors, and Node Scheduling

File:

```text
label-selector-scheduling-lab.md
```

Labels are operational metadata used to connect Kubernetes objects.

```text
Label
   ↓
Selector
   ↓
Matching Resource Set
```

Current relationships include:

```text
ReplicaSet selector
→ Pod labels

Service selector
→ Pod labels

nodeSelector
→ Node labels
```

The course introduces node labeling and `nodeSelector` as a simple scheduling constraint.

```text
Pod Requirement
      ↓
nodeSelector
      ↓
Matching Node Label
      ↓
Scheduler Candidate
```

## Deployment and Rolling Update

File:

```text
deployment-rolling-update-lab.md
```

Deployment updates include:

```text
kubectl set image
kubectl edit
kubectl apply
```

A Pod-template change can create a new ReplicaSet revision.

```text
Deployment
     ↓
Old ReplicaSet
     ↓
Pod Revision A

Deployment Update
     ↓
New ReplicaSet
     ↓
Pod Revision B
```

## RollingUpdate

Conceptually:

```text
Old Pods
   ↓
Gradual Replacement
   ↓
New Pods
```

The course also introduces:

```text
Recreate
Blue/Green
Rollout History
Rollback
Rollout Status
Pause
Resume
Restart
```

## Desired State and Runtime State

A recurring Kubernetes distinction is:

```text
spec
→ Desired State
```

```text
status
→ Observed State
```

Controllers reconcile differences between the two.

## Controller, Scheduler, and kubelet

```text
Controller
→ What should exist?
```

```text
Scheduler
→ Where should a new Pod run?
```

```text
kubelet
→ How is the Pod executed on the selected node?
```

Labels can influence both controller relationships and scheduler eligibility, but these component responsibilities remain distinct.

## Troubleshooting Method

```text
Symptom
   ↓
Evidence
   ↓
Failing Layer
   ↓
Root Cause
   ↓
Resolution
   ↓
Verification
```

## Scheduling Troubleshooting

```text
Pod Pending?
      ↓
Inspect nodeSelector
      ↓
Inspect node labels
      ↓
Check scheduler events
      ↓
Correct requirement or labels
      ↓
Verify placement
```

## Deployment Rollout Troubleshooting

```text
Deployment updated?
      ↓
New ReplicaSet created?
      ↓
New Pods created?
      ↓
Scheduled?
      ↓
Image pulled?
      ↓
Container started?
      ↓
Ready?
      ↓
Application healthy?
```

## Monitoring and Dashboard

File:

```text
monitoring-dashboard-foundations-lab.md
```

The course introduces Kubernetes resource monitoring through:

```text
kubelet resource metrics
      ↓
Metrics Server
      ↓
Resource Metrics API
      ↓
kubectl top
```

Current topics include:

```text
Resource Requests
Resource Limits
Node Metrics
Pod Metrics
Container Metrics
Metrics Server
kubectl top
HPA Context
Long-Term Monitoring
Grafana
Prometheus
ELK / EFK Context
Kubernetes Dashboard
```

`kubectl top` should be treated as current resource observation rather than a historical monitoring database.

The course also contains historical Heapster context, which should not be treated as a current default Kubernetes monitoring component.

## Monitoring Troubleshooting

```text
Metrics Missing?
      ↓
Metrics Server Running?
      ↓
Node Metrics Reachable?
      ↓
Resource Metrics API Available?
      ↓
RBAC / TLS / Network Evidence
```

Resource metrics should be correlated with Pod state, events, logs, and application behavior rather than used as isolated proof of root cause.

## Security Principles

Current principles include:

```text
Use least privilege.
Do not publish kubeconfig credentials.
Do not publish bootstrap tokens.
Do not commit real application secrets.
Review exported API objects before publishing them.
Do not disable host security controls as a generic fix.
```

## API Security and RBAC

File:

```text
api-security-rbac-foundations-lab.md
```

The Kubernetes API security flow is:

```text
Client Request
      ↓
Authentication
      ↓
Authorization
      ↓
Admission Control
      ↓
API Operation
```

Current security topics include:

```text
ServiceAccount
RBAC
Role
RoleBinding
ClusterRole
ClusterRoleBinding
Subjects
Verbs
Namespace Scope
Cluster Scope
Least Privilege
Predefined ClusterRoles
```

A core distinction is:

```text
Authentication
→ Who are you?
```

```text
Authorization
→ What are you allowed to do?
```

```text
Admission
→ Is the authorized request acceptable under cluster policy?
```

Namespace and cluster scopes should be kept explicit to avoid unnecessarily broad permissions.

## RBAC Troubleshooting

```text
Identity Correct?
      ↓
Authentication Successful?
      ↓
Role Rules Correct?
      ↓
Binding Correct?
      ↓
Namespace / Cluster Scope Correct?
      ↓
Verb and Resource Correct?
      ↓
Admission Policy?
```

Authorization problems should not be solved by automatically granting `cluster-admin`.

## Evidence Policy

Course screenshots and example values are educational examples.

Do not fabricate:

```text
Node Names
Labels
Pod Names
ReplicaSet Names
Deployment Names
Revision Numbers
Image Versions
Events
Rollout Results
Command Output
```

Actual evidence must come from an authorized lab environment.

## Historical Material Policy

Historical course material is preserved with clear context.

Examples encountered include:

```text
Legacy Kubernetes package repositories
Historical Docker runtime integration
Heapster
rkt
docker0-based networking diagrams
Historical CNI flags
Older Calico manifests
apps/v1beta1 examples
Endpoints-focused Service material
kubectl --record
```

## Current Learning Progress

Completed through:

```text
p.116
```

Current completed topics include:

```text
Kubernetes Architecture
Minikube
kubeadm
kubectl
Pods
CNI
YAML
Object Inspection
Resource Templates
Controller Reconciliation
ReplicaSet
Scaling
Namespaces
Services
Service Types
kube-proxy
iptables
IPVS
Labels
Selectors
nodeSelector
Deployment Image Updates
RollingUpdate
Recreate
Blue/Green Introduction
Rollout History
Rollback
Monitoring Foundations
Metrics Server
kubectl top
Resource Metrics
Dashboard Introduction
API Server Security
Authentication
Authorization
Admission Control
ServiceAccount
RBAC
Role / RoleBinding
ClusterRole / ClusterRoleBinding
Least Privilege
```

Next topic:

```text
Helm
```

The course continues from:

```text
p.117
```

## Long-Term Infrastructure Path

```text
Linux
   ↓
Networking
   ↓
Containers
   ↓
Docker
   ↓
Kubernetes
   ↓
Cloud Infrastructure
   ↓
Infrastructure as Code
   ↓
Cloud Security
```
