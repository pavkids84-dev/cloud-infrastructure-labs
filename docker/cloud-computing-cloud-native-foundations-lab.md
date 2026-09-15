# Cloud Computing and Cloud-Native Foundations Lab

## Objective

Understand the cloud-computing concepts that provide the infrastructure context for containers and Docker.

This lab covers cloud service models, management responsibility, cloud deployment models, cloud-native application characteristics, monolithic and microservice architectures, and the relationship between containers and cloud services.

The goal is to understand why container technology is commonly associated with modern cloud-native application delivery.

## Scope

```text
Cloud Computing
Cloud Services
IaaS
PaaS
SaaS
Management Responsibility
Private Cloud
Community Cloud
Public Cloud
Hybrid Cloud
Cloud Native
DevOps
REST / HTTP API
Decoupling
Microservices
CI/CD
Containers
Infrastructure as Code
Serverless
```

---

# Cloud Computing

The course introduces cloud computing as a model in which computing work such as processing, storage, management, and service delivery can occur in remote infrastructure accessed through a network.

Conceptually:

```text
Client Device
      ↓
Network
      ↓
Cloud
├── Software
├── Platform
└── IT Infrastructure
```

The client does not need to perform every computing function locally.

---

# Cloud Services

Cloud services can provide more than remote file storage.

The course describes services that allow users to:

```text
Store data remotely
Access programs through the network
Share information
Use web-based applications
Collaborate with multiple users
```

A simplified model is:

```text
User
 ↓
Internet
 ↓
Cloud Service
```

---

# Cloud Service Models

The course introduces three major cloud service models:

```text
IaaS
PaaS
SaaS
```

Each model changes how management responsibility is divided between the user and service provider.

---

# IaaS

IaaS stands for:

```text
Infrastructure as a Service
```

The service provider manages infrastructure layers such as:

```text
Networking
Storage
Servers
Virtualization
```

The user manages higher layers such as:

```text
Operating System
Middleware
Runtime
Data
Applications
```

Conceptually:

```text
Application
Data
Runtime
Middleware
OS
----------------
Virtualization
Servers
Storage
Networking
```

The boundary separates user-managed and provider-managed responsibilities.

---

# PaaS

PaaS stands for:

```text
Platform as a Service
```

In the course responsibility model, the user primarily manages:

```text
Applications
Data
```

while the provider manages the underlying platform and infrastructure.

Conceptually:

```text
Application
Data
----------------
Runtime
Middleware
OS
Virtualization
Servers
Storage
Networking
```

PaaS allows developers to focus more on application delivery and less on infrastructure administration.

---

# SaaS

SaaS stands for:

```text
Software as a Service
```

The course model shows the service provider managing the complete application and infrastructure stack.

The user consumes the provided software service.

Conceptually:

```text
User
 ↓
SaaS Application
```

The user does not directly administer the underlying runtime, operating system, or infrastructure.

---

# Service Model Comparison

A simplified comparison is:

```text
IaaS
→ Infrastructure provided
→ Highest user infrastructure responsibility

PaaS
→ Application platform provided
→ Reduced infrastructure responsibility

SaaS
→ Complete software provided
→ Lowest direct infrastructure responsibility
```

As provider abstraction increases:

```text
Provider Responsibility
↑
```

while:

```text
User Infrastructure Responsibility
↓
```

---

# Management Responsibility Model

The course compares responsibility across:

```text
On-Premises
IaaS
PaaS
SaaS
```

using these layers:

```text
Applications
Data
Runtime
Middleware
Operating System
Virtualization
Servers
Storage
Networking
```

---

# On-Premises Responsibility

In the course model, the organization manages every layer:

```text
Applications
Data
Runtime
Middleware
OS
Virtualization
Servers
Storage
Networking
```

This provides maximum control but also maximum operational responsibility.

---

# IaaS Responsibility

In the course IaaS model:

```text
User Manages
→ Applications
→ Data
→ Runtime
→ Middleware
→ OS
```

```text
Provider Manages
→ Virtualization
→ Servers
→ Storage
→ Networking
```

Using cloud infrastructure does not eliminate the user's responsibility for the operating system and application layers.

---

# PaaS Responsibility

In the course PaaS model:

```text
User Manages
→ Applications
→ Data
```

```text
Provider Manages
→ Runtime
→ Middleware
→ OS
→ Virtualization
→ Servers
→ Storage
→ Networking
```

This allows application teams to operate at a higher abstraction level.

---

# SaaS Responsibility

In the course SaaS model, the provider manages the software and infrastructure stack.

The user primarily consumes the service.

The specific operational responsibility can depend on the actual service, but the course diagram emphasizes the high provider-management level of SaaS.

---

# Cloud Deployment Models

The course introduces four cloud deployment models:

```text
Private Cloud
Community Cloud
Public Cloud
Hybrid Cloud
```

---

# Private Cloud

A private cloud is shown as cloud infrastructure dedicated to a particular organization.

Conceptually:

```text
Organization
      ↓
Private Cloud
```

---

# Community Cloud

A community cloud is shown as infrastructure shared among multiple organizations.

Conceptually:

```text
Organization A
Organization B
Organization C
       ↓
Community Cloud
```

The organizations share a common cloud environment.

---

# Public Cloud

A public cloud is shown as provider-operated infrastructure serving cloud consumers.

Conceptually:

```text
Cloud Provider
      ↓
Cloud Consumers
```

The provider operates the infrastructure used by multiple customers.

---

# Hybrid Cloud

A hybrid cloud combines or connects different cloud environments.

A simplified example is:

```text
Private Cloud
      +
Public Cloud
      ↓
Hybrid Environment
```

The course diagram emphasizes connectivity between separate cloud environments.

---

# Cloud-Native Application Characteristics

The course introduces the following cloud-native application concepts:

```text
DevOps
REST / HTTP API
Decoupling
Microservices
CI/CD
Containers
Infrastructure as Code
Serverless
```

These concepts provide the context in which container technology is commonly used.

---

# Decoupling

Decoupling separates application components so that they are less tightly bound to one large application structure.

Conceptually:

```text
Large Application
      ↓
Separated Components
```

Decoupling supports the architectural direction shown later in the microservices examples.

---

# Monolithic Architecture

The course compares a monolithic application containing multiple functions inside one application boundary.

Example structure:

```text
Monolithic Application
├── Users
├── Threads
└── Posts
```

The components are packaged as one application service.

---

# Microservices Architecture

The course contrasts the monolith with separate services:

```text
Users Service

Threads Service

Posts Service
```

Conceptually:

```text
One Large Application
        ↓
Multiple Independent Services
```

This architecture is referred to in the course as:

```text
MSA
MicroService Architecture
```

---

# Microservice Request Flow

The course illustrates an application containing:

```text
Mobile App
Browser
API Gateway
Storefront Web Application
Account Service
Inventory Service
Shipping Service
```

The services communicate using REST-style interfaces.

A simplified flow is:

```text
Mobile App
    ↓
API Gateway
    ↓
Backend Services
```

and:

```text
Browser
    ↓
Storefront Web Application
    ↓
Backend Services
```

---

# Service-Specific Data

The course diagram shows separate databases associated with services:

```text
Account Service
→ Account Database

Inventory Service
→ Inventory Database

Shipping Service
→ Shipping Database
```

This illustrates service-oriented separation of application components and their data responsibilities.

---

# REST / HTTP API

The course identifies:

```text
REST / HTTP API
```

as a cloud-native application characteristic.

The microservice diagram shows REST communication between frontend or gateway components and backend services.

Conceptually:

```text
Service A
   ↓
REST / HTTP
   ↓
Service B
```

---

# DevOps

The course identifies DevOps as a cloud-native application characteristic.

At this stage, the important relationship is:

```text
Development
+
Operations
```

working more closely around application delivery and operation.

Detailed DevOps practices are outside the scope of this section.

---

# CI/CD

The course identifies:

```text
CI/CD
```

as a cloud-native application characteristic.

A general delivery flow can be represented as:

```text
Code
 ↓
Build
 ↓
Test
 ↓
Package
 ↓
Deploy
```

Automation of this flow becomes especially relevant when application artifacts are packaged as container images.

---

# Infrastructure as Code

The course identifies:

```text
IaC
```

as a cloud-native characteristic.

IaC stands for:

```text
Infrastructure as Code
```

It represents the practice of defining infrastructure using code or configuration rather than relying only on manual interface operations.

Conceptually:

```text
Infrastructure Definition
        ↓
Automated Provisioning
        ↓
Repeatable Environment
```

---

# Serverless

The course includes:

```text
Serverless
```

as both a cloud-native application concept and a cloud-service model in the container-and-cloud context.

Serverless should not be interpreted as meaning that no physical servers exist.

The infrastructure still exists, but server provisioning and management are abstracted from the application user.

---

# Containers

The course places:

```text
Container
```

among the core cloud-native characteristics.

Containers provide a way to package an application and its required runtime environment into a repeatable execution unit.

Conceptually:

```text
Application
+
Libraries
+
Runtime Requirements
        ↓
Containerized Workload
```

Detailed Docker implementation is covered in the following sections of the course.

---

# Containers and Microservices

Containers and microservices are separate concepts, but they can work well together.

Conceptually:

```text
Users Service
→ Container

Inventory Service
→ Container

Shipping Service
→ Container
```

Each service can be packaged and operated independently.

The course does not state that every microservice must run in a container.

---

# Cloud and Container Relationship

The course connects containers with cloud service models including:

```text
IaaS
PaaS
SaaS
Serverless
```

The exact role of containers depends on the architecture and cloud service being used.

Containers can run on infrastructure provided by cloud platforms and can also be hidden behind higher-level managed services.

---

# Course Service Examples

The course provides examples such as:

```text
IaaS
→ OpenStack
→ SoftLayer
→ AWS
→ Azure
```

and:

```text
PaaS
→ Bluemix
→ OpenShift
→ Cloud Foundry
→ Elastic Beanstalk
```

These examples reflect the course material and its terminology.

The important learning objective is the service-model concept rather than memorizing product names.

---

# Cloud-Native Architecture Model

The concepts introduced by the course can be connected as:

```text
Cloud Infrastructure
        ↓
Cloud-Native Application
        ↓
Decoupled Services
        ↓
REST / HTTP APIs
        ↓
Microservices
        ↓
Containers
        ↓
CI/CD and Automation
```

This provides the architectural context for studying Docker.

---

# Virtualization to Containers

The previous virtualization lab introduced:

```text
Physical Infrastructure
      ↓
Virtual Machines
      ↓
Guest Operating Systems
```

The cloud-native model can extend this architecture with:

```text
Cloud Infrastructure
      ↓
Virtual Machine
      ↓
Linux
      ↓
Container Runtime
      ↓
Containerized Services
```

Virtual machines and containers therefore operate at different infrastructure layers and can be used together.

---

# Verification Checklist

- Cloud computing was understood as network-accessible computing infrastructure and services.
- IaaS, PaaS, and SaaS were distinguished.
- User and provider management responsibilities were compared.
- On-premises responsibility was reviewed.
- Private cloud was reviewed.
- Community cloud was reviewed.
- Public cloud was reviewed.
- Hybrid cloud was reviewed.
- Cloud-native application characteristics were identified.
- Monolithic and microservice architectures were distinguished.
- The course microservice request-flow diagram was reviewed.
- REST / HTTP API communication was connected to service interaction.
- CI/CD was connected to automated application delivery.
- Infrastructure as Code was introduced.
- Serverless was not interpreted as the absence of servers.
- Containers were connected to cloud-native application delivery.
- Containers and microservices were not treated as identical concepts.
- Course vendor examples were treated as examples rather than the primary learning objective.

## What I Learned

- Cloud service models differ primarily in abstraction and management responsibility.
- IaaS gives users more infrastructure control and responsibility than PaaS or SaaS.
- Cloud deployment can use private, community, public, or hybrid models.
- Cloud-native architecture emphasizes loosely coupled services, APIs, automation, and repeatable deployment.
- Microservices divide a larger application into smaller service boundaries.
- Containers can package independent services into repeatable execution environments.
- CI/CD and Infrastructure as Code support automated and repeatable delivery.
- Serverless abstracts server management rather than eliminating infrastructure.
- Docker should be understood within the broader context of cloud-native application delivery.
