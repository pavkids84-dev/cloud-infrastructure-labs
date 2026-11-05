# AWS Lambda Serverless Foundations Lab

## Objective

Understand the serverless-computing and AWS Lambda concepts introduced in the AWS course, including responsibility boundaries, function execution, event-driven invocation, runtime environments, scaling, memory allocation, execution limits, IAM permissions, monitoring, cost, and troubleshooting.

The focus is on connecting Lambda to previously studied EC2, Auto Scaling, S3, DynamoDB, IAM, CloudWatch, Linux, Docker, and Kubernetes concepts without treating course screenshots or conceptual examples as completed AWS exercises.

## Scope

```text
Serverless Computing
AWS Lambda
EC2 vs Lambda
Function
Handler
Event
Trigger
Event Source
Event Source Mapping
Execution Environment
Managed Runtime
Initialization
Cold Start
Warm Start
Stateless Execution
Temporary Storage
S3 Events
DynamoDB Streams
API Gateway Integration
Synchronous Invocation
Asynchronous Invocation
Concurrency
Automatic Scaling
Memory and CPU Allocation
Execution Timeout
Execution Role
Resource-Based Invocation Permission
CloudWatch Metrics
CloudWatch Logs
Error and Timeout Troubleshooting
Cost Perspective
Historical Course Limits
```

---

# Serverless Computing

The course introduces serverless computing as a model in which AWS manages the underlying execution infrastructure so developers can focus on application code.

Serverless does not mean that the service runs without servers or an operating system.

It means that customers do not directly provision and administer the underlying compute hosts in the same way that they manage an EC2 instance.

Conceptually:

```text
Application Requirement
         ↓
Function Code and Configuration
         ↓
Managed Compute Service
         ↓
Execution When Invoked
```

The customer remains responsible for application logic, access permissions, event configuration, data security, dependencies, and appropriate monitoring.

---

# EC2 vs Lambda

An EC2 workload generally requires explicit instance lifecycle and operating-system management.

```text
EC2
  ↓
Instance Provisioning
  ↓
Operating System and Runtime
  ↓
Application Deployment
  ↓
Monitoring / Patching / Scaling
```

Lambda changes the operational boundary:

```text
Event / Request
      ↓
AWS Lambda
      ↓
Managed Execution Environment
      ↓
Function Code
      ↓
Result or Downstream Action
```

EC2 remains useful for persistent processes, specialized system control, or workloads that do not fit the function execution model.

Lambda is useful for event processing and bounded application tasks that benefit from managed provisioning and demand-driven execution.

---

# AWS Lambda

AWS Lambda executes application code in response to invocations without requiring the customer to create and manage individual compute instances.

The course highlights:

```text
Managed Execution Infrastructure
Event-Driven Execution
Automatic Scaling
Usage-Based Charging
Configurable Runtime Resources
```

A Lambda function is not an EC2 instance.

It is a managed compute resource that combines function code with configuration and execution permissions.

---

# Function and Handler

A function contains application code and configuration.

The handler is the entry point that receives invocation data and performs the application operation.

Conceptually:

```text
Invoke Function
      ↓
Receive Event
      ↓
Call Handler
      ↓
Application Logic
      ↓
Return Result or Perform Action
```

A simple Python handler example:

```python
import json


def lambda_handler(event, context):
    message = event.get("message", "hello")

    return {
        "statusCode": 200,
        "body": json.dumps({"message": message}),
    }
```

This is illustrative application code, not evidence that a function has been deployed or invoked in an AWS account.

The `event` parameter contains input data; `context` provides invocation-related runtime information.

---

# Event-Driven Execution

An event represents an occurrence or request that an application needs to process.

Examples introduced by the course include:

```text
HTTP Request
S3 Object Event
DynamoDB Data Change
Kinesis Stream Record
```

Conceptually:

```text
Event Source
     ↓
Event / Trigger Integration
     ↓
Lambda Invocation
     ↓
Handler Execution
     ↓
Outcome
```

A trigger or event source mapping connects a source to a function.

Event-driven execution does not imply that every source uses the same invocation or retry mechanism.

---

# S3 Event Example

The course lists S3 object events as a Lambda trigger source.

An example workflow is:

```text
Object Uploaded to S3
          ↓
Object-Created Event
          ↓
Lambda Function
          ↓
Process Object
          ↓
Store Result or Record Metadata
```

S3 can invoke a Lambda function asynchronously after a configured notification event.

Permissions must allow the relevant bucket to invoke the function. The function execution role separately needs permission to read or write any S3 objects accessed by its code.

Avoid configuring a function to write matching new objects back to the same triggering prefix, which can create repeated invocations.

---

# DynamoDB Streams and Event Source Mapping

The course also lists DynamoDB as an event source.

For table-change processing, DynamoDB Streams can provide records about item changes to an event source mapping.

```text
DynamoDB Table Change
          ↓
DynamoDB Stream
          ↓
Lambda Event Source Mapping
          ↓
Poll and Batch Records
          ↓
Lambda Handler
```

This is different from direct S3 notification delivery.

The mapping polls the stream and invokes the function with records.

A stream must be configured and the execution role must have the necessary stream-reading permissions.

---

# API Gateway and HTTP Integration

The course introduces API Gateway and Elastic Load Balancing as ways to process HTTP-based requests with Lambda.

Conceptually:

```text
HTTP Client
     ↓
API Gateway
     ↓
Lambda Handler
     ↓
Response
     ↓
HTTP Client
```

API Gateway manages the HTTP API entry point; Lambda runs the application code.

Lambda does not automatically provide a public HTTP endpoint merely because a function exists.

HTTP exposure, authorization, request processing, and response behavior must be configured and verified.

---

# Synchronous vs Asynchronous Invocation

A useful extension to the course's event-driven introduction is the distinction between invocation models.

Synchronous invocation:

```text
Caller
   ↓
Invoke Lambda
   ↓
Wait for Execution
   ↓
Receive Result or Error
```

Asynchronous invocation:

```text
Event Producer
     ↓
Submit Event
     ↓
Lambda Queues Event
     ↓
Invoke Later
     ↓
Process Outcome / Retry Policy
```

For queue- and stream-based sources, an event source mapping may poll records and invoke the function in batches.

Retry behavior depends on the invocation type and source integration.

An architecture should not assume that every event is delivered exactly once; duplicate delivery and safe reprocessing must be considered.

Detailed serverless event patterns and fan-out architectures are deferred to the course's later serverless-design section.

---

# Execution Environment

Lambda uses a managed and isolated execution environment to run function code.

The environment provides a language runtime, CPU and memory resources, and temporary storage as configured for the workload.

```text
Lambda Service
      ↓
Execution Environment
      ├── Runtime
      ├── Function Code
      ├── Memory / CPU
      └── Temporary Files
      ↓
Handler
```

An execution environment can be reused across multiple invocations, but the duration of reuse is not guaranteed.

Application correctness must not depend on one environment remaining available indefinitely.

---

# Cold Starts and Warm Starts

When Lambda must create a new execution environment, initialization adds time before the handler runs.

```text
Cold Start
   ↓
Prepare Environment
   ↓
Initialize Runtime and Code
   ↓
Invoke Handler
```

A reusable environment can serve a later invocation without repeating all initialization work.

```text
Warm Start
   ↓
Reuse Prepared Environment
   ↓
Invoke Handler
```

Cold-start behavior depends on runtime, initialization work, package size, and scaling conditions.

Cold start is a latency consideration, not proof that Lambda cannot scale.

---

# Stateless Execution and Data Persistence

Code can use temporary files during a Lambda invocation, but the execution environment is not a durable source of application state.

```text
Lambda Function
      ├── Temporary Processing: /tmp
      └── Persistent Data: S3 / DynamoDB / RDS / Other Services
```

Even if a temporary file remains available during an environment reuse, no durable-lifetime guarantee exists.

This connects directly to previous Docker and Kubernetes storage lessons: compute lifecycle and persistent data lifecycle should be designed separately.

---

# Automatic Scaling and Concurrency

The course explains that Lambda can scale execution capacity in response to demand.

Scaling depends on the number of simultaneous invocations, execution duration, configured concurrency controls, and applicable quotas.

A useful estimate for standard event-function workloads is:

```text
Concurrency
≈ Requests per Second × Average Duration in Seconds
```

Example:

```text
100 requests per second
× 0.5 seconds per request
≈ 50 concurrent executions
```

Concurrency is not the same as requests per second.

Lambda scaling removes much of the instance-management work, but it does not eliminate concurrency limits, throttling, downstream capacity limits, or cost concerns.

---

# Memory and CPU Allocation

The course explains that Lambda memory allocation affects both available memory and computing power.

For standard Lambda event functions, AWS documents a configurable memory range of 128 MB to 10,240 MB, in 1-MB increments.

The amount of CPU power allocated increases with memory configuration.

```text
Increase Configured Memory
          ↓
More Available Memory
          +
More Allocated CPU Capacity
          ↓
Potentially Different Execution Duration
          ↓
Different Cost Behavior
```

Higher memory does not always mean higher total cost; a faster function can change the duration component of billing. Performance should be measured rather than assumed.

---

# Historical Memory and Runtime Statements

The course's Lambda feature slide includes 2021-era details:

```text
Memory: 128 MB to 3,008 MB
Memory Step: 64 MB
Runtime Examples: Amazon Linux / Amazon Linux 2
Language Support as of February 2021
```

These are historical course statements, not timeless current service limits.

Current runtimes and their operating-system bases depend on the supported runtime version; newer runtimes commonly use Amazon Linux 2023.

Select runtimes using current AWS support and deprecation documentation instead of assuming that a course-era language and OS list remains unchanged.

---

# Execution Time Limits

The course emphasizes Lambda's suitability for short-running tasks and introduces a 15-minute execution limit.

The traditional standard Lambda event-function timeout is up to 900 seconds, or 15 minutes.

Newer Lambda product variants can have different execution models and limits, so the 15-minute statement should not be generalized to every Lambda offering.

A function should be given an appropriate timeout based on real processing time and dependency latency.

Long-running processes and continuously running services may fit EC2, containers, or other orchestration and managed compute services better.

---

# Usage-Based Cost Model

The course presents Lambda as charging for consumed compute time rather than requiring an idle instance to run continuously.

A more complete cost model considers:

```text
Invocation Requests
Execution Duration
Configured Memory
Applicable Architecture / Pricing Model
Additional Services
```

Related services may incur separate charges:

```text
CloudWatch Logs
API Gateway
S3
Data Transfer
Networking
Other AWS Services
```

Some Lambda configurations, such as provisioned concurrency, have additional pricing considerations.

Avoid treating Lambda as universally free or assuming that cost depends only on handler execution seconds.

---

# IAM Execution Role

A Lambda execution role determines what AWS resources the function code can access.

For example:

```text
Lambda Execution Role
       ├── Write Application Logs
       ├── Read Required S3 Objects
       └── Update Specific DynamoDB Items
```

The execution role should follow least privilege.

It should not contain broad administrator permissions merely to simplify setup.

Do not embed long-lived AWS access keys inside function source code or environment variables.

---

# Invocation Permission vs Execution Permission

Two permission directions are easy to confuse.

```text
Who Can Invoke the Function?
      ↓
Invocation Authorization / Resource-Based Policy
```

```text
What Can the Function Access?
      ↓
Execution Role / IAM Policy
```

For an S3 notification example, permission for S3 to invoke Lambda is not the same as permission for Lambda to read S3 objects.

Both sides of the request flow must be verified independently.

---

# Conceptual Practice Workflow

A minimal beginner workflow is:

```text
1. Select a Supported Runtime
2. Write the Handler
3. Create the Function
4. Assign a Least-Privilege Execution Role
5. Configure Memory and Timeout
6. Invoke with a Controlled Test Event
7. Check Response and CloudWatch Logs
8. Configure an Event Source If Needed
9. Verify Trigger Behavior
10. Delete Unneeded Resources and Verify Cleanup
```

The uploaded slides explain Lambda conceptually; they do not provide an executed Lambda deployment record for this repository.

---

# Example Test Invocation

If a function with the specified name has already been created and the caller has the required permissions, AWS CLI can invoke it with a small test payload.

```bash
aws lambda invoke \
  --function-name FUNCTION_NAME \
  --cli-binary-format raw-in-base64-out \
  --payload '{"message":"hello"}' \
  response.json
```

Then inspect the returned payload:

```bash
cat response.json
```

`FUNCTION_NAME` is a placeholder.

Do not treat this command example as a recorded successful invocation.

For a real lab, capture the actual command status, function response, and relevant logs without publishing confidential data.

---

# Monitoring and Logs

Lambda integrates with CloudWatch for observability.

Useful metrics include:

```text
Invocations
Errors
Duration
Throttles
ConcurrentExecutions
```

CloudWatch Logs can contain application messages and runtime diagnostic information when logging permissions and configuration are in place.

Do not log entire event payloads blindly. Events may contain private information, credentials, or business-sensitive data.

---

# Troubleshooting Invocation Failures

If an expected function execution does not happen, investigate the event path first.

```text
Expected Event Occurred?
         ↓
Event Source Configured?
         ↓
Trigger or Mapping Enabled?
         ↓
Invocation Permission Valid?
         ↓
Function Exists and Is Available?
         ↓
Execution Role / Downstream Access Valid?
         ↓
CloudWatch Metrics and Logs?
```

A missing invocation and an invocation that started but failed are different situations.

Inspect the invocation source and authorization path before changing function code.

---

# Troubleshooting Function Execution

If the function runs but does not complete successfully:

```text
Invocation Recorded?
       ↓
Error or Timeout?
       ↓
Execution Role Correct?
       ↓
External Service Reachable?
       ↓
Memory and CPU Adequate?
       ↓
Configured Timeout Adequate?
       ↓
Concurrency / Throttling?
       ↓
Application Logic and Input Valid?
```

Use actual logs and metrics to decide which layer failed.

A Lambda error does not automatically prove an AWS infrastructure outage.

---

# Retry, Duplication, and Idempotency

Event-driven processing can involve retries or duplicate delivery depending on the source and invocation type.

For example, recording a payment or updating an inventory item twice can be harmful if the function repeats the operation without safeguards.

An idempotent design makes repeated processing of the same logical event safe.

```text
Event ID
   ↓
Check Whether Already Processed
   ↓
Perform Action Only When Appropriate
   ↓
Record Completion
```

This is a design principle, not proof that the sample Lambda function implements deduplication.

---

# Relationship to Previous AWS Study

```text
EC2
→ Explicit Server Lifecycle Management

Auto Scaling
→ Instance Capacity Management

Lambda
→ Managed Function Execution and Scaling

IAM
→ Runtime Permissions and Invocation Authorization

S3 / DynamoDB
→ Event Sources and Persistent Data Services

CloudWatch
→ Metrics, Logs, and Troubleshooting

CloudFormation
→ Infrastructure-as-Code Definition of Cloud Resources
```

Lambda does not replace these services. It can operate as one component within an AWS architecture.

---

# Deferred Serverless Architecture Topics

The later course pages 199-202 introduce additional serverless design topics:

```text
API Gateway Event Patterns
Synchronous vs Asynchronous Architectures
Fan-Out
AWS SAM
```

This file introduces invocation concepts only. The dedicated architecture and SAM study remains separate and should not be marked complete by this Lambda foundation lab.

---

# Evidence Policy

Do not fabricate or publish:

```text
AWS Account IDs
Actual Lambda Function ARNs
Real Production Function Names
IAM Access Keys
Secret Access Keys
Session Tokens
Actual Event Payloads Containing Sensitive Data
CloudWatch Log Output
Real Invocation Results
S3 Bucket Identifiers from Private Environments
DynamoDB Stream ARNs
Concurrency Metrics
Billing Values
Console Screenshots from Unperformed Labs
```

Course screenshots and example code are educational references only.

Actual evidence must come from an authorized AWS environment.

---

# Verification Checklist

- Serverless computing was distinguished from the absence of servers or operating systems.
- EC2 operating responsibilities were compared with managed Lambda execution.
- A Lambda function and handler were introduced.
- Events, triggers, and event source mappings were distinguished.
- S3 object events were connected to asynchronous Lambda invocation.
- DynamoDB Streams were connected to polling through event source mappings.
- API Gateway was connected to HTTP invocation.
- Synchronous, asynchronous, and stream-polling models were distinguished.
- Execution environment lifecycle and reuse were introduced.
- Cold and warm starts were distinguished.
- Temporary Lambda storage was not treated as durable data storage.
- Concurrency was distinguished from requests per second.
- Lambda memory allocation was connected to CPU capacity and cost.
- Historical 2021 memory and runtime statements were corrected.
- The standard Lambda event-function timeout was distinguished from other newer variants.
- Execution roles and resource-based invocation permissions were distinguished.
- CloudWatch metrics and logs were connected to troubleshooting.
- Course examples were not presented as real AWS invocation evidence.
- Later serverless architecture and AWS SAM topics remained explicitly deferred.

## What I Learned

- Serverless changes the responsibility boundary rather than eliminating physical servers.
- Lambda provides managed, event-driven execution of application functions.
- Event sources and invocation methods must be understood before designing reliable workflows.
- Runtime environments can be reused but are not a dependable place to keep durable application state.
- Concurrency, memory, CPU, timeout, downstream service limits, and cost influence Lambda behavior.
- Lambda execution permissions and invocation permissions answer different security questions.
- Event-driven applications require observability, duplicate-handling strategies, and careful troubleshooting of the entire event path.
- Lambda complements existing infrastructure services instead of replacing the need for architecture, networking, security, and operational reasoning.
