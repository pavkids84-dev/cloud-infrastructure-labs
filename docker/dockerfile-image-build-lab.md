# Dockerfile and Image Build Lab

## Objective

Understand how Dockerfiles define reproducible container images and how build context, instructions, image layers, caching, multi-stage builds, execution users, ports, and persistent storage affect the resulting image and container runtime.

The goal is to move from manually configuring containers toward repeatable image-based infrastructure.

## Scope

```text
Dockerfile
Build Context
.dockerignore
docker build
FROM
CMD
ENTRYPOINT
ENV
EXPOSE
COPY
ADD
RUN
USER
Image Layers
Build Cache
Multi-Stage Builds
VOLUME
Bind Mount Concepts
docker history
```

---

# Dockerfile Workflow

A Dockerfile defines how an image should be built.

```text
Dockerfile
    ↓
docker build
    ↓
Docker Image
    ↓
docker run
    ↓
Container
```

This replaces repeated manual installation and configuration steps with a reproducible build definition.

---

# Dockerfile Syntax

Dockerfile instructions generally follow:

```text
INSTRUCTION arguments
```

Dockerfile instructions are conventionally written in uppercase.

Examples include:

```text
FROM
RUN
COPY
ENV
USER
EXPOSE
ENTRYPOINT
CMD
VOLUME
```

Comments begin with:

```text
#
```

---

# `FROM`

`FROM` defines the base image for a build stage.

Example:

```dockerfile
FROM ubuntu
```

Conceptually:

```text
Base Image
    ↓
Additional Build Instructions
    ↓
Final Image
```

A Dockerfile can contain multiple `FROM` instructions when using multi-stage builds.

Comments, parser directives, and some build arguments can appear before the first build-stage `FROM`.

---

# Historical `MAINTAINER`

The course introduces:

```dockerfile
MAINTAINER name <email>
```

as image-author metadata.

This should be treated as historical Dockerfile syntax.

Modern image metadata is generally represented using labels rather than relying on the deprecated `MAINTAINER` instruction.

---

# Building an Image

The course demonstrates:

```bash
docker build -t IMAGE:TAG .
```

The final argument is the build context.

```text
-t
→ Assign image name and tag

.
→ Current directory as build context
```

A useful conceptual model is:

```text
Build Context
    +
Dockerfile
    ↓
Docker Build
    ↓
Image
```

---

# Build Context

The build context contains files available to the image build process.

Conceptually:

```text
Project Directory
├── Dockerfile
├── Source Code
├── Configuration
├── Dependencies
└── Other Files
        ↓
Build Context
```

Only files that are required for the image build should be included.

Large or unnecessary build contexts can slow builds and expose files to the build process unnecessarily.

---

# `.dockerignore`

`.dockerignore` excludes unnecessary files from the build context.

Example:

```text
.git
*.tmp
*.log
build/
private/
```

The goal is:

```text
Project Directory
      ↓
.dockerignore
      ↓
Minimal Build Context
```

Useful exclusions can include:

```text
Version-control metadata
Temporary files
Build artifacts
Development-only files
Unrelated large files
Sensitive local files
```

Secrets should not be embedded in images or casually included in build contexts.

---

# `CMD`

`CMD` defines default runtime behavior for containers created from an image.

Example shell form:

```dockerfile
CMD echo hello
```

Example exec form:

```dockerfile
CMD ["echo", "hello"]
```

A useful distinction is:

```text
RUN
→ Build time
```

```text
CMD
→ Container runtime default
```

A command supplied to `docker run` can override the image's default `CMD`.

---

# Shell Form and Exec Form

Shell form can invoke a shell:

```dockerfile
CMD echo hello
```

Conceptually:

```text
/bin/sh
   ↓
Command
```

Exec form directly specifies the executable and arguments:

```dockerfile
CMD ["echo", "hello"]
```

Exec form avoids an implicit shell for the command itself.

---

# `ENTRYPOINT`

`ENTRYPOINT` defines the primary executable for the container.

Example:

```dockerfile
ENTRYPOINT ["myservice"]
```

A useful relationship is:

```text
ENTRYPOINT
→ Primary executable
```

```text
CMD
→ Default command or arguments
```

---

# `ENTRYPOINT` with `CMD`

A common pattern is:

```dockerfile
ENTRYPOINT ["mysqld"]
CMD ["--datadir=/var/lib/mysql"]
```

Conceptually:

```text
mysqld --datadir=/var/lib/mysql
```

Arguments supplied when the container is started can replace the default `CMD` while retaining the exec-form `ENTRYPOINT`.

---

# Overriding the Entry Point

The course introduces overriding the configured entry point using a runtime option.

This should be treated as an explicit override rather than normal application operation.

Conceptually:

```text
Image ENTRYPOINT
      ↓
Runtime Override
      ↓
Different Executable
```

---

# Container Main Process

`CMD` and `ENTRYPOINT` are closely related to the container process model.

```text
Container Starts
      ↓
Main Process Runs
      ↓
Main Process Exits
      ↓
Container Exits
```

Dockerfile runtime instructions therefore help define the container's main process.

---

# `ENV`

`ENV` defines environment variables in the image.

Example:

```dockerfile
ENV APP_ENV=production
```

Environment variables can be consumed by later build or runtime instructions depending on their context.

The course demonstrates overriding an image environment value when starting a container.

Conceptually:

```text
Dockerfile ENV
→ Image Default

Runtime Environment Option
→ Runtime Override
```

---

# Environment Variables and Secrets

Environment variables are useful for configuration.

However, sensitive values should not be permanently hardcoded into Dockerfiles.

Avoid embedding values such as:

```text
Passwords
API Keys
Private Keys
Access Tokens
```

in reusable image definitions.

Configuration and secret management should be treated separately.

---

# `EXPOSE`

`EXPOSE` documents ports used by a containerized application.

Example:

```dockerfile
EXPOSE 80
EXPOSE 443
```

`EXPOSE` does not automatically publish the port to external clients.

A useful distinction is:

```text
EXPOSE
→ Image/container port metadata
```

```text
Port Publishing
→ Host-to-container network mapping
```

---

# Port Publishing

The course demonstrates:

```bash
docker run -p 8080:80 IMAGE
```

Conceptually:

```text
Host Port 8080
      ↓
Container Port 80
```

The `-p` option explicitly maps a host port to a container port.

Uppercase `-P` is different:

```text
-P
→ Automatically publish exposed ports using host ports selected by Docker
```

---

# `COPY`

`COPY` transfers files from the build context into the image.

Examples:

```dockerfile
COPY *.txt /tmp/
COPY project.tar.gz /project/
COPY . /project/
```

Conceptually:

```text
Build Context
      ↓
COPY
      ↓
Image Filesystem
```

The source must be available from the build context.

---

# `COPY` and Archives

`COPY` performs file copying.

A local archive copied with `COPY` should not be assumed to be automatically extracted.

Conceptually:

```text
archive.tar.gz
      ↓
COPY
      ↓
archive.tar.gz inside image
```

---

# `ADD`

`ADD` provides file-copy functionality with additional behavior.

The course introduces behavior including:

```text
Remote URL support
Archive extraction
```

A useful operational rule is:

```text
Simple File Copy
→ Prefer COPY
```

```text
ADD-specific behavior required
→ Consider ADD
```

This makes image build intent easier to understand.

---

# `RUN`

`RUN` executes a command during image build.

Example:

```dockerfile
RUN yum install -y httpd
```

Conceptually:

```text
docker build
     ↓
RUN Command
     ↓
Filesystem Change
     ↓
Image Layer
```

`RUN` should not be confused with runtime instructions such as `CMD` or `ENTRYPOINT`.

---

# `RUN` Shell Form

Example:

```dockerfile
RUN yum install -y httpd
```

The shell form can use shell syntax.

The course associates it with the shell available in the base image.

---

# `RUN` Exec Form

An exec-style instruction can be written as:

```dockerfile
RUN ["yum", "install", "-y", "httpd"]
```

This explicitly specifies the executable and its arguments.

---

# Build Cache

Docker builds can reuse results from previous builds.

Conceptually:

```text
Dockerfile Instruction
        ↓
Matching Cached Result?
        ↓
Yes → Reuse
No  → Rebuild
```

Cache behavior can significantly affect build speed.

---

# Cache Miss

A simplified build model is:

```text
Layer 1 → Cache Hit
Layer 2 → Cache Hit
Layer 3 → Cache Miss
Layer 4 → Rebuild
Layer 5 → Rebuild
```

Once an earlier dependency changes, following build work may also need to be rebuilt.

---

# Dockerfile Instruction Ordering

Place relatively stable build work before frequently changing work when doing so preserves correct build semantics.

Conceptually:

```text
Base Image
    ↓
Stable Dependencies
    ↓
Stable Configuration
    ↓
Frequently Changing Source
```

This can increase cache reuse.

The goal is not simply minimizing the number of lines.

The goal is:

```text
Correct Build
+
Reproducibility
+
Useful Cache Reuse
+
Readable Definition
```

---

# Combining `RUN` Instructions

Multiple shell operations can sometimes be combined into one logical build step.

Example:

```dockerfile
RUN command1 \
    && command2 \
    && command3
```

This can be useful when the operations belong to the same build transaction.

However, Dockerfile optimization should not blindly combine every instruction.

Consider:

```text
Readability
Cache Boundaries
Package Cleanup
Build Reproducibility
```

as well.

---

# `USER`

`USER` changes the user identity used by subsequent applicable instructions and container runtime behavior.

Example:

```dockerfile
RUN useradd appuser
USER appuser
```

Subsequent commands can run using that identity.

---

# User and File Ownership

The course demonstrates files created before and after changing `USER`.

Conceptually:

```text
RUN as root
→ root-owned file

USER student

RUN as student
→ student-owned file
```

This connects Dockerfile behavior to Linux users, groups, permissions, and ownership.

---

# Least Privilege

Containers should not run with unnecessary privilege.

A useful pattern is:

```text
Create Application User
        ↓
Grant Required Access
        ↓
USER ApplicationUser
        ↓
Run Application
```

This applies the same least-privilege principle used in Linux administration.

---

# Image Layers

Dockerfile build operations produce image metadata and filesystem layers.

Conceptually:

```text
Base Image
    ↓
Build Instruction
    ↓
Layer
    ↓
Build Instruction
    ↓
Layer
    ↓
Final Image
```

Layer design affects:

```text
Build Cache
Image Distribution
Image Size
Rebuild Time
```

---

# Multi-Stage Builds

Multi-stage builds use multiple `FROM` stages in one Dockerfile.

A simplified architecture is:

```text
Build Stage
     ↓
Build Artifact
     ↓
Test Stage
     ↓
Validated Artifact
     ↓
Runtime Stage
```

Only required artifacts need to be copied into the final stage.

---

# Build and Runtime Separation

Build environments can contain tools such as:

```text
Compilers
Build Systems
Development Dependencies
Source Code
```

The final runtime environment can contain only:

```text
Application Artifact
Runtime Libraries
Runtime Configuration
```

This can reduce unnecessary content in the final image.

---

# Named Build Stages

Stages can be named:

```dockerfile
FROM alpine AS build-stage
```

Another stage can copy from that stage:

```dockerfile
COPY --from=build-stage /artifact /artifact
```

Conceptually:

```text
build-stage
      ↓
Selected Artifact
      ↓
final-stage
```

---

# Multi-Stage Build Benefits

Potential benefits include:

```text
Smaller Runtime Images
Reduced Unnecessary Tooling
Clear Build/Runtime Separation
Smaller Attack Surface
Simpler Artifact Promotion
```

The final runtime image does not need to contain the complete build environment.

---

# `VOLUME`

The course introduces:

```dockerfile
VOLUME /app
```

and:

```dockerfile
VOLUME ["/app", "/etc/app"]
```

A volume separates application data from the normal writable container layer.

Conceptually:

```text
Container Runtime
       ↓
Volume Mount Point
       ↓
External Data Storage
```

---

# Container and Data Lifecycles

A useful distinction is:

```text
Container Lifecycle
→ Create / Start / Stop / Remove
```

```text
Data Lifecycle
→ Persist independently when configured appropriately
```

Persistent application data should not depend only on the temporary writable layer of a replaceable container.

---

# Host Path Mapping

The course demonstrates:

```bash
docker run -v /host/path:/container/path IMAGE
```

This maps a specific host path into a container.

Conceptually:

```text
Host Directory
      ↕
Container Directory
```

This is a bind-mount style relationship.

---

# Dockerfile `VOLUME` vs Host Path

A Dockerfile can declare a volume mount point:

```dockerfile
VOLUME /app
```

but that declaration does not hardcode a specific host filesystem path.

The runtime environment determines the backing storage.

---

# Shared Data

The course demonstrates multiple containers using a shared host-backed path.

Conceptually:

```text
Container A
      ↘
       Shared Data
      ↗
Container B
```

Shared storage must be designed carefully when multiple applications modify the same data.

---

# Bind Mounts and Docker-Managed Volumes

A useful conceptual distinction is:

```text
Bind Mount
→ Explicit host filesystem path
```

```text
Docker-Managed Volume
→ Storage managed through Docker
```

Both can place data outside the normal container writable layer, but they have different operational management models.

---

# Image and Volume Separation

Persistent volume data should be treated separately from image content.

Conceptually:

```text
Image
→ Application Definition
```

```text
Volume
→ Runtime Data
```

This separation supports disposable and replaceable containers.

---

# `docker history`

The course introduces:

```bash
docker history IMAGE:TAG
```

This displays image build history information such as:

```text
Layer/Image Reference
Created Time
Created By
Size
```

It can help identify which image operations contributed to image size and structure.

---

# Image History Analysis

A useful troubleshooting workflow is:

```text
Image unexpectedly large
        ↓
docker history
        ↓
Identify large build layer
        ↓
Inspect related Dockerfile instruction
        ↓
Optimize build
```

Image history is evidence about the built image, but it should not be treated as a complete reconstruction of the original Dockerfile.

---

# Complete Build Model

The Docker image build process can now be represented as:

```text
Project Files
     ↓
.dockerignore
     ↓
Build Context
     ↓
Dockerfile
     ↓
docker build
     ↓
Image Layers
     ↓
Docker Image
     ↓
Registry / Deployment
     ↓
Container
```

---

# Runtime Instruction Model

The most important Dockerfile instruction relationships are:

```text
FROM
→ Base image

RUN
→ Build-time command

COPY / ADD
→ Add build-context content

ENV
→ Environment configuration

USER
→ Runtime/build identity

EXPOSE
→ Port metadata

ENTRYPOINT
→ Primary runtime executable

CMD
→ Default runtime command/arguments

VOLUME
→ Persistent-data mount point
```

---

# Troubleshooting Model

When an image build fails:

```text
Build Failure
    ↓
Which Dockerfile instruction failed?
    ↓
Is the required file in the build context?
    ↓
Was it excluded by .dockerignore?
    ↓
Does the base image contain the required shell/tool?
    ↓
Are permissions and USER correct?
    ↓
Was an old cache result reused?
```

When a built image behaves incorrectly at runtime:

```text
Image Builds Successfully
       ↓
Container Starts?
       ↓
ENTRYPOINT / CMD correct?
       ↓
Environment correct?
       ↓
User permissions correct?
       ↓
Port published?
       ↓
Persistent storage mounted?
```

Build-time and runtime problems should be investigated separately.

---

# Security Principles

Dockerfile design affects container security.

Important principles include:

```text
Use trusted base images.
Keep build contexts minimal.
Do not embed secrets in Dockerfiles.
Use least-privilege users.
Avoid unnecessary build tools in runtime images.
Use multi-stage builds when appropriate.
Review exposed and published ports.
Keep persistent data separate from replaceable containers.
```

---

# Evidence Policy

Course screenshots and example build output are educational examples.

Do not treat them as actual runtime evidence.

Do not fabricate:

```text
Image IDs
Layer IDs
Build Cache Results
Container IDs
File Ownership
Image Sizes
Volume IDs
Build Output
History Output
```

Actual evidence must be collected from the authorized lab environment.

---

# Verification Checklist

- Dockerfile was understood as a reproducible image-build definition.
- `FROM` was connected to build stages and base images.
- Historical `MAINTAINER` syntax was distinguished from current metadata practices.
- `docker build` was connected to the build context.
- `.dockerignore` was connected to build-context control.
- `CMD` was understood as runtime default behavior.
- `ENTRYPOINT` was understood as the primary runtime executable.
- `ENTRYPOINT` and `CMD` were understood as complementary instructions.
- Shell and exec forms were distinguished.
- `ENV` defaults and runtime overrides were reviewed.
- Secrets were not treated as ordinary Dockerfile configuration.
- `EXPOSE` was distinguished from actual port publishing.
- `-p` and `-P` were distinguished.
- `COPY` was connected to the build context.
- `COPY` and `ADD` were distinguished.
- `RUN` was understood as a build-time instruction.
- Build cache behavior was reviewed.
- Dockerfile instruction ordering was connected to cache reuse.
- Instructions were not blindly combined only to reduce layer count.
- `USER` was connected to Linux identity and ownership.
- Least privilege was applied to container users.
- Image layers were connected to Dockerfile build operations.
- Multi-stage builds were reviewed.
- Named stages and `COPY --from` were understood.
- Build and runtime environments were separated.
- `VOLUME` was connected to persistent data.
- Dockerfile volume declarations were distinguished from explicit host-path mappings.
- Bind mounts and Docker-managed volumes were conceptually distinguished.
- Image and data lifecycles were separated.
- `docker history` was connected to image-layer analysis.
- Build-time and runtime troubleshooting were treated as separate problems.

## What I Learned

- Dockerfiles turn manual application setup into repeatable image builds.
- Build context controls which local files are available during image construction.
- `.dockerignore` improves build efficiency and reduces unnecessary build-context exposure.
- `RUN` executes during image build, while `CMD` and `ENTRYPOINT` define runtime behavior.
- `ENTRYPOINT` represents the primary executable while `CMD` can provide defaults.
- `EXPOSE` does not automatically publish a container port.
- `COPY` is preferred for straightforward file transfer, while `ADD` includes additional behavior.
- Dockerfile instruction order affects build-cache reuse.
- `USER` applies Linux least-privilege principles to container images.
- Multi-stage builds separate build tooling from the final runtime image.
- Persistent data should be separated from disposable container state.
- `docker history` helps analyze how image layers were created.
