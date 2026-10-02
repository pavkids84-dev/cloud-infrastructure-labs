# AWS RDS Database Foundations Lab

## Objective

Understand relational database concepts in AWS and the operational differences between running a database on Amazon EC2 and using Amazon RDS.

## Scope

```text
Relational Databases
SQL and Schema
Amazon RDS
DB Instances
DB Instance Classes
RDS Storage
Multi-AZ
Read Replicas
Automated Backups
DB Snapshots
Point-in-Time Recovery
Enhanced Monitoring
RDS vs Database on EC2
Amazon Aurora
RDS Connectivity
Database Security
RDS Troubleshooting
```

---

# Relational Database Foundation

A relational database stores structured data in tables and uses defined relationships between data.

Typical concepts include:

```text
Table
Row
Column
Primary Key
Foreign Key
Schema
SQL
```

A relational model is useful when data integrity and relationships between records are important.

---

# SQL and Schema

The course contrasts relational databases with NoSQL databases.

Relational databases generally emphasize:

```text
Defined Schema
Data Integrity
Relationships
Structured Queries
```

A schema describes the expected structure of the data.

This structure can improve consistency but can also require more planning before major changes.

---

# Amazon RDS

Amazon Relational Database Service is a managed relational database service.

Conceptually:

```text
Application
    ↓
RDS Endpoint
    ↓
Managed Database Engine
```

AWS manages significant parts of the underlying database infrastructure, including supported maintenance operations, backups, and failure handling.

The customer still remains responsible for database design, users, credentials, query behavior, application integration, and many database configuration choices.

---

# Managed Service Boundary

RDS is not the same as installing MySQL or PostgreSQL directly on an EC2 instance.

With RDS:

```text
AWS
→ Underlying Host
→ Managed Database Infrastructure
→ Supported Maintenance Operations
```

The customer does not receive normal operating-system shell access to the managed database host.

This reduced host-level control is one of the main tradeoffs of using a managed database service.

---

# Supported Database Engines

The course introduces engines such as:

```text
PostgreSQL
MySQL
MariaDB
Oracle Database
Microsoft SQL Server
Amazon Aurora
```

Engine availability, versions, features, and pricing can change over time.

Actual implementation should verify current AWS documentation.

---

# DB Instance

A DB instance is an isolated database environment managed by Amazon RDS.

Conceptually:

```text
RDS DB Instance
├── Database Engine
├── Compute Capacity
├── Memory
├── Storage
└── Network Endpoint
```

Applications connect through the RDS endpoint rather than by logging into the underlying host operating system.

---

# DB Instance Class

RDS provides DB instance classes with different compute and memory characteristics.

The course uses examples such as:

```text
db.m5
db.r5
```

These are course-era examples.

Instance families and available sizes should be checked when building a current environment.

---

# RDS Storage

The course introduces storage categories such as:

```text
General Purpose SSD
Provisioned IOPS
Magnetic
```

The reusable selection principle is:

```text
Capacity
IOPS
Throughput
Latency
Cost
```

Storage should be selected according to workload behavior rather than only database size.

---

# Storage Auto Scaling

RDS can increase allocated storage automatically when configured for storage autoscaling.

Conceptually:

```text
Database Growth
      ↓
Free Storage Falls
      ↓
Storage Auto Scaling
      ↓
Allocated Capacity Increases
```

This should not be confused with automatically changing database compute capacity.

---

# Multi-AZ

The course presents Multi-AZ as a high-availability design.

Conceptually:

```text
AZ A
Primary DB
   ⇅
Synchronous Replication
   ⇅
Standby DB
AZ B
```

If the primary database becomes unavailable under supported failover conditions, RDS can fail over to a standby.

---

# Multi-AZ Purpose

The main purpose of Multi-AZ is:

```text
High Availability
Failure Recovery
```

It should not be treated as the same feature as read scaling.

A standby used for high availability is conceptually different from a read replica used to serve read traffic.

---

# Multi-AZ Course Numbers

The course includes specific failover-time examples.

Treat those values as course examples rather than guaranteed service-level timing.

Actual failover duration depends on configuration, failure mode, workload, DNS behavior, and current AWS implementation.

---

# Read Replica

A read replica is designed to offload read traffic from the primary database.

Conceptually:

```text
Primary DB
Read + Write
    ↓
Asynchronous Replication
    ↓
Read Replica
Read Workload
```

This can reduce read pressure on the primary.

---

# Read Replica and Multi-AZ Are Different

```text
Multi-AZ
→ Availability
→ Failover
```

```text
Read Replica
→ Read Scaling
→ Read Workload Distribution
```

Do not use these terms interchangeably.

---

# Replication Lag

Because read-replica replication can be asynchronous, an application should consider replication lag.

Conceptually:

```text
Write to Primary
      ↓
Replication Delay
      ↓
Replica Receives Update
```

A read immediately after a write can therefore require careful application design if the newest value must always be returned.

---

# Automated Backups

The course introduces RDS automated backups and point-in-time recovery.

Conceptually:

```text
RDS Instance
    ↓
Automated Backup Data
    ↓
Recovery Window
    ↓
Restore to Selected Time
```

Backup-retention defaults and limits are configuration- and service-dependent and should be verified in the current AWS console or documentation.

---

# DB Snapshots

A DB snapshot represents a database instance at a particular point in time.

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

A key operational point is that restoring a snapshot creates another DB instance rather than overwriting the existing DB instance in place.

---

# Backup vs Snapshot

A useful conceptual distinction is:

```text
Automated Backups
→ Managed backup history
→ Point-in-time recovery capability
```

```text
Manual Snapshot
→ Explicit recovery point
→ Retained until intentionally removed
```

Exact retention and feature behavior should be verified for the selected database engine.

---

# Enhanced Monitoring

The course introduces Enhanced Monitoring as additional operating-system-level visibility for RDS.

Conceptually:

```text
Managed DB Host Metrics
      ↓
Enhanced Monitoring
      ↓
Operational Visibility
```

This is different from ordinary service-level CloudWatch metrics.

---

# RDS Monitoring Layers

Useful database monitoring can include:

```text
CPU
Memory
Storage
Connections
Read / Write Activity
Latency
Database Logs
Application Errors
```

A healthy RDS resource does not automatically mean the application is healthy.

---

# RDS vs Database on EC2

The major tradeoff is operational control versus management responsibility.

```text
Amazon RDS
→ More Managed Operations
→ Less Host-Level Control
```

```text
Database on EC2
→ More Host-Level Control
→ More Operational Responsibility
```

With EC2, the team is responsible for more tasks such as:

```text
Operating System
Database Installation
Patching
Backups
High Availability Design
Monitoring
Recovery
```

---

# Service-Model Clarification

The course labels RDS as SaaS.

For infrastructure study, it is more useful to understand RDS as a managed database service rather than equating it with a typical end-user SaaS application.

The important boundary is operational responsibility, not the label itself.

---

# Amazon Aurora

The course introduces Amazon Aurora as a relational database service compatible with MySQL and PostgreSQL.

The reusable concepts are:

```text
Managed Relational Database
Distributed Storage Design
High Availability
Read Scaling
MySQL / PostgreSQL Compatibility
```

Specific performance multipliers, replica limits, and storage implementation numbers in course material should be treated as time-sensitive service details.

---

# RDS Practice Workflow

The course practice follows this sequence:

```text
Create MySQL RDS Instance
      ↓
Configure Storage
      ↓
Configure Network Access
      ↓
Connect with SQL Client
      ↓
Run SQL Queries
      ↓
Delete DB Instance
```

This sequence is useful for understanding the database lifecycle.

---

# Security Warning About Course Credentials

The course includes an example database password.

Do not reuse or publish course passwords in real environments.

Never commit actual database passwords, secrets, endpoints tied to private environments, or access credentials to Git.

Use a secure secret-management method for real projects.

---

# Public Accessibility Warning

The course enables public accessibility for the training RDS instance.

That setting is appropriate only when intentionally required for the lab architecture.

For production-oriented architecture, a common pattern is:

```text
Internet
   ↓
Public Application Tier
   ↓
Private Database Tier
```

The database should not be made publicly reachable merely for convenience.

---

# RDS Network Path

A database connection depends on multiple layers.

```text
Client
  ↓
DNS / RDS Endpoint
  ↓
Route
  ↓
Security Group
  ↓
Database Listener Port
  ↓
Database Authentication
  ↓
Database Authorization
```

A database connection failure should be investigated in this order instead of changing all security rules at once.

---

# RDS Connectivity Troubleshooting

Example workflow:

```text
DB Instance Available?
      ↓
Correct Endpoint?
      ↓
Correct Port?
      ↓
Client Has Network Route?
      ↓
RDS Security Group Allows Client?
      ↓
Database User Correct?
      ↓
Password / Authentication Correct?
      ↓
Database Exists?
```

---

# RDS Deletion

The course deletes the training DB instance and disables the final snapshot.

That is a cleanup choice for a disposable training environment.

In a real environment, deleting a database without a final recovery point can cause permanent data loss.

Deletion planning should explicitly consider:

```text
Final Snapshot
Backup Retention
Recovery Requirement
Data Classification
Cost
```

---

# Recovery Perspective

Database resilience requires more than one feature.

```text
High Availability
+
Backup
+
Restore
+
Recovery Verification
```

Multi-AZ does not replace backups, and backups do not replace high availability.

They solve different failure scenarios.

---

# Evidence Policy

Do not fabricate or publish:

```text
RDS Endpoints
DB Instance Identifiers
DB Passwords
Security Group IDs
Subnet IDs
Snapshot IDs
Account IDs
CloudWatch Output
Query Output
Billing Values
```

Actual evidence must come from an authorized AWS environment.

---

# Verification Checklist

- SQL and NoSQL were distinguished at a high level.
- Amazon RDS was understood as a managed relational database service.
- DB instances and DB instance classes were introduced.
- RDS storage choices were connected to workload characteristics.
- Multi-AZ was connected to availability and failover.
- Read replicas were connected to read scaling.
- Automated backups and DB snapshots were distinguished.
- Snapshot restore was understood to create a new DB instance.
- Enhanced Monitoring was introduced.
- RDS and database-on-EC2 responsibilities were compared.
- Aurora was introduced.
- Public database exposure was treated as a deliberate architecture choice rather than a default recommendation.
- Course passwords and endpoints were not treated as reusable credentials.

## What I Learned

- Managed database services reduce operating-system and database-infrastructure management work.
- Multi-AZ and read replicas solve different problems.
- Database availability, backup, and recovery should be designed separately.
- Database connectivity troubleshooting requires checking the full path from network reachability to authentication.
- Recovery capability must be verified instead of assuming that a backup alone is sufficient.
