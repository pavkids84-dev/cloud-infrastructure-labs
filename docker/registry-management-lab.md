# Docker Registry Management Lab

## Objective

Understand how Docker images are named, distributed, uploaded, downloaded, and shared through public and private container registries.

The goal is to connect local image builds to repeatable multi-host container deployment.

## Scope

```text
Docker Registry
Docker Hub
Public Repository
Private Repository
Image Tags
docker tag
docker login
docker push
docker pull
Private Registry
Image Distribution
CI/CD Context
Registry Security
```

---

# Docker Registry

The course defines a Docker registry as an image-storage server.

Conceptually:

```text
Docker Host
    ↓ push
Registry
    ↓ pull
Docker Host
```

A registry allows reusable images to be distributed independently from the host on which they were originally built.

---

# Docker Hub

The course introduces Docker Hub as the default public registry service used in its Docker environment.

Docker Hub provides access to:

```text
Official Images
Publisher Images
User Repositories
```

The course also discusses public and private repository concepts.

Repository pricing and quota details in the course reflect the policy at the time the material was created and should not be treated as permanent service limits.

---

# Registry vs Repository

A useful distinction is:

```text
Registry
→ Image storage and distribution service
```

```text
Repository
→ Logical collection of related images within a registry
```

A repository can contain multiple image tags.

---

# Image Reference

A registry image can be represented using a structure such as:

```text
REGISTRY/REPOSITORY:TAG
```

For example:

```text
registry.example.com/team/app:1.0
```

can be interpreted as:

```text
registry.example.com
→ Registry

team/app
→ Repository

1.0
→ Tag
```

---

# `docker tag`

The course demonstrates assigning a registry-oriented reference to an existing image.

Conceptually:

```text
Existing Image
      ↓
docker tag
      ↓
Additional Image Reference
```

`docker tag` should not be interpreted as rebuilding the image.

It creates another reference to image content so that the image can be identified using the target repository name.

---

# Docker Hub Push Workflow

The course demonstrates a workflow such as:

```text
Local Image
    ↓
docker tag
    ↓
Registry-Compatible Image Reference
    ↓
docker login
    ↓
docker push
    ↓
Docker Hub
```

This connects local image creation to remote image distribution.

---

# `docker login`

The course introduces:

```bash
docker login
```

before pushing an authenticated repository image.

Registry authentication should be treated as sensitive infrastructure access.

Do not store registry credentials in:

```text
Dockerfiles
Public Git Repositories
Shell Scripts committed with secrets
Image Layers
```

---

# `docker push`

`docker push` uploads image content to the registry referenced by the image name.

Conceptually:

```text
Local Image Layers
       ↓
docker push
       ↓
Registry Repository
```

Reusable layers can reduce repeated transfer when content already exists in the registry.

---

# `docker pull`

`docker pull` retrieves image content from a registry.

Conceptually:

```text
Registry
   ↓
docker pull
   ↓
Local Image Store
   ↓
docker run
   ↓
Container
```

This makes image deployment independent from the build host.

---

# Automated Image Build Context

The course describes automated build integration with source repositories such as GitHub and Bitbucket.

The important architectural idea is:

```text
Source Repository
       ↓
Dockerfile / Source Change
       ↓
Automated Image Build
       ↓
Registry
```

This concept connects naturally to modern CI/CD pipelines.

---

# Container Delivery Pipeline

The complete image-delivery flow can be represented as:

```text
Source Code
    ↓
Dockerfile
    ↓
docker build
    ↓
Image
    ↓
docker tag
    ↓
docker push
    ↓
Registry
    ↓
docker pull
    ↓
Deployment Host
    ↓
docker run
```

The registry separates image build from image execution.

---

# Private Registry

The course introduces operating a local Docker registry instead of relying only on Docker Hub.

Conceptually:

```text
Public Registry
      ↓
Registry Software/Image
      ↓
Local Registry Server
```

and:

```text
Developer / Build Host
       ↓ push
Private Registry
       ↓ pull
Server 1
Server 2
Server 3
```

---

# Private Registry Image Reference

The course demonstrates registry references using a host and port:

```text
registry_server_ip:5000/test:env
```

Conceptually:

```text
Registry Host
→ registry_server_ip:5000

Repository
→ test

Tag
→ env
```

---

# Private Registry Workflow

The course demonstrates:

```text
Local Image
    ↓
docker tag
    ↓
PRIVATE_REGISTRY/repository:tag
    ↓
docker login
    ↓
docker push
    ↓
Private Registry
```

Another host can then use:

```text
Private Registry
     ↓
docker pull
     ↓
Local Image
```

---

# Multi-Host Distribution

A registry enables the same image to be distributed to multiple hosts.

```text
                 ┌→ Server 1
Image → Registry ├→ Server 2
                 └→ Server 3
```

This supports consistent application packaging across deployment targets.

---

# Registry and Kubernetes

The registry model becomes especially important in orchestration environments.

Conceptually:

```text
Container Image
      ↓
Registry
      ↓
Cluster Node
      ↓
Container Runtime
      ↓
Container
```

The orchestration platform does not need the application to be manually installed on every node.

It needs access to the required image.

---

# Public vs Private Registry Use

A public registry can be useful for:

```text
Public Software Images
Open-Source Projects
Shared Community Images
```

A private registry can be useful for:

```text
Internal Applications
Organization-Specific Base Images
Restricted Software
Controlled Deployment Artifacts
```

The appropriate model depends on the organization's security and distribution requirements.

---

# Registry Security

The course demonstrates a simple local registry using a host and port.

Production registry design should also consider:

```text
TLS
Authentication
Authorization
Credential Protection
Image Provenance
Image Scanning
Access Logging
Availability
Storage Protection
```

A registry is part of the software supply chain and should be treated as security-sensitive infrastructure.

---

# Trusted Image Sources

Do not treat every image in a registry as equally trustworthy.

Before using an image, consider:

```text
Publisher
Repository Source
Image Tag
Image Digest
Maintenance Status
Required Architecture
Security Review
```

Where stronger reproducibility is required, image digests can be useful in addition to human-readable tags.

---

# Tags and Deployment Reproducibility

Tags provide convenient references:

```text
app:1.0
app:stable
app:latest
```

but tags are references rather than immutable content guarantees.

A deployment requiring exact image identity should understand the distinction between:

```text
Tag
→ Human-readable reference
```

and:

```text
Digest
→ Content-addressed identity
```

---

# CI/CD Relationship

A registry sits naturally between build and deployment.

```text
Git Commit
    ↓
CI
    ↓
Test
    ↓
docker build
    ↓
Image
    ↓
docker push
    ↓
Registry
    ↓
Deployment
```

This makes the image itself a versioned deployable artifact.

---

# Troubleshooting Model

If an image cannot be deployed from a registry:

```text
Correct Image Reference?
       ↓
Registry Reachable?
       ↓
Authentication Successful?
       ↓
Repository / Tag Exists?
       ↓
Push Completed?
       ↓
Pull Authorized?
       ↓
Image Download Successful?
```

Network, DNS, TLS, authentication, and registry state can all participate in a registry failure.

---

# Evidence Policy

Course registry addresses and command output are educational examples.

Do not fabricate:

```text
Registry Hostnames
Registry IP Addresses
Repository Names
Authentication Results
Image IDs
Image Digests
Push Results
Pull Results
```

Actual evidence should come from the authorized lab environment.

Do not commit registry passwords or access tokens to Git.

---

# Verification Checklist

- Registry and repository were distinguished.
- Docker Hub was understood as a registry service.
- Historical repository quota information was not treated as permanent current policy.
- Docker image references were decomposed into registry, repository, and tag.
- `docker tag` was understood as creating an image reference rather than rebuilding image content.
- `docker login` was connected to registry authentication.
- `docker push` was understood as uploading image content.
- `docker pull` was understood as retrieving image content.
- Source-repository automation was connected to CI/CD.
- A private registry was understood as an internal image-distribution service.
- Registry host and port were recognized as part of a private image reference.
- Multi-host image distribution was reviewed.
- Registry concepts were connected to future Kubernetes image delivery.
- Public and private registry use cases were distinguished.
- Registry infrastructure was recognized as security-sensitive.
- Tags and digests were distinguished for reproducibility.
- Registry credentials were not treated as content that belongs in Dockerfiles or Git repositories.

## What I Learned

- A registry separates image creation from image execution.
- Image references tell Docker which registry and repository should be used.
- Tags provide convenient image names while digests identify image content.
- Private registries allow organizations to distribute internal images without publishing them publicly.
- Registries are central components of container CI/CD pipelines.
- Registry availability, authentication, networking, and security become deployment dependencies.
- Kubernetes and other orchestrators depend on registries to distribute container images across nodes.
