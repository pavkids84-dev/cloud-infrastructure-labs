# AWS S3 and CloudFront Foundations Lab

## Objective

Understand Amazon S3 object storage, storage classes, multipart upload, versioning, lifecycle management, static website hosting, transfer acceleration, CloudFront CDN behavior, cache invalidation, and origin-access concepts.

## Scope

```text
Object Storage
Amazon S3
Bucket
Object
Key
Metadata
Storage Classes
Multipart Upload
Versioning
Lifecycle
Static Website Hosting
Transfer Acceleration
Amazon CloudFront
CDN
Origin
Edge Location
Distribution
Cache
TTL
Invalidation
Origin Access Identity Context
Signed Access Context
```

## Object Storage

An object contains:

```text
Data
Metadata
Key
```

S3 exposes object storage through APIs rather than as a normal local block device.

## Bucket and Object

```text
Bucket
├── Object Key A
├── Object Key B
└── Object Key C
```

A bucket is created in a Region. Objects can have metadata, tags, storage classes, encryption settings, and versions.

## Block vs Object Storage

```text
EBS
→ Block Storage
→ Filesystem / Database / OS Disk

S3
→ Object Storage
→ API-Based Object Access
```

S3 should not be treated as a direct replacement for every filesystem or database workload.

## S3 Storage Classes

The course introduces:

```text
S3 Standard
S3 Standard-IA
S3 One Zone-IA
S3 Intelligent-Tiering
S3 Glacier
S3 Glacier Deep Archive
```

Selection depends on access frequency, retention, recovery requirements, availability, and cost. Exact prices and retrieval characteristics are time-sensitive.

## Multipart Upload

Large objects can be split into parts and uploaded independently.

```text
Large Object
    ↓
Part 1 / Part 2 / Part 3 / ...
    ↓
Complete Multipart Upload
```

Multipart upload is an API capability and can be used through CLI, SDKs, and tools that implement it.

## Versioning

Versioning allows multiple versions of the same object key.

```text
Object Key
├── Version 1
├── Version 2
└── Version 3
```

With versioning enabled, uploading the same key creates a new version rather than simply destroying the old version.

## Delete Markers

A normal delete in a versioned bucket can create a delete marker. Earlier versions can remain recoverable until permanently removed.

## Lifecycle Management

Lifecycle rules can transition or expire objects and old versions.

```text
Current Object
      ↓ after time
Lower-Cost Storage Class
      ↓ after retention period
Expiration
```

Lifecycle rules can also help clean incomplete multipart uploads.

## Static Website Hosting

S3 can host static web content.

```text
HTML / CSS / JS
      ↓
S3 Website Endpoint
      ↓
Browser
```

The course practice uses public-access changes to demonstrate this feature. Treat that as training context, not a default production security pattern.

## Public Access Security

Review these controls deliberately:

```text
Block Public Access
Bucket Policy
Object Permissions
CloudFront
TLS
Least Privilege
```

Do not make a private bucket public merely to make a demo work.

## Transfer Acceleration

S3 Transfer Acceleration uses AWS edge infrastructure and backbone networking to accelerate long-distance transfers.

```text
Client
   ↓
Nearby Edge Location
   ↓
AWS Backbone
   ↓
S3 Bucket
```

It is a transfer feature, not a content-cache replacement for CloudFront.

## Course S3 Practice

The course covers:

```text
Create Bucket
Upload Object
Test Access
Local Backup with AWS CLI
Static Website Hosting
CloudFront Integration
```

Course resource names and access results are examples only.

## AWS CLI Credential Warning

The course configures an IAM-user access key with `aws configure`.

Never commit:

```text
Access Key ID
Secret Access Key
Session Token
AWS Credentials File
```

Prefer temporary or centrally managed credentials where available.

## Amazon CloudFront

CloudFront is a CDN.

```text
Origin
   ↓
CloudFront Distribution
   ↓
Edge Location
   ↓
User
```

Origins can include S3, EC2, load balancers, and supported external servers.

## Cache Flow

```text
User Request
      ↓
Edge Location
      ↓
Cache Hit?
   ┌──────┴──────┐
  Yes            No
   ↓              ↓
Return Cache    Fetch Origin
                  ↓
               Cache / Return
```

## TTL and Invalidation

TTL controls how long cached content may remain according to cache policy.

Invalidation can remove selected cached paths before normal expiration.

```text
Origin Updated
      ↓
Old Edge Cache
      ↓
Invalidation
      ↓
New Content on Future Request
```

## Origin Access Identity Context

The course introduces Origin Access Identity, or OAI, as a way to restrict direct S3-origin access.

Treat OAI as course-era context. Current production architecture should verify the current AWS-recommended origin-access mechanism rather than assuming OAI is the only option.

## Signed Access Context

Keep these concepts distinct:

```text
S3 Presigned URL
→ Temporary direct S3 access

CloudFront Signed URL / Signed Cookie
→ Restricted CloudFront content access
```

Course-era CloudFront key-pair procedures should be treated as historical implementation context.

## Troubleshooting Workflow

For S3:

```text
Correct Bucket / Key?
      ↓
Identity Permission?
      ↓
Bucket Policy?
      ↓
Block Public Access?
      ↓
Encryption Permission?
```

For CloudFront:

```text
Distribution Deployed?
      ↓
Correct Origin?
      ↓
Origin Accessible?
      ↓
Cache Behavior?
      ↓
Object Path?
      ↓
Invalidation Needed?
```

## Evidence Policy

Do not fabricate or publish:

```text
Real Bucket Names
Private Object URLs
Access Keys
Secret Access Keys
CloudFront Distribution IDs
CloudFront Domain Names
Signed URLs
Private Policy Documents
CLI Output
Billing Values
```

Actual evidence must come from an authorized AWS environment.

## What I Learned

- S3 is object storage accessed through APIs.
- Storage classes match different access and retention patterns.
- Versioning and lifecycle rules manage object history and cost.
- CloudFront caches content at edge locations to reduce latency and origin load.
- Secure S3 and CloudFront designs require deliberate origin and public-access controls.
