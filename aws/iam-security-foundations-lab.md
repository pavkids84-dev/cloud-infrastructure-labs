# AWS IAM and Security Foundations Lab

## Objective

Understand the AWS security concepts introduced in the course, including the shared responsibility model, major AWS security services, IAM identities and permissions, roles, MFA, AWS Organizations, organizational units, service control policies, and the IAM practice workflow.

## Scope

```text
Shared Responsibility Model
Security of the Cloud
Security in the Cloud
IAM
Root User
IAM User
IAM Group
IAM Policy
IAM Role
MFA
AWS Organizations
Organizational Unit
Service Control Policy
Least Privilege
Major AWS Security Services
IAM Practice Workflow
```

---

# Shared Responsibility Model

AWS security is based on a shared responsibility model.

Conceptually:

```text
AWS
→ Security OF the Cloud
```

```text
Customer
→ Security IN the Cloud
```

AWS is responsible for protecting the infrastructure that runs AWS services.

The customer is responsible for securing the workloads, data, identities, permissions, and configurations placed in AWS.

---

# AWS Responsibility

The course associates AWS responsibility with infrastructure layers such as:

```text
Physical Facilities
Hardware
Networking Infrastructure
Storage Infrastructure
Virtualization and Service Infrastructure
Global Infrastructure
```

The exact boundary depends on the AWS service model.

---

# Customer Responsibility

Customer responsibilities can include:

```text
Data
Identity and Access
Resource Configuration
Operating System Configuration
Application Security
Network Access Rules
Encryption Choices
Credential Protection
```

The exact amount of customer responsibility changes by service.

---

# Service Model and Responsibility

The responsibility boundary introduced in the previous cloud-computing module applies directly to security.

Conceptually:

```text
IaaS
→ More customer-managed layers

PaaS
→ More provider-managed platform layers

SaaS
→ More provider-managed application layers
```

Managed services reduce some operational responsibility, but they do not remove the customer's responsibility for secure configuration and authorized access.

---

# AWS Security Services Introduced by the Course

The course introduces several AWS security and compliance services.

```text
IAM
Inspector
ACM
WAF
Shield
GuardDuty
Secrets Manager
CloudHSM
KMS
```

These services solve different security problems and should not be treated as interchangeable.

---

# AWS Identity and Access Management

IAM controls access to AWS resources.

The core questions are:

```text
Who is the principal?
What action is requested?
Which resource is targeted?
Is the action allowed or denied?
```

IAM provides identities and permission policies for AWS access control.

---

# Amazon Inspector

The course presents Amazon Inspector as an automated security assessment service for identifying security risks and deviations from security best practices.

The reusable concept is:

```text
Workload
   ↓
Automated Security Assessment
   ↓
Findings
```

Course-era agent requirements should be treated as implementation details that can change over time.

---

# AWS Certificate Manager

AWS Certificate Manager, or ACM, manages SSL/TLS certificates for supported AWS services.

Conceptually:

```text
Certificate
   ↓
ACM
   ↓
Supported AWS Service
```

The course connects ACM with services such as Elastic Load Balancing and CloudFront.

---

# AWS WAF

AWS WAF is a web application firewall.

The course connects it with filtering and blocking malicious web traffic such as:

```text
SQL Injection
Script-Based Attacks
IP-Based Blocking
Geographic Filtering
```

AWS WAF protects the web application layer rather than replacing all network-layer security controls.

---

# AWS Shield

AWS Shield is introduced as a DDoS protection service.

The course distinguishes:

```text
Shield Standard
Shield Advanced
```

The detailed feature set and covered resources should be verified against current AWS documentation when implementing a real production design.

---

# Amazon GuardDuty

GuardDuty is introduced as a threat-detection service.

The course connects GuardDuty with analysis of AWS account and network activity such as:

```text
CloudTrail Events
VPC Flow Logs
DNS-Related Activity
Threat Intelligence
Anomaly Detection
Machine Learning
```

The reusable concept is continuous threat detection rather than manual inspection of every event.

---

# AWS Secrets Manager

Secrets Manager protects and manages sensitive application credentials and secrets.

Examples introduced by the course include:

```text
Database Credentials
SaaS Credentials
Third-Party API Keys
Other Application Secrets
```

Secrets should not be embedded directly into source code or public repositories.

---

# AWS CloudHSM

CloudHSM provides dedicated hardware security modules for cryptographic key operations.

Conceptually:

```text
Cryptographic Key
      ↓
Dedicated HSM
      ↓
Encryption / Signing Operations
```

CloudHSM is relevant when dedicated HSM control or specific compliance requirements are needed.

---

# AWS KMS

AWS Key Management Service provides managed cryptographic key management.

Conceptually:

```text
AWS KMS Key
      ↓
Encryption / Decryption
Signing / Verification
      ↓
AWS Services and Applications
```

KMS and CloudHSM both relate to cryptographic keys, but they provide different management models and control boundaries.

---

# AWS Account Root User

The course describes the account root identity as having complete access to AWS services and account resources.

The important operational rule is:

```text
Root User
→ Extremely Powerful Account Identity
```

The root user should not be used for routine administration.

Protect it carefully and enable strong MFA.

---

# Root User vs IAM

The root user is the original identity associated with the AWS account.

It should not be confused with an IAM user.

Conceptually:

```text
AWS Account Root User
!=
IAM User
```

Routine access should use appropriately scoped identities rather than the root user whenever possible.

---

# IAM User

An IAM user is an AWS identity that can be assigned permissions.

The course connects IAM users with people or applications that interact with AWS.

A newly created IAM user does not automatically receive permissions.

Conceptually:

```text
IAM User Created
      ↓
No Useful Permission by Default
      ↓
Policy or Group Membership
      ↓
Authorized AWS Actions
```

---

# Least Privilege

The course explicitly recommends least privilege.

Conceptually:

```text
Required Task
      ↓
Minimum Necessary Actions
      ↓
Minimum Necessary Resources
      ↓
Permission Policy
```

Avoid broad permissions when narrower permissions are sufficient.

---

# IAM Group

An IAM group is a collection of IAM users.

Conceptually:

```text
IAM Policy
    ↓
IAM Group
    ↓
User A
User B
User C
```

Groups simplify permission management for users that need similar access.

IAM groups contain users, not roles.

---

# IAM Policy

An IAM policy is a permissions document.

Important elements introduced by the course include:

```text
Effect
Action
Resource
```

Conceptually:

```text
Effect
→ Allow or Deny

Action
→ AWS API action

Resource
→ AWS resource affected by the action
```

A policy can be attached or associated in different ways depending on the IAM resource.

---

# Policy Evaluation Mindset

A useful way to read an IAM policy is:

```text
Who receives this policy?
Which actions are mentioned?
Which resources are targeted?
Is the effect Allow or Deny?
Are there additional conditions?
```

Do not judge a policy only by its name.

---

# IAM Role

An IAM role provides a set of permissions that can be assumed temporarily by a trusted principal.

Conceptually:

```text
Principal
   ↓
Assume Role
   ↓
Temporary Credentials
   ↓
Role Permissions
```

Roles are especially important for AWS services and workloads because they avoid embedding long-lived static access keys.

---

# EC2 and IAM Roles

The course demonstrates attaching an IAM role to an EC2 instance.

Conceptually:

```text
EC2 Instance
      ↓
IAM Role
      ↓
Temporary AWS Credentials
      ↓
Allowed AWS API Calls
```

This allows software running on the instance to access AWS resources according to the role's permissions.

---

# Role-Based Workload Access

A workload should not need hardcoded IAM-user credentials when an appropriate service role can be used.

Conceptually:

```text
Bad Pattern
Application
→ Embedded Long-Lived Access Key
```

```text
Preferred Pattern
Application on AWS Service
→ IAM Role
→ Temporary Credentials
```

The exact role mechanism depends on the AWS service.

---

# Multi-Factor Authentication

MFA requires more than one authentication factor.

Conceptually:

```text
Primary Credential
      +
Additional Authentication Factor
      ↓
Stronger Authentication
```

The exact supported MFA methods depend on the AWS identity and current AWS capabilities.

MFA is especially important for highly privileged identities.

---

# AWS Organizations

AWS Organizations centrally manages multiple AWS accounts.

Conceptually:

```text
Organization
   ↓
Root
   ↓
Organizational Units
   ↓
AWS Accounts
```

This is useful for environments where different teams, workloads, or environments use separate AWS accounts.

---

# Organizational Units

An Organizational Unit, or OU, groups AWS accounts.

Example conceptual structure:

```text
Organization
├── Production OU
│   ├── Account A
│   └── Account B
└── Development OU
    ├── Account C
    └── Account D
```

Policies can be applied at higher levels to create consistent organizational guardrails.

---

# Service Control Policies

Service Control Policies, or SCPs, restrict the maximum permissions available to accounts in an AWS Organization.

Important distinction:

```text
SCP
→ Permission Guardrail
```

```text
SCP
!=
Permission Grant
```

An SCP can limit which services or API actions are available, but an IAM principal still needs an IAM permission that allows the requested action.

---

# SCP Inheritance

Policies applied to organizational containers can affect child accounts.

Conceptually:

```text
Organization Root / OU
        ↓
SCP Guardrail
        ↓
Member Accounts
```

This enables centralized security boundaries across many accounts.

---

# IAM Practice Workflow in the Course

The course practice is organized as:

```text
1. Create IAM Group
2. Create IAM User
3. Sign In as Added User
4. Create IAM Role
5. Launch EC2 Using IAM Role
```

This workflow demonstrates the relationships among users, groups, policies, roles, and service permissions.

---

# Course Group Practice

The course creates a group named:

```text
EC2Admin
```

and attaches:

```text
AmazonEC2FullAccess
```

This is a training example.

For real environments, broad managed policies should not automatically be treated as the desired production permission model.

---

# Course User Practice

The course creates a user and adds it to the EC2-related group.

It then directly attaches an S3 full-access managed policy to the user.

The learning purpose is to demonstrate that permissions can come from:

```text
Group Membership
and
Direct Policy Attachment
```

In production design, permissions should remain as simple, reviewable, and least-privileged as practical.

---

# Course Console Permission Test

The course signs in as the created IAM user and checks access to multiple AWS services.

The intended observation is:

```text
EC2
→ Allowed by assigned permissions

S3
→ Allowed by assigned permissions

RDS
→ Not granted by the demonstrated permission set
```

These are course-environment results and must not be recorded as personal lab evidence unless reproduced in the user's own account.

---

# Course Role Practice

The course creates an EC2 service role and attaches S3 access.

Conceptually:

```text
EC2 Service
      ↓
Assume Role
      ↓
Role Permissions
      ↓
S3 Access
```

The role name shown in the course is an example only.

---

# Course EC2 Role Verification

The course launches an EC2 instance with the IAM role and tests AWS service access from the instance.

The intended learning point is:

```text
Allowed API
→ Works according to role permission

Unrelated API
→ Denied when role permission is absent
```

Do not copy the course bucket name, instance IP, passwords, or command results as personal evidence.

---

# Course Credential Warning

The course screenshots include a simple console password for training.

Do not reuse course credentials in a real AWS account.

Never commit:

```text
Passwords
Access Key IDs
Secret Access Keys
Session Tokens
MFA Secrets
Console Login Links
```

to GitHub.

---

# Security Troubleshooting Model

When an AWS API call fails with an access problem:

```text
Which Principal?
      ↓
Which Credential?
      ↓
Which Action?
      ↓
Which Resource?
      ↓
Which IAM Policies?
      ↓
Role / Group / User Permissions?
      ↓
Organizations SCP?
      ↓
Explicit Deny?
```

Do not solve every authorization failure by granting administrator access.

---

# Authentication vs Authorization

Keep the concepts separate.

```text
Authentication
→ Who are you?
```

```text
Authorization
→ What are you allowed to do?
```

IAM participates in both identity and permissions, but troubleshooting should still distinguish the two questions.

---

# Security and Previous Study

This module connects directly to earlier topics.

```text
Linux Users and Permissions
→ Local OS authorization concepts
```

```text
Kubernetes ServiceAccounts and RBAC
→ Workload identity and API authorization
```

```text
AWS IAM
→ AWS identity and API authorization
```

The systems are different, but the recurring design questions are similar:

```text
Who?
Can do what?
To which resource?
Under which scope?
```

---

# Evidence Policy

Do not fabricate or publish:

```text
AWS Account IDs
IAM User Names from Real Accounts
Access Key IDs
Secret Access Keys
Session Tokens
Passwords
MFA Secrets
Console Sign-In URLs
Real Policy ARNs
Role Credentials
Bucket Names from Private Environments
EC2 Public IP Addresses
CLI Output
Authorization Results
```

Course values and screenshots are educational examples only.

Actual evidence must come from an authorized AWS environment.

---

# Verification Checklist

- The shared responsibility model was understood.
- Security OF the cloud and security IN the cloud were distinguished.
- Major AWS security services were categorized by purpose.
- The root user was distinguished from IAM users.
- IAM users, groups, policies, and roles were distinguished.
- Least privilege was recognized as a core IAM principle.
- Policy `Effect`, `Action`, and `Resource` were introduced.
- IAM roles were connected to temporary permissions for workloads and services.
- MFA was connected to stronger authentication.
- AWS Organizations and OUs were introduced.
- SCPs were understood as guardrails rather than permission grants.
- The course IAM practice flow was understood without reusing its credentials.
- Course access results were not treated as actual lab evidence.

## What I Learned

- AWS security responsibility is divided between AWS and the customer.
- IAM controls AWS identities and permissions.
- Root credentials should not be used for routine administration.
- Users, groups, policies, and roles solve different identity and permission problems.
- IAM roles are a better workload-access pattern than embedding long-lived access keys.
- AWS Organizations provides centralized multi-account governance.
- SCPs restrict permission boundaries but do not grant permissions.
- Least privilege should guide every access-control decision.
