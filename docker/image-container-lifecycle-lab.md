# Docker Image and Container Lifecycle Lab

## Objective

Understand the relationship between Docker images and containers and learn the fundamental lifecycle operations used to retrieve images, create containers, inspect state, stop and restart workloads, and execute commands inside running containers.

The focus is on understanding Docker state transitions rather than memorizing commands.

## Scope

```text
Docker Images
Image Layers
Repositories
Tags
Image IDs
Digests
Docker Hub
docker images
docker search
docker pull
docker rmi
Docker Containers
docker run
docker ps
docker start
docker stop
docker restart
docker pause
docker unpause
docker rm
docker exec
Container PID 1
Container Lifecycle
Image vs Container
```

---

# Docker Image

A Docker image is a reusable artifact used as the basis for creating containers.

Conceptually:

```text
Base Filesystem
      ↓
Application Dependencies
      ↓
Application Content
      ↓
Configuration
      ↓
Docker Image
```

An image is not itself a running application.

```text
Image
→ Static artifact
```

```text
Container
→ Instance created from an image
```

---

# Container Images and the Kernel

A Linux container image should not be interpreted as a complete virtual machine operating system.

Containers normally share the host kernel.

The image primarily provides user-space content such as:

```text
Executables
Libraries
Filesystem Content
Configuration
Application Files
```

The container does not boot its own Linux kernel in the same way as a virtual machine.

---

# Image Layers

Docker images are composed of filesystem layers.

Conceptually:

```text
Layer A
   ↓
Layer B
   ↓
Layer C
   ↓
Final Image
```

Unchanged layers can be reused.

This supports:

```text
Storage Reuse
Faster Distribution
Build Caching
Repeatable Images
```

The course describes layers using historical parent/child image terminology.

Modern image architecture is better understood as content-addressed image layers.

---

# Read-Only Image Layers

Image layers are treated as reusable read-only content.

When a container runs, writable container state is placed above the image layers.

Conceptually:

```text
Read-Only Image Layers
        ↓
Writable Container Layer
```

Different containers created from the same image can therefore share base image layers while maintaining separate writable state.

---

# Image IDs

Docker image identifiers are content-related identifiers.

The course refers to a 64-character hexadecimal identifier.

A 64-character hexadecimal value represents:

```text
64 × 4 bits
=
256 bits
```

It should not be described as a 64-bit identifier.

---

# Repository and Tag

Docker images are commonly referenced using:

```text
repository:tag
```

Examples:

```text
ubuntu:latest
nginx:1.27
myapp:1.0
```

A useful distinction is:

```text
Repository
→ Image collection/name
```

```text
Tag
→ Human-readable label referencing an image
```

Tags should not be treated as immutable version identifiers.

---

# `latest`

`latest` is a normal Docker tag.

It should not be interpreted as a guarantee that an image always represents the newest available software version.

Conceptually:

```text
latest
→ Label
```

rather than:

```text
latest
→ Guaranteed newest version
```

---

# Image Digest

Container registries can identify image content using a digest such as:

```text
sha256:...
```

A useful distinction is:

```text
Tag
→ Mutable human-friendly reference
```

```text
Digest
→ Content-based reference
```

---

# Listing Local Images

The course introduces:

```bash
docker images
```

A modern equivalent command structure is:

```bash
docker image ls
```

Useful output fields can include:

```text
Repository
Tag
Image ID
Created
Size
```

The command inspects images available in the local Docker environment.

---

# Docker Group Security

The course demonstrates adding a user to the Docker group:

```bash
usermod -aG docker USER
```

This can allow Docker commands without repeatedly using `sudo`.

However, access to the Docker daemon is security-sensitive.

A user who can freely control the Docker daemon can often obtain highly privileged access to the host.

Therefore:

```text
docker group membership
→ High-privilege access
```

It should be granted only when required.

---

# Searching for Images

The course demonstrates image discovery through:

```bash
docker search IMAGE
```

and through Docker Hub.

Image selection should consider more than the image name.

Relevant considerations include:

```text
Publisher
Source
Tag
Architecture
Maintenance Status
Trust
```

Do not assume that every similarly named image is equivalent or trustworthy.

---

# Pulling an Image

The course introduces:

```bash
docker pull IMAGE:TAG
```

Conceptually:

```text
Registry
   ↓
Image Layers
   ↓
Local Docker Host
```

Images can consist of multiple layers, which can be transferred independently.

---

# Removing an Image

The course introduces:

```bash
docker rmi IMAGE
```

A structured equivalent is:

```bash
docker image rm IMAGE
```

The important distinction is:

```text
docker rm
→ Remove container
```

```text
docker rmi
→ Remove image
```

Images and containers have separate lifecycles.

---

# Docker Container

The course describes a Docker container as an image in an executed state.

A more precise conceptual model is:

```text
Image
    ↓
Container Creation
    ↓
Isolated Process Environment
```

One image can create multiple containers.

```text
           ┌── Container A
Image ─────┼── Container B
           └── Container C
```

Each container can maintain independent writable runtime state.

---

# Image and Container Layers

Multiple containers can share the same read-only image layers.

```text
            Shared Image
                ↓
       ┌────────┴────────┐
       ↓                 ↓
Container A          Container B
Writable Layer       Writable Layer
```

A runtime change in one container does not directly modify the shared image layers.

---

# `docker run`

The course introduces:

```bash
docker run OPTIONS IMAGE COMMAND
```

A useful conceptual model is:

```text
Locate Image
    ↓
Create Container
    ↓
Configure Runtime
    ↓
Start Container
    ↓
Run Main Process
```

`docker run` is not simply an alias for `docker start`.

---

# `docker run` vs `docker start`

The distinction is:

```text
docker run
→ Create a new container and start it
```

```text
docker start
→ Start an existing stopped container
```

Repeated use of `docker run` can therefore create multiple containers from the same image.

---

# Interactive Mode

The course introduces:

```text
-i
→ Interactive input
```

and:

```text
-t
→ Allocate a terminal
```

A common interactive shell pattern is:

```bash
docker run -it IMAGE /bin/bash
```

The exact shell available depends on the image.

---

# Detached Mode

The course introduces:

```text
-d
→ Detached / background execution
```

Conceptually:

```text
Terminal
   ↓
docker run -d
   ↓
Container continues running independently
```

Detached mode is commonly used for long-running services.

---

# Container Naming

The course introduces:

```bash
--name NAME
```

A container can then be addressed using the assigned name instead of only its generated ID.

For example:

```bash
docker stop web
```

A descriptive container name can improve operational readability.

---

# Automatic Removal

The course introduces:

```bash
--rm
```

The useful interpretation is:

```text
Container exits
      ↓
Container object is automatically removed
```

This is useful for temporary workloads and test containers.

---

# Storage Mounting

The course introduces the `-v` option using the structure:

```text
host_path:container_path
```

Conceptually:

```text
Host Storage
     ↕
Container Path
```

Detailed volume and persistence behavior is covered in later storage labs.

---

# Listing Containers

The course introduces:

```bash
docker ps
```

which displays running containers.

```text
docker ps
→ Running containers
```

The course also introduces:

```bash
docker ps -a
```

which includes stopped and exited containers.

```text
docker ps -a
→ All container states
```

---

# Container IDs Only

The course introduces:

```bash
docker ps -q
```

which displays only container IDs.

This can be useful when IDs need to be consumed by another command or script.

---

# Container Main Process

A fundamental container concept is:

```text
Main Process Running
→ Container Running
```

```text
Main Process Exits
→ Container Exits
```

A container should not be interpreted as a virtual machine that remains running independently of its main process.

---

# Normal Container Exit

The course demonstrates a container created with:

```bash
docker run --name hello-world ubuntu /bin/bash
```

without an interactive terminal.

The container appears later as:

```text
Exited (0)
```

This illustrates that container termination is not automatically an error.

An exit status of:

```text
0
```

normally indicates successful process completion.

---

# Container PID 1

The course demonstrates an interactive container in which `/bin/bash` appears as PID 1.

Conceptually:

```text
Container PID Namespace

PID 1
→ Main Container Process
```

The host has its own PID namespace and process hierarchy.

This demonstrates that Linux namespaces can present an isolated process view while containers continue to share the host kernel.

---

# Starting a Container

The course introduces:

```bash
docker start CONTAINER
```

This starts an existing stopped container using its existing container configuration.

Conceptually:

```text
Stopped Container
      ↓
docker start
      ↓
Running Container
```

It does not create a new container.

---

# Stopping a Container

The course introduces:

```bash
docker stop CONTAINER
```

Conceptually:

```text
Running
   ↓
docker stop
   ↓
Stopped
```

Stopping a container does not remove the container object.

---

# Restarting a Container

The course introduces:

```bash
docker restart CONTAINER
```

Conceptually:

```text
Running
   ↓
Stop
   ↓
Start
   ↓
Running
```

The existing container object is reused.

---

# Pause and Unpause

The course introduces:

```bash
docker pause CONTAINER
```

and:

```bash
docker unpause CONTAINER
```

A simplified state model is:

```text
Running
   ↓
Paused
   ↓
Running
```

Pausing differs from stopping because the container is suspended rather than terminated.

---

# Removing a Container

The course introduces:

```bash
docker rm CONTAINER
```

The basic lifecycle is:

```text
Running
  ↓
Stop
  ↓
Stopped
  ↓
Remove
```

The normal removal workflow applies to stopped containers unless another explicit removal method is used.

---

# Stop vs Remove

The distinction is:

```text
Stop
→ Container object remains
```

```text
Remove
→ Container object is deleted
```

The underlying image is a separate object and is not automatically removed with the container.

---

# Image Lifecycle

A simplified image lifecycle is:

```text
Registry
   ↓
Pull
   ↓
Local Image
   ↓
Create Containers
   ↓
Image Removal
```

---

# Container Lifecycle

A simplified container lifecycle is:

```text
Image
  ↓
docker run
  ↓
Created / Running
  ↓
Stop
  ↓
Stopped
  ↓
Start
  ↓
Running
  ↓
Remove
```

Keeping image and container lifecycles separate makes Docker state easier to understand.

---

# Interactive Detach

The course introduces the sequence:

```text
Ctrl-P
Ctrl-Q
```

to detach from an attached interactive container without terminating its main process.

Conceptually:

```text
Terminal Attached
      ↓
Detach
      ↓
Container Continues Running
```

---

# `exit` vs Detach

If an interactive shell is the container's main process:

```text
exit
→ Shell exits
→ Main process exits
→ Container can stop
```

By contrast:

```text
Ctrl-P, Ctrl-Q
→ Terminal detaches
→ Main process continues
→ Container continues running
```

This distinction is important when working interactively with containers.

---

# `docker exec`

The course introduces:

```bash
docker exec CONTAINER COMMAND
```

and:

```bash
docker exec -it CONTAINER /bin/sh
```

`docker exec` does not create a new container.

Instead:

```text
Existing Running Container
          ↓
docker exec
          ↓
Additional Process
```

is created inside the existing container environment.

---

# `docker run` vs `docker exec`

The distinction is:

```text
docker run
→ Create a new container
→ Start its main process
```

```text
docker exec
→ Use an existing running container
→ Start an additional process
```

This distinction is fundamental during troubleshooting.

---

# Shell Access with `docker exec`

Running:

```bash
docker exec -it CONTAINER /bin/sh
```

should not be interpreted exactly like logging into a virtual machine.

It starts an additional shell process inside the namespaces and environment of an already running container.

Conceptually:

```text
Running Container
├── Main Process
└── Shell Process
```

---

# Image-to-Container Workflow

The complete relationship can be represented as:

```text
Dockerfile
    ↓
Build
    ↓
Image
    ↓
Run
    ↓
Container
    ↓
Main Process
```

Image distribution adds:

```text
Local Image
    ↕
Push / Pull
    ↕
Registry
```

This workflow forms the foundation for later Dockerfile, registry, CI/CD, and orchestration topics.

---

# Troubleshooting Model

When an expected container is not running:

```text
Symptom
   ↓
docker ps
   ↓
Running container present?
   ↓
docker ps -a
   ↓
Exited container present?
   ↓
Inspect container state
   ↓
Investigate why main process exited
```

Do not immediately recreate the container before checking its existing state.

---

# Evidence Policy

Course screenshots and example output are educational examples.

Do not treat course values as actual runtime evidence.

Do not fabricate:

```text
Container IDs
Image IDs
Digests
Container Names
Exit Codes
Process IDs
Image Sizes
Command Output
```

Actual evidence should be collected from the authorized lab environment.

---

# Verification Checklist

- Docker images were distinguished from containers.
- Container images were not interpreted as complete virtual machines.
- Image layers were understood.
- Read-only image layers and writable container state were distinguished.
- Historical parent/child image terminology was recognized.
- A 64-character hexadecimal image identifier was correctly understood as 256 bits.
- Repository, tag, image ID, and digest concepts were distinguished.
- `latest` was understood as a tag rather than a guarantee.
- Docker group membership was recognized as highly privileged.
- Image discovery was reviewed.
- `docker pull` was understood.
- `docker rmi` was distinguished from `docker rm`.
- One image was understood to create multiple containers.
- `docker run` was distinguished from `docker start`.
- `-i`, `-t`, and `-d` were reviewed.
- `--name` was reviewed.
- `--rm` was interpreted as automatic cleanup after container exit.
- Host/container storage mapping was introduced.
- `docker ps`, `docker ps -a`, and `docker ps -q` were distinguished.
- Container runtime state was connected to the main process.
- A normal process exit was not automatically treated as an error.
- Container PID 1 was connected to PID namespaces.
- `start`, `stop`, `restart`, `pause`, and `unpause` were reviewed.
- Stopping and removing a container were distinguished.
- Interactive detach was distinguished from exiting the main shell.
- `docker exec` was understood to start an additional process in a running container.
- `docker run` and `docker exec` were distinguished.
- Image and container lifecycles were understood as separate state models.
- Course output was not treated as actual lab evidence.

## What I Learned

- Docker images are reusable artifacts while containers are runtime instances.
- Container images contain user-space runtime content and normally share the host kernel.
- Images are composed of reusable filesystem layers.
- Tags are human-friendly references, while digests identify content.
- One Docker image can create many independent containers.
- `docker run` creates a new container, while `docker start` reuses an existing one.
- The lifecycle of a container follows the lifecycle of its main process.
- A container that exits is not necessarily broken.
- PID namespaces allow a container process to appear as PID 1 inside the container.
- `docker exec` starts an additional process inside an existing running container.
- Image state and container state must be investigated separately during troubleshooting.
