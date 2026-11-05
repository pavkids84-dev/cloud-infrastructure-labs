# AWS Migration Foundations Lab

## Objective

Understand the AWS migration concepts introduced in the course, including organizational readiness, application migration strategies, online and offline data transfer, and architecture quality assessment.

The goal is to connect migration decisions to previously studied Linux, networking, storage, databases, AWS infrastructure, security, monitoring, and recovery practices rather than treating migration as a simple file-copy operation.

## Scope

```text
Cloud Migration
On-Premises to AWS
Application and Data Dependencies
AWS Cloud Adoption Framework (CAF)
Business Perspective
People Perspective
Governance Perspective
Platform Perspective
Security Perspective
Operations Perspective
Six Migration Strategies (6 Rs)
Seven Migration Strategies (7 Rs) Current Context
Rehosting
Replatforming
Refactoring / Re-architecting
Repurchasing
Retaining
Retiring
Relocating
Online Data Migration
AWS Storage Gateway
AWS DataSync
AWS Transfer Family
AWS Snow Family Historical Context
AWS Snowcone
AWS Snowball Edge
AWS Snowmobile
Migration Assessment
Initial Copy and Delta Synchronization
Cutover and Rollback
AWS Well-Architected Framework
Operational Excellence
Security
Reliability
Performance Efficiency
Cost Optimization
Sustainability
Troubleshooting
Evidence Policy
```

---

# Cloud Migration

Cloud migration is the process of moving an existing workload, its data, and the required operational dependencies from a source environment to a target environment.

The course introduces migration after compute, networking, storage, databases, infrastructure as code, and serverless services.

Conceptually:

```text
Existing Workload
      |
      v
Inventory and Dependency Discovery
      |
      v
Migration Strategy and Target Design
      |
      v
Data / Application Movement
      |
      v
Cutover
      |
      v
Application and Operational Verification
```

A successful copy of files or a successful EC2 launch alone does not establish a successful migration.

The migrated application must remain usable, secure, observable, recoverable, and consistent with its business requirements.

---

# Migration Is Not Simply Backup

```text
Backup
-> Maintain recoverable copies of data or configuration
```

```text
Migration
-> Move the intended workload and transition its operation
```

A migration project might require backups, but backup verification and migration verification answer different questions.

Examples of migration dependencies include:

```text
Application Servers
Databases
File Shares
DNS
Authentication
Firewall Rules
Certificates
Scheduled Jobs
External APIs
Monitoring
Backup and Recovery
```

The source and target must be evaluated as systems, not merely as collections of servers.

---

# AWS Cloud Adoption Framework

The course introduces the AWS Cloud Adoption Framework (AWS CAF) as a way to prepare for cloud adoption from six organizational perspectives.

```text
AWS CAF
   |
   +-- Business
   +-- People
   +-- Governance
   +-- Platform
   +-- Security
   +-- Operations
```

CAF describes how organizations prepare for and manage cloud transformation.

It is different from the AWS Well-Architected Framework, which assesses architecture quality and operational practices of workloads.

Reference: https://docs.aws.amazon.com/whitepapers/latest/overview-aws-cloud-adoption-framework/foundational-capabilities.html

---

# Business Perspective

The business perspective connects migration investment to business outcomes.

Typical questions:

```text
Why Migrate?
What Business Value Is Expected?
Which Services Are Most Important?
What Downtime Is Acceptable?
How Will Success Be Measured?
```

An application can be migrated technically without meeting the business case for moving it.

---

# People Perspective

The people perspective addresses organizational change, skills, responsibilities, and the workforce needed to operate cloud workloads.

```text
Existing Infrastructure Skills
             +
Cloud Service Skills
             +
New Roles and Procedures
             |
             v
Sustainable Cloud Operations
```

A migration plan should include ownership, training, escalation paths, and handover to the operating team.

---

# Governance Perspective

The governance perspective concerns policy, decision rights, risk, costs, and cloud-program management.

Typical controls include:

```text
Account Ownership
Budget Management
Tagging Standards
Change Approval
Auditability
Regulatory Requirements
Architecture Decisions
```

AWS Organizations, account boundaries, and cloud financial controls are examples of previously studied topics related to this perspective.

---

# Platform Perspective

The platform perspective focuses on the technical foundation for deploying and running applications in AWS.

```text
AWS Account / Landing Zone
        |
        v
VPC and Connectivity
        |
        v
Compute / Storage / Database
        |
        v
Application Workload
```

Source-to-target architecture must account for address ranges, routing, name resolution, load balancing, private access, persistence, and service limits.

---

# Security Perspective

Migration must preserve or improve the security properties of the workload.

Questions include:

```text
Who Can Access the Environment?
Where Are Sensitive Data Stored?
How Are Data Encrypted in Transit and at Rest?
Which Network Paths Are Necessary?
How Are Access and Changes Logged?
How Are Credentials Rotated?
```

A change in hosting location does not remove the need for least privilege, workload isolation, or incident response.

---

# Operations Perspective

The operations perspective focuses on how a workload is run, monitored, maintained, and recovered after migration.

```text
Service Monitoring
      |
      v
Incident Detection
      |
      v
Investigation
      |
      v
Recovery and Verification
      |
      v
Operational Improvement
```

The target environment needs runbooks, alerting, backup/restore procedures, ownership, and escalation contacts before cutover.

---

# Application Migration Strategies

The course presents six application migration strategies, commonly called the 6 Rs.

```text
Rehost
Replatform
Refactor / Re-architect
Repurchase
Retain
Retire
```

These are different decisions for different applications, not mandatory sequential steps for every workload.

The target approach should be chosen after workload assessment and dependency discovery.

---

# Rehosting

Rehosting is commonly called lift and shift.

An application is moved with little or no fundamental application redesign.

```text
On-Premises VM
      |
      v
AWS EC2
```

Possible benefits include reducing initial transformation complexity and moving workloads sooner.

Limitations include carrying existing operational inefficiencies, configuration problems, or licensing constraints into the target environment.

The migrated workload still requires validation of boot, networking, application health, and dependencies.

---

# Replatforming

Replatforming introduces some cloud-oriented improvements without fundamentally redesigning the application's main architecture.

Example:

```text
Self-Managed MySQL
         |
         v
Amazon RDS for MySQL
```

Moving a database to a managed service can reduce some server and database-infrastructure administration work.

It still requires evaluation of engine compatibility, extensions, data migration, connection configuration, backup policy, and application testing.

---

# Refactoring or Re-architecting

Refactoring changes the application architecture to benefit from cloud-native capabilities.

For example:

```text
Monolithic Application
          |
          v
Separated Application Services
          |
          +-- Container-based Workloads
          +-- Managed Data Services
          +-- Event-driven Components
```

Refactoring may improve independent deployment and scaling, but generally introduces more design, testing, and operational change than rehosting.

Microservices are one possible outcome, not a universal requirement.

---

# Repurchasing

Repurchasing replaces an existing product with a different service, often a SaaS offering.

```text
Self-Hosted Business Application
               |
               v
SaaS Product
```

Migration planning shifts toward data export/import, identity integration, vendor requirements, process changes, and contract or licensing considerations.

---

# Retaining

Retaining keeps selected applications in the source environment.

Reasons can include:

```text
Regulatory Constraints
Hardware Dependencies
Migration Risk
Low Business Priority
Application Dependencies
```

A retained workload may still need secure hybrid connectivity to migrated applications.

Retention is a deliberate strategy, not necessarily a failed migration.

---

# Retiring

Retiring decommissions workloads that no longer provide sufficient value or are no longer required.

Before retirement, verify:

```text
No Required Consumers
No Hidden Dependencies
Data Retention Requirements
Legal / Regulatory Obligations
Backup and Archival Requirements
Owner Approval
```

The removal of an unused workload can also eliminate operational cost and security exposure.

---

# Six Rs and Seven Rs Current Context

The course uses the historical 6 Rs classification.

Current AWS Prescriptive Guidance commonly uses the 7 Rs, adding Relocate.

```text
6 Rs in the Course
       +
Relocate
       =
7 Rs in Current AWS Guidance
```

Relocate describes moving an existing workload to a different compatible environment with limited application-level changes, such as moving compatible virtualized workloads between environments.

The 6 Rs should be retained as course context, while the 7 Rs should be recognized as the broader classification currently used in AWS migration guidance.

Reference: https://docs.aws.amazon.com/prescriptive-guidance/latest/large-migration-guide/migration-strategies.html

---

# Migration Strategy Diagrams

The course diagrams on pages 206 and 207 show a conceptual progression from moving workloads to the cloud toward managed platforms and cloud-native design.

```text
Move to Cloud
     |
     v
Move to Managed Platforms
     |
     v
Move to Cloud Native
```

This is a conceptual modernization path, not a required sequence.

One workload might be rehosted quickly and modernized later; another might be replatformed immediately.

---

# Online Data Migration

The course introduces three services for network-based data movement and hybrid storage workflows:

```text
AWS Storage Gateway
AWS DataSync
AWS Transfer Family
```

These services have different primary responsibilities.

A file-share integration, a managed data-copy task, and a protocol-compatible file-transfer endpoint should not be treated as interchangeable products.

---

# AWS Storage Gateway

The course introduces File, Volume, and Tape gateway modes.

File Gateway provides familiar file-access protocols while storing associated data in AWS storage.

Conceptually:

```text
On-Premises NFS / SMB Client
               |
               v
         File Gateway
               |
               v
          Amazon S3
```

This is useful when existing applications must continue using file-share access patterns while AWS object storage is integrated into the environment.

File Gateway is not simply a one-time bulk copy utility.

Local caching, asynchronous upload, S3 object semantics, and gateway availability matter during operation.

Reference: https://docs.aws.amazon.com/filegateway/latest/files3/file-gateway-concepts.html

---

# AWS DataSync

DataSync is a managed service for transferring file or object data between supported source and destination storage systems.

The course introduces transfers from on-premises NFS or SMB to AWS storage such as S3, EFS, or FSx.

A typical transfer path is:

```text
On-Premises File Server
        |
        v
   DataSync Agent
        |
        v
   DataSync Service
        |
        v
Amazon S3 / EFS / FSx
```

A DataSync agent is normally required when accessing an on-premises NFS or SMB server.

Some transfers entirely within AWS do not require an agent.

DataSync supports transfer scheduling, changed-data transfers, and data verification options.

However, a completed transfer task does not automatically prove application consistency, correct user access, or successful cutover.

References:

https://docs.aws.amazon.com/datasync/latest/userguide/what-is-datasync.html

https://docs.aws.amazon.com/datasync/latest/userguide/do-i-need-datasync-agent.html

---

# DataSync Architecture in the Course

The diagram on page 209 connects an on-premises NFS source and DataSync agent to AWS-managed transfer components and an S3 bucket.

```text
On-Premises
   |
   +-- Application Server
   +-- NFS Server
   +-- DataSync Agent
              |
              | Secure Network Transfer
              v
AWS
   |
   +-- DataSync Management
   +-- S3 Bucket
```

Transfer connectivity, agent health, task configuration, permissions, and destination access must all be validated.

---

# AWS Transfer Family

Transfer Family supports managed file-transfer workflows using familiar protocols, including SFTP, FTPS, and FTP in the course.

Conceptually:

```text
Existing File Transfer Client
             |
          SFTP / FTPS
             |
             v
       AWS Transfer Family
             |
             v
       Amazon S3 / EFS
```

This service is useful when a partner or legacy application needs to continue using a traditional file-transfer protocol.

It is different from DataSync's managed bulk or scheduled synchronization workflow.

FTP is not encrypted by default; SFTP or appropriately configured FTPS is generally preferable for sensitive data.

Current AWS documentation also includes additional options such as AS2 and browser-based transfers.

Reference: https://docs.aws.amazon.com/transfer/latest/userguide/

---

# Comparing Online Transfer Choices

```text
Need Existing NFS / SMB Access Integrated with S3?
       -> Consider Storage Gateway

Need Planned / Repeated Dataset Transfer and Verification?
       -> Consider DataSync

Need Existing SFTP / FTPS Client Workflow?
       -> Consider Transfer Family
```

Actual selection depends on source and target support, permissions, data characteristics, security, connectivity, operating mode, and costs.

---

# Initial Copy and Delta Synchronization

A common migration challenge is that source data can change while the initial copy is running.

```text
Source Dataset
      |
      v
Initial Transfer
      |
      v
Changes Continue on Source
      |
      v
Delta Synchronization
      |
      v
Cutover Preparation
```

Incremental transfer can reduce the amount of data that must move just before cutover.

However, incremental file copying alone does not guarantee transactional consistency for an active database.

Database engines may require replication, transaction-aware backup/restore, coordinated write freezes, or other database-specific migration mechanisms.

---

# Offline Data Migration

The course introduces the Snow Family as a historical example of physically moving large datasets when network-based transfer is impractical.

Conceptually:

```text
On-Premises Data
       |
       v
Physical Transfer Device
       |
       v
Secure Transport
       |
       v
AWS Data Import
```

Physical transfer is not automatically faster or safer than network transfer.

Shipping, import processing, chain of custody, encryption, and verification must be considered.

---

# AWS Snow Family Course Context

The course lists:

```text
AWS Snowcone
AWS Snowball / Snowball Edge
AWS Snowmobile
```

Historical course slides include specific storage sizes, compute specifications, and a truck-scale Snowmobile example.

These values are product-generation-specific, not timeless specifications.

**Current availability warning (2026):**

- AWS Snowcone was discontinued in November 2024.
- AWS Snowmobile was discontinued in March 2024.
- AWS Snowball Edge is no longer available to new customers. AWS has announced an end-of-support date of December 31, 2026, for Snowball devices in commercial Regions, with stated exceptions for certain restricted Regions.

Do not present the course devices as generally available options for a new migration project.

Current alternatives should be evaluated based on bandwidth, data size, required physical transfer, and AWS availability in the relevant Region.

AWS documents point new customers toward options such as DataSync, Data Transfer Terminal, and partners.

References:

https://docs.aws.amazon.com/snowball/latest/developer-guide/snowball-edge-availability-change.html

https://aws.amazon.com/snowball/

https://docs.aws.amazon.com/general/latest/gr/full_shutdown_services.html

---

# Online vs Offline Transfer Decision

The transfer method should be selected using more than data size alone.

Important factors include:

```text
Dataset Size
Available Bandwidth
Network Reliability
Transfer Window
Data Change Rate
Encryption Requirements
Shipping Constraints
Compliance
Cost
Validation Process
```

A fast initial transfer is insufficient if the source continues changing and no cutover synchronization strategy exists.

---

# Migration Assessment and Planning

The course introduces the strategy categories and transfer services; an end-to-end migration operating plan is an additional application of those concepts.

Before selecting the target design, collect:

```text
Application Owner
Business Criticality
Source Servers and OS
Application Dependencies
Database Engine and Version
Data Size and Change Rate
Network and DNS Dependencies
Authentication and Certificates
Recovery Requirements
Security and Compliance Requirements
Acceptable Downtime
```

An inventory without dependency mapping can result in moving individual servers while breaking the application as a whole.

---

# Migration Phases Current Context

Current AWS Prescriptive Guidance commonly organizes large migrations into:

```text
Assess
   |
   v
Mobilize
   |
   v
Migrate and Modernize
```

This is supplementary process context beyond the short course diagrams.

The assess phase establishes the business and technical case.

The mobilize phase prepares the organization, environment, skills, and runbooks.

The migrate phase performs the actual move and verification.

Reference: https://docs.aws.amazon.com/prescriptive-guidance/latest/large-migration-guide/phases.html

---

# Cutover

Cutover is the controlled transition from the source workload to the target workload.

Conceptually:

```text
Pre-Cutover Validation
         |
         v
Freeze / Control Source Writes When Required
         |
         v
Final Synchronization
         |
         v
Change DNS / Routing / Application Endpoint
         |
         v
Verify Target Service
         |
         v
Monitor and Confirm Completion
```

The exact process depends on application architecture, database consistency, and allowable downtime.

DNS TTL can influence client transition timing, but lowering TTL does not guarantee instantaneous global cutover.

---

# Rollback and Recovery

Every significant cutover should define failure conditions and a recovery plan.

```text
Target Verification Failed?
          |
          v
Evaluate Rollback Criteria
          |
          v
Restore Previous Routing / Endpoint
          |
          v
Validate Data Consistency
          |
          v
Confirm Application Recovery
```

Returning clients to the old environment may not be safe if writes already occurred in the new environment.

Rollback must account for data divergence, not only DNS changes.

---

# AWS Well-Architected Framework

The final technical slide of the course introduces the AWS Well-Architected Framework.

It provides a set of architecture and operations review principles based on six pillars:

```text
Operational Excellence
Security
Reliability
Performance Efficiency
Cost Optimization
Sustainability
```

It differs from the AWS CAF:

```text
AWS CAF
-> Organizational cloud adoption and transformation readiness
```

```text
AWS Well-Architected
-> Workload architecture and operating-practice quality
```

Reference: https://docs.aws.amazon.com/wellarchitected/latest/userguide/waf.html

---

# Operational Excellence Pillar

This pillar emphasizes effective operation, monitoring, automation, and continuous improvement.

Migration questions include:

```text
Are Runbooks Available?
Are Alerts Configured?
Can Changes Be Repeated Safely?
Can Operators Diagnose and Recover the Workload?
```

CloudWatch, logging, IaC, and operational verification are relevant foundations.

---

# Security Pillar

This pillar concerns protection of data, applications, identities, and infrastructure.

Migration questions include:

```text
Are IAM Permissions Least Privilege?
Is Sensitive Data Protected in Transit and at Rest?
Are Public Network Paths Necessary?
Are Logs and Audit Records Available?
```

A functional migrated service can still have unacceptable security exposure.

---

# Reliability Pillar

This pillar focuses on resilience and recovery from failures.

Migration questions include:

```text
Are Critical Components Redundant?
Are Backups Recoverable?
Is Recovery Tested?
Are Failure Domains Understood?
```

Multi-AZ and automatic replacement are useful but do not eliminate the need for data recovery planning.

---

# Performance Efficiency Pillar

This pillar concerns using computing and storage resources effectively as requirements change.

Migration questions include:

```text
Is EC2 Sized for the Actual Workload?
Is the Storage Type Appropriate?
Is Database Response Time Acceptable?
Does Network Latency Affect Dependencies?
```

A simple lift-and-shift can preserve inefficient source-system sizing.

---

# Cost Optimization Pillar

This pillar emphasizes managing resources and spending according to business needs.

Migration cost considerations include:

```text
Compute Charges
Storage Charges
Data Transfer
Load Balancers
NAT Gateways
Backups
Monitoring and Logs
Software Licenses
```

The cost of moving data and the ongoing cost of operating the target should be considered separately.

---

# Sustainability Pillar

This pillar focuses on efficient resource consumption and reducing environmental impact.

Examples include:

```text
Avoid Unused Resources
Right-Size Workloads
Reduce Unnecessary Data Retention
Use Appropriate Managed Services
Align Resources with Actual Demand
```

Sustainability and cost optimization can overlap, but they are not identical goals.

---

# Comparing CAF and Well-Architected

```text
AWS CAF
   |
   +-- Business
   +-- People
   +-- Governance
   +-- Platform
   +-- Security
   +-- Operations
```

```text
AWS Well-Architected
   |
   +-- Operational Excellence
   +-- Security
   +-- Reliability
   +-- Performance Efficiency
   +-- Cost Optimization
   +-- Sustainability
```

The first is principally about organizational transformation; the second evaluates how workloads are designed and operated.

---

# Migration Practice Workflow

A conceptual practice plan based on the course topics is:

```text
1. Document an Existing On-Premises Application
2. Identify Network, Database, and File Dependencies
3. Select One of the Migration Strategies
4. Design VPC, Security, Compute, and Storage Targets
5. Choose an Online Transfer Approach
6. Transfer Test Data to an Authorized AWS Environment
7. Verify Source and Destination Data
8. Validate Application Connectivity and Functionality
9. Plan Cutover and Rollback
10. Review the Six Well-Architected Pillars
11. Remove Disposable Lab Resources After Verification
```

This is a proposed practice workflow, not evidence that an actual migration has been performed.

---

# Example DataSync Inspection Commands

After an authorized DataSync task has been configured, relevant AWS CLI inspection commands can include:

```bash
aws datasync list-tasks
```

```bash
aws datasync describe-task --task-arn "$TASK_ARN"
```

```bash
aws datasync list-task-executions --task-arn "$TASK_ARN"
```

```bash
aws datasync describe-task-execution \
  --task-execution-arn "$TASK_EXECUTION_ARN"
```

The ARN variables must come from the user's actual environment.

Do not invent task states, source or destination identifiers, transfer statistics, or command output.

---

# Data Transfer Troubleshooting

For a failed NFS-to-S3 DataSync job:

```text
DataSync Task Failed
       |
       v
Agent Healthy?
       |
       v
NFS Server Reachable?
       |
       v
NFS Export and File Permissions Correct?
       |
       v
Network / Firewall / DNS Correct?
       |
       v
S3 Destination and IAM Access Correct?
       |
       v
Task Execution Error and Logs?
       |
       v
Transferred Data Verified?
```

A task can fail because of connectivity, authorization, unsupported file characteristics, destination behavior, or data changes during the transfer.

Use the actual task execution details rather than assuming a root cause.

---

# Application Cutover Troubleshooting

When the destination application is not accessible after cutover:

```text
DNS Resolves to Intended Endpoint?
       |
       v
Network Route and Firewall Allow Traffic?
       |
       v
Load Balancer Target Healthy?
       |
       v
Application Process Healthy?
       |
       v
Database and File Storage Reachable?
       |
       v
Authentication and Certificates Valid?
       |
       v
Application Data Consistent?
```

Application success requires user-facing functional verification, not only infrastructure resource health.

---

# Security Perspective

Migration can move data across trust boundaries and expose previously private services.

Protect:

```text
Migration Credentials
IAM Role Permissions
Transfer Network
Encryption Keys
Database Secrets
Sensitive File Contents
S3 Bucket Access
Audit Logs
```

Avoid making databases, file shares, or administrative ports publicly reachable merely to simplify a migration test.

---

# Cost Perspective

Migration costs can include both one-time and ongoing charges.

```text
One-Time / Temporary
-> Data Transfer
-> Temporary Compute
-> Transfer Tools
-> Parallel Source and Target Operation
```

```text
Ongoing
-> EC2 / RDS / Storage
-> Data Transfer
-> Monitoring
-> Backups
-> Network Infrastructure
```

Service pricing and availability are time-sensitive and must be verified for the intended Region and account before provisioning resources.

---

# Evidence Policy

Do not fabricate or publish:

```text
AWS Account IDs
Access Keys
Secret Access Keys
Session Tokens
IAM Role ARNs
VPC IDs
Subnet IDs
Server IP Addresses
Customer Data
NFS Export Details from Real Environments
S3 Bucket Names from Private Environments
DataSync Task ARNs
DataSync Execution IDs
Transfer Statistics
Migration Completion Results
CloudWatch Logs
Cost and Billing Values
Actual Cutover Times
```

Course illustrations, training values, and example CLI commands are educational references only.

A migration is not considered performed or verified without evidence from an authorized source and target environment.

---

# Verification Checklist

- Cloud migration was distinguished from backup or simple file copying.
- Application dependencies and source-to-target connectivity were recognized.
- AWS CAF was understood as an organizational cloud-adoption framework.
- The six CAF perspectives were identified.
- The course's six migration strategies were distinguished.
- Relocate was recognized as the additional strategy in current AWS 7 Rs guidance.
- Rehosting was distinguished from replatforming and refactoring.
- Retaining and retiring were understood as valid migration decisions.
- Storage Gateway, DataSync, and Transfer Family were compared by purpose.
- DataSync agents and online data transfer workflows were introduced.
- DataSync transfer completion was distinguished from application success.
- Initial data copying, delta synchronization, and cutover were connected.
- The historical Snow Family examples were not treated as current service availability guarantees.
- Snowcone, Snowmobile, and Snowball Edge availability changes were noted.
- The six Well-Architected pillars were identified.
- AWS CAF and AWS Well-Architected were distinguished.
- Rollback planning included data consistency, not just traffic switching.
- Actual migration evidence was not fabricated.

## What I Learned

- Migration is an application and operations transition, not simply a transfer of servers or files.
- AWS CAF identifies organizational capabilities needed to support cloud adoption.
- Migration strategies reflect different levels of change, cost, and risk for each application.
- Online transfer tools solve different problems: hybrid file access, managed synchronization, and protocol-based file exchange.
- Storage transfers require connectivity, permissions, consistency planning, and source-to-target verification.
- Snow Family device examples in historical training material require current availability checks.
- The Well-Architected Framework provides six pillars for evaluating target workload quality.
- Cutover, rollback, application validation, security, and operational readiness determine whether a migration is successful.
