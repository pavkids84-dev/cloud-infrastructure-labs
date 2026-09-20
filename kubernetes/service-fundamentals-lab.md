# Kubernetes Service Fundamentals Lab

## Objective

Understand Kubernetes Service as a stable network abstraction for reaching dynamic Pod backends, and distinguish ClusterIP, NodePort, LoadBalancer, ExternalName, endpoints, internal DNS, and kube-proxy traffic handling.

## Scope

```text
Service
Stable Service IP
Labels and Selectors
Service DNS
port
targetPort
ClusterIP
NodePort
LoadBalancer
ExternalName
Endpoints
EndpointSlice Context
kubectl expose
kube-proxy
iptables
IPVS
Service Troubleshooting
```

---

# Why Services Exist

Pods are dynamic runtime objects.

Pods can be created, replaced, rescheduled, and assigned different Pod IP addresses.

Applications therefore should not normally depend on one specific Pod IP as a permanent access point.

Conceptually:

```text
Client
   ↓
Stable Service
   ↓
Dynamic Pod Backends
```

A Service provides a stable access abstraction in front of matching workloads.

---

# Service and Pods

A common Service relationship is:

```text
Service
   ↓
Label Selector
   ↓
Matching Pods
```

The Service selects backend Pods using labels.

Example concept:

```text
Service selector:
app=web

Pod labels:
app=web
```

The Service can then direct traffic toward the selected workload endpoints.

---

# Service Manifest Structure

A basic Service manifest can include:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  selector:
    app: web
  ports:
    - port: 80
      targetPort: 8080
```

This is an example configuration, not actual lab evidence.

---

# `port` and `targetPort`

The Service-facing port and backend application port are different concepts.

```text
Client
   ↓
Service port
   ↓
targetPort
   ↓
Pod Application
```

Example:

```text
Service port = 80
targetPort = 8080
```

The client addresses the Service on port 80 while the selected Pod application receives traffic on port 8080.

---

# Stable Service Address

A Service can provide a stable virtual address even when backend Pods are replaced.

Conceptually:

```text
Pod A deleted
      ↓
Pod B created with another Pod IP
      ↓
Service identity remains stable
```

This separates client-facing service identity from individual Pod identity.

---

# Service DNS

Services are integrated with Kubernetes cluster DNS.

Conceptually:

```text
Application
    ↓
Service Name
    ↓
Cluster DNS
    ↓
Service
```

Applications inside the cluster can therefore use service-oriented naming instead of tracking changing Pod IP addresses directly.

---

# Service Types

The course introduces four Service types:

```text
ClusterIP
NodePort
LoadBalancer
ExternalName
```

They solve different access requirements.

---

# ClusterIP

ClusterIP is the normal cluster-internal Service type.

Conceptually:

```text
Cluster Client
      ↓
ClusterIP : Service Port
      ↓
Selected Backends
```

It provides a stable virtual Service address inside the cluster network.

ClusterIP should not be interpreted as a general public external IP.

---

# NodePort

NodePort exposes the Service through a port on cluster nodes.

Conceptually:

```text
External Client
      ↓
Node IP : NodePort
      ↓
Service
      ↓
Backend Pod
```

The course demonstrates creating a NodePort Service and accessing an nginx workload through a node address and the allocated NodePort.

Exact IP addresses and port values from the course are training examples and are not personal lab evidence.

---

# NodePort and ClusterIP

A NodePort Service still participates in the Service abstraction.

Conceptually:

```text
NodePort
   ↓
Service
   ↓
Cluster Backend Selection
```

The NodePort provides an additional external entry path rather than replacing the Service model.

---

# LoadBalancer

LoadBalancer is designed for environments where Kubernetes can integrate with external load-balancer infrastructure.

Conceptually:

```text
External Client
      ↓
External Load Balancer
      ↓
Kubernetes Service
      ↓
Backend Pods
```

In a supported cloud environment, a controller can request creation or release of the external load-balancer resource.

The exact implementation depends on the infrastructure and Kubernetes integration.

---

# ExternalName

ExternalName represents an external DNS name through the Kubernetes Service namespace.

Conceptually:

```text
Kubernetes Service Name
        ↓
DNS Mapping
        ↓
External DNS Name
```

It does not select normal Pod backends in the same way as a selector-based ClusterIP Service.

---

# Endpoints

The course introduces endpoint information as the combination of backend Pod addresses and application ports.

Conceptually:

```text
Service
   ↓
Selected Backend Set
   ↓
Pod IP : Port
```

The course uses commands such as:

```bash
kubectl get endpoints
```

to inspect backend address information.

Course output values should not be reused as personal evidence.

---

# Endpoint Lifecycle

The course describes endpoint objects as being updated when Service and Pod relationships change.

The reusable operational concept is:

```text
Matching Backend Set Changes
        ↓
Service Backend Information Changes
```

This allows a stable Service identity to continue directing traffic toward changing workload instances.

---

# EndpointSlice Context

Older Kubernetes material commonly emphasizes the `Endpoints` object.

Modern Kubernetes architectures also use EndpointSlice resources to represent scalable Service backend information.

The important learning point is not the historical object name alone, but the relationship:

```text
Service
→ Backend Endpoint Information
→ Ready Workload Addresses
```

---

# `kubectl expose`

The course introduces `kubectl expose` as an imperative way to create a Service from an existing Kubernetes resource.

General concept:

```text
Existing Workload
      ↓
kubectl expose
      ↓
Service
```

Possible source resources shown by the course include:

```text
Pod
ReplicationController
ReplicaSet
Deployment
Service
```

For repeatable infrastructure, a reviewed Service manifest is generally easier to version-control than relying only on imperative commands.

---

# Service Creation Verification

After creating a Service, useful verification includes:

```text
Service exists?
      ↓
Correct Service type?
      ↓
Correct port mapping?
      ↓
Backend endpoints present?
      ↓
Application reachable through intended path?
```

Commands can include:

```bash
kubectl get svc
kubectl describe svc SERVICE_NAME
kubectl get endpoints
```

Actual names and outputs must come from the lab environment.

---

# Direct Pod Access vs Service Access

The course demonstrates both direct backend access and Service-based access.

These answer different questions.

```text
Direct Pod IP
→ Is the application reachable at the backend itself?
```

```text
Service IP / NodePort
→ Is the Kubernetes Service path functioning?
```

This distinction is useful during troubleshooting.

---

# Service Troubleshooting Layers

A useful investigation path is:

```text
Application Process
      ↓
Pod Ready?
      ↓
Pod IP / Application Port
      ↓
Service Selector
      ↓
Backend Endpoint Information
      ↓
Service Port Mapping
      ↓
kube-proxy / Dataplane
      ↓
Node / External Network
```

Do not assume that a `Running` Pod proves Service reachability.

---

# Selector Troubleshooting

A common conceptual failure is:

```text
Service exists
      ↓
No matching Pods
      ↓
No usable backends
```

Check:

```text
Service selector
vs
Pod labels
```

If they do not match, the Service cannot select the intended workloads.

---

# Port Troubleshooting

Another possible mismatch is:

```text
Service port
targetPort
Application listening port
```

All three should be understood separately.

Example:

```text
Service port: 80
targetPort: 8080
Application listens: 8080
```

If the application listens on a different port, the network path can fail even when the Service object exists.

---

# kube-proxy

The course connects Service traffic handling to kube-proxy running on cluster nodes.

Conceptually:

```text
Service Virtual Address
       ↓
Node Dataplane Rules
       ↓
Backend Pod
```

The course introduces multiple kube-proxy modes.

---

# iptables Mode

The course explains iptables-based Service proxying as kernel-space packet handling using netfilter rules.

Conceptually:

```text
Service Traffic
      ↓
iptables / netfilter rules
      ↓
Selected Backend
```

This avoids implementing all Service forwarding through a userspace proxy process.

---

# Backend Health Context

The course notes that iptables forwarding does not simply retry another Pod if a selected backend fails to respond.

A more useful operational model is:

```text
Readiness / Backend Membership
        ↓
Only usable endpoints should normally receive traffic
```

Application health, readiness state, endpoint membership, and Service dataplane behavior should be investigated together.

---

# IPVS Mode

The course also introduces IPVS.

It describes IPVS as operating in kernel space and using hash-table-based structures for Service forwarding.

Conceptually:

```text
Service Traffic
      ↓
IPVS
      ↓
Backend Selection
```

The course lists balancing algorithms such as:

```text
Round Robin
Least Connection
Destination Hashing
Source Hashing
Shortest Expected Delay
Never Queue
```

The exact mode available depends on the cluster implementation and Kubernetes version.

---

# Service Is an Abstraction

A Service should not be imagined as an application server process that owns the virtual IP in the same way a normal host process binds an address.

Conceptually:

```text
Service Object
      +
Cluster Networking Rules
      +
Backend Endpoint Information
```

together provide the access abstraction.

---

# Internal and External Access

The course separates internal and external Service access.

Conceptually:

```text
Internal
Client Pod
   ↓
ClusterIP Service
   ↓
Backend Pod
```

and:

```text
External
Client
   ↓
NodePort / LoadBalancer Path
   ↓
Service
   ↓
Backend Pod
```

The exact path depends on Service type and infrastructure.

---

# Service and Controller Relationship

Services are API objects whose related state is maintained through Kubernetes control-plane and node networking components.

Conceptually:

```text
Service spec
      ↓
Controllers / API State
      ↓
Backend Endpoint Information
      ↓
Node Dataplane
      ↓
Traffic to Pods
```

This continues the desired-state model introduced in the controller section.

---

# Service and DNS Relationship

A Service provides two important forms of stable identity:

```text
Network Identity
→ Stable Service address
```

```text
Name Identity
→ Cluster DNS name
```

Applications can use these instead of depending directly on individual Pod IP addresses.

---

# Network Foundation Relationship

Kubernetes Services build on previously studied networking concepts:

```text
IP Addressing
Ports
TCP / UDP
Routing
DNS
NAT / Netfilter Concepts
Load Balancing
```

Service troubleshooting therefore still requires ordinary network reasoning.

---

# Controller, Scheduler, kubelet, and Service Dataplane

These roles should remain distinct.

```text
Controller
→ Reconcile desired workload state
```

```text
Scheduler
→ Select a node for new Pods
```

```text
kubelet
→ Manage Pod execution on a node
```

```text
Service Dataplane
→ Forward traffic toward selected backends
```

A Service connectivity failure does not automatically imply a scheduler or controller failure.

---

# Evidence Policy

Course screenshots and example runtime values are educational examples.

Do not fabricate or copy course values as personal lab evidence.

Do not fabricate:

```text
Service IP Addresses
Node IP Addresses
NodePort Values
Pod IP Addresses
Endpoint Addresses
External IP Addresses
Load Balancer Addresses
DNS Results
iptables Rules
IPVS Tables
curl Output
Browser Results
Command Output
```

Actual evidence must come from an authorized Kubernetes lab environment.

---

# Verification Checklist

- Service was understood as a stable abstraction over dynamic Pod backends.
- Service selectors were connected to Pod labels.
- Service DNS integration was introduced.
- `port` and `targetPort` were distinguished.
- ClusterIP was identified as the cluster-internal Service type.
- NodePort was connected to node-address-based external access.
- LoadBalancer was connected to external infrastructure integration.
- ExternalName was distinguished from normal selector-based Pod Services.
- Backend endpoint information was introduced.
- Historical Endpoints terminology was distinguished from modern EndpointSlice context.
- `kubectl expose` was introduced.
- Direct Pod access and Service access were distinguished.
- Service selector and port mismatches were identified as troubleshooting areas.
- kube-proxy was connected to Service traffic handling.
- iptables and IPVS modes were introduced.
- Service reachability was distinguished from Pod `Running` state.
- Course runtime values were not treated as personal evidence.

## What I Learned

- Pods are dynamic, while Services provide stable network and DNS identities.
- Labels and selectors connect Services to workload backends.
- Service ports and backend target ports are separate concepts.
- Different Service types provide different access scopes.
- Service reachability depends on workload readiness, backend selection, port mapping, and the cluster network dataplane.
- kube-proxy modes such as iptables and IPVS implement Service traffic forwarding in the course architecture.
- Troubleshooting should verify each layer from the application backend to the client-facing Service path.
