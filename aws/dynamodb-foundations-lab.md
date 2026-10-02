# AWS DynamoDB Foundations Lab

## Objective

Understand the DynamoDB concepts introduced by the course, including NoSQL data modeling, tables, items, attributes, primary keys, partition keys, sort keys, read consistency, and the importance of access-pattern-driven key design.

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
Eventually Consistent Read
Strongly Consistent Read
Access Pattern
Key Distribution
```

---

# SQL and NoSQL Context

The course contrasts relational and non-relational databases.

Relational systems emphasize:

```text
Defined Schema
Relationships
Data Integrity
SQL
```

NoSQL systems emphasize flexible data models and different scaling and access patterns.

NoSQL does not mean that structure is unimportant.

In DynamoDB, data modeling is strongly connected to how the application reads and writes data.

---

# Amazon DynamoDB

DynamoDB is a fully managed NoSQL database service.

The course introduces:

```text
Table
Item
Attribute
Primary Key
Partition Key
Sort Key
Read Consistency
Auto Scaling
```

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

---

# Table

A table is a collection of items.

Conceptually:

```text
Customers Table
├── Item A
├── Item B
└── Item C
```

Each item is identified through the table's primary-key design.

---

# Item

An item is similar to a row in a relational database at a high conceptual level.

Example concept:

```text
Item
├── customer_id
├── name
└── email
```

Items can have attributes that are not identical across every item, depending on the data model.

---

# Attribute

An attribute is a piece of data stored inside an item.

Conceptually:

```text
customer_id = ...
name        = ...
email       = ...
```

The exact attribute design should follow application requirements.

---

# Primary Key

The primary key uniquely identifies an item.

The course introduces two key-design patterns:

```text
Partition Key Only
```

and:

```text
Partition Key + Sort Key
```

The second form is often called a composite primary key.

---

# Partition Key

The partition key is required.

The course connects it to how items are distributed and located.

A useful design goal is:

```text
Many Well-Distributed Key Values
```

Examples can include identifiers such as:

```text
Customer ID
Device ID
Account ID
```

The correct key depends on the application's access patterns.

---

# Why Partition-Key Design Matters

A poor partition-key choice can concentrate traffic.

Conceptually:

```text
Many Requests
      ↓
Same Key Pattern
      ↓
Uneven Access
```

A strong key design attempts to distribute data and request load appropriately.

Do not choose a partition key only because a field is unique; consider how the application will query and write data.

---

# Sort Key

The sort key is optional.

When used with a partition key, it organizes multiple related items under the same partition-key value.

Conceptually:

```text
Partition Key: customer_id
Sort Key: order_time
```

This supports access patterns such as:

```text
Orders for Customer A
Between Time X and Time Y
```

The exact supported expressions depend on the DynamoDB API operation.

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

Then the application can retrieve a customer's orders within a selected time range.

This demonstrates the core DynamoDB design idea:

```text
Design Keys Around Access Patterns
```

---

# Key Immutability Context

The course emphasizes that the table's primary-key definition is fundamental.

Changing key design is not the same as editing an ordinary attribute.

When access patterns change significantly, data-model redesign or a new table may be required.

---

# Eventually Consistent Reads

The course introduces eventually consistent reads as reads that can return data before every replica reflects the latest update.

Conceptually:

```text
Write
 ↓
Replication
 ↓
Read May Temporarily See Older State
```

The important idea is:

```text
Potentially Stale Read
in Exchange for Different Consistency / Capacity Characteristics
```

---

# Strongly Consistent Reads

The course contrasts this with strongly consistent reads.

Conceptually:

```text
Successful Write
      ↓
Strong Read
      ↓
Latest Committed State Expected
```

Support and behavior depend on the DynamoDB operation and feature context.

---

# Consistency Is an Application Decision

Not every read requires the strongest possible consistency.

Ask:

```text
Can This Application Tolerate a Short-Lived Stale Read?
```

Examples where eventual consistency may be acceptable can differ from cases where users must immediately observe the latest state.

The correct choice depends on the business requirement.

---

# Relational vs DynamoDB Thinking

Relational design often begins with:

```text
Entities
Relationships
Normalization
```

DynamoDB design commonly begins with:

```text
What Queries Must the Application Perform?
      ↓
What Keys Support Those Access Patterns?
      ↓
How Should Items Be Structured?
```

This is a major conceptual shift.

---

# Simple Conceptual Model

```text
Table
  ↓
Partition Key
  ↓
Related Items
  ↓
Optional Sort Key Ordering
```

The primary-key design affects both identity and access behavior.

---

# Security Perspective

Applications should access DynamoDB through appropriate IAM permissions.

A useful principle is:

```text
Application Role
      ↓
Only Required DynamoDB Actions
      ↓
Only Required Tables
```

Do not embed long-lived AWS access keys in application code or Git repositories.

---

# Troubleshooting Workflow

When an application cannot retrieve expected DynamoDB data:

```text
Correct Table?
      ↓
Correct Region?
      ↓
IAM Permission?
      ↓
Partition Key Value?
      ↓
Sort Key Condition?
      ↓
Consistency Requirement?
      ↓
Actual Item Exists?
      ↓
Application Serialization / Parsing?
```

For performance issues:

```text
Access Pattern
      ↓
Partition-Key Distribution
      ↓
Request Volume
      ↓
Capacity Mode / Throttling
      ↓
Indexes if Used
```

---

# Evidence Policy

Do not fabricate or publish:

```text
AWS Account IDs
Real Table ARNs
Real Access Keys
Actual Item Data Containing Sensitive Information
Billing Values
Actual Throttling Metrics
```

Use real evidence only from an authorized environment.

---

# Verification Checklist

- DynamoDB was understood as a managed NoSQL database.
- Tables, items, and attributes were distinguished.
- Partition keys were understood as required primary-key components.
- Sort keys were understood as optional components of composite primary keys.
- Key design was connected to application access patterns.
- Eventually consistent and strongly consistent reads were distinguished.
- Relational schema-first thinking was contrasted with DynamoDB access-pattern-driven design.
- IAM least privilege was connected to application access.

## What I Learned

- DynamoDB data modeling starts with access patterns.
- Partition-key design affects data distribution and request behavior.
- Sort keys make ordered and range-oriented access patterns possible within a partition-key value.
- Consistency choices should follow application requirements.
- NoSQL flexibility does not eliminate the need for careful data modeling.
