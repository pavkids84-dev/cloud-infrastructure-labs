# Docker Container Management Lab

## Objective

Understand how to inspect, troubleshoot, transfer data from, monitor, and preserve Docker containers after they have been created.

This lab focuses on observable container state and operational evidence rather than immediately restarting or recreating a workload when a problem occurs.

## Scope

```text
docker cp
docker diff
docker commit
docker inspect
docker events
docker logs
docker export
docker import
docker save
docker load
docker top
docker stats
docker system df
```

---

# Container Management Model

Container operations should be treated as observable runtime state.

```text
Container
    ↓
Inspect State
    ↓
Collect Evidence
    ↓
Identify Change
    ↓
Take Action
    ↓
Verify
```

A container should not be restarted or recreated before useful evidence has been collected when troubleshooting requires root-cause analysis.

---

# `docker cp`

`docker cp` transfers files between a Docker container filesystem and the host filesystem.

Container to host:

```bash
docker cp CONTAINER:/path /host/path
```

Host to container:

```bash
docker cp /host/path CONTAINER:/path
```

Conceptually:

```text
Host Filesystem
      ↕
   docker cp
      ↕
Container Filesystem
```

---

# Copying From Stopped Containers

The course demonstrates copying a file from a stopped container.

This is operationally useful because evidence can sometimes be recovered from a container even after its main process has exited.

Conceptually:

```text
Exited Container
      ↓
docker cp
      ↓
Configuration / Output / Evidence File
```

---

# `docker cp` vs `docker exec`

The commands solve different problems.

```text
docker cp
→ Transfer files between host and container
```

```text
docker exec
→ Start an additional process inside a running container
```

Do not use them as interchangeable concepts.

---

# Runtime Changes and Reproducibility

Copying files into a running container can be useful for:

```text
Troubleshooting
Temporary Testing
Evidence Collection
```

However, permanent application changes should normally be represented through reproducible image definitions.

A useful model is:

```text
Temporary Investigation
→ Runtime action
```

```text
Permanent Application Change
→ Dockerfile
→ New Image
→ Replacement Container
```

---

# `docker diff`

The course introduces:

```bash
docker diff CONTAINER
```

to identify filesystem changes made relative to the container's image.

Change indicators are:

```text
A
→ Added

C
→ Changed

D
→ Deleted
```

Conceptually:

```text
Image Filesystem
      ↓
Container Writable Changes
      ↓
docker diff
      ↓
Changed Paths
```

---

# Container Drift

`docker diff` can help identify runtime filesystem drift.

For example:

```text
Expected Image State
       ↓
Running Container
       ↓
Unexpected Manual Change
       ↓
docker diff
```

This can provide evidence that a container was modified after deployment.

---

# `docker commit`

The course introduces:

```bash
docker commit CONTAINER IMAGE:TAG
```

to create an image from a modified container.

Conceptually:

```text
Image
 ↓
Container
 ↓
Runtime Filesystem Changes
 ↓
docker commit
 ↓
New Image
```

Options in the course include author and message metadata.

---

# `docker commit` vs Dockerfile

`docker commit` captures state.

A Dockerfile records how an image should be built.

```text
docker commit
→ State-oriented
```

```text
Dockerfile
→ Process-oriented and reproducible
```

For repeatable infrastructure:

```text
Dockerfile
→ Preferred image definition
```

`docker commit` can still be useful for:

```text
Experiments
Temporary State Capture
Debugging
Short-Lived Testing
```

---

# Commit Is Not a Complete Backup

Container writable state and persistent volume data have different lifecycles.

Conceptually:

```text
Container Writable Layer
!=
External Volume Data
```

A committed image should not be treated as a complete backup of all application data.

---

# `docker inspect`

The course introduces:

```bash
docker inspect CONTAINER
```

to retrieve detailed container metadata.

Information can include areas such as:

```text
Container ID
Created Time
Command
Arguments
Runtime State
PID
Exit Code
Image
Network Configuration
Mount Configuration
Restart Information
```

The exact fields depend on the inspected Docker object and Docker version.

---

# `docker ps` vs `docker inspect`

A useful distinction is:

```text
docker ps
→ Quick lifecycle overview
```

```text
docker inspect
→ Detailed configuration and runtime metadata
```

Use `inspect` when the high-level container list does not provide enough information.

---

# Runtime State Verification

Do not rely only on intended configuration.

A useful infrastructure principle is:

```text
Expected Configuration
!=
Verified Runtime State
```

Inspect the actual Docker object when troubleshooting.

---

# `docker events`

The course introduces:

```bash
docker events
```

to observe Docker daemon events.

Conceptually:

```text
Docker Objects
      ↓
Lifecycle Changes
      ↓
Docker Event Stream
      ↓
docker events
```

Possible event categories can include container creation, start, stop, termination, and removal.

---

# Events vs Logs

These are different evidence sources.

```text
docker events
→ Docker object lifecycle events
```

```text
docker logs
→ Container application stdout / stderr
```

For example:

```text
Container Event
→ Container exited
```

while:

```text
Application Log
→ Database connection failed
```

can provide different parts of the same incident.

---

# `docker logs`

The course introduces container log inspection with:

```bash
docker logs CONTAINER
```

and demonstrates time-based filtering.

Container logs commonly expose application output written to:

```text
stdout
stderr
```

The logging behavior can depend on the containerized application and Docker logging configuration.

---

# Container Failure Investigation

A useful first-response workflow is:

```text
docker ps -a
      ↓
Container State
      ↓
docker inspect
      ↓
Runtime / Exit Metadata
      ↓
docker logs
      ↓
Application Evidence
      ↓
docker events
      ↓
Lifecycle Evidence
```

Additional investigation can then use process, network, storage, or filesystem evidence.

---

# `docker export`

The course introduces:

```bash
docker export CONTAINER > container.tar
```

This exports the container filesystem into an archive.

Conceptually:

```text
Container Filesystem
       ↓
docker export
       ↓
Filesystem Archive
```

This should not be interpreted as preserving the original layered image structure.

---

# `docker import`

The course introduces importing filesystem archive content into a Docker image.

Conceptually:

```text
Filesystem Archive
       ↓
docker import
       ↓
Docker Image
```

`export` and `import` are therefore centered on filesystem content.

---

# `docker save`

The course introduces:

```bash
docker save IMAGE > image.tar
```

This archives Docker image data for transport or storage.

Conceptually:

```text
Docker Image
     ↓
docker save
     ↓
Image Archive
```

---

# `docker load`

The course introduces:

```bash
docker load < image.tar
```

Conceptually:

```text
Image Archive
     ↓
docker load
     ↓
Docker Image
```

This workflow preserves the image-oriented representation rather than flattening a container filesystem into a new image.

---

# Export / Import vs Save / Load

This distinction is fundamental.

```text
docker export
docker import
→ Container filesystem workflow
```

```text
docker save
docker load
→ Docker image workflow
```

A simplified comparison is:

```text
Container
   ↓ export
Filesystem Tar
   ↓ import
Image
```

versus:

```text
Image
  ↓ save
Image Tar
  ↓ load
Image
```

Use the workflow that matches the object being preserved.

---

# `docker top`

The course introduces:

```bash
docker top CONTAINER
```

to inspect processes associated with a container.

This reinforces the container process model:

```text
Container
→ Isolated process environment
```

Process inspection can help determine whether the expected application process is actually running.

---

# `docker stats`

The course introduces:

```bash
docker stats
```

for container resource monitoring.

Relevant resource information can include:

```text
CPU
Memory
Network I/O
Block I/O
Process Count
```

The exact output depends on the Docker version and environment.

---

# cgroups and Resource Observation

Container resource monitoring connects back to Linux cgroups.

```text
cgroups
→ Resource accounting and control
```

```text
docker stats
→ Runtime resource observation
```

A high-level Docker metric should be correlated with host-level Linux metrics when investigating resource pressure.

---

# `docker system df`

The course introduces:

```bash
docker system df
```

to inspect Docker storage consumption.

Docker storage categories can include:

```text
Images
Containers
Volumes
Build Data
```

depending on the Docker environment.

---

# Host Disk vs Docker Disk Usage

A useful investigation flow is:

```text
Host Disk Problem
      ↓
df
      ↓
Docker suspected?
      ↓
docker system df
      ↓
Identify Docker storage category
```

The Linux filesystem remains the underlying resource.

---

# Troubleshooting Workflow

A general Docker container investigation can follow:

```text
Symptom
   ↓
docker ps -a
   ↓
docker inspect
   ↓
docker logs
   ↓
docker top
   ↓
docker stats
   ↓
docker diff
```

Additional evidence can include:

```text
docker events
docker cp
Linux journal
Host filesystem state
Network state
```

---

# Evidence Preservation

When possible, collect evidence before:

```text
Restarting the container
Removing the container
Rebuilding the image
Deleting writable state
```

Useful evidence can include:

```text
Exit Code
Application Logs
Container Metadata
Filesystem Changes
Process State
Resource Usage
Relevant Files
```

Do not fabricate runtime evidence.

---

# Verification Checklist

- `docker cp` was understood as host/container file transfer.
- File extraction from stopped containers was recognized as useful for evidence collection.
- Runtime file copying was distinguished from reproducible image modification.
- `docker diff` A/C/D indicators were reviewed.
- Filesystem drift was connected to container writable state.
- `docker commit` was understood.
- `docker commit` was distinguished from Dockerfile-based reproducible builds.
- Persistent volume data was not treated as part of a complete container commit backup.
- `docker inspect` was connected to detailed runtime metadata.
- `docker ps` and `docker inspect` were distinguished.
- `docker events` and `docker logs` were distinguished.
- `docker export` and `docker import` were understood as filesystem-oriented operations.
- `docker save` and `docker load` were understood as image-oriented operations.
- Export/import and save/load were distinguished.
- `docker top` was connected to the container process model.
- `docker stats` was connected to runtime resource observation.
- `docker system df` was connected to Docker storage usage.
- Docker-level metrics were connected back to Linux host resources.
- Evidence collection was prioritized before destructive recovery actions.

## What I Learned

- Docker containers can be inspected and investigated without immediately recreating them.
- Container filesystem changes can be observed with `docker diff`.
- Runtime state captured with `docker commit` is less reproducible than a Dockerfile-defined image build.
- `docker inspect`, `docker logs`, and `docker events` provide different types of evidence.
- Container filesystem archives and Docker image archives are different concepts.
- `docker stats` exposes container resource behavior while the underlying resources still belong to the Linux host.
- Docker troubleshooting should collect evidence before changing the failed workload.
