# Docker Compose Lab

## Objective

Understand how Docker Compose defines and manages multi-container applications as one project.

The focus is on replacing repeated manual `docker run` operations with a reproducible YAML-based runtime definition that describes services, networking, ports, storage, environment configuration, and application relationships.

## Scope

```text
Docker Compose
Compose Projects
YAML
Services
Images
Restart Policies
Container Names
Ports
Volumes
Environment Variables
Service Discovery
Service Names
Multi-Container Applications
docker compose up
docker compose ps
docker compose stop
docker compose start
docker compose down
docker compose exec
docker compose logs
WordPress
MySQL
Registry Service
Compose Troubleshooting
```

---

# Why Docker Compose

Managing multiple containers manually can require many separate commands.

Conceptually:

```text
Create Network
    ↓
Start Database Container
    ↓
Start Application Container
    ↓
Configure Ports
    ↓
Configure Storage
    ↓
Configure Environment
```

Docker Compose moves these runtime definitions into a YAML file.

```text
Compose Definition
      ↓
docker compose up
      ↓
Multi-Container Application
```

The goal is repeatable project-level container operation.

---

# Compose Project Model

Docker Compose manages multiple containers as one project.

Conceptually:

```text
Application Project
├── Web Service
├── Database Service
├── Network
└── Storage
```

This changes the operational unit from an individual container to an application stack.

---

# YAML

Compose definitions use YAML.

A simple structure is:

```yaml
services:
  web:
    image: nginx
```

YAML hierarchy is represented using indentation.

Incorrect indentation can change or invalidate the configuration structure.

---

# Compose Service Definition

The course introduces service configuration using properties such as:

```text
services
image
restart
container_name
ports
volumes
environment
```

These properties represent runtime configuration that would otherwise be passed through multiple `docker run` options.

---

# Infrastructure as Configuration

A Compose file provides a reusable definition of the runtime environment.

Conceptually:

```text
Manual Runtime Commands
        ↓
Compose YAML
        ↓
Versioned Runtime Definition
        ↓
Repeatable Environment
```

This connects container operation to infrastructure automation and configuration-as-code practices.

---

# Service Discovery

The course identifies service discovery as a Docker Compose capability.

A service can reference another service by its logical service name.

For example:

```yaml
services:
  wordpress:
    environment:
      WORDPRESS_DB_HOST: db

  db:
    image: mysql
```

Conceptually:

```text
WordPress
    ↓
Service Name: db
    ↓
Database Service
```

This avoids unnecessary dependency on a temporary container IP address.

---

# Service Name vs Container IP

Container IP addresses are runtime network state and can change after recreation.

```text
Old Container
→ IP A

Recreated Container
→ IP B
```

A service name provides a more stable logical application reference.

```text
Runtime IP
→ Network location

Service Name
→ Application identity
```

---

# Scale-Out Concept

The course introduces scale-out as a Compose capability.

Conceptually:

```text
Web Service
   ↓
Multiple Container Instances
```

Scaling is not only a container-count problem.

Applications can also require consideration of:

```text
Port Conflicts
Load Balancing
State Management
Shared Storage
Service Discovery
```

The course section introduces the concept rather than a complete production scaling design.

---

# Compose Commands

The course uses historical standalone Compose commands such as:

```bash
docker-compose up -d
docker-compose ps
docker-compose stop
docker-compose start
docker-compose down
docker-compose exec
docker-compose logs
```

Modern Docker installations commonly expose Compose through the Docker CLI:

```bash
docker compose ...
```

The architecture and project concepts remain the same.

---

# `docker compose up`

A simplified Compose deployment flow is:

```text
Read Compose Definition
        ↓
Create Required Network Resources
        ↓
Create Required Containers
        ↓
Apply Runtime Configuration
        ↓
Start Services
```

Detached operation can be requested with:

```bash
docker compose up -d
```

---

# `docker compose ps`

Use:

```bash
docker compose ps
```

to inspect service/container state for the project.

Conceptually:

```text
Compose Definition
        ↓
Runtime Containers
        ↓
docker compose ps
        ↓
Observed State
```

A successful configuration parse does not prove that every service is healthy.

---

# `docker compose stop`

Conceptually:

```text
Running Project Containers
        ↓
docker compose stop
        ↓
Stopped Containers
```

The project containers remain available for later restart.

---

# `docker compose start`

Conceptually:

```text
Existing Stopped Project
        ↓
docker compose start
        ↓
Running Containers
```

This reuses existing Compose-created containers.

---

# `docker compose down`

`down` represents project teardown rather than only process termination.

Conceptually:

```text
Running Compose Project
        ↓
docker compose down
        ↓
Project Runtime Resources Removed
```

`stop` and `down` should therefore not be treated as identical operations.

---

# `docker compose exec`

Compose can execute an additional process inside a running service container.

Conceptually:

```text
Running Service
      ↓
docker compose exec
      ↓
Additional Process
```

This is the project/service-oriented equivalent of the previously studied `docker exec` concept.

---

# `docker compose logs`

Compose can collect application logs from services in the project.

This is useful when a multi-container application fails because the visible symptom can originate from another service.

Conceptually:

```text
Application Failure
       ↓
docker compose logs
       ↓
Web Logs
Database Logs
Other Service Logs
```

---

# Registry Service Example

The course demonstrates a Compose project defining a Docker registry service.

The historical course definition is conceptually equivalent to:

```yaml
services:
  registry-server:
    image: registry
    restart: always
    container_name: registry-server
    ports:
      - "5000:5000"
    volumes:
      - /registry:/var/lib/registry
```

This combines previously studied Docker concepts in one service definition.

---

# `image`

The `image` field specifies which image should be used by the service.

```yaml
image: registry
```

Conceptually:

```text
Service
   ↓
Docker Image
   ↓
Container
```

---

# `restart`

The course uses:

```yaml
restart: always
```

to define restart behavior.

Restart policies can cause a container to run again after process or daemon lifecycle events.

A restart policy should not replace root-cause investigation.

Repeated container failure should still be investigated using:

```text
Container State
Exit Code
Application Logs
Runtime Metadata
```

---

# `container_name`

The course explicitly assigns:

```yaml
container_name: registry-server
```

This provides a fixed container name.

However, Compose application design should also understand the distinction between:

```text
Container Name
```

and:

```text
Compose Service Name
```

Service names are central logical identifiers within the Compose project.

---

# `ports`

The course demonstrates:

```yaml
ports:
  - "5000:5000"
```

This maps:

```text
Host Port 5000
      ↓
Container Port 5000
```

The concept is the same as Docker's previously studied `-p` port-publishing option.

---

# `volumes`

The registry example includes:

```yaml
volumes:
  - /registry:/var/lib/registry
```

Conceptually:

```text
Host Storage
/registry
    ↕
Container Storage
/var/lib/registry
```

This prevents registry data from depending only on the replaceable container writable layer.

---

# Deploying a Compose Project

The course demonstrates:

```bash
docker-compose up -d
```

followed by:

```bash
docker-compose ps
```

The operational pattern is:

```text
Define
   ↓
Deploy
   ↓
Observe
   ↓
Verify
```

The Compose file represents intended configuration.

Runtime commands verify what actually happened.

---

# Multi-Container WordPress Application

The course demonstrates a WordPress and MySQL Compose project.

The architecture is:

```text
Browser
   ↓
Host Port 8080
   ↓
WordPress Service
   ↓
Service Name: db
   ↓
MySQL Service
```

This is the first course example that combines several Docker concepts into one multi-container application.

---

# WordPress Service

The course defines a WordPress service with:

```text
Image
Restart Policy
Published Port
Database Environment Variables
```

Conceptually:

```yaml
services:
  wordpress:
    image: wordpress
    restart: always
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: exampleuser
      WORDPRESS_DB_PASSWORD: examplepass
      WORDPRESS_DB_NAME: exampledb
```

The application receives database connection configuration through environment variables.

---

# Database Service

The course also defines a database service.

Conceptually:

```yaml
services:
  db:
    image: mysql:5.7
    restart: always
    environment:
      MYSQL_DATABASE: exampledb
      MYSQL_USER: exampleuser
      MYSQL_PASSWORD: examplepass
      MYSQL_RANDOM_ROOT_PASSWORD: "1"
```

The specific image version reflects the course environment.

The important concept is that a Compose project can define multiple cooperating services.

---

# Environment Variables

Compose environment configuration can be used to provide application settings.

Conceptually:

```text
Compose Definition
       ↓
Environment Variables
       ↓
Container Process
       ↓
Application Configuration
```

Do not hardcode real production secrets into Git-tracked Compose files.

Sensitive values require an intentional secret-management strategy.

---

# Example Credentials

The course uses credentials such as:

```text
exampleuser
examplepass
```

for educational demonstration.

These should not be interpreted as acceptable production credential-management practices.

```text
Course Example Secret
→ Demonstration only

Actual Secret
→ Do not commit to Git
```

---

# Service Readiness

A running container is not necessarily a ready application.

```text
Container Running
!=
Application Ready
```

For example:

```text
Database Process Started
```

does not automatically mean:

```text
Database Ready for Application Queries
```

The course introduces service relationships but does not fully cover health or readiness management in this section.

---

# Service Dependencies

The course states that Compose can describe container dependencies.

The example demonstrates application-level dependency through WordPress database configuration.

The presence of a startup relationship should not be assumed to guarantee application readiness.

Dependency management and readiness are separate operational concerns.

---

# Historical Compose Version

The course uses:

```yaml
version: "3"
```

This reflects the Compose file model used by the training material.

The important concepts are the actual service definitions:

```text
services
ports
volumes
environment
networks
```

rather than memorizing one historical Compose schema number.

---

# Historical Docker Toolbox Context

The course refers to Docker Toolbox in the WordPress example.

Docker Toolbox should be treated as historical environment context.

The multi-container Compose concepts remain relevant independently of that legacy tooling.

---

# Dockerfile vs Compose

These files solve different problems.

```text
Dockerfile
→ How to build one image
```

```text
Compose
→ How multiple containers should run together
```

Conceptually:

```text
Dockerfile
   ↓
Image
```

while:

```text
Compose
   ↓
Services
Networks
Volumes
Environment
Ports
```

---

# Dockerfile, Registry, and Compose

The container-delivery model can now be represented as:

```text
Source Code
    ↓
Dockerfile
    ↓
docker build
    ↓
Image
    ↓
Registry
    ↓
Compose
    ↓
Multi-Container Application
```

This forms a foundation for later CI/CD and container orchestration.

---

# Compose Troubleshooting

A practical project-level troubleshooting workflow is:

```text
Compose File Valid?
       ↓
Images Available?
       ↓
docker compose ps
       ↓
Which Service Failed?
       ↓
docker compose logs
       ↓
Network / Service Name Resolution?
       ↓
Environment Configuration?
       ↓
Storage Mounted?
       ↓
Port Published?
       ↓
Application Ready?
```

Do not troubleshoot only the user-facing service.

A dependent service can be the actual source of failure.

---

# Example Dependency Failure

Symptom:

```text
WordPress page cannot connect to database.
```

Investigation can proceed as:

```text
WordPress Container Running?
        ↓
Database Container Running?
        ↓
Database Logs?
        ↓
Service Name "db" Resolves?
        ↓
Database Environment Correct?
        ↓
Database Accepting Connections?
```

This applies the same evidence-based method used in Linux and network troubleshooting.

---

# Runtime vs Definition

Compose reinforces the distinction:

```text
Compose YAML
→ Intended runtime definition
```

```text
docker compose ps / logs
→ Observed runtime state
```

A declarative file alone is not proof that the application is operating correctly.

---

# Security Principles

Compose definitions can expose infrastructure and application configuration.

Important principles include:

```text
Do not commit real secrets.
Review published ports.
Use trusted images.
Use explicit image versions when appropriate.
Use persistent storage intentionally.
Use least privilege.
Keep services on only the networks they require.
Investigate restart loops instead of hiding them.
```

---

# Evidence Policy

Course screenshots and runtime values are educational examples.

Do not fabricate:

```text
Container IDs
Container Names
Service IP Addresses
Network IDs
Database Connection Results
Port Binding Results
Compose Output
Application Screenshots
Log Output
```

Actual lab evidence must come from an authorized runtime environment.

---

# Verification Checklist

- Docker Compose was understood as project-level multi-container management.
- Compose was connected to YAML-based runtime definition.
- `docker run` options were connected to Compose service properties.
- `docker-compose` legacy syntax was distinguished from `docker compose`.
- `up`, `ps`, `stop`, `start`, `down`, `exec`, and `logs` were reviewed.
- `stop` and `down` were distinguished.
- `services` was understood as the central application definition.
- `image` was connected to service container creation.
- Restart policy was reviewed.
- Container names and service names were distinguished.
- Port publishing was represented in Compose.
- Bind-mount style persistent storage was represented in Compose.
- WordPress and MySQL were understood as one multi-container project.
- Service-name-based communication was understood.
- Hardcoded container IP addresses were avoided.
- Environment variables were connected to application configuration.
- Example credentials were not treated as production secret-management practice.
- Container running state was distinguished from application readiness.
- Historical `version: "3"` syntax was recognized as course context.
- Docker Toolbox was recognized as legacy course context.
- Dockerfile and Compose responsibilities were distinguished.
- Compose troubleshooting was treated as project-wide investigation.

## What I Learned

- Docker Compose manages multiple containers as one application project.
- YAML replaces repeated runtime command options with a reusable definition.
- Service names provide logical communication identities between containers.
- Compose can define ports, storage, environment configuration, and restart behavior.
- Dockerfile defines how an image is built, while Compose defines how application services run together.
- Multi-container troubleshooting requires inspecting dependent services as well as the user-facing container.
- Compose is a direct step from individual container management toward container orchestration.
