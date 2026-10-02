# AWS DynamoDB NoSQL Foundations Lab

## Objective

Understand Amazon DynamoDB as a managed NoSQL database and learn the data-model concepts introduced by the course, including tables, items, attributes, partition keys, sort keys, consistency models, and access-pattern-oriented design.

## Scope

```text
NoSQL
Amazon DynamoDB
Table
Item
Attribute
Primary Key
Partition Key
Sort Key
Composite Primary Key
Eventually Consistent Reads
Strongly Consistent Reads
Horizontal Scale Concepts
Access Patterns
Key Design
DynamoDB Troubleshooting
```

---

# NoSQL Foundation

The course contrasts NoSQL with relational databases.

NoSQL systems can provide flexible data models and can be designed for large-scale distributed workloads.

A useful high-level distinction is:

```text
Relational Database
→ Schema and Relationships
→ SQL Queries
```

```text
NoSQL Database
→ Data Model Depends on Workload
→ Access Patterns Matter Strongly
```

NoSQL does not mean that data modeling is unnecessary.

It means the modeling approach is different.

---

# Amazon DynamoDB

Amazon DynamoDB is a managed NoSQL database service.

Conceptually:

```text
Application
    ↓
DynamoDB API
    ↓
Table
    ↓
Items
```

The application interacts with DynamoDB through service APIs rather than managing database servers directly.

---

# Managed Service

The course describes DynamoDB as fully managed.

That means application teams do not normally manage database hosts, operating-system patching, or database-server installation.

The team still must design:

```text
Keys
Access Patterns
Capacity Behavior
Security
Data Lifecycle
Application Error Handling
```

---

# Table

A DynamoDB table contains items.

Conceptually:

```text
Table
├── Item A
├── Item B
└── Item C
```

Unlike a traditional relational table, items do not need to contain an identical set of non-key attributes.

---

# Item

The course compares an item to a row in an RDBMS.

Conceptually:

```text
Item
├── Attribute
├── Attribute
└── Attribute
```

An item is the collection of data associated with one record.

---

# Attribute

An attribute is an individual data element inside an item.

Example concept:

```text
Customer Item
├── customer_id
├── name
├── email
└── status
```

The exact attributes depend on the application data model.

---

# Primary Key

Every DynamoDB table requires a primary key.

The primary key uniquely identifies each item.

Two primary-key forms are important:

```text
Partition Key Only
```

or:

```text
Partition Key
+
Sort Key
```

---

# Partition Key

The partition key is required.

The course explains that the partition key affects how items are distributed.

Conceptually:

```text
Partition Key Value
      ↓
Internal Distribution
      ↓
Item Location / Access
```

A good partition-key design should avoid concentrating too much traffic on a narrow set of key values.

---

# High-Cardinality Key Values

The course recommends values with many distinct values, such as:

```text
Customer ID
Device ID
```

The underlying lesson is to distribute workload effectively rather than sending most requests to the same small set of partition-key values.

---

# Sort Key

The sort key is optional.

When a table uses both a partition key and a sort key, items with the same partition-key value can be organized and queried according to the sort-key value.

Conceptually:

```text
customer_id = CustomerA

├── 2026-01-01
├── 2026-02-01
└── 2026-03-01
```

This is useful for access patterns such as retrieving a customer's records across a time range.

---

# Composite Primary Key

With a partition key and sort key:

```text
Primary Key
=
Partition Key + Sort Key
```

The combination uniquely identifies an item.

This enables multiple items to share the same partition-key value while remaining distinguishable by sort key.

---

# Example Access Pattern

The course uses an online-shopping example.

Conceptually:

```text
Partition Key
→ Customer ID

Sort Key
→ Order Time
```

Then an application can query orders belonging to one customer within a selected time range.

This demonstrates a key DynamoDB design principle:

```text
Start from the queries the application must perform.
```

---

# Access-Pattern-Oriented Design

Relational modeling often begins from entities and relationships.

DynamoDB design should strongly consider required access patterns before choosing keys.

Questions include:

```text
What must be retrieved?
By which identifier?
In what order?
Over what range?
How frequently?
```

A poor key design can create performance and scaling problems even when the table technically stores the data correctly.

---

# Eventually Consistent Reads

The course introduces eventually consistent reads.

Conceptually:

```text
Write
 ↓
Distributed Replication
 ↓
Read May Temporarily See Older Data
 ↓
Replicas Converge
```

This model can be appropriate when a short delay before all reads observe the newest value is acceptable.

---

# Strongly Consistent Reads

The course also introduces strongly consistent reads.

Conceptually:

```text
Read
→ Require Latest Committed View
```

This can be useful when an application must read the latest committed value immediately.

Consistency options have performance, availability, and cost considerations that should be checked for the exact DynamoDB operation being used.

---

# Consistency Is an Application Requirement

Do not choose consistency behavior only because one option sounds safer.

Ask:

```text
Does this read require the newest value?
Can the application tolerate short-lived stale data?
What is the cost and performance impact?
```

The correct choice depends on the application workflow.

---

# Auto Scaling

The course notes DynamoDB Auto Scaling support.

The reusable concept is that database capacity can be adjusted according to demand.

Current DynamoDB also has multiple capacity-management approaches, so implementation should verify the current service options instead of assuming one model applies to every table.

---

# SQL vs DynamoDB Thinking

A useful comparison is:

```text
RDS
→ Tables and Relationships
→ SQL
→ Flexible Ad-Hoc Querying
```

```text
DynamoDB
→ Keys and Access Patterns
→ API Operations
→ Highly Intentional Query Design
```

Neither model is universally better.

The workload determines the appropriate database design.

---

# Key-Design Troubleshooting

If a DynamoDB workload performs poorly:

```text
Which Access Pattern Is Slow?
      ↓
What Partition Key Is Used?
      ↓
Is Traffic Concentrated?
      ↓
Is the Query Using the Intended Key?
      ↓
Is the Application Scanning Instead of Querying?
      ↓
Are Capacity / Throttling Metrics Normal?
```

---

# Operational Troubleshooting

A useful workflow is:

```text
Request Failed?
      ↓
Authentication / IAM?
      ↓
Correct Region?
      ↓
Correct Table?
      ↓
Correct Key Values?
      ↓
Validation Error?
      ↓
Throttling?
      ↓
Application Retry Behavior?
```

Do not treat every DynamoDB error as a database-server failure.

There is no customer-managed database host to SSH into.

---

# Security Perspective

DynamoDB access should be controlled with IAM and encryption settings appropriate to the workload.

Application permissions should follow least privilege.

Conceptually:

```text
Application Role
      ↓
Required DynamoDB Actions Only
      ↓
Required Tables / Indexes Only
```

Do not embed long-lived AWS access keys in application source code.

---

# Evidence Policy

Do not fabricate or publish:

```text
AWS Account IDs
Table ARNs
Real Production Table Names
Access Keys
Secret Keys
Session Tokens
Actual Customer Data
CloudWatch Metrics
Billing Values
API Output
```

Actual evidence must come from an authorized AWS environment.

---

# Verification Checklist

- SQL and NoSQL were distinguished at a high level.
- DynamoDB was understood as a managed NoSQL database.
- Tables, items, and attributes were introduced.
- Partition keys were understood as required key components.
- Sort keys were understood as optional key components.
- Composite primary keys were introduced.
- Key design was connected to access patterns.
- Eventually consistent and strongly consistent reads were distinguished.
- Auto Scaling was introduced without treating course-era implementation details as permanent.
- Troubleshooting focused on API, IAM, key design, and workload behavior rather than host access.

## What I Learned

- DynamoDB data modeling starts from required access patterns.
- Partition-key design strongly affects workload distribution.
- Sort keys support ordered and range-oriented access within a partition-key value.
- Consistency should be selected according to application requirements.
- A managed NoSQL service changes both the operational model and the troubleshooting workflow.
