# Cloud Infrastructure Labs

This repository documents my hands-on learning path toward cloud infrastructure engineering.

The current progression is:

```text
Linux System Administration
        ↓
Network Fundamentals and Troubleshooting
        ↓
Containers and Docker
        ↓
Kubernetes
        ↓
AWS Cloud Infrastructure
```

The repository emphasizes architecture, runtime observation, troubleshooting, verification, reproducible configuration, and security.

## Repository Structure

```text
cloud-infrastructure-labs/
├── README.md
├── linux/
│   └── ...
├── network/
│   └── ...
├── docker/
│   └── ...
├── kubernetes/
│   ├── README.md
│   ├── kubernetes-architecture-foundations-lab.md
│   ├── minikube-local-cluster-lab.md
│   ├── kubeadm-cluster-bootstrap-lab.md
│   ├── kubectl-basic-control-lab.md
│   ├── pod-fundamentals-lab.md
│   ├── resource-object-template-lab.md
│   ├── controller-fundamentals-lab.md
│   ├── service-fundamentals-lab.md
│   ├── label-selector-scheduling-lab.md
│   ├── deployment-rolling-update-lab.md
│   ├── monitoring-dashboard-foundations-lab.md
│   └── api-security-rbac-foundations-lab.md
└── aws/
    ├── README.md
    └── cloud-computing-foundations-lab.md
```

Future top-level areas should be created only after actual study exists.

## Linux System Administration

Linux provides the operating-system foundation for infrastructure engineering.

Key areas include:

```text
Files and Permissions
Shell and Bash
Processes
systemd
SSH
Packages
Users and Groups
Scheduling
Storage
Filesystems
LVM
RAID
Memory
Boot
Backup
Logging
Firewall
SELinux
Networking
NFS
Samba
Apache
DNS
Host Hardening
```

## Network Fundamentals and Troubleshooting

Network studies include:

```text
OSI
Ethernet
IPv4
IPv6
ARP
Routing
DNS
Troubleshooting
Wireshark
Packet Analysis
Flow Analysis
Latency Analysis
Capture Filters
Display Filters
```

## Docker and Containers

Docker studies include:

```text
Virtualization
Cloud Computing
Cloud Native
Container Isolation
Images
Container Lifecycle
Dockerfile
Storage
Registry
Networking
Compose
Container Clustering
```

## Kubernetes

Current Kubernetes study has progressed through:

```text
Architecture
Minikube
kubeadm
kubectl
Pods
CNI
Pod Storage Introduction
YAML
Runtime Inspection
Object Templates
Controllers
ReplicaSet
Scaling
Namespaces
Services
kube-proxy
Labels
Selectors
nodeSelector
Deployment Updates
Rolling Updates
Rollback
Blue/Green Introduction
Monitoring Foundations
Metrics Server
kubectl top
Kubernetes Dashboard Introduction
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

Current course position:

```text
Completed through p.116
```

Next:

```text
Helm
```

## Kubernetes Desired-State Model

```text
spec
→ Desired State
```

```text
status
→ Observed State
```

Controllers reconcile the difference.

## Kubernetes Workload Hierarchy

```text
Deployment
     ↓
ReplicaSet
     ↓
Pod
     ↓
Container
     ↓
Linux Process
```

## Kubernetes Service Networking

```text
Client
   ↓
Service
   ↓
Selected Backends
   ↓
Pods
```

Current Service types:

```text
ClusterIP
NodePort
LoadBalancer
ExternalName
```

## Labels and Selectors

Labels connect Kubernetes resources through selector relationships.

```text
Service selector
→ Pod labels
```

```text
ReplicaSet selector
→ Pod labels
```

```text
nodeSelector
→ Node labels
```

Label changes can therefore affect networking, controller membership, and scheduling.

## Kubernetes Scheduling Constraints

The current scheduling constraint introduced by the course is:

```text
Pod nodeSelector
      ↓
Matching Node Labels
      ↓
Scheduler Candidate Nodes
```

A mismatch can leave a Pod unscheduled.

## Deployment Updates

Deployment image changes update the desired Pod template.

```text
Deployment Update
      ↓
New ReplicaSet Revision
      ↓
New Pods
```

The course introduces three update workflows:

```text
kubectl set image
kubectl edit
kubectl apply
```

## RollingUpdate

```text
Old Revision
      ↓
Controlled Replacement
      ↓
New Revision
```

Current rollout concepts include:

```text
RollingUpdate
Recreate
Rollout History
Rollback
Rollout Status
Pause
Resume
Restart
Blue/Green Introduction
Monitoring Foundations
Metrics Server
kubectl top
Dashboard Introduction
API Security
ServiceAccount
RBAC
Least Privilege
```

## Kubernetes Monitoring

The current monitoring foundation includes:

```text
Resource Requests
Resource Limits
Metrics Server
kubectl top
Node Metrics
Pod Metrics
Container Metrics
HPA Context
Long-Term Monitoring Concepts
Kubernetes Dashboard
```

Conceptually:

```text
Node / Pod Resource Usage
        ↓
Metrics Pipeline
        ↓
Metrics Server
        ↓
kubectl top / Autoscaling Consumers
```

Current resource snapshots and long-term observability should be treated as different capabilities.

## AWS Cloud Infrastructure

AWS study has started as the next major infrastructure layer.

The current AWS course begins with cloud-computing foundations before moving into global infrastructure, IAM, computing, storage, networking, scaling, infrastructure as code, serverless computing, databases, and migration.

Current AWS topics include:

```text
Cloud Computing
On-Premises vs Cloud
Virtualization
On-Demand Self-Service
Broad Network Access
Resource Pooling
Multi-Tenancy
Rapid Elasticity
Measured Service
IaaS
PaaS
SaaS
Public Cloud
Hybrid Cloud
Private Cloud
```

Current AWS course position:

```text
Completed through p.14
```

Next topic:

```text
Global Infrastructure
```

The AWS directory is:

```text
aws/
├── README.md
└── cloud-computing-foundations-lab.md
```

The repository should continue to separate course examples from actual lab evidence. AWS account IDs, access keys, ARNs, public IP addresses, resource IDs, billing values, and command output must not be fabricated.

## Troubleshooting Method

```text
Symptom
   ↓
Evidence
   ↓
Root Cause
   ↓
Resolution
   ↓
Verification
```

## Kubernetes Troubleshooting Layers

Current layers include:

```text
Application
Container
Pod
ReplicaSet
Deployment
Service
Backend Endpoints
Scheduler
Node
kubelet
Runtime
CNI
Control Plane
API
```

## Rollout Troubleshooting

```text
Deployment Desired State
      ↓
ReplicaSet
      ↓
Pod Creation
      ↓
Scheduling
      ↓
Image Pull
      ↓
Container Start
      ↓
Readiness
      ↓
Application Verification
```

## Kubernetes API Security and RBAC

The current API security model includes:

```text
Client
   ↓
Authentication
   ↓
Authorization
   ↓
Admission
   ↓
Kubernetes API Operation
```

Current RBAC concepts include:

```text
ServiceAccount
Role
RoleBinding
ClusterRole
ClusterRoleBinding
Subjects
Verbs
Namespace Scope
Cluster Scope
Least Privilege
```

A RoleBinding and a ClusterRoleBinding should not be treated as equivalent because their permission scope can be very different.

## Security Approach

Current principles include:

```text
Use least privilege.
Do not publish kubeconfig credentials.
Do not publish bootstrap tokens.
Do not commit real secrets.
Review exported objects before publishing them.
Do not disable host security controls as a generic fix.
```

## Evidence Policy

Do not fabricate:

```text
IP Addresses
Node Names
Labels
Pod Names
ReplicaSet Names
Deployment Names
Revision Numbers
Image Versions
Events
Logs
Rollout Results
Command Output
```

Actual evidence must come from the environment where the exercise was performed.

## Historical Material Policy

Training material can contain historical commands and implementation assumptions.

Examples include:

```text
Legacy Linux networking commands
Docker Toolbox
Boot2Docker
Historical Docker runtime integration
Heapster
rkt
Older Kubernetes repositories
Legacy Kubernetes API versions
docker0-based diagrams
Historical kubelet CNI options
Older Calico procedures
apps/v1beta1 examples
kubectl --record
```

Historical examples are preserved for context while modern reusable concepts are separated clearly.

## Current Progress

Completed major areas:

```text
Linux Fundamentals
Linux System Administration
Linux Networking and Security

Network Fundamentals
Routing
DNS
Network Troubleshooting
Packet Analysis

Virtualization
Cloud Computing
Cloud Native
Docker
Docker Networking
Docker Compose
Container Clustering

Kubernetes Architecture
Minikube
kubeadm
kubectl
Pods
CNI
Object Templates
Controllers
Services
Labels and Selectors
Node Scheduling Constraints
Deployment Updates
Rolling Updates
Rollback
Blue/Green Introduction
```

Kubernetes course checkpoint:

```text
Completed through p.116
Helm begins at p.117 and is intentionally paused for later study.
```

Current learning area:

```text
AWS
```

AWS course position:

```text
Completed through p.14
```

Next topic:

```text
AWS Global Infrastructure
```

## Planned Expansion

Potential later top-level areas include:

```text
terraform/
```

They should be created only after actual study exists.

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
