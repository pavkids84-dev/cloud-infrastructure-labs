# Kubernetes API Security and RBAC Foundations Lab

## Objective

Understand the Kubernetes API security flow introduced by the course, including authentication, authorization, admission control, ServiceAccounts, namespace-scoped and cluster-scoped RBAC resources, RoleBindings, ClusterRoleBindings, predefined ClusterRoles, and least-privilege access design.

## Scope

```text
Kubernetes API Security
Authentication
Authorization
Admission Control
ServiceAccount
RBAC
Role
ClusterRole
RoleBinding
ClusterRoleBinding
Subjects
Verbs
Resources
Namespace Scope
Cluster Scope
Least Privilege
Predefined ClusterRoles
Security Troubleshooting
```

---

# Kubernetes API Security Flow

The Kubernetes API server is the central interface for cluster operations.

A simplified request flow is:

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

Each stage answers a different question.

---

# Authentication

Authentication determines:

```text
Who is making the request?
```

The course introduces authentication mechanisms such as:

```text
Client Certificates
Bearer Tokens
HTTP-Based Authentication Context
Other Authentication Plugins
```

The exact available mechanisms depend on Kubernetes version and cluster configuration.

---

# Authorization

Authorization determines:

```text
Is this authenticated identity allowed to perform this action?
```

Examples of actions include:

```text
get
list
watch
create
update
patch
delete
```

Authentication success does not automatically imply authorization success.

---

# Admission Control

After authentication and authorization, admission logic can inspect or modify API requests before persistence.

Conceptually:

```text
Authenticated Request
      ↓
Authorized Request
      ↓
Admission
      ↓
Validated / Mutated Object
      ↓
Persisted API State
```

The course references admission behavior such as defaulting, policy enforcement, ServiceAccount handling, namespace lifecycle, and resource quota checks.

---

# CRUD and the API Server

Kubernetes resources are managed through API operations.

Conceptually:

```text
Create
Read
Update
Delete
```

Clients do not bypass the API server to directly rewrite cluster object state in etcd.

The API server applies API schema, validation, security, and admission logic around those requests.

---

# ServiceAccount

A ServiceAccount represents an identity used by workloads running inside Kubernetes.

Conceptually:

```text
Pod
   ↓
ServiceAccount
   ↓
Kubernetes API Identity
```

Applications inside Pods can use ServiceAccount credentials when they need to call the Kubernetes API.

---

# ServiceAccount Identity Format

The course introduces the identity format:

```text
system:serviceaccount:<namespace>:<serviceaccount>
```

This makes the namespace and ServiceAccount name part of the authenticated workload identity.

---

# ServiceAccount Token Context

The course shows a ServiceAccount token mounted under a path such as:

```text
/var/run/secrets/kubernetes.io/serviceaccount/
```

The reusable concept is:

```text
Pod
→ ServiceAccount identity
→ projected or mounted credentials
→ Kubernetes API authentication
```

Token implementation details have changed across Kubernetes versions, so course-era long-lived token behavior should not be treated as a universal current model.

---

# RBAC

RBAC stands for:

```text
Role-Based Access Control
```

Its purpose is to define which subjects can perform which actions on which resources.

Conceptually:

```text
Subject
   ↓
Binding
   ↓
Role / ClusterRole
   ↓
Allowed Verbs on Resources
```

---

# RBAC Subjects

A binding can associate permissions with subjects such as:

```text
User
Group
ServiceAccount
```

A subject identifies who receives the permission.

---

# RBAC Verbs

Common RBAC verbs include:

```text
get
list
watch
create
update
patch
delete
```

Permissions should be granted only as broadly as required.

---

# Least Privilege

The course recommends minimum required permissions.

Conceptually:

```text
Required Task
      ↓
Smallest Necessary Permission Set
      ↓
Role / ClusterRole
      ↓
Binding to Specific Subject
```

Avoid granting broad cluster-wide privileges when a namespace-scoped permission is sufficient.

---

# Role

A Role defines permissions within a namespace.

Example structure:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: example
  name: service-reader
rules:
  - apiGroups: [""]
    resources: ["services"]
    verbs: ["get", "list"]
```

This is an example manifest and not actual lab evidence.

---

# Role Scope

A Role is namespace-scoped.

Conceptually:

```text
Namespace
   ↓
Role
   ↓
Permissions for namespaced resources
```

The same Role name in another namespace is a separate object.

---

# RoleBinding

A RoleBinding grants a Role or suitable ClusterRole to subjects within a namespace scope.

Conceptually:

```text
Subject
   ↓
RoleBinding
   ↓
Role
   ↓
Namespace Permissions
```

A single RoleBinding can include multiple subjects.

---

# RoleBinding and ServiceAccount

A ServiceAccount can be bound to a Role.

Conceptually:

```text
ServiceAccount
      ↓
RoleBinding
      ↓
Role
      ↓
Allowed Namespace Actions
```

This is a common pattern for granting workload-specific API access.

---

# ClusterRole

A ClusterRole defines a reusable permission set at cluster scope.

It can be used for:

```text
Cluster-Scoped Resources
Non-Resource URLs
Reusable Permission Sets
```

Examples of cluster-scoped resources include:

```text
Nodes
PersistentVolumes
Namespaces
```

---

# ClusterRoleBinding

A ClusterRoleBinding grants a ClusterRole across the cluster.

Conceptually:

```text
Subject
   ↓
ClusterRoleBinding
   ↓
ClusterRole
   ↓
Cluster-Wide Permission
```

This has a much larger security scope than a normal RoleBinding.

---

# RoleBinding Referencing a ClusterRole

A RoleBinding can reference a ClusterRole.

However, the binding still applies within the RoleBinding's namespace scope.

Conceptually:

```text
ClusterRole
      ↓
RoleBinding in Namespace A
      ↓
Permissions constrained to Namespace A
```

This is different from a ClusterRoleBinding.

---

# Namespace Scope vs Cluster Scope

A useful distinction is:

```text
Role
RoleBinding
→ Namespace scope
```

```text
ClusterRole
ClusterRoleBinding
→ Cluster-oriented scope
```

The binding type is critical to understanding the resulting blast radius.

---

# Specific Resource Names

RBAC rules can optionally constrain access to specific named resources through `resourceNames`.

Conceptually:

```text
All Services
```

is broader than:

```text
Only one named Service
```

This can support narrower permission boundaries.

---

# Predefined ClusterRoles

The course shows predefined roles such as:

```text
admin
cluster-admin
edit
view
```

These roles provide common permission sets.

Their exact rules should be inspected in the actual cluster rather than assumed from a course screenshot.

---

# `view`

The course presents `view` as a read-oriented namespaced role.

The important operational principle is:

```text
Read Access
!=
Modification Access
```

Sensitive resources can still have special restrictions depending on role definitions and Kubernetes version.

---

# `edit`

The course presents `edit` as broader namespaced modification access than `view`.

It should still not be assumed to provide arbitrary RBAC administration rights.

Always inspect actual rules before granting it.

---

# `admin`

The course presents `admin` as broad namespace-level management capability.

It should not be confused with full cluster administration.

---

# `cluster-admin`

`cluster-admin` represents extremely broad cluster authority when bound cluster-wide.

Conceptually:

```text
cluster-admin
+
ClusterRoleBinding
→ Full or near-full cluster control
```

This should be granted only when genuinely required.

---

# Non-Resource URL Access

The course also introduces authorization for API endpoints that are not normal Kubernetes resource objects.

Examples can include special API paths such as health-related endpoints.

This demonstrates that RBAC can protect both:

```text
Kubernetes Resources
and
Non-Resource URLs
```

---

# Authentication vs Authorization

Keep these concepts separate.

```text
Authentication
→ Who are you?
```

```text
Authorization
→ What are you allowed to do?
```

A request can authenticate successfully and still receive an authorization denial.

---

# Authorization vs Admission

Authorization and admission also solve different problems.

```text
Authorization
→ Is the requested action allowed?
```

```text
Admission
→ Is the object/request acceptable after authorization?
```

Admission can apply validation, mutation, defaults, or policy logic.

---

# Security Troubleshooting Flow

When an API operation is denied:

```text
Client Identity
      ↓
Authentication Successful?
      ↓
Authorization Allowed?
      ↓
Correct Role / ClusterRole?
      ↓
Correct Binding?
      ↓
Correct Namespace?
      ↓
Correct Verb / Resource?
      ↓
Admission Policy?
```

This is more reliable than immediately granting broader permissions.

---

# ServiceAccount Troubleshooting

For a workload that cannot access the Kubernetes API:

```text
Which ServiceAccount?
      ↓
Which Namespace?
      ↓
Credential Available?
      ↓
Role / ClusterRole?
      ↓
RoleBinding / ClusterRoleBinding?
      ↓
Requested Verb and Resource?
      ↓
Authorization Result?
```

Avoid solving every denial by binding `cluster-admin`.

---

# Security Blast Radius

Permission scope determines risk.

Conceptually:

```text
Namespace Role
→ Limited Scope
```

```text
ClusterRoleBinding
→ Potential Cluster-Wide Scope
```

Before granting permissions, identify the smallest scope that supports the required operation.

---

# Historical Authentication Context

The course lists older authentication mechanisms and examples.

Authentication options have evolved over Kubernetes versions.

The reusable concepts are:

```text
Identity
Authentication
Authorization
Admission
Least Privilege
```

rather than memorizing every historical authentication mechanism.

---

# Evidence Policy

Course usernames, namespaces, ServiceAccounts, command outputs, and role names are educational examples.

Do not fabricate:

```text
User Identities
ServiceAccount Tokens
Certificates
RoleBindings
Authorization Results
API Server Configuration
ClusterRole Rules
Command Output
```

Do not publish real tokens, client certificates, kubeconfig credentials, or sensitive API credentials.

Actual evidence must come from an authorized Kubernetes environment.

---

# Verification Checklist

- Authentication, authorization, and admission were distinguished.
- The API server was understood as the central secured API interface.
- ServiceAccount was connected to workload API identity.
- ServiceAccount identity format was introduced.
- Historical token behavior was not treated as a universal current implementation.
- RBAC subjects, verbs, and resources were distinguished.
- Role and RoleBinding were connected to namespace scope.
- ClusterRole and ClusterRoleBinding were connected to cluster-oriented scope.
- RoleBinding referencing a ClusterRole was distinguished from ClusterRoleBinding.
- Least privilege was treated as the default permission-design principle.
- Predefined roles such as view, edit, admin, and cluster-admin were introduced.
- Non-resource URL authorization was introduced.
- Troubleshooting focused on identity, scope, verbs, resources, and bindings before broadening permissions.
- Sensitive credentials were excluded from repository evidence.

## What I Learned

- Kubernetes API security is a pipeline of authentication, authorization, and admission.
- ServiceAccounts provide workload identities for API access.
- RBAC expresses who can perform which actions on which resources.
- Namespace-scoped and cluster-scoped permission models have different blast radii.
- RoleBindings and ClusterRoleBindings are not interchangeable.
- Least privilege is the correct starting point for Kubernetes authorization.
- Authorization problems should be debugged by inspecting identity, scope, role rules, and bindings rather than granting broad administrator access.
