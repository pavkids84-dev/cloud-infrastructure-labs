# AWS CloudFormation Foundations Lab

## Objective

Understand Infrastructure as Code (IaC) and AWS CloudFormation as a way to define, provision, update, inspect, and delete AWS infrastructure through templates and stacks.

The goal is to connect CloudFormation concepts with the course's WordPress stack workflow, change management, drift detection, troubleshooting, verification, and resource cleanup.

## Scope

```text
Infrastructure as Code
Declarative Infrastructure Definition
Version Control
AWS CloudFormation
Template
Stack
Stack Lifecycle
Stack Update
Change Set
Automatic Rollback
JSON / YAML
Parameters
Conditions
Resources
Metadata
Mappings
Template Designer
Sample WordPress Template
Stack Events
Stack Outputs
Security Group Changes
Configuration Drift
Drift Detection
Drift Details
Template Reconciliation
Resource Replacement Risk
Stack Deletion
Cleanup Verification
Cost Awareness
Troubleshooting
Evidence Policy
```

---

# Infrastructure as Code

Infrastructure as Code (IaC) is an approach to defining and managing infrastructure through code rather than configuring every resource manually through a graphical interface.

The course introduces IaC for AWS infrastructure and operating-system environments.

A manual workflow may look like:

```text
AWS Management Console
        ↓
Create Resource A
        ↓
Configure Resource B
        ↓
Create Resource C
        ↓
Manually Repeat the Configuration
```

With IaC, the infrastructure definition becomes an artifact that can be inspected and reused.

```text
Infrastructure Requirements
        ↓
Code / Template
        ↓
Provisioning Service
        ↓
AWS Resources
```

IaC does not eliminate the need to understand the resources being created.

It makes their intended configuration easier to describe, repeat, review, and manage.

---

# Why IaC Matters

The course emphasizes several benefits:

```text
Readable Infrastructure Definition
Version-Controlled Changes
Repeatable Environments
Collaboration
Resource Lifecycle Management
```

For example, manually creating a VPC, subnet, security group, and EC2 instance twice can introduce inconsistent settings.

A reusable template provides a defined starting point for both environments.

```text
Template
   ├── Development Stack
   └── Test Stack
```

The environments may still differ because of parameters, account settings, Region availability, quotas, existing resources, or external dependencies.

Using the same template supports consistency; it does not guarantee identical runtime behavior in every environment.

---

# Version Control and Infrastructure

Infrastructure templates can be stored in a version-control system such as Git.

This allows a team to review:

```text
Who Changed the Definition?
What Changed?
When Was It Changed?
Why Was It Changed?
```

A useful intended workflow is:

```text
Infrastructure Change Request
        ↓
Edit Template
        ↓
Review Difference
        ↓
Commit Change
        ↓
Review Deployment Impact
        ↓
Update Stack
```

Version control records the template history.

It does not, by itself, prove that the deployed AWS resources currently match the template.

That distinction becomes important when studying drift detection.

---

# IaC Limitations

IaC also introduces operational complexity.

The course identifies:

```text
Learning Cost
Tool-Specific Syntax
Infrastructure Resource Knowledge
Dependency Management
Update Behavior
```

For a one-time, simple operation, a console workflow may be faster.

For repeated or shared infrastructure, templates can reduce inconsistent manual configuration.

A particular risk occurs when managed resources are changed directly in the console without updating the infrastructure definition.

```text
Version-Controlled Template
        ≠
Actual Resource Configuration
```

This difference is the foundation of configuration drift.

---

# AWS CloudFormation

AWS CloudFormation is an AWS service for modeling and provisioning AWS and supported third-party resources as infrastructure code.

The course describes CloudFormation as a way to manage related resources consistently throughout their lifecycle.

Conceptually:

```text
CloudFormation Template
        ↓
AWS CloudFormation
        ↓
Stack
        ↓
AWS Resources
```

Instead of treating each resource as an unrelated console operation, CloudFormation manages resources defined within a stack.

A template expresses infrastructure structure and dependencies; CloudFormation performs supported provisioning operations against AWS services.

---

# Template and Stack Are Different

A **template** is the infrastructure definition.

A **stack** is the CloudFormation-managed collection of resources created or managed from that definition.

```text
Template
→ Defines resources and configuration
```

```text
Stack
→ Manages the deployed resource collection
```

For example:

```text
wordpress-template.yaml
        ↓
WordPress Stack
        ├── EC2 Instance
        ├── Security Group
        └── Other Defined Resources
```

The exact resources depend on the selected WordPress template.

A template stored in Git is not the same as a deployed stack in an AWS account.

---

# Declarative Infrastructure Model

CloudFormation templates describe the intended infrastructure configuration.

A simplified model is:

```text
Expected Infrastructure Definition
        ↓
CloudFormation Operation
        ↓
Managed AWS Resources
```

This resembles a concept already introduced in Kubernetes:

```text
Kubernetes Manifest
        ↓
Desired State
        ↓
Kubernetes Controllers
        ↓
Workload Resources
```

However, CloudFormation and Kubernetes are not identical reconciliation systems.

CloudFormation stack operations and drift detection have their own lifecycle and support boundaries.

A template change should therefore be reviewed as an infrastructure operation, not assumed to be a harmless text edit.

---

# Stack

A CloudFormation stack groups resources so they can be managed together.

The course introduces three major stack operations:

```text
Create
Update
Delete
```

Conceptually:

```text
Create Stack
→ Provision Defined Resources

Update Stack
→ Apply Supported Configuration Changes

Delete Stack
→ Delete Managed Resources Where Allowed
```

This lifecycle model helps organize related infrastructure around a defined deployment unit.

---

# Stack Lifecycle

A useful lifecycle view is:

```text
Template Selected
        ↓
Stack Creation
        ↓
Resource Provisioning
        ↓
Stack Verification
        ↓
Template Change
        ↓
Stack Update
        ↓
Resource Verification
        ↓
Stack Deletion
        ↓
Cleanup Verification
```

A successful CloudFormation operation is not the same as a healthy application.

For example, an EC2 instance may be created while the application running on it is unavailable.

Stack status and application behavior must be checked separately.

---

# Stack Update

An existing stack can be updated to reflect changes to its template or supported parameters.

```text
Current Stack
        ↓
Updated Template / Parameters
        ↓
Stack Update
        ↓
Resource Changes
```

The important operational principle is to change the managed infrastructure definition deliberately rather than rely on undocumented console modifications.

Different properties have different update behaviors.

A change may update a resource in place, require resource replacement, or fail.

---

# Change Set

The course introduces a change set as a way to inspect proposed stack changes.

```text
Current Stack
        +
Proposed Template Change
        ↓
Change Set
        ↓
Review Proposed Changes
        ↓
Execute or Reconsider
```

A change set is useful because a small template edit may have a large operational effect.

For example:

```text
Property Change
   ├── Update Existing Resource
   ├── Replace Resource
   └── Remove / Add Resource
```

Change sets support review, but they are not a guarantee that an update will succeed or that an application will remain healthy.

---

# Automatic Rollback

The course explains automatic rollback when a stack creation operation fails.

Conceptually:

```text
Stack Creation
     ↓
Resource A Created
     ↓
Resource B Created
     ↓
Resource C Creation Failed
     ↓
Rollback
```

Rollback attempts to reverse a failed stack operation according to the operation and resource behavior.

It should not be interpreted as proof that every possible external effect or retained resource has disappeared.

After a rollback, inspect:

```text
Stack Status
Stack Events
Remaining Resources
Deletion or Retention Settings
Related Resource Charges
```

The course's general automatic-rollback explanation is a starting point; actual cleanup must still be verified.

---

# Stack Deletion

Deleting a stack requests deletion of its managed resources, subject to CloudFormation behavior and resource-specific rules.

```text
Select Stack
      ↓
Delete Stack
      ↓
Delete Managed Resources
      ↓
Inspect Deletion Results
```

The course also notes that a stack may fail to delete when AWS cannot delete a managed resource.

Deletion can be affected by dependencies, retention policies, service constraints, and resource state.

Never assume that selecting **Delete** guarantees that no billable resource remains.

---

# CloudFormation Template

A CloudFormation template is a JSON or YAML text document describing the resources and settings of a stack.

The course mentions templates stored locally or in Amazon S3.

```text
Local Template File
        or
S3-Hosted Template
        ↓
CloudFormation
        ↓
Stack
```

A template can be inspected and version controlled independently of the resources it provisions.

The course introduces template structure before the WordPress example.

---

# Template Sections

The course highlights these sections:

```text
Parameters
Conditions
Resources
Metadata
Mappings
```

Their roles differ:

| Section | Purpose | Required? |
| --- | --- | --- |
| Parameters | Accept values during stack creation or update | Optional |
| Conditions | Control conditional configuration or resource creation | Optional |
| Resources | Declare resources managed by the stack | Required for the course's standard resource template |
| Metadata | Store additional template-related information | Optional |
| Mappings | Define static lookup values | Optional |

Outputs also appear in the WordPress stack practice, because the deployed website link can be exposed as a stack output.

---

# Resources

`Resources` declares the resource objects CloudFormation should manage.

A resource entry identifies a logical name and an AWS resource type.

A conceptual structure is:

```yaml
Resources:
  ExampleResource:
    Type: AWS::Service::ResourceType
    Properties:
      ExampleProperty: ExampleValue
```

This is a **structural illustration**, not a deployable resource definition or the course's complete WordPress template.

Conceptually:

```text
Logical Resource ID
        ↓
Resource Type
        ↓
Resource Properties
        ↓
AWS Provisioning
```

CloudFormation templates describe dependencies between resources as part of infrastructure modeling.

The properties and constraints of each real resource type must be checked before deployment.

---

# Parameters

Parameters supply values when a stack is created or updated.

The course uses EC2 instance type selection as an example.

```text
Reusable Template
        ↓
Parameter: Instance Type
        ↓
Selected Value
        ↓
Stack Resource Configuration
```

Parameters let the same template support different inputs without duplicating the entire definition.

```text
Development
→ Smaller Instance Type

Production
→ Different Instance Type
```

Parameter values are not proof that a specific instance was actually provisioned.

That must be checked through stack and resource evidence.

---

# Conditions

Conditions allow parts of a template to depend on evaluated values.

Conceptually:

```text
Environment Parameter
        ↓
Is Production?
   ├── Yes → Create Conditional Resource
   └── No  → Skip Conditional Resource
```

The course presents conditions as a mechanism for controlling whether resources are created.

This improves template reuse when environments require different resource combinations.

---

# Metadata

`Metadata` is an optional template section for additional structured information.

It can provide descriptive or tooling-related information about the template or resources.

```text
Template
   ├── Infrastructure Definition
   └── Additional Metadata
```

Metadata should not be confused with the required resource declarations that trigger provisioning.

---

# Mappings

`Mappings` defines static lookup tables inside a CloudFormation template.

The course compares mappings with a programming-language `switch` statement.

A more precise model is:

```text
Lookup Key
      ↓
Mapping Table
      ↓
Matching Stored Value
```

For example:

```text
Region A → AMI A
Region B → AMI B
```

Mappings are not a general-purpose programming-language control-flow mechanism.

They provide predefined values that other template expressions can reference.

---

# Outputs

A stack may expose values that are useful after provisioning.

The course checks a website link after deploying the WordPress example.

Conceptually:

```text
Stack Provisioning
        ↓
Application Endpoint Created
        ↓
Stack Output
        ↓
Website URL
```

Possible output categories include:

```text
Application URL
DNS Name
Resource Identifier
```

An output value identifies a resource or endpoint; it does not by itself prove that the application is functioning.

---

# CloudFormation Cost Model

The course explains that CloudFormation itself does not add a charge for the ordinary provisioning operations covered by this training, while resources created through CloudFormation are billed according to their AWS service pricing.

```text
CloudFormation Template
        ↓
Create EC2 / Storage / Network Resources
        ↓
Charges for Provisioned AWS Resources
```

Examples of potentially billable resources include:

```text
EC2 Instances
EBS Volumes
Elastic IP / Public IPv4
Load Balancers
NAT Gateways
Data Transfer
Other AWS Resources
```

Exact service pricing and any service-specific CloudFormation charges should be checked against current AWS pricing before deployment.

IaC makes resource creation repeatable; it does not automatically prevent unintended costs.

---

# Practice Workflow

The course's Module 8 practice consists of three stages:

```text
1. Deploy a WordPress instance using CloudFormation
2. Create drift, inspect drift, and update the template
3. Delete the stack
```

The overall learning workflow is:

```text
Select Sample Template
        ↓
Create WordPress Stack
        ↓
Inspect Stack Events
        ↓
Open WordPress Website
        ↓
Change Security Group Manually
        ↓
Detect Drift
        ↓
Inspect Drift Details
        ↓
Update Template / Stack
        ↓
Detect Drift Again
        ↓
Delete Stack
```

The following sections reconstruct the course workflow.

They do not claim that this procedure was executed in an AWS account during documentation.

---

# WordPress Stack Practice

The course selects an AWS sample template for a WordPress deployment.

This practice is primarily about understanding the relationship between a template, a stack, and the resulting resources.

It is not presented as an exercise in writing the entire WordPress template from scratch.

The console workflow is:

```text
CloudFormation Console
        ↓
Create Stack
        ↓
Specify Template
        ↓
Specify Stack Details
        ↓
Configure Stack Options
        ↓
Review
        ↓
Create Stack
```

The course's stack name, example instance type, credentials, and other input values are training examples, not values to copy into a real account.

---

# Sample Template

The course uses a preexisting WordPress sample template.

```text
Sample Template
       ↓
CloudFormation Template Content
       ↓
Stack Resources
       ↓
WordPress Application
```

The resource graph and application behavior depend on the actual sample template version and chosen parameters.

Do not assume that every WordPress sample template provisions exactly the same resource types.

A real deployment should start by inspecting the selected template and identifying its resources, parameters, security rules, and potential costs.

---

# CloudFormation Designer

The course displays the WordPress template using CloudFormation Designer.

Designer provides a visual representation of template resources and their relationships.

```text
Template Definition
       ↕
Visual Resource Diagram
```

A diagram helps explain the model, but it is not evidence that every resource has been successfully deployed.

The resource definitions and actual stack state should still be inspected.

---

# Stack Options and Review

Before creating the WordPress stack, the course configures stack options and reviews the planned deployment.

Useful questions before creation include:

```text
Which Template Is Selected?
Which Parameters Are Supplied?
Which Resources May Be Created?
Which Region and Account Are Targeted?
Which Security Rules Are Defined?
Which Resources May Generate Charges?
```

When operating a real account, review the template rather than treating sample infrastructure as automatically production-safe.

---

# Stack Events

After stack creation, the course opens CloudFormation stack events.

Events provide an operational timeline of resource actions and reported failures.

```text
Stack Operation
       ↓
Resource Events
       ↓
Resource Status
       ↓
Failure Reason or Completion Evidence
```

When a resource fails, investigate the failed resource and its reported status reason.

An overall stack failure does not identify the root cause on its own.

---

# WordPress Application Verification

The course opens the website link returned by the WordPress stack.

The intended verification sequence is:

```text
Stack Creation Complete?
        ↓
Output Website Link Available?
        ↓
Browser Can Reach Endpoint?
        ↓
WordPress Page Responds?
```

A stack reporting `CREATE_COMPLETE` only establishes the reported outcome of the CloudFormation operation.

Application availability requires a separate check.

The course screenshots are educational references, not a fresh browser test or an observed deployment in this document.

---

# Configuration Drift

Configuration drift occurs when a CloudFormation-managed resource's actual supported configuration differs from the expected configuration in the stack definition.

For example:

```text
Template Expected State
        ↓
Security Group Rule Set A
```

A manual console change may produce:

```text
Actual AWS State
        ↓
Security Group Rule Set B
```

The states are no longer aligned.

```text
Expected State ≠ Actual State
```

This undermines the assumption that the template alone accurately represents the deployed resource configuration.

---

# Course Security Group Change

The course intentionally changes the security group associated with the CloudFormation-created EC2 instance.

The relevant workflow is:

```text
Locate the WordPress EC2 Instance
        ↓
Inspect the Associated Security Group
        ↓
Modify a Security Group Rule in the Console
        ↓
Actual Resource Configuration Changes
        ↓
Template Remains Unchanged
```

The purpose is to create a difference that can be investigated with drift detection.

This is a controlled training scenario, not a recommendation to make unmanaged production security-group changes.

---

# Drift Detection

CloudFormation drift detection checks supported managed resources for differences between expected and actual configuration.

```text
CloudFormation Stack Definition
        ↓
Expected Property Values
        ↕
Actual Supported Resource Properties
        ↓
Drift Detection Result
```

The course starts drift detection after the security-group change.

Its purpose is to reveal configuration differences rather than silently assume the live environment matches the template.

---

# Drift Results

The course inspects resource-level drift information.

Important terms include:

```text
IN_SYNC
→ No detected difference in the checked supported properties

MODIFIED
→ Detected difference in a managed resource
```

The course's screenshots show the changed security-group resource as modified before reconciliation and in sync after the later update and drift check.

Drift detection does not guarantee complete coverage of every AWS resource type or every property.

A reported in-sync state should therefore be interpreted within the service's supported detection scope.

---

# Drift Details

A drift summary indicates that a difference was found.

Drift details help determine what changed.

```text
Stack Drift Result
        ↓
Affected Resource
        ↓
Expected Property
        ↓
Actual Property
        ↓
Review the Difference
```

The course examines drift details before updating the template.

This evidence-based investigation is more useful than modifying resources blindly.

---

# Drift Is Not the Same as Incorrect Configuration

A detected difference does not automatically identify which state is correct.

Consider:

```text
Template
→ Security Rule Set A

Actual Resource
→ Security Rule Set B
```

The manual change may represent:

```text
A Legitimate New Requirement
An Accidental Change
An Unauthorized Change
A Temporary Troubleshooting Change
```

Drift detection reveals a difference.

An operator must still decide whether to revert the live configuration, update the template, or investigate a possible security incident.

---

# Template Reconciliation

The course reconciles the drift by incorporating the intended live change into the template and updating the stack.

```text
Manual Security Group Change
        ↓
Drift Detected
        ↓
Inspect Drift Details
        ↓
Decide Intended Configuration
        ↓
Edit Template
        ↓
Update Stack
        ↓
Detect Drift Again
        ↓
Verify Synchronization
```

This is an example of making the managed infrastructure definition consistent with the intended resource configuration.

The correct reconciliation direction depends on whether the manual change was approved and desirable.

---

# Updating the WordPress Template

The course opens the stack template in Designer, reflects the observed drift in the template definition, saves the updated template, and applies the stack update.

Conceptually:

```text
Drift Details
        ↓
Template Editing
        ↓
Updated Resource Properties
        ↓
Save Template
        ↓
Update Stack
```

The precise property edited must match the actual template and the drift details.

Do not copy security-group identifiers, console values, or rule entries from screenshots as if they belonged to another AWS environment.

---

# Confirming the Stack Update

After the template change, the course checks the stack update result.

A safe interpretation workflow is:

```text
Stack Update Started
        ↓
Inspect Stack Events
        ↓
Check Update Status
        ↓
Inspect Affected Resource
        ↓
Verify Intended Configuration
```

A successful stack update indicates that the CloudFormation operation completed.

It does not automatically establish that every network access path or application function is correct.

---

# Rechecking Drift

The course runs drift detection again after updating the stack.

```text
Template Updated
        ↓
Stack Update Completed
        ↓
Drift Detection Executed Again
        ↓
Supported Resource Properties Compared
        ↓
In-Sync Result Checked
```

The intended outcome is that the reviewed configuration difference has been reconciled.

This verification step is essential because changing the template alone does not prove that the deployed resource is synchronized.

---

# Source of Truth

A useful IaC operating model places the intended infrastructure definition under version control.

```text
Git
 ↓
Reviewed Template
 ↓
CloudFormation Stack Operation
 ↓
AWS Resources
```

Unreviewed console changes can break the relationship between the committed definition and deployed resources.

Drift detection and reconciliation help investigate that gap.

However, CloudFormation does not continuously guarantee that every manual change is corrected automatically.

---

# Resource Update and Replacement Risk

A template change can have effects beyond the size of the code difference.

```text
Template Property Change
         ↓
CloudFormation Update Behavior
         ├── Update in Place
         ├── Replace Resource
         └── Operation Failure
```

For infrastructure that holds data or serves production traffic, resource replacement can be particularly significant.

Review proposed changes before updating a live stack.

This is one reason the change-set concept matters.

---

# Safe Update Workflow

A practical sequence for an authorized deployment is:

```text
Edit Template
      ↓
Review and Validate Template
      ↓
Review Proposed Stack Changes
      ↓
Check Replacement / Deletion Risk
      ↓
Apply Stack Update
      ↓
Inspect Events
      ↓
Verify Resource State
      ↓
Verify Application Behavior
```

The course introduces stack updates and change sets; this sequence connects those concepts to controlled operational verification.

Never use a production stack for uncontrolled drift experiments.

---

# CloudFormation Troubleshooting

CloudFormation failures should be investigated through reported resource events and the infrastructure dependencies they reveal.

```text
Stack Status
      ↓
Stack Events
      ↓
Failed Resource
      ↓
Status Reason
      ↓
Relevant AWS Service / Configuration
      ↓
Correction
      ↓
Retry or Recovery
      ↓
Verification
```

Potential areas to investigate include:

```text
Template Syntax or Properties
Parameter Values
IAM Permissions
Resource Dependencies
Service Quotas
Network Configuration
Resource Naming Conflicts
Region-Specific Availability
```

Do not treat a failed stack operation as an unspecified CloudFormation problem without examining evidence.

---

# WordPress Troubleshooting Layers

The sample application spans both provisioning and runtime behavior.

```text
CloudFormation Template
        ↓
Stack Operation
        ↓
EC2 / Security Group Resources
        ↓
Network Access
        ↓
WordPress Application
```

If the stack completes but WordPress cannot be reached, investigate the application and network layers separately from the stack operation.

```text
Stack Completed?
      ↓
EC2 Instance Available?
      ↓
Security Group Allows Intended Traffic?
      ↓
Route / Network Path Correct?
      ↓
Web Service Running?
      ↓
Application Responding?
```

Do not change security rules broadly just to make the demonstration succeed.

---

# Stack Deletion Practice

The last course practice step deletes the CloudFormation stack.

```text
Select WordPress Stack
        ↓
Choose Delete
        ↓
CloudFormation Deletes Managed Resources
        ↓
Review Deletion Events and Status
```

The course screenshots demonstrate the deletion action, not fresh cleanup evidence from this document.

Deletion of a resource can fail, and some resources may be deliberately retained according to configuration.

---

# Cleanup Verification

For a temporary infrastructure lab, the lifecycle is not complete until cleanup has been checked.

```text
Delete Requested
        ↓
Deletion Outcome Verified
        ↓
Remaining Managed Resources Checked
        ↓
Related AWS Resources Checked
        ↓
Unexpected Charges Investigated
```

Depending on the deployed template, checks may include:

```text
EC2 Instances
EBS Volumes / Snapshots
Security Groups
Elastic IP / Public IPv4 Resources
Other Resources Created by the Stack
```

Do not claim that a deleted stack always means every related resource or charge has disappeared.

---

# Relationship to Previous Study

CloudFormation builds on concepts already used in earlier infrastructure topics.

```text
Linux
→ Operating Systems and Services

Networking
→ Subnets, Routes, Security Boundaries

Docker
→ Repeatable Application Configuration

Kubernetes
→ Declarative Workload Definitions

AWS
→ Compute, Network, Storage, Security Resources

CloudFormation
→ Infrastructure as Code and Stack Lifecycle
```

A useful parallel is:

```text
Kubernetes
Manifest → Desired Workload Definition

CloudFormation
Template → Expected Infrastructure Definition
```

The systems have different controllers and operation models, but both benefit from explicit definitions and verification against running infrastructure.

---

# Security Perspective

IaC makes security configuration easier to review and reproduce, but it can also repeat insecure settings.

Important principles include:

```text
Review Security Group Rules
Use Least-Privilege IAM
Avoid Hardcoded Secrets
Inspect Template Changes
Restrict Access to Production Stacks
Treat Unexpected Drift as a Review Signal
```

The WordPress drift exercise modifies a security-group rule only to demonstrate configuration differences.

An actual security change requires evaluating the intended exposure, affected systems, and authorization.

---

# Evidence Policy

Do not fabricate or publish:

```text
AWS Account IDs
Stack IDs
Stack ARNs
Stack Events Presented as Actual Execution
Resource Physical IDs
EC2 Instance IDs
Security Group IDs
Security Group Rules from Real Accounts
WordPress Website URLs from Real Deployments
Public IP Addresses
Private IP Addresses
IAM Credentials
Passwords
Access Keys
Session Tokens
Drift Detection IDs
Drift Detection Output Presented as Actual Execution
Template Update Results Presented as Actual Execution
Stack Deletion Results Presented as Actual Execution
CLI Output
Billing Values
```

The course's console screenshots, sample values, and observed outcomes are educational references.

They do not establish that the documented procedure was executed in a separate AWS account.

Actual evidence must come from an authorized AWS environment.

---

# Verification Checklist

- Infrastructure as Code was understood as code-based infrastructure definition and management.
- The benefits of repeatability, version control, collaboration, and review were introduced.
- IaC learning cost and limitations were distinguished from its operational benefits.
- CloudFormation was understood as a resource provisioning and lifecycle management service.
- A CloudFormation template was distinguished from a deployed stack.
- Stack creation, update, and deletion were connected to managed resource lifecycles.
- Change sets were understood as a way to review proposed stack changes.
- Automatic rollback was introduced without assuming unconditional resource cleanup.
- YAML and JSON were recognized as template formats.
- Resources was identified as the principal resource-declaration section.
- Parameters, Conditions, Metadata, and Mappings were distinguished.
- Mappings were understood as static lookup tables rather than a general-purpose `switch` statement.
- Outputs were connected to values returned after a stack deployment.
- CloudFormation cost was distinguished from the costs of provisioned AWS resources.
- The course WordPress practice was understood as a sample-template-based deployment.
- Designer was understood as a template visualization tool.
- Stack Events were connected to progress inspection and troubleshooting.
- Stack creation status was distinguished from WordPress application availability.
- A manual EC2 security-group change was understood as the course drift scenario.
- Drift detection was understood as comparing supported expected and actual properties.
- A detected drift was not automatically classified as an incorrect live configuration.
- Resource-level drift details were connected to the decision to update or revert configuration.
- Template editing and stack update were connected to drift reconciliation.
- Repeated drift detection was understood as a necessary verification step after reconciliation.
- Template changes were recognized as capable of causing resource replacement.
- Change review, stack events, and application checks were included in safe update reasoning.
- Stack deletion was connected to cleanup verification and possible remaining charges.
- Course screenshots and example identifiers were not treated as real deployment evidence.

## What I Learned

- IaC turns an infrastructure configuration into a reviewable and reusable definition.
- CloudFormation uses templates to manage related AWS resources through stacks.
- Templates describe expected configuration, while stack and resource inspection reveal deployed state.
- Parameters and conditions support controlled reuse of a template across environments.
- Change sets help review infrastructure update impact before execution.
- Rollback and deletion simplify lifecycle management but still require verification.
- Stack Events are essential evidence when provisioning or updating resources fails.
- Drift detection exposes supported configuration differences after out-of-band changes.
- Detecting drift does not determine whether the template or the live modification reflects the correct requirement.
- Reconciliation should be based on reviewed intent, followed by a stack update and another verification step.
- Successful provisioning, application availability, and cleanup are separate outcomes that must be checked independently.
- The preferred long-term workflow is to review infrastructure changes in code and verify their effects in AWS.
