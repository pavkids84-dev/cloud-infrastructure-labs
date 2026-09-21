# Kubernetes Monitoring and Dashboard Foundations Lab

## Objective

Understand the Kubernetes resource-metrics path introduced by the course, why CPU and memory usage must be observed at workload level, how Metrics Server supports `kubectl top` and autoscaling-related resource metrics, and where Kubernetes Dashboard fits as a visual management interface.

## Scope

```text
Monitoring
Resource Requests
Resource Limits
Workload Resource Usage
kubelet
cAdvisor Context
Metrics Server
Resource Metrics API
kubectl top
Node Metrics
Pod Metrics
Container Metrics
HPA Context
Long-Term Monitoring
InfluxDB Course Context
Grafana
Prometheus
ELK / EFK
Kubernetes Dashboard
Dashboard Authentication Context
Troubleshooting
```

---

# Why Resource Monitoring Matters

Kubernetes schedules and runs workloads on finite CPU and memory resources.

The course emphasizes that resource configuration should be based on observed workload behavior rather than arbitrary values.

Conceptually:

```text
Workload
   ↓
CPU / Memory Usage
   ↓
Observation
   ↓
Resource Planning
   ↓
Requests / Limits Tuning
```

Monitoring helps determine whether resource definitions are realistic for the actual workload.

---

# Resource Requests

A resource request expresses the amount of CPU or memory that Kubernetes should consider when scheduling a workload.

Conceptually:

```text
Pod Resource Request
        ↓
Scheduler
        ↓
Node Capacity Evaluation
```

A very large request can reserve more scheduling capacity than the workload normally needs and can reduce overall cluster utilization.

---

# Resource Limits

A resource limit defines an upper resource boundary for a container.

Requests and limits should not be treated as the same setting.

Conceptually:

```text
requests
→ scheduling and baseline resource expectations
```

```text
limits
→ upper runtime boundary
```

The exact CPU and memory behavior differs and should be verified through workload observation.

---

# Requests and Limits Tuning

The course warns that resource settings that are too high can waste capacity and cost, while settings that are too low can contribute to resource problems.

A more precise operational model is:

```text
Requests Too High
→ Over-reservation
→ Lower Cluster Utilization
```

```text
Requests Too Low
→ Overcommit Risk
→ Scheduling May Not Reflect Real Demand
```

```text
Limits Too Low
→ CPU Throttling or Memory Termination Risk
```

Actual tuning should be based on measured application behavior.

---

# Workload-Level Monitoring

Cluster-wide health alone is not enough.

A useful monitoring hierarchy is:

```text
Cluster
  ↓
Node
  ↓
Pod
  ↓
Container
  ↓
Application
```

A healthy node does not automatically mean every container has appropriate resource allocation.

---

# kubelet and Container Metrics

The course explains that each node's kubelet includes cAdvisor-related container resource collection functionality.

Conceptually:

```text
Container Runtime Activity
        ↓
Node-Level Resource Metrics
        ↓
kubelet
        ↓
Cluster Metrics Pipeline
```

The internal implementation can vary by Kubernetes version, but the reusable concept is that node-local workload metrics are collected and exposed through the Kubernetes resource-metrics path.

---

# Historical Heapster Context

The course mentions both:

```text
Heapster
Metrics Server
```

Heapster belongs to historical Kubernetes monitoring architecture.

The reusable modern concept is:

```text
Metrics Server
→ lightweight cluster resource-metrics aggregation
```

Do not treat Heapster as a current default component.

---

# Metrics Server

Metrics Server aggregates resource usage information from Kubernetes nodes and exposes it through the Kubernetes resource metrics API.

Conceptually:

```text
Nodes / kubelet
      ↓
Metrics Server
      ↓
Resource Metrics API
      ↓
kubectl top / autoscaling consumers
```

Metrics Server is not a general-purpose long-term monitoring database.

---

# `kubectl top`

The course introduces real-time resource observation with commands such as:

```bash
kubectl top node
```

and:

```bash
kubectl top pod --all-namespaces
```

Container-level detail can also be requested where supported.

These commands depend on the resource metrics pipeline being available.

---

# Node Metrics

Node metrics provide an overview of resource consumption across worker and control-plane nodes where metrics are available.

Conceptually:

```text
Node
├── CPU Usage
└── Memory Usage
```

The exact values in course screenshots are examples and must not be reused as personal lab evidence.

---

# Pod Metrics

Pod metrics help identify workloads with unusual or unexpectedly high resource consumption.

Conceptually:

```text
Namespace
   ↓
Pod
   ↓
CPU / Memory Usage
```

This provides a bridge between Kubernetes object state and infrastructure resource consumption.

---

# Container Metrics

Pod-level totals can hide differences between containers inside the same Pod.

For multi-container workloads:

```text
Pod
├── Application Container
└── Sidecar Container
```

container-level observation can help identify which process group is responsible for resource usage.

---

# Metrics Availability Delay

The course notes that `kubectl top` may require some waiting time after the metrics component is installed.

Conceptually:

```text
Metrics Component Starts
      ↓
Collect Samples
      ↓
Resource Metrics Become Available
```

A temporary lack of metrics immediately after installation should therefore be distinguished from a permanent metrics-pipeline failure.

---

# Metrics Server and HPA

The course states that Metrics Server is needed for HPA configuration.

At this study level, the relationship can be understood as:

```text
Resource Metrics
      ↓
Metrics Server
      ↓
Horizontal Pod Autoscaler
      ↓
Replica Adjustment
```

Detailed HPA behavior is outside this section.

---

# Short-Term vs Long-Term Monitoring

`kubectl top` provides current resource observations, but it is not a historical analytics system.

Conceptually:

```text
Current Snapshot
→ kubectl top
```

```text
Historical Trends
→ Time-Series Monitoring Platform
```

Long-term capacity planning and incident analysis require retained data.

---

# InfluxDB Course Context

The course mentions InfluxDB as an open-source time-series data store.

Conceptually:

```text
Metrics
   ↓
Time-Series Storage
   ↓
Historical Analysis
```

The specific tool choice is architecture-dependent and should not be treated as mandatory.

---

# Grafana

The course introduces Grafana as a visualization and analysis interface.

Conceptually:

```text
Metrics Data Source
      ↓
Grafana
      ↓
Dashboards / Visualization
```

Grafana is a visualization layer rather than the Kubernetes resource-metrics collector itself.

---

# Prometheus

The course also mentions Prometheus.

Prometheus is commonly used for broader monitoring architectures where metrics must be scraped, retained, queried, and alerted on.

Conceptually:

```text
Applications / Infrastructure
          ↓
Metrics Collection
          ↓
Prometheus
          ↓
Queries / Alerts / Visualization
```

This is broader than the lightweight resource metrics provided for `kubectl top`.

---

# ELK / EFK Context

The course mentions ELK / EFK stacks alongside monitoring tools.

Metrics and logs should still be conceptually separated.

```text
Metrics
→ numerical measurements over time
```

```text
Logs
→ event and application records
```

Both can contribute to incident analysis, but they answer different questions.

---

# Kubernetes Dashboard

The course introduces Kubernetes Dashboard as a web-based visual management interface.

Conceptually:

```text
Browser
   ↓
Dashboard
   ↓
Kubernetes API
   ↓
Cluster Resources
```

A dashboard can provide visual views of workloads and resource state, but it does not replace command-line or API-based troubleshooting.

---

# Dashboard Login Context

The course screenshots show Dashboard authentication through mechanisms such as a token or kubeconfig.

Exact installation, authentication, and access procedures are version-dependent.

Do not copy course tokens, credentials, or old authentication procedures into a real environment.

---

# Dashboard Security

A management dashboard can expose powerful cluster capabilities.

Security principles include:

```text
Authentication Required
Authorization Required
Least Privilege
Protect Tokens and kubeconfig
Avoid Unnecessary Public Exposure
```

A dashboard should not be treated as a harmless read-only website by default.

---

# CLI vs Dashboard

The Dashboard and CLI solve overlapping but different operational needs.

```text
Dashboard
→ visual overview and navigation
```

```text
kubectl
→ precise API operations and troubleshooting
```

For evidence-based troubleshooting, command-line and API observations remain important because they expose exact resource state and events.

---

# Resource Monitoring Troubleshooting

If `kubectl top` does not return metrics:

```text
Metrics Server Installed?
      ↓
Metrics Server Running?
      ↓
Can It Reach Node Metrics?
      ↓
Resource Metrics API Available?
      ↓
RBAC / TLS / Network Problems?
      ↓
Retry After Samples Exist
```

The exact root cause must come from cluster evidence.

---

# Workload Resource Troubleshooting

For resource-related application problems:

```text
Application Symptom
      ↓
Pod State
      ↓
Container State
      ↓
CPU / Memory Metrics
      ↓
Requests / Limits
      ↓
Node Capacity
      ↓
Events / Logs
      ↓
Root Cause
```

Do not diagnose resource exhaustion from one metric alone.

---

# Monitoring Is Not Health by Itself

High or low CPU usage does not by itself prove that an application is healthy or unhealthy.

Metrics should be correlated with:

```text
Application Behavior
Readiness
Events
Logs
Latency
Error Rate
Resource Configuration
```

Monitoring provides evidence, not an automatic root-cause conclusion.

---

# Evidence Policy

Course screenshots and displayed metric values are educational examples.

Do not fabricate or copy them as personal lab evidence.

Do not fabricate:

```text
CPU Usage
Memory Usage
Node Names
Pod Names
Container Names
Metrics Server Status
Dashboard Tokens
Dashboard Login Results
HPA Results
Grafana Screenshots
Prometheus Data
Command Output
```

Actual evidence must come from an authorized Kubernetes environment.

---

# Verification Checklist

- The reason for workload resource monitoring was understood.
- Requests and limits were distinguished.
- Resource over-reservation and under-provisioning risks were recognized.
- Node, Pod, and container observation levels were distinguished.
- kubelet was connected to node-local resource metric collection.
- Heapster was recognized as historical course context.
- Metrics Server was connected to the resource metrics API.
- `kubectl top` was connected to Metrics Server availability.
- Short-term resource snapshots were distinguished from long-term monitoring.
- InfluxDB, Grafana, Prometheus, and ELK / EFK were treated as separate observability components.
- Metrics Server was connected conceptually to HPA.
- Kubernetes Dashboard was introduced as a web management interface.
- Dashboard authentication was treated as security-sensitive.
- Course metric values and credentials were not treated as actual evidence.

## What I Learned

- Kubernetes resource configuration should be informed by measured workload behavior.
- Metrics Server provides lightweight resource metrics for Kubernetes consumers such as `kubectl top`.
- `kubectl top` is useful for current usage observation but is not a historical monitoring platform.
- Long-term monitoring requires a separate metrics-retention and analysis architecture.
- Kubernetes Dashboard provides a visual management interface but does not replace API- and evidence-based troubleshooting.
- Monitoring data should always be correlated with workload state, events, logs, and application behavior.
