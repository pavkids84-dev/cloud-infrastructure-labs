# AWS RDS Database Foundations Lab

## Objective

Understand managed relational databases on AWS through Amazon RDS, including database engines, DB instances, storage, Multi-AZ, read replicas, automated backups, snapshots, enhanced monitoring, Aurora, and the difference between managed RDS and a database installed directly on EC2.

## Scope

```text
Relational Database
Amazon RDS
DB Instance
DB Instance Class
DB Storage
Multi-AZ
Read Replica
Automated Backup
Point-in-Time Recovery
Manual Snapshot
Enhanced Monitoring
RDS vs Database on EC2
Amazon Aurora
MySQL Client Connectivity
Security Group Access
Cleanup
```

---

# Relational Database Context

Relational databases organize data through structured schemas and relationships.

Typical characteristics include:

```text
Defined Schema
Data Integrity
Relationships
SQL Queries
JOIN Operations
```

They are useful when consistency, relationships, and structured transactions are important.

---

# Amazon RDS

Amazon Relational Database Service is a managed relational database service.

AWS manages parts of the database infrastructure lifecycle such as:

```text
Underlying Host Management
Operating System Access
Backup Automation
Software Patching
Failure Detection
Recovery Operations
```

Customers continue to manage database-level concerns such as:

```text
Schema
Users
Queries
Application Connectivity
Parameter Choices
Network Access
Data Lifecycle
```

---

# Supported Engine Concept

The course introduces engines such as:

```text
PostgreSQL
MySQL
MariaDB
Oracle Database
Microsoft SQL Server
Amazon Aurora
```

Engine availability, versions, and pricing should be checked in current AWS documentation when implementing a real environment.

---

# DB Instance

An RDS DB instance is an isolated managed database environment.

Conceptually:

```text
Application
    ↓
RDS Endpoint
    ↓
DB Instance
    ↓
Managed Storage
```

The instance class determines compute and memory characteristics.

---

# RDS Storage

The course introduces general-purpose SSD and provisioned-IOPS storage concepts.

The reusable design question is:

```text
What I/O Pattern Does the Database Need?
```

Consider:

```text
Latency
IOPS
Throughput
Consistency
Storage Growth
Cost
```

Do not select storage only by capacity.

---

# Multi-AZ

Multi-AZ is primarily a high-availability design.

Conceptually:

```text
Primary DB
   ↓ synchronous replication
Standby DB in another AZ
```

When the primary becomes unavailable, failover can move service to a standby.

The key idea is:

```text
Multi-AZ
→ Availability / Failover
```

not read scaling.

---

# Read Replica

A read replica is primarily used to offload read traffic.

Conceptually:

```text
Primary
├── Read / Write
└── Asynchronous Replication
        ↓
    Read Replica
        ↓
      Read
```

The key idea is:

```text
Read Replica
→ Read Scaling
```

This must not be confused with the Multi-AZ standby role.

---

# Multi-AZ vs Read Replica

```text
Multi-AZ
→ High Availability
→ Failover
→ Synchronous or service-managed HA replication context
```

```text
Read Replica
→ Read Performance
→ Read Scaling
→ Asynchronous replication context
```

These features solve different problems.

---

# Automated Backup

The course introduces automated backup of the DB instance and point-in-time recovery.

Conceptually:

```text
DB Changes Over Time
      ↓
Automated Backup
      ↓
Recovery Window
      ↓
Restore to Selected Point
```

Retention periods and current service-specific limits should be verified at implementation time.

---

# Manual Snapshot

A snapshot represents a database state at a specific point in time.

Conceptually:

```text
DB Instance
   ↓
Snapshot
   ↓
Restore
   ↓
New DB Instance
```

A restore does not simply overwrite the existing DB instance in place.

This distinction is important for recovery planning.

---

# Recovery Perspective

A backup is useful only when it can actually be restored.

A useful validation workflow is:

```text
Create Backup
      ↓
Restore
      ↓
Connect
      ↓
Verify Schema / Data
      ↓
Confirm Application Access
```

This is more meaningful than checking only whether a snapshot exists.

---

# Enhanced Monitoring

The course introduces enhanced monitoring as a way to collect more detailed operating-system-level metrics for RDS.

Conceptually:

```text
Managed DB Host Metrics
      ↓
Enhanced Monitoring
      ↓
Operational Visibility
```

The collection interval, retention behavior, and available metrics should be verified for the selected engine and current service configuration.

---

# RDS vs Database on EC2

## RDS

```text
AWS Manages More Infrastructure
No SSH to the Managed Database Host
Managed Backup / Patching Features
Parameter Groups for Supported Configuration
Less OS-Level Control
```

## Database on EC2

```text
Full OS Access
More Customization
Customer Manages Patching
Customer Manages Backup
Customer Manages Database Availability Design
```

The decision is a tradeoff between management convenience and control.

---

# Amazon Aurora

The course introduces Aurora as an AWS relational database compatible with MySQL and PostgreSQL ecosystems.

Core ideas:

```text
Managed Relational Database
Distributed Storage Architecture
High Availability
Read Scaling
Backup Integration
```

Exact performance claims, replica limits, and internal implementation details are time-sensitive and should be verified when designing a real production system.

---

# Course Practice Flow

The course practice uses MySQL on RDS.

The workflow is:

```text
Create RDS MySQL DB Instance
      ↓
Configure Storage
      ↓
Configure VPC and Security Group
      ↓
Obtain Endpoint
      ↓
Connect with MySQL Workbench
      ↓
Run Basic SQL
      ↓
Delete DB Instance
```

---

# Connectivity Model

A database connection requires more than a valid username and password.

Check:

```text
DB Instance Available?
      ↓
Correct Endpoint?
      ↓
Correct Port?
      ↓
Network Route?
      ↓
Security Group?
      ↓
Public or Private Reachability?
      ↓
Database Authentication?
```

---

# Security Warning for the Course Practice

The course practice uses a publicly accessible RDS configuration and a sample master password.

These settings must be treated as training examples only.

For a stronger architecture:

```text
Application in Private Network
      ↓
Security Group Reference
      ↓
RDS in Private Subnet
```

Avoid exposing a production database directly to the public Internet.

Never commit:

```text
Database Passwords
RDS Endpoints from Real Accounts
Security Group IDs
Account IDs
Connection Strings with Credentials
```

---

# Basic SQL Verification

The course uses simple SQL statements such as:

```sql
SHOW DATABASES;
SHOW TABLES;
```

The purpose is to confirm that:

```text
Network Access
+
Authentication
+
Database Session
```

all work.

Actual database contents and user-created records should come from a real authorized lab environment.

---

# RDS Troubleshooting Workflow

```text
Cannot Connect
      ↓
DB Status
      ↓
Endpoint / Port
      ↓
Security Group
      ↓
Subnet / Route
      ↓
Public or Private Reachability
      ↓
Credentials
      ↓
Database User Permission
```

For application failures, continue with:

```text
Connection Pool
TLS Settings
DNS Resolution
Parameter Group
Engine Logs
Application Logs
```

---

# Multi-AZ Troubleshooting Perspective

A running standby does not mean every application failure automatically disappears.

Check:

```text
Database Failover
      ↓
Endpoint Behavior
      ↓
Application Reconnection
      ↓
Connection Pool Recovery
      ↓
Application Verification
```

Availability must be verified at the application layer.

---

# Backup and Restore Troubleshooting

```text
Snapshot Exists?
      ↓
Correct Recovery Point?
      ↓
Restore New DB Instance
      ↓
Security / Network Access
      ↓
Connect
      ↓
Verify Data
      ↓
Redirect Application if Needed
```

Do not treat backup existence as proof of recoverability.

---

# Evidence Policy

Do not fabricate or publish:

```text
RDS Endpoint
DB Instance Identifier
Security Group ID
Subnet Group ID
Account ID
Master Password
Snapshot Identifier
Actual SQL Output
Actual Restore Timing
Billing Values
```

Use actual evidence only from an authorized AWS environment.

---

# Verification Checklist

- RDS was understood as a managed relational database service.
- DB instance and instance class concepts were introduced.
- Storage choices were connected to workload I/O needs.
- Multi-AZ was connected to availability and failover.
- Read replicas were connected to read scaling.
- Automated backup and point-in-time recovery were distinguished from manual snapshots.
- Snapshot restore was understood to create a new DB instance.
- Enhanced monitoring was introduced.
- RDS and a database on EC2 were compared.
- Aurora was introduced.
- Public database exposure in the course practice was treated as training-only.
- Backup existence was separated from successful restore verification.

## What I Learned

- Managed databases reduce operating-system and platform-management responsibilities.
- Multi-AZ and read replicas solve different problems.
- Database availability depends on both database infrastructure and application reconnection behavior.
- A backup strategy is incomplete until restore is tested.
- Database network exposure should be minimized.
