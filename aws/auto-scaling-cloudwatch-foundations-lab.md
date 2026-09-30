# AWS Auto Scaling and CloudWatch Foundations Lab

## Objective

Understand Amazon EC2 Auto Scaling and the monitoring concepts introduced by the course, including Auto Scaling groups, launch templates, capacity settings, scaling policies, cooldown, lifecycle hooks, CloudWatch metrics, alarms, CloudWatch Agent, CloudWatch Logs, and event-driven automation.

## Scope

```text
Amazon EC2 Auto Scaling
Auto Scaling Group
Minimum Capacity
Desired Capacity
Maximum Capacity
Launch Template
Launch Configuration Historical Context
Target Tracking Scaling
Simple Scaling
Step Scaling
Scheduled Scaling
Health Replacement
Elastic Load Balancing Integration
Scaling Cooldown
Lifecycle Hook
Amazon CloudWatch
Metrics
Alarms
Basic and Detailed Monitoring
CloudWatch Agent
CloudWatch Logs
CloudWatch Logs Insights
CloudWatch Events Historical Context
Amazon EventBridge Current Context
CPU Stress Practice
Troubleshooting
```

---

# Amazon EC2 Auto Scaling

Amazon EC2 Auto Scaling automatically changes the number of EC2 instances in response to configured capacity requirements, scaling policies, schedules, and health conditions.

Conceptually:

```text
Application Demand
      ↓
Auto Scaling Policy
      ↓
Auto Scaling Group
      ↓
Launch or Terminate EC2 Instances
```

The goal is to maintain enough compute capacity for the workload without permanently running unnecessary instances.

---

# Scale Out and Scale In

```text
Scale Out
→ Increase the number of instances
```

```text
Scale In
→ Decrease the number of instances
```

Scale out supports increasing demand.

Scale in can reduce unused capacity and cost.

---

# Auto Scaling Group

An Auto Scaling group, or ASG, manages a logical group of EC2 instances.

Important capacity values are:

```text
Minimum Capacity
Desired Capacity
Maximum Capacity
```

Conceptually:

```text
Minimum
   ≤
Desired
   ≤
Maximum
```

The ASG attempts to maintain the desired capacity while respecting the configured limits.

---

# Desired Capacity

Desired capacity represents the number of instances the group currently attempts to maintain.

If an instance becomes unhealthy and the ASG decides it must be replaced:

```text
Desired = 3
Current Healthy = 2
      ↓
Replacement Instance
      ↓
Desired State Restored
```

This is similar to desired-state reconciliation concepts previously studied in Kubernetes.

---

# Launch Template

A launch template defines how new EC2 instances should be created.

Typical configuration includes:

```text
AMI
Instance Type
Key Pair
Security Groups
Storage
Monitoring Options
Tags
Other Launch Parameters
```

Conceptually:

```text
Launch Template
      ↓
Auto Scaling Group
      ↓
New EC2 Instance
```

---

# Launch Template Versioning

Launch templates support versions.

Conceptually:

```text
Launch Template
├── Version 1
├── Version 2
└── Version 3
```

A new version can change instance launch settings without overwriting the historical template version.

---

# Launch Configuration Historical Context

The course mixes the terms `launch template` and `launch configuration`.

They should be kept separate.

```text
Launch Template
→ Versioned EC2 launch definition
```

```text
Launch Configuration
→ Older Auto Scaling launch-definition mechanism
```

Current AWS guidance favors launch templates, and launch configurations now have significant creation limitations.

---

# Scaling Options

The course introduces multiple ways to change ASG capacity.

```text
Dynamic Scaling
Scheduled Scaling
Health-Based Replacement
```

Dynamic scaling reacts to metrics.

Scheduled scaling reacts to known time-based demand.

Health replacement restores desired capacity when instances become unhealthy.

---

# Target Tracking Scaling

Target tracking attempts to keep a selected metric near a target value.

Conceptually:

```text
Metric Above Target
      ↓
Scale Out

Metric Below Target
      ↓
Scale In
```

The course uses examples such as average CPU utilization and load-balancer request metrics.

---

# Simple Scaling

Simple scaling performs a configured scaling adjustment when an alarm threshold is reached.

Conceptually:

```text
Alarm Threshold Reached
      ↓
Add or Remove Configured Capacity
```

This model is easier to understand but can be less flexible than more advanced scaling approaches.

---

# Step Scaling

Step scaling changes capacity by different amounts according to how far the metric moves beyond a threshold.

Conceptually:

```text
Small Threshold Breach
→ Small Adjustment

Large Threshold Breach
→ Larger Adjustment
```

This allows the scaling response to reflect the severity of the metric change.

---

# Scheduled Scaling

Scheduled scaling is useful when demand is predictable.

Example concept:

```text
08:00
→ Increase Desired Capacity

22:00
→ Reduce Desired Capacity
```

This is different from metric-driven scaling because it is based on a known schedule.

---

# Elastic Load Balancing Integration

An Auto Scaling group can be associated with an Elastic Load Balancing target group.

Conceptually:

```text
Clients
   ↓
Load Balancer
   ↓
Target Group
   ↓
Auto Scaling Group Instances
```

Newly launched healthy instances can become traffic targets, while unhealthy or terminating instances can be removed from active traffic.

---

# Health Replacement

Auto Scaling can replace unhealthy instances.

Conceptually:

```text
Unhealthy Instance
      ↓
Health Evaluation
      ↓
Terminate / Replace
      ↓
New Instance
      ↓
Desired Capacity Restored
```

A replacement instance is a new EC2 instance, not the original instance being repaired in place.

---

# Scaling Cooldown

The course introduces scaling cooldown as a waiting period after a scaling activity.

Its purpose is to avoid reacting repeatedly before the effect of the previous scaling activity can be observed.

Conceptually:

```text
Scaling Activity
      ↓
Wait / Stabilize
      ↓
Evaluate Again
```

Do not treat one course default value as a permanent rule for every scaling policy.

---

# Lifecycle Hooks

Lifecycle hooks provide time to run custom actions when instances enter or leave the Auto Scaling group lifecycle.

Conceptually:

```text
Instance Launch / Termination
      ↓
Lifecycle Hook
      ↓
Custom Work
      ↓
Continue Lifecycle
```

Possible tasks can include:

```text
Configuration
Registration
Log Collection
Notification
Custom Automation
```

---

# Lifecycle Hooks and Automation

The course connects lifecycle events with services such as Lambda and CloudWatch-era event handling.

A useful architecture is:

```text
Lifecycle Event
      ↓
Event Handling
      ↓
Automation Function
      ↓
Complete or Continue Lifecycle
```

---

# Amazon CloudWatch

CloudWatch provides monitoring for AWS resources and applications.

Core concepts introduced by the course include:

```text
Metrics
Dashboards
Alarms
Logs
Custom Metrics
```

---

# Metrics

A CloudWatch metric is a time-ordered set of data points for a monitored variable.

Examples include:

```text
CPU Utilization
Network Activity
Status Checks
Custom Application Metrics
```

Conceptually:

```text
Resource
   ↓
Metric Data
   ↓
CloudWatch
   ↓
Dashboard / Alarm / Automation
```

---

# Metrics and Auto Scaling

CloudWatch metrics can drive Auto Scaling decisions.

Conceptually:

```text
EC2 CPU Metric
      ↓
CloudWatch
      ↓
Scaling Policy
      ↓
Auto Scaling Group
```

This is the feedback loop that makes dynamic scaling possible.

---

# Basic and Detailed Monitoring

The course distinguishes basic and detailed EC2 monitoring by collection frequency.

The exact frequency and cost behavior should be verified against current AWS service documentation when implementing a real environment.

The reusable concept is:

```text
Higher Monitoring Resolution
→ Faster Visibility
→ Different Cost / Operational Tradeoff
```

---

# Memory Metrics

The course notes that standard EC2 metrics do not automatically expose guest operating-system memory utilization.

To collect guest-level information such as memory usage, an agent can publish additional metrics.

Conceptually:

```text
EC2 Guest OS
      ↓
CloudWatch Agent
      ↓
Custom / Agent Metrics
      ↓
CloudWatch
```

---

# CloudWatch Alarms

An alarm evaluates a metric against configured conditions.

Conceptually:

```text
Metric
   ↓
Threshold Evaluation
   ↓
Alarm State
   ↓
Action
```

Actions can support automation such as notifications, scaling, or supported EC2 operations.

---

# CloudWatch Agent

The CloudWatch Agent can collect additional system-level metrics and logs from supported systems.

The course connects it with:

```text
EC2
On-Premises Servers
Memory Metrics
Log Collection
```

This is useful when AWS service-level metrics are not enough to diagnose the operating system or application.

---

# CloudWatch Logs

CloudWatch Logs stores and provides access to log data.

Possible sources introduced by the course include:

```text
EC2 Application / System Logs
CloudTrail-Related Logs
Route 53-Related Logs
VPC Flow Logs
Other AWS and Application Sources
```

The actual ingestion mechanism depends on the source.

---

# CloudWatch Logs Insights

CloudWatch Logs Insights provides interactive log querying and analysis.

Conceptually:

```text
Centralized Logs
      ↓
Query
      ↓
Filter / Aggregate / Analyze
      ↓
Troubleshooting Evidence
```

This supports evidence-based troubleshooting instead of relying only on instance console status.

---

# CloudWatch Events Historical Context

The course uses the name:

```text
CloudWatch Events
```

for event-pattern and schedule-based automation.

Current AWS terminology has evolved.

```text
CloudWatch Events
→ Historical Name

Amazon EventBridge
→ Current Event Routing Service
```

The reusable concept remains:

```text
Event Source
      ↓
Rule / Pattern
      ↓
Target
```

---

# Event Source and Target

The course gives event-source examples such as S3 object activity and target examples such as:

```text
AWS Lambda
Amazon SNS
Amazon SQS
Amazon Kinesis
```

The important architectural idea is event-driven automation.

---

# Practice Workflow

The course practice is organized as:

```text
1. Create Launch Template
2. Create Auto Scaling Group
3. Configure Capacity and Target Tracking
4. Verify Instance Health
5. Generate CPU Load
6. Observe Scaling
7. Stop Load
8. Observe Capacity Again
```

---

# Course Launch Template Practice

The course uses training values for:

```text
Template Name
AMI
Instance Type
Security Group
Key Pair
Monitoring
```

These are course examples only.

Do not reuse course identifiers as actual lab evidence.

---

# Course Auto Scaling Group Practice

The course creates an ASG across two subnets and configures:

```text
Minimum Capacity
Desired Capacity
Maximum Capacity
Health Check Grace Period
Monitoring
Target Tracking Policy
```

The exact values in the slides are educational settings rather than universal production recommendations.

---

# CPU Stress Practice

The course installs a CPU stress tool and runs a CPU-intensive workload.

Conceptually:

```text
CPU Load
   ↓
CloudWatch Metric Rises
   ↓
Target Tracking Policy Evaluates
   ↓
Scale Out May Occur
```

After the workload stops:

```text
CPU Load Falls
   ↓
Metric Falls
   ↓
Policy Evaluates
   ↓
Scale In May Occur
```

Actual scaling timing depends on metric collection, warmup, health, and policy behavior.

---

# Monitoring Before Interpreting Scaling

Do not conclude that Auto Scaling is broken only because a new instance does not appear immediately.

Check:

```text
Metric Data Available?
      ↓
Alarm / Policy Condition Met?
      ↓
ASG Below Maximum?
      ↓
Launch Template Valid?
      ↓
Subnet Capacity Available?
      ↓
IAM / Service-Linked Role Works?
      ↓
Instance Launch Successful?
      ↓
Health Checks Passing?
```

---

# Auto Scaling Troubleshooting Workflow

A useful workflow is:

```text
Expected Capacity?
      ↓
Current ASG Desired / Min / Max?
      ↓
Scaling Policy?
      ↓
CloudWatch Metric?
      ↓
Alarm / Target Condition?
      ↓
Scaling Activity History?
      ↓
Launch Template?
      ↓
EC2 Launch Failure?
      ↓
Health Check?
      ↓
Load Balancer Target Health?
```

The ASG activity history is especially important because it records why scaling actions succeeded or failed.

---

# Load Balancer Troubleshooting

When Auto Scaling is integrated with a load balancer:

```text
Instance Exists?
      ↓
Instance InService?
      ↓
Target Registered?
      ↓
Target Health Check Passing?
      ↓
Application Listening?
      ↓
Security Group / Network Path?
      ↓
Traffic Reaches Target?
```

Compute scaling and application health must be evaluated separately.

---

# Desired State Connection

Auto Scaling can be understood with a familiar reconciliation model.

```text
Desired Capacity
      ↓
Compare with Current Capacity
      ↓
Launch / Terminate / Replace
      ↓
Desired Capacity Restored
```

This is conceptually similar to Kubernetes controllers maintaining replica counts, although the systems and APIs are different.

---

# Cost Perspective

Auto Scaling can reduce unnecessary compute capacity, but it does not guarantee the lowest possible AWS bill.

Costs can also come from:

```text
EBS
Load Balancers
NAT Gateways
Public IPv4
Data Transfer
Monitoring
Logs
Other AWS Services
```

Scaling decisions should consider both performance and cost.

---

# Evidence Policy

Do not fabricate or publish:

```text
Auto Scaling Group Names from Real Accounts
Launch Template IDs
Launch Template Versions from Real Labs
AMI IDs
Instance IDs
Security Group IDs
Subnet IDs
Key Pair Names
CloudWatch Alarm ARNs
Metric Output
Scaling Activity Output
Public IP Addresses
CLI Output
Billing Values
```

Actual evidence must come from an authorized AWS environment.

---

# Verification Checklist

- Auto Scaling was understood as automatic EC2 capacity management.
- Minimum, desired, and maximum capacity were distinguished.
- Scale out and scale in were distinguished.
- Launch templates were connected to repeatable EC2 creation.
- Launch templates and legacy launch configurations were distinguished.
- Target tracking, simple scaling, step scaling, and scheduled scaling were introduced.
- Health-based replacement was connected to desired capacity.
- Elastic Load Balancing integration was understood.
- Cooldown and lifecycle hooks were introduced.
- CloudWatch metrics and alarms were connected to scaling.
- CloudWatch Agent was connected to guest-level metrics and logs.
- CloudWatch Logs and Logs Insights were introduced.
- CloudWatch Events was recognized as historical terminology related to current Amazon EventBridge.
- The course CPU-stress workflow was not treated as actual lab evidence.

## What I Learned

- Auto Scaling combines desired capacity, health evaluation, monitoring, and instance launch configuration.
- CloudWatch provides the observation layer that dynamic scaling depends on.
- Launch templates make scaled instances reproducible.
- Scaling must be validated through metrics, ASG activity history, EC2 launch state, and application health.
- Automatic scaling is a feedback loop, not an immediate reaction to every short-lived metric change.
