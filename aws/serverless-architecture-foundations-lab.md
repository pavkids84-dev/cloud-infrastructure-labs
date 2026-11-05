# AWS Serverless Architecture Foundations Lab

## Objective

Understand the serverless architecture patterns introduced in the AWS course after the Lambda and DynamoDB modules, including API Gateway, synchronous request handling, asynchronous EventBridge workflows, SQS-based fan-out, dead-letter queues, custom authorizers, AWS SAM templates, and the AWS SAM CLI.

The focus is on connecting previously studied Lambda, DynamoDB, IAM, CloudWatch, X-Ray, and CloudFormation concepts into observable and recoverable application flows. Course diagrams and template examples are not treated as evidence of an actual AWS deployment.

## Scope

```text
Serverless Architecture
Amazon API Gateway
AWS Lambda
Amazon DynamoDB
Amazon CloudWatch
AWS X-Ray
API Request and Response Flow
Synchronous Invocation
Asynchronous Processing
Amazon EventBridge
PutEvents
Event Bus
Event Rules and Routing
Fan-Out
Amazon SQS
Queue Consumers
Dead-Letter Queues
Retry Behavior
Idempotency
Custom Authorizer
Least Privilege
AWS Serverless Application Model (AWS SAM)
SAM Template
AWS::Serverless::Function
AWS::Serverless::SimpleTable
AWS SAM Transform
AWS SAM CLI
Local Build and Testing
Deployment through CloudFormation
Troubleshooting
Evidence Policy
```

---

# Serverless Architecture

The course first introduces Lambda as a managed function execution service, then combines managed services into an application architecture.

Serverless architecture does not remove the need for system design.

It changes which layers the customer operates directly.

Conceptually:

```text
Client
   ↓
Managed API Entry Point
   ↓
Managed Function Execution
   ↓
Managed Data Store
```

Application requirements, identity and access, data modeling, error handling, network paths, observability, and cost remain engineering responsibilities.

---

# Course Architecture Example 1

The course diagram on PDF page 199 shows a client application using API Gateway, Lambda, and DynamoDB.

```text
Client
   ↓
Amazon API Gateway
   ↓
AWS Lambda
   ↓
Amazon DynamoDB
```

The diagram also shows AWS X-Ray and Amazon CloudWatch as observation capabilities associated with the service path.

Do not interpret X-Ray or CloudWatch as sequential business-logic steps through which the request must pass.

The core responsibilities are:

```text
API Gateway
→ API endpoint and request integration

Lambda
→ Application logic

DynamoDB
→ Data storage and access

CloudWatch
→ Metrics and logs

X-Ray
→ Distributed tracing
```

---

# API Gateway

API Gateway offers managed endpoints through which applications can invoke backend services.

In a simple request flow:

```text
HTTP Request
     ↓
API Route
     ↓
Integration
     ↓
Backend
     ↓
HTTP Response
```

Relevant responsibilities include routing requests, integration with services, authentication and authorization configurations, and request-control features.

Different API Gateway API types and integration modes support different feature sets. A design should not assume that every API type implements the same features in the same way.

---

# Lambda and DynamoDB Responsibilities

Lambda runs application code, while DynamoDB provides a managed data store.

```text
API Gateway
     ↓
Lambda Handler
     ↓
DynamoDB API
     ↓
Table / Item
```

A Lambda function still needs an execution role that permits the required DynamoDB operations.

The data model also matters:

```text
Partition Key
Sort Key When Needed
Access Patterns
Read and Write Capacity
Error Handling
```

Using managed services does not remove data-model or permission-design work.

---

# CloudWatch and X-Ray

The course architecture includes both monitoring and distributed tracing.

```text
CloudWatch
→ Metrics
→ Logs
→ Alarms
```

```text
X-Ray
→ Request Traces
→ Service Dependencies
→ Latency Investigation
```

Tracing requires supported service integrations and appropriate tracing or instrumentation settings.

Not every call will automatically be represented as a complete trace without configuration.

---

# Synchronous Request Processing

The PDF page 200 left-hand diagram shows a synchronous request to update an item.

```text
Client
  |
  | PUT /todo/1
  v
API Gateway
  |
  | Invoke (Sync)
  v
Lambda
  |
  | UpdateItem
  v
DynamoDB
  |
  | Database Result
  v
Lambda
  |
  v
API Gateway
  |
  | HTTP Response
  v
Client
```

The response can reflect the backend result because the client request remains associated with the function's processing path.

A response code indicating success should be generated only after the application has verified the required outcome.

---

# Synchronous Failure and Latency

Synchronous requests couple client-perceived latency to the downstream execution path.

```text
Slow DynamoDB Operation
          ↓
Longer Lambda Duration
          ↓
Delayed API Response
          ↓
Client Timeout Risk
```

The limits of the API integration, the function, and the client must be considered separately.

A function's maximum permitted execution time does not imply that an API client can wait for that entire period.

Typical investigations include:

```text
API Gateway Status / Integration Status
Lambda Invocation / Errors / Duration
DynamoDB Error and Throttling Metrics
Trace Segments When Available
```

---

# Asynchronous Architecture

The PDF page 200 right-hand diagram uses API Gateway to submit an event to EventBridge, which later invokes Lambda.

```text
Client
  |
  | PUT /todo/1
  v
API Gateway
  |
  | PutEvents
  v
Amazon EventBridge
  |
  | Event Submission Accepted
  v
API Gateway
  |
  v
Client

Separate processing path:

EventBridge
  |
  | Asynchronous Event Delivery
  v
Lambda
  |
  | UpdateItem
  v
DynamoDB
```

The diagram describes an asynchronous application flow through EventBridge, not merely a change in API Gateway's Lambda-invocation flag.

The client need not wait for the final DynamoDB operation to complete before receiving an acknowledgement.

---

# Accepted Event vs Completed Work

A successful API response in this architecture may only mean that the event was accepted for downstream processing.

```text
Event Accepted
      !=
Lambda Executed Successfully
      !=
DynamoDB Updated Successfully
```

The API contract must define what its response means.

For an asynchronous API, HTTP 202 Accepted can communicate that work was accepted but not yet completed. The course diagram uses 200 Success; the appropriate status depends on the implemented API contract.

Applications that require final status should design a way to retrieve operation status or deliver a later completion notification.

---

# Synchronous vs Asynchronous Tradeoffs

```text
Synchronous
→ Client waits for processing result
→ Simpler immediate confirmation
→ Downstream latency affects request
```

```text
Asynchronous
→ Client may receive early acknowledgement
→ Processing continues separately
→ Status, retry, and failure tracking need design
```

Asynchronous processing is not a guarantee of shorter end-to-end processing time.

It reduces the need for the original caller to remain connected until all work completes.

---

# Amazon EventBridge

EventBridge is an event-routing service that can receive events and route them to targets based on configured rules.

The course uses it as a decoupling layer between an API endpoint and background processing.

```text
Event Producer
     ↓
Event Bus
     ↓
Matching Rules
     ↓
Target Services
```

Publishing an event and successfully delivering it to every intended consumer are distinct operational stages.

---

# PutEvents and Event Content

The course diagram labels the API Gateway-to-EventBridge interaction as `PutEvents`.

Conceptually, an event can include:

```json
{
  "source": "training.todo",
  "detail-type": "TodoStatusChanged",
  "detail": {
    "todoId": "example-1",
    "status": "Created"
  }
}
```

This JSON is an illustrative logical event, not a captured AWS request or response.

Actual `PutEvents` API entries use service-defined fields such as `Source`, `DetailType`, and a string-encoded `Detail` value.

The publisher must use appropriate IAM permissions, and the receiver must use appropriate event-pattern and target configuration.

---

# PutEvents Response Handling

The HTTP status of a `PutEvents` request does not by itself establish that every event entry was ingested successfully.

The response can contain:

```json
{
  "FailedEntryCount": 1,
  "Entries": [
    { "EventId": "illustrative-success-id" },
    { "ErrorCode": "InternalFailure", "ErrorMessage": "Illustrative failure" }
  ]
}
```

The values above are illustrative, not captured AWS API output.

A publisher should inspect failed entries and decide whether and how to retry them. Even an accepted event must still match a suitable rule and reach its intended target before business processing can begin.

---

# Course Architecture Example 2: Fan-Out

The diagram on PDF page 201 extends the architecture with EventBridge, multiple SQS queues, multiple Lambda consumers, an authorizer, and a dead-letter queue.

```text
Client
   ↓
API Gateway
   ↓
EventBridge
   ├── Status=Created   ──> SQS ──> Consumer Lambda
   ├── Status=Processed ──> SQS ──> Consumer Lambda
   └── Status=Refunded  ──> SQS ──> Consumer Lambda
```

The diagram labels several independent processing paths.

Fan-out generally refers to one event being delivered to more than one consumer or processing branch when rules are configured accordingly.

In this specific course diagram, the branches are also distinguished by status-based routing. A Created event should not be assumed to enter the Processed and Refunded queues unless the rules explicitly match it.

---

# Event Rules and Status Routing

EventBridge rules can use event patterns to select applicable event data.

For example, a conceptual rule pattern for Created status is:

```json
{
  "source": ["training.todo"],
  "detail-type": ["TodoStatusChanged"],
  "detail": {
    "status": ["Created"]
  }
}
```

Corresponding patterns can route Processed and Refunded statuses to other targets.

A rule that does not match an event will not invoke its target for that event.

Rules and event payload contracts must be versioned or reviewed together so an application change does not silently break routing.

---

# Why SQS Is Between EventBridge and Lambda

The course places Amazon SQS queues between EventBridge and the processing functions.

```text
EventBridge Rule
       ↓
SQS Queue
       ↓
Lambda Event Source Mapping
       ↓
Consumer Lambda
```

SQS is useful because producers and consumers can operate at different rates.

For example:

```text
Sudden Event Burst
        ↓
SQS Backlog
        ↓
Consumers Process Over Time
```

The queue buffers work while consumers process available messages.

However, a queue is not a substitute for monitoring or capacity planning. Queue age, backlog, visibility timeout, duplicate handling, and consumer concurrency still matter.

---

# SQS Consumer Processing

For an SQS event source mapping, Lambda polls the queue and may invoke a function with a batch of messages.

```text
SQS Messages
     ↓
Event Source Mapping
     ↓
Lambda Batch Processing
     ↓
Successful Messages Removed
```

If an invocation fails, messages can become visible again after the queue visibility timeout.

Without partial batch failure handling, one failed record can cause a whole batch to be retried.

This is why idempotent consumer logic is important.

---

# Idempotency

Asynchronous systems can deliver or process a message more than once.

Idempotency means repeated processing of the same logical operation does not create unintended duplicate effects.

```text
Order Created Event
      ↓
Consumer Receives Event
      ↓
Already Processed This Event?
      ├── Yes → Skip Duplicate Side Effect
      └── No  → Process and Record Outcome
```

Possible approaches include durable event IDs, conditional writes, deduplication records, and domain-specific state transitions.

Idempotency cannot be guaranteed simply by enabling EventBridge or SQS.

---

# Dead-Letter Queues

The PDF page 201 labels DLQs in the design.

A dead-letter queue preserves selected messages or failed-delivery events for later analysis instead of discarding them silently.

Two mechanisms should be distinguished.

```text
EventBridge Rule Target Delivery Failure
          ↓
EventBridge Target DLQ (SQS)
```

```text
SQS Message Repeated Consumer Failure
          ↓
SQS Redrive Policy
          ↓
SQS DLQ
```

These are not necessarily the same queue or the same failure stage.

The first concerns delivery from EventBridge to a target. The second concerns repeated failure while processing an SQS source message.

---

# Retries and Recovery

A safe asynchronous workflow considers:

```text
Event Accepted?
       ↓
Rule Matched?
       ↓
Target Delivery Succeeded?
       ↓
Message Present in SQS?
       ↓
Consumer Invoked?
       ↓
Processing Succeeded?
       ↓
Required State Verified?
```

A failure can occur at any stage.

Recovery may require correcting permissions, event patterns, destination configuration, consumer code, timeouts, or downstream capacity.

A DLQ only preserves evidence or work according to its configuration; it does not automatically make the root cause disappear.

---

# API Gateway Custom Authorizer

The page 201 diagram also includes a custom authorizer connected to API Gateway.

Conceptually:

```text
Client Request
      ↓
API Gateway
      ↓
Authorizer Decision
      ├── Deny → Reject Request
      └── Allow → Continue Integration
```

This is a separate responsibility from Lambda's execution role.

```text
API Authorization
→ Is the caller permitted to invoke the API?
```

```text
Lambda Execution Role
→ What AWS actions may the function perform?
```

An authorizer can protect an API entry point, but consumer functions and queues must also use least privilege and appropriate resource policies.

---

# Asynchronous Observability

In a synchronous design, one client request can make it easier to correlate a final response with the work performed.

In an asynchronous design, work is separated across services and time.

A useful correlation model is:

```text
Request ID / Business Operation ID
            ↓
Published Event
            ↓
Queue Message
            ↓
Consumer Log and Outcome
```

Useful evidence can include:

```text
API Gateway Request and Integration Metrics
EventBridge Rule and Delivery Metrics
SQS Message Backlog and Age
Lambda Invocation / Error / Duration
CloudWatch Logs
Distributed Traces Where Configured
Application State
```

An API-level success response alone does not prove that all consumers completed successfully.

---

# AWS SAM

The PDF page 202 introduces AWS SAM (AWS Serverless Application Model) as a way to describe and automate serverless applications.

SAM builds on AWS CloudFormation.

A SAM template can define serverless-specific resources in a concise form and be transformed into CloudFormation resources for deployment.

```text
SAM Template
      ↓
SAM / CloudFormation Transformation
      ↓
CloudFormation Stack
      ↓
API Gateway / Lambda / DynamoDB / IAM
```

This connects directly to the CloudFormation module studied earlier.

SAM does not eliminate the need to understand the generated infrastructure and its permissions.

---

# CloudFormation vs SAM

```text
CloudFormation
→ General AWS infrastructure as code
```

```text
AWS SAM
→ CloudFormation-based model optimized for serverless applications
```

The course page 202 shows that a shorter template can represent the API, function, DynamoDB table, and related permissions.

The deployment still uses CloudFormation resource lifecycle and stack-management concepts.

---

# SAM Template Structure

The course shows these top-level template elements:

```text
AWSTemplateFormatVersion
Transform
Resources
```

A representative template structure is:

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Transform: AWS::Serverless-2016-10-31

Resources:
  GetProductsFunction:
    Type: AWS::Serverless::Function
    Properties:
      CodeUri: src/
      Handler: app.handler
      Runtime: python3.12
      Policies:
        - DynamoDBReadPolicy:
            TableName: !Ref ProductTable
      Events:
        GetProductsEvent:
          Type: Api
          Properties:
            Path: /products
            Method: get

  ProductTable:
    Type: AWS::Serverless::SimpleTable
```

This is a course-aligned conceptual template. It is not a completed deployment artifact without the corresponding function source code, dependencies, AWS environment, and deployment configuration.

The original course screenshot uses `python3.9`. The example above uses a more recent runtime for illustration; deployed projects must confirm supported runtimes and dates at the time of use.

---

# AWS::Serverless::Function

This resource defines a Lambda function through SAM-specific shorthand.

Important properties in the course example include:

```text
CodeUri
→ Location of function code

Handler
→ Function entry point

Runtime
→ Execution runtime

Policies
→ Function permissions

Events
→ Invoking event definitions
```

The example uses `DynamoDBReadPolicy` to represent read-oriented table access.

Actual effective IAM permissions should be reviewed rather than inferred solely from the resource name.

---

# AWS::Serverless::SimpleTable

`AWS::Serverless::SimpleTable` is a SAM shorthand for a basic DynamoDB table.

It is suitable for introductory examples that require simple key-based table definitions.

For more detailed DynamoDB features, applications can use `AWS::DynamoDB::Table` in CloudFormation or SAM templates.

This connects the serverless architecture lesson to the previously completed DynamoDB data-model module.

---

# SAM CLI

The course introduces AWS SAM CLI as a local development and deployment tool.

The general workflow is:

```text
Application Code and Template
              ↓
Validate
              ↓
Build
              ↓
Local Test Where Applicable
              ↓
Review Deployment Plan
              ↓
Deploy Through CloudFormation
              ↓
Verify Application
```

Representative commands include:

```bash
sam validate
sam build
sam local start-api
sam deploy --guided
```

These commands are examples and have not been run in an AWS environment for this document.

Local testing may require Docker or another supported local container environment. It does not prove that cloud-side IAM permissions or managed-service integrations are correct.

---

# Conceptual Practice Workflow

The four-page course section introduces architecture patterns rather than documenting the completion of a full AWS deployment.

A safe follow-up practice workflow is:

```text
1. Define an API operation and result contract.
2. Decide whether the operation is synchronous or asynchronous.
3. Define data access and DynamoDB keys.
4. Define least-privilege permissions.
5. Model the services in SAM or CloudFormation.
6. Inspect API and Lambda configuration.
7. Configure event patterns and queues if asynchronous.
8. Test success, duplicate, and failure scenarios.
9. Verify metrics, logs, and final application state.
10. Delete disposable resources and verify cleanup.
```

No account-specific resources or successful test results are claimed by this workflow.

---

# Synchronous API Troubleshooting

When the HTTP request fails or is slow:

```text
Client Request Valid?
       ↓
API Route and Authorization?
       ↓
API Integration Working?
       ↓
Lambda Invoked?
       ↓
Function Logs / Errors / Duration?
       ↓
DynamoDB Permissions / Throttling?
       ↓
Response Mapping and Status?
```

A 5xx response does not identify which backend component failed without additional evidence.

---

# Asynchronous Event Troubleshooting

When the API returns an acknowledgement but data is not updated:

```text
Event Successfully Submitted?
       ↓
Event Bus and Source Correct?
       ↓
Event Pattern Matched?
       ↓
Target Permission Correct?
       ↓
Message Reached SQS?
       ↓
Lambda Event Source Mapping Enabled?
       ↓
Consumer Error / Timeout?
       ↓
Retry / DLQ State?
       ↓
Final DynamoDB State Verified?
```

An accepted event is not equivalent to successful end-to-end business processing.

---

# Security Perspective

Security responsibilities exist at multiple boundaries.

```text
Client
   ↓
API Authentication / Authorization
   ↓
API Gateway Integration Permission
   ↓
EventBridge Bus and Target Policies
   ↓
SQS Queue Policies / Encryption
   ↓
Lambda Execution Role
   ↓
DynamoDB Table Permissions
```

Important principles include:

```text
Use Least Privilege
Do Not Embed Long-Lived Credentials
Protect Sensitive Event Payloads
Avoid Logging Secrets or Personal Data
Validate Untrusted Input
Review Public API Exposure
Protect DLQ Data
```

---

# Reliability Perspective

Serverless scaling is not the same as end-to-end reliability.

```text
API Throughput
     ↓
Event Ingestion
     ↓
Queue Backlog
     ↓
Consumer Concurrency
     ↓
Downstream Database Capacity
```

Potential problems include duplicate deliveries, missed event patterns, queue age growth, throttled consumers, failed permissions, and downstream data conflicts.

Retries must be combined with idempotency and explicit success verification.

---

# Cost Perspective

Serverless infrastructure may incur charges from several independent services.

```text
API Gateway Requests
Lambda Invocations and Duration
EventBridge Events
SQS Requests and Storage
DynamoDB Usage
CloudWatch Logs / Metrics
Tracing
Data Transfer
```

Returning a client response early does not mean downstream processing incurs no cost.

Pricing and quotas should be checked for the deployed services and Region rather than assumed from a course diagram.

---

# Evidence Policy

Do not fabricate or publish:

```text
Real AWS Account IDs
Access Keys
Secret Access Keys
Session Tokens
API Gateway Invoke URLs from Private Accounts
Actual API Request IDs
Actual Event IDs
Event Bus ARNs
SQS Queue URLs and Private ARNs
Production DynamoDB Table Names and Data
Lambda Function ARNs
Authorization Tokens
CloudWatch Logs and Metrics from Unperformed Tests
X-Ray Trace IDs or Diagrams from Unperformed Tests
DLQ Messages and Retry Results from Unperformed Tests
Stack IDs and Deployment Output
Billing Values
```

The diagrams, YAML, and commands in this document are educational examples based on the course and technical background explanations.

Actual evidence must come from a permitted AWS account and completed exercise.

---

# Verification Checklist

- The PDF page 199 API Gateway–Lambda–DynamoDB architecture was identified.
- API handling, function logic, and data storage responsibilities were distinguished.
- CloudWatch and X-Ray were recognized as observation tools, not mandatory sequential request-processing steps.
- The PDF page 200 synchronous request path was explained.
- The PDF page 200 asynchronous EventBridge path was explained.
- Event acceptance was distinguished from downstream processing completion.
- EventBridge `PutEvents`, event buses, and rules were introduced.
- The PDF page 201 status-based routing and fan-out pattern was explained.
- EventBridge rules were understood to depend on matching event content.
- SQS was connected to buffering and consumer decoupling.
- SQS-triggered Lambda processing and possible duplicate deliveries were introduced.
- Idempotency was treated as a requirement for safe retries.
- EventBridge target DLQs and SQS consumer DLQs were distinguished.
- The API custom authorizer was separated from the Lambda execution role.
- The PDF page 202 AWS SAM example was connected to CloudFormation.
- `AWS::Serverless::Function` and `AWS::Serverless::SimpleTable` were introduced.
- A historical course runtime was not treated as a timeless deployment requirement.
- `sam validate`, `sam build`, `sam local start-api`, and `sam deploy --guided` were introduced without claiming they were executed.
- Troubleshooting covered the entire synchronous and asynchronous path.
- Security, reliability, cost, and evidence boundaries were considered.

## What I Learned

- A serverless application still requires careful design of API entry points, compute, data, permissions, and observability.
- Synchronous APIs can return the result of backend processing, while asynchronous APIs may acknowledge work before it is complete.
- EventBridge decouples event producers from consumers through rules and targets.
- SQS provides buffering between event delivery and function execution.
- Event routing, retries, dead-letter queues, and idempotency are necessary to reason about asynchronous reliability.
- API authorization and Lambda execution permissions protect different boundaries.
- AWS SAM provides serverless-oriented infrastructure definitions that deploy through CloudFormation.
- A successful infrastructure deployment or API acknowledgement is not the same as verified application behavior.
- The next course module moves from serverless application design to AWS migration concepts.
