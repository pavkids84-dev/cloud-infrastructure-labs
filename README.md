# Cloud Infrastructure Labs

This repository documents my hands-on learning path toward cloud infrastructure engineering.

The current technical progression is:

```text
Linux System Administration
        ↓
Network Fundamentals and Troubleshooting
        ↓
Containers and Docker
        ↓
Kubernetes
```

The repository emphasizes architecture, runtime observation, troubleshooting, verification, and security rather than command memorization alone.

## Repository Structure

```text
cloud-infrastructure-labs/
├── README.md
├── linux/
│   ├── README.md
│   ├── system-information-lab.md
│   ├── file-directory-permission-lab.md
│   ├── vi-basic-lab.md
│   ├── shell-basics-lab.md
│   ├── shell-environment-lab.md
│   ├── search-archive-compression-lab.md
│   ├── text-processing-lab.md
│   ├── process-management-lab.md
│   ├── service-management-lab.md
│   ├── ssh-basic-lab.md
│   ├── package-management-lab.md
│   ├── user-management-lab.md
│   ├── job-scheduling-lab.md
│   ├── storage-management-lab.md
│   ├── filesystem-management-lab.md
│   ├── lvm-management-lab.md
│   ├── raid-management-lab.md
│   ├── memory-swap-management-lab.md
│   ├── boot-kernel-management-lab.md
│   ├── backup-recovery-lab.md
│   ├── log-management-lab.md
│   ├── firewall-management-lab.md
│   ├── selinux-management-lab.md
│   ├── network-management-lab.md
│   ├── network-teaming-lab.md
│   ├── nfs-management-lab.md
│   ├── linux-bridge-lab.md
│   ├── autofs-management-lab.md
│   ├── samba-cifs-management-lab.md
│   ├── apache-httpd-management-lab.md
│   ├── dns-bind-unbound-management-lab.md
│   ├── host-network-security-hardening-lab.md
│   └── shell-script/
│       └── README.md
├── network/
│   ├── README.md
│   ├── osi-model-lab.md
│   ├── network-types-protocols-lab.md
│   ├── ethernet-lab.md
│   ├── ipv4-addressing-lab.md
│   ├── ipv6-addressing-lab.md
│   ├── arp-rarp-lab.md
│   ├── routing-fundamentals-lab.md
│   ├── routing-protocols-lab.md
│   ├── network-standards-lab.md
│   ├── dns-fundamentals-lab.md
│   ├── network-troubleshooting-lab.md
│   └── packet-analysis-lab.md
├── docker/
│   ├── README.md
│   ├── virtualization-container-foundations-lab.md
│   ├── cloud-computing-cloud-native-foundations-lab.md
│   ├── docker-engine-foundations-lab.md
│   ├── image-container-lifecycle-lab.md
│   ├── dockerfile-image-build-lab.md
│   ├── container-management-lab.md
│   ├── registry-management-lab.md
│   ├── docker-networking-lab.md
│   ├── docker-compose-lab.md
│   └── container-clustering-foundations-lab.md
└── kubernetes/
    ├── README.md
    ├── kubernetes-architecture-foundations-lab.md
    ├── minikube-local-cluster-lab.md
    ├── kubeadm-cluster-bootstrap-lab.md
    ├── kubectl-basic-control-lab.md
    ├── pod-fundamentals-lab.md
    ├── resource-object-template-lab.md
    ├── controller-fundamentals-lab.md
    └── service-fundamentals-lab.md
```

Future top-level areas should be created only after actual study exists.

## Linux System Administration

The Linux area provides the operating-system foundation for infrastructure work.

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
Storage and Filesystems
LVM
RAID
Memory and Swap
Boot and Kernel
Backup and Recovery
Logging
Firewall
SELinux
Networking
NFS
Samba / CIFS
Apache
DNS
Host Hardening
```

## Network Fundamentals and Troubleshooting

The network area covers:

```text
OSI
Ethernet
IPv4 / IPv6
ARP
Routing
Routing Protocols
DNS
Troubleshooting
Wireshark
Packet Analysis
Follow Stream
Flow Graph
Latency Analysis
Capture Filters
Display Filters
TCP Analysis
```

General networking remains separate from Linux-specific network administration.

## Docker and Containers

The completed Docker path covers:

```text
Virtualization
Cloud Computing
Cloud Native
Container Isolation
Docker Engine
Images
Container Lifecycle
Dockerfile
Storage
Container Management
Registry
Docker Networking
Docker Compose
Container Clustering
```

Docker provides the immediate container foundation for Kubernetes.

## Kubernetes

Current Kubernetes studies include:

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
Live Object YAML
Resource Templates
Controllers
ReplicaSet
Deployment Introduction
Scaling
Namespaces
Services
Service Types
Endpoints
kube-proxy
iptables
IPVS
```

The current course position is:

```text
Completed through p.94
```

The next topic is:

```text
Labels and Selectors
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

Controllers reconcile differences between desired and observed state.

```text
Desired State
      ↓
Controller
      ↓
Observed State
      ↓
Reconciliation
```

## Kubernetes Workload Hierarchy

A common application hierarchy is:

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

Controller, scheduler, and kubelet roles should remain distinct.

```text
Controller
→ Determine what state is required
```

```text
Scheduler
→ Choose where new Pods run
```

```text
kubelet
→ Manage Pod execution on a node
```

## Kubernetes Service Networking

Pods are dynamic workload objects.

Services provide stable access identities in front of changing Pod backends.

```text
Client
   ↓
Service
   ↓
Selected Backends
   ↓
Pods
```

Current Service types studied:

```text
ClusterIP
NodePort
LoadBalancer
ExternalName
```

Important relationships:

```text
Labels
→ Service Selector
→ Backend Endpoints
```

```text
Service port
→ targetPort
→ Application port
```

Service traffic handling in the course includes:

```text
kube-proxy
iptables
IPVS
```

## Linux, Network, Docker, and Kubernetes Relationship

```text
Linux Processes
      ↓
Container Processes
      ↓
Kubernetes Workloads
```

```text
Linux Namespaces
      ↓
Container Isolation
      ↓
Pod Network Namespace
```

```text
IP / Routing / DNS
      ↓
Docker Networking
      ↓
Kubernetes Pod and Service Networking
```

```text
Docker Images
      ↓
Registry
      ↓
Kubernetes Workloads
```

## Troubleshooting Method

The repository uses:

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

Observation should normally come before configuration changes.

## Kubernetes Troubleshooting

A Pod investigation can begin with:

```text
kubectl get
      ↓
kubectl describe
      ↓
Events
      ↓
kubectl logs
      ↓
kubectl exec
```

A Service investigation can continue with:

```text
Application listening?
      ↓
Pod Ready?
      ↓
Labels correct?
      ↓
Service selector correct?
      ↓
Backend endpoints present?
      ↓
port / targetPort correct?
      ↓
Service type and network path correct?
```

## Runtime vs Persistent and Desired State

A recurring infrastructure principle is:

```text
Runtime State
!=
Persistent Configuration
```

Kubernetes extends this into:

```text
Desired State
!=
Observed State
```

Version-controlled manifests describe intent, while runtime inspection provides evidence of actual state.

## Security Approach

Security is part of each infrastructure layer.

Current principles include:

```text
Use least privilege.
Do not publish kubeconfig credentials.
Do not publish bootstrap tokens.
Do not commit real application secrets.
Do not disable host security controls as a generic fix.
Review exported Kubernetes objects before publishing them.
```

Future Kubernetes security topics include:

```text
Authentication
Authorization
RBAC
Service Accounts
Secrets
Workload Security
```

## Evidence Policy

Course screenshots and example outputs are educational examples.

Do not fabricate:

```text
IP Addresses
MAC Addresses
Process IDs
Container IDs
Image IDs
Node Names
Pod Names
Pod IP Addresses
Service IP Addresses
NodePort Values
Endpoint Addresses
Events
Logs
Packet Captures
Command Output
```

Actual evidence must come from the environment where the exercise was performed.

## Historical Material Policy

Training material can contain historical commands, versions, products, and implementation assumptions.

Examples encountered include:

```text
Legacy Linux networking commands
Docker Toolbox
Boot2Docker
Historical Docker runtime integration
rkt
Heapster
Older Kubernetes repositories
Legacy API versions
docker0-based Kubernetes diagrams
Historical kubelet CNI flags
Older Calico procedures
apps/v1beta1 Deployment examples
Endpoints-focused Service material
```

Historical examples are preserved for context while reusable architecture and current conceptual corrections are clearly distinguished.

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
Kubernetes YAML
Pod Troubleshooting
Resource Templates
Controller Reconciliation
ReplicaSet
Deployment Introduction
Scaling
Namespaces
Service Fundamentals
Service Types
Endpoints
kube-proxy
iptables
IPVS
```

Current learning area:

```text
Kubernetes
```

Next:

```text
Labels and Selectors
```

## Planned Expansion

Potential later top-level areas include:

```text
aws/
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

The objective is to understand, operate, troubleshoot, automate, and secure infrastructure across each layer.
