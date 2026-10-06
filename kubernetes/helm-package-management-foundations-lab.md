# Helm Package Management Foundations Lab

## Objective

Understand Helm as a Kubernetes package manager and connect charts, templates, values, releases, repositories, installation, upgrades, namespaces, and troubleshooting into one reusable workflow.

## Scope

```text
Helm
Helm v2 Historical Architecture
Helm v3
Chart
Release
Repository
Artifact Hub
Chart.yaml
values.yaml
templates/
helm create
helm repo add
helm repo update
helm search repo
helm show
helm install
helm list
helm status
helm pull
helm upgrade
Namespace Selection
Persistence Considerations
Troubleshooting
```

---

# Helm

Helm is a package manager for Kubernetes.

The package format managed by Helm is called a chart.

Conceptually:

```text
Chart
  ↓
Helm
  ↓
Rendered Kubernetes Manifests
  ↓
Kubernetes API
  ↓
Kubernetes Resources
```

Helm does not replace Kubernetes objects.

It helps package, parameterize, install, upgrade, and manage groups of Kubernetes manifests.

---

# Helm v2 and Helm v3

The course introduces the historical Helm v2 architecture:

```text
Helm Client
   ↓
Tiller Server
```

Helm v3 removed Tiller.

Conceptually:

```text
Helm v3 Client
      ↓
Kubernetes API
```

The important reusable point is that current Helm does not require a Tiller server running inside the cluster.

---

# Chart

A chart is a package that contains metadata, default values, templates, and optional dependencies.

Typical chart structure:

```text
mychart/
├── Chart.yaml
├── values.yaml
├── charts/
└── templates/
```

Depending on Helm version and chart scaffolding, additional files such as `.helmignore` or test templates can also appear.

---

# Release

A release is an installed instance of a chart.

Conceptually:

```text
Chart
   ↓
helm install
   ↓
Release
   ↓
Kubernetes Resources
```

The same chart can be installed multiple times with different release names and values.

---

# Chart and Release Are Different

```text
Chart
→ Package / Template Source
```

```text
Release
→ Installed Instance of That Chart
```

For example, one chart can produce multiple releases:

```text
wordpress chart
├── dev release
└── prod release
```

Each release can have different values.

---

# Create a Chart

The course uses:

```bash
helm create hhsapp
```

This creates a starter chart.

A generated chart commonly includes:

```text
Chart.yaml
values.yaml
charts/
templates/
```

The `templates/` directory contains Kubernetes resource templates.

---

# Chart.yaml

`Chart.yaml` stores chart metadata.

Typical information includes:

```text
Chart Name
Chart Version
Description
Application Version
Dependencies Metadata
```

Chart version and application version should not be treated as the same concept.

---

# values.yaml

`values.yaml` contains default configuration values consumed by templates.

Conceptually:

```text
values.yaml
    ↓
Template Expressions
    ↓
Rendered Manifest
```

This separates reusable Kubernetes resource templates from environment-specific settings.

---

# Templates

Helm templates use expressions such as:

```text
{{ ... }}
```

to inject values and reusable template helpers into Kubernetes manifests.

The course service example uses concepts such as:

```text
.Values.service.type
.Values.service.port
include
selectorLabels
```

The result after rendering is ordinary Kubernetes YAML sent to the Kubernetes API.

---

# Service Values

If a chart contains:

```yaml
service:
  type: NodePort
  port: 1000
```

the `port` value represents the Kubernetes Service port used by that chart template.

It does not automatically mean the externally exposed NodePort number is `1000`.

If the chart does not explicitly set `nodePort`, Kubernetes can allocate a NodePort from the configured NodePort range.

---

# Install a Local Chart

A local chart can be installed with a release name.

Conceptually:

```bash
helm install myapp ./hhsapp
```

The installation process is:

```text
Chart
  +
Values
  ↓
Template Rendering
  ↓
Kubernetes API
  ↓
Resources
  ↓
Release Record
```

---

# Inspect Releases

Useful release-oriented commands include:

```bash
helm list
helm status RELEASE_NAME
```

Conceptually:

```text
helm list
→ Which releases exist?
```

```text
helm status
→ What is the current state and release information?
```

Actual release output must come from the user's own cluster.

---

# Inspect a Chart Before Installation

The course introduces:

```bash
helm show all REPOSITORY/CHART
```

This is useful for reviewing chart metadata, default values, and related information before installation.

A chart should be inspected before deploying it into a real environment.

---

# Helm Repositories

The course uses repository operations such as:

```bash
helm repo add
helm repo update
helm search repo
```

Conceptually:

```text
Repository
   ↓
Chart Index / Metadata
   ↓
Search
   ↓
Install or Pull Chart
```

---

# Add and Update a Repository

Example syntax from the course:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

This registers the repository locally and refreshes repository metadata.

Repository availability, chart names, and chart versions can change over time.

---

# Search a Repository

The course uses:

```bash
helm search repo bitnami
```

The purpose is to discover charts available through repositories already registered with the Helm client.

---

# Artifact Hub

The course introduces Artifact Hub as a place to discover Kubernetes packages and Helm charts.

Conceptually:

```text
Artifact Hub
     ↓
Discover Package
     ↓
Identify Repository / Chart
     ↓
Review
     ↓
Install
```

Discovery is not the same as security approval.

Before installing a third-party chart, review the publisher, chart source, values, templates, and required permissions.

---

# Install from a Repository

Conceptual syntax:

```bash
helm install RELEASE_NAME REPOSITORY/CHART
```

This creates a Helm release from the selected chart.

The course uses Bitnami charts as examples.

Those examples should be treated as course examples rather than permanent chart names or version guarantees.

---

# Pull a Chart Locally

The course uses the historical term `chart fetch`.

For Helm v3, the reusable command to remember is:

```bash
helm pull REPOSITORY/CHART
```

A chart can be downloaded and optionally unpacked for inspection or modification.

Conceptually:

```text
Repository Chart
      ↓
helm pull
      ↓
Local Chart Files
      ↓
Review / Modify
      ↓
helm install or helm upgrade
```

---

# Customize values.yaml

The course demonstrates downloading a chart, modifying `values.yaml`, and then installing or upgrading it.

This is a common Helm workflow:

```text
Chart
  ↓
values.yaml
  ↓
Custom Configuration
  ↓
Install / Upgrade
```

Do not edit templates unnecessarily when a supported value already provides the required configuration.

---

# Upgrade a Release

`helm upgrade` changes an existing release using a chart and values.

Conceptually:

```text
Existing Release
      +
Updated Chart / Values
      ↓
helm upgrade
      ↓
Rendered Desired Manifests
      ↓
Kubernetes Update
```

A common automation-oriented pattern is:

```bash
helm upgrade --install RELEASE_NAME CHART
```

This can install the release if it does not already exist or upgrade it if it does.

---

# Namespace Selection

The course introduces:

```bash
-n NAMESPACE
```

or:

```bash
--namespace NAMESPACE
```

This selects the namespace used for the release operation.

Selecting a namespace does not necessarily create it.

When installation should create a missing namespace, Helm supports:

```bash
--create-namespace
```

with an install operation.

---

# Persistence

The course examples modify persistence settings for application and database charts.

This is important:

```text
persistence.enabled: false
```

can make application or database data non-persistent depending on the chart and workload.

That can be useful for temporary training environments, but it should not be copied into production without understanding the data-loss implications.

---

# Pending Pods and Persistent Storage

The course shows a MariaDB Pod in `Pending` state and suggests investigating persistent storage.

The correct troubleshooting rule is:

```text
Pending Pod
   ↓
kubectl describe pod
   ↓
Events
   ↓
Identify Actual Scheduling / Storage Cause
```

A missing PersistentVolume is one possible cause.

It is not the only possible cause.

In clusters with a working default StorageClass and dynamic provisioning, a PVC can trigger PV provisioning automatically.

---

# Helm and Kubernetes Troubleshooting

Helm adds a package-management layer, but Kubernetes runtime troubleshooting still applies.

A useful flow is:

```text
helm status
    ↓
kubectl get
    ↓
kubectl describe
    ↓
Events
    ↓
kubectl logs
```

If the rendered resources are unexpected, also inspect:

```text
Chart
values.yaml
Rendered Templates
Release Values
```

---

# Render Before Applying

When investigating template behavior, render the chart before changing the cluster.

Useful commands include:

```bash
helm template RELEASE_NAME CHART
```

and dry-run workflows.

Conceptually:

```text
Chart + Values
      ↓
Render
      ↓
Inspect YAML
      ↓
Apply Only After Review
```

This is especially useful for understanding generated Services, Deployments, StatefulSets, RBAC, and storage resources.

---

# Helm and Desired State

Helm packages Kubernetes desired-state manifests.

The final runtime model remains:

```text
Chart + Values
      ↓
Rendered Manifests
      ↓
Kubernetes API Objects
      ↓
Controllers
      ↓
Observed Runtime State
```

Helm manages releases, while Kubernetes controllers continue to reconcile the actual workloads.

---

# Security Considerations

Do not commit real credentials or sensitive values into `values.yaml`.

Avoid publishing:

```text
Passwords
API Tokens
Private Keys
Kubeconfig Credentials
Cloud Credentials
Production Endpoints
Real Secret Values
```

Use appropriate Kubernetes Secret management and external secret-management mechanisms for real environments.

---

# Evidence Policy

Do not fabricate:

```text
Release Names from Real Environments
Cluster Addresses
Pod Names
PVC Names
PV Names
Service IPs
NodePort Values
Repository Output
Chart Versions
Release Revisions
Status Output
Command Output
```

Course screenshots and sample output are educational references only.

Actual evidence must come from an authorized lab environment.

---

# Verification Checklist

- Helm was understood as a Kubernetes package manager.
- Chart and release were distinguished.
- Helm v2 Tiller was treated as historical architecture.
- Helm v3 was understood as not requiring Tiller.
- Chart.yaml, values.yaml, charts/, and templates/ were introduced.
- Template values were connected to rendered Kubernetes manifests.
- Local chart installation was introduced.
- Repository add, update, search, and install workflows were introduced.
- Artifact Hub was connected to package discovery.
- `helm pull` was distinguished from historical `fetch` terminology.
- Release inspection with `helm list` and `helm status` was introduced.
- `helm upgrade` was connected to release updates.
- Namespace selection was separated from namespace creation.
- Persistence settings were treated as operationally significant.
- Pending Pods were connected to Kubernetes evidence rather than assumptions.

## What I Learned

- Helm packages reusable Kubernetes manifests into charts.
- `values.yaml` parameterizes templates without changing every manifest manually.
- A chart is the package, while a release is an installed instance.
- Helm repositories distribute charts, while Artifact Hub helps discover packages.
- Helm simplifies deployment management but does not replace Kubernetes troubleshooting.
- Storage, security, and namespace behavior still need to be verified at the Kubernetes resource level.
