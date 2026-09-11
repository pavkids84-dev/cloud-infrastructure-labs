# Linux NFS Management Lab

## Objective

Practice Network File System administration by configuring an NFS export, starting the NFS server, inspecting exported directories, mounting an NFS share from a client, verifying the mount, and reviewing NFS mount options.

The main goal is to understand NFS as an end-to-end network storage service involving server storage, export configuration, service state, firewall policy, network connectivity, client discovery, mounting, and verification.

## Environment

- OS: Rocky Linux lab environment
- Shell: Bash
- Package: `nfs-utils`
- Server Service: `nfs-server`
- Export Configuration: `/etc/exports`
- Export Inspection: `exportfs`
- Client Discovery: `showmount`
- Filesystem Type: NFS
- Firewall: firewalld

## Safety Notice

The course uses a deliberately open lab configuration:

```text
/share *(rw)
```

and creates the directory with:

```text
1777
```

These values are useful for a simple isolated lab but should not automatically be copied into a production environment.

Real NFS access should be scoped according to:

```text
Required clients
Required networks
Read-only or read-write access
Linux ownership and permissions
SELinux policy
Firewall policy
```

Do not expose an NFS share broadly without understanding the security implications.

## NFS Overview

NFS stands for:

```text
Network File System
```

It allows a directory stored on one system to be accessed over the network by another system.

Conceptually:

```text
NFS Server
    |
    v
Exported Directory
    |
    v
Network
    |
    v
NFS Client
    |
    v
Local Mount Point
```

A client can therefore access remote data through a local directory path.

## Local Filesystem vs NFS

A local filesystem can be represented as:

```text
Disk
  ↓
Partition
  ↓
Filesystem
  ↓
Mount Point
```

An NFS filesystem introduces a network boundary:

```text
NFS Server Storage
        ↓
Exported Directory
        ↓
Network
        ↓
NFS Client
        ↓
Mount Point
```

The client does not directly access the server's block device.

It accesses an exported filesystem path over the network.

## Install NFS Utilities

The course installs:

```bash
yum install -y nfs-utils
```

On a Rocky Linux environment using DNF, the corresponding package installation can be performed with:

```bash
sudo dnf install -y nfs-utils
```

Record the actual package version from the current VM rather than copying the lecture output.

## NFS Server Configuration

The primary export configuration file introduced by the course is:

```text
/etc/exports
```

Inspect it before modification:

```bash
cat /etc/exports
```

or edit it in a disposable lab environment:

```bash
sudo vi /etc/exports
```

## Course Export Example

The course configures:

```text
/share *(rw)
```

The fields can be interpreted as:

```text
/share
→ Directory exported by the server

*
→ All clients

rw
→ Read and write access
```

This is intentionally broad for the lab.

## Export Syntax

The general structure is:

```text
DIRECTORY CLIENT(OPTIONS)
```

Client specifications can vary according to the export configuration.

The course manual-page example shows forms based on:

```text
Hostnames
Domain patterns
Networks
Groups
All clients
```

Use:

```bash
man exports
```

to inspect the syntax available in the current system.

## Read-Write and Read-Only Exports

The course manual examples include:

```text
rw
```

and:

```text
ro
```

Conceptually:

```text
rw
→ Allow read and write operations

ro
→ Allow read operations only
```

Choose the minimum access required for a real share.

## Additional Export Options

The course manual screenshot also shows examples containing options such as:

```text
no_root_squash
all_squash
anonuid
anongid
```

The course does not provide a detailed hands-on exercise for each option.

Do not enable security-sensitive export options merely because they appear in the manual example.

## Create the Export Directory

The course creates:

```bash
mkdir -m 1777 /share
```

This creates a directory with world read/write/execute permissions plus the sticky bit.

The course configuration is intended for a simple lab.

Do not assume that `1777` is the correct permission model for a production NFS share.

## Apply Export Configuration

After modifying `/etc/exports`, the course uses:

```bash
exportfs -ra
```

Conceptually:

```text
/etc/exports
      |
      v
exportfs -ra
      |
      v
Reload exported filesystem definitions
```

## Inspect Current Exports

The course uses:

```bash
exportfs
```

Its lecture environment displays the configured `/share` export.

Do not copy the lecture output as actual runtime evidence.

Record the current VM result.

## Configuration Verification

The server-side configuration workflow is:

```text
Create Export Directory
        ↓
Configure /etc/exports
        ↓
Apply Export Configuration
        ↓
Inspect Current Exports
```

A configuration-file edit alone should not be treated as verification.

## Start the NFS Server

The course starts:

```bash
systemctl start nfs-server
```

Inspect the service:

```bash
systemctl status nfs-server
```

The lecture screenshot shows an `active (exited)` state.

A systemd unit can be active even when the command used during activation has completed.

Interpret the actual service state from the current environment.

## NFS Firewall Inspection

The course checks allowed firewall services with:

```bash
firewall-cmd --list-services
```

The lecture environment includes:

```text
nfs
```

in the allowed-service list.

The course page demonstrates inspection rather than showing the rule-addition command at this point.

Verify the actual current firewall configuration.

## NFS Server Layers

An NFS server requires more than a running service.

Conceptually:

```text
Server Storage
      ↓
Directory Permissions
      ↓
Export Configuration
      ↓
NFS Service
      ↓
Firewall
      ↓
Network
```

A failure at any layer can prevent client access.

## NFS Client Package

The course also installs `nfs-utils` on the client.

In a Rocky Linux lab:

```bash
sudo dnf install -y nfs-utils
```

The client uses NFS utilities to discover and mount NFS exports.

## Inspect Server Exports from the Client

The course uses:

```bash
showmount -e localhost
```

General form:

```bash
showmount -e SERVER
```

This requests the export list advertised by the target NFS server.

The lecture uses `localhost` because the lab is demonstrated on the local system.

For a multi-VM lab, use the actual NFS server hostname or address.

## Export Discovery

Conceptually:

```text
Client
  |
  | showmount -e SERVER
  v
NFS Server
  |
  v
Export List
```

If an expected export is missing, investigate the server-side export configuration before troubleshooting the client mount point.

## Create a Client Mount Point

The course creates:

```bash
mkdir /nfs
```

The directory becomes the client's local mount point.

The mount point and the server export are different paths.

```text
Server:
 /share

Client:
 /nfs
```

## Mount the NFS Export

The course uses:

```bash
mount -t nfs localhost:/share /nfs
```

General form:

```bash
sudo mount -t nfs SERVER:/EXPORT_PATH MOUNT_POINT
```

Components:

```text
-t nfs
→ Filesystem type

SERVER:/EXPORT_PATH
→ Remote NFS filesystem source

MOUNT_POINT
→ Local client directory
```

## NFS Source Syntax

An NFS source uses the structure:

```text
SERVER:/PATH
```

Example structure:

```text
NFS_SERVER:/share
```

The server name and exported path are separated by a colon.

## Verify the NFS Mount

The course verifies the mount using:

```bash
df -h /nfs
```

A successful NFS mount can display a filesystem source in the form:

```text
SERVER:/EXPORT
```

mounted on the local directory.

Do not copy lecture capacity values as actual evidence.

## Mount Verification Model

```text
Mount Command
      ↓
Inspect Mounted Filesystem
      ↓
Confirm Source
      ↓
Confirm Mount Point
```

A successful `mount` command should be followed by an independent state check.

## Local and Network Mount Comparison

Local filesystem:

```text
/dev/DEVICE
      ↓
LOCAL_MOUNT_POINT
```

NFS filesystem:

```text
SERVER:/EXPORT
      ↓
LOCAL_MOUNT_POINT
```

Both appear through the Linux mount model, but the storage source is different.

## NFS Mount Options

The course introduces the following options:

```text
bg
fg
soft
hard
intr
rsize
wsize
timeo
retrans
retry
```

The exact behavior and defaults can depend on the NFS and Linux versions in use.

Do not assume that every value shown in the lecture table is the current default for every system.

## `bg`

The course describes `bg` as moving mount retries to the background if the initial mount attempt fails.

Conceptually:

```text
Initial Mount Attempt
        ↓
Failure
        ↓
Continue Retry in Background
```

## `fg`

The course describes `fg` as performing mount attempts in the foreground.

The lecture marks it as a default option.

## `hard`

The course describes a hard mount as continuing RPC attempts until the server responds.

Conceptually:

```text
Request
  ↓
No Response
  ↓
Retry
  ↓
Retry
  ↓
Wait for Server
```

The lecture marks `hard` as a default.

## `soft`

The course describes a soft mount as allowing repeated RPC calls to eventually time out.

Conceptually:

```text
Request
  ↓
Retry
  ↓
Retry Limit / Timeout
  ↓
Return Error
```

A soft mount should not automatically be selected merely to avoid waiting.

The data and application implications should be understood before using it.

## `rsize`

The course identifies:

```text
rsize
```

as the block size used for reading.

The lecture table shows a historical default value.

Do not treat that value as universal across current NFS versions.

## `wsize`

The course identifies:

```text
wsize
```

as the block size used for writing.

Actual negotiated values can depend on the environment.

## `timeo`

The course describes:

```text
timeo
```

as controlling the timeout before retransmission.

This illustrates that NFS I/O depends on network communication rather than only local storage latency.

## `retrans`

The course describes:

```text
retrans
```

as a retransmission-count setting.

## `retry`

The course associates:

```text
retry
```

with retry behavior for hard-mounted filesystems.

The detailed semantics should be checked in the current system manual before production configuration.

## `intr`

The course introduces:

```text
intr
```

as an option related to interrupting hard mount attempts.

This should be treated as a course-era mount option rather than assumed to have the same operational significance on every current Linux/NFS implementation.

## Persistent NFS Mounts

The course shows NFS entries in:

```text
/etc/fstab
```

General structure:

```text
SERVER:/EXPORT   MOUNT_POINT   nfs   OPTIONS   0 0
```

Example structure:

```text
NFS_SERVER:/share   /nfs   nfs   rw   0 0
```

Use actual server names and paths from the lab environment.

## Runtime and Persistent Mounts

A manual mount:

```bash
mount -t nfs SERVER:/EXPORT MOUNT_POINT
```

changes the current runtime mount state.

An NFS entry in:

```text
/etc/fstab
```

defines persistent mount configuration.

Conceptually:

```text
mount
→ Runtime state


/etc/fstab
→ Persistent configuration
```

This follows the same runtime-versus-persistent pattern seen throughout Linux administration.

## End-to-End NFS Workflow

```text
NFS Server
----------
Install nfs-utils
      ↓
Create Export Directory
      ↓
Configure /etc/exports
      ↓
Apply with exportfs
      ↓
Verify Export
      ↓
Start nfs-server
      ↓
Verify Firewall
      ↓

       Network

      ↓
NFS Client
----------
Install nfs-utils
      ↓
Discover Exports
      ↓
Create Mount Point
      ↓
Mount NFS
      ↓
Verify Mount
```

## NFS Troubleshooting Model

When an NFS mount fails:

```text
Mount Failure
     |
     v
Is Client Networking Working?
     |
     v
Can the NFS Server Be Reached?
     |
     v
Is nfs-server Running?
     |
     v
Is the Export Correctly Defined?
     |
     v
Does exportfs Show the Export?
     |
     v
Does the Firewall Permit NFS?
     |
     v
Can the Client Discover the Export?
     |
     v
Does the Local Mount Point Exist?
     |
     v
Can the Export Be Mounted?
     |
     v
Verify the Mounted Filesystem
```

The problem should be localized before configuration changes are made.

## Server-Side Troubleshooting

Inspect the service:

```bash
systemctl status nfs-server
```

Inspect exports:

```bash
exportfs
```

Inspect the configuration:

```bash
cat /etc/exports
```

Inspect the firewall:

```bash
firewall-cmd --list-services
```

Use actual runtime output as evidence.

## Client-Side Troubleshooting

Inspect server exports:

```bash
showmount -e SERVER
```

Inspect the mount point:

```bash
ls -ld MOUNT_POINT
```

Inspect current mounts with an appropriate mount or filesystem-inspection command.

Verify the final result independently after mounting.

## Troubleshooting by Layer

NFS connects several Linux administration areas.

```text
Storage
  ↓
Filesystem
  ↓
Linux Permissions
  ↓
SELinux
  ↓
NFS Export
  ↓
NFS Service
  ↓
Firewall
  ↓
Network
  ↓
Client Mount
```

Do not assume that every NFS failure is caused by the NFS daemon itself.

## Export Security

The course uses:

```text
/share *(rw)
```

for convenience.

A real export should normally be restricted according to the actual requirement.

Questions to consider include:

```text
Which clients require access?
Which network should be trusted?
Is read-only sufficient?
Is write access required?
Which Linux users or groups require access?
What SELinux policy applies?
Which firewall sources should be allowed?
```

Use the minimum access required by the application.

## NFS Incident Documentation

A useful troubleshooting record can follow:

```text
Symptom
   ↓
Evidence
   ↓
Root Cause
   ↓
Resolution
   ↓
Verification
```

Example scenario:

```text
Symptom
→ Client cannot mount the expected export.

Evidence
→ Collect service, export, firewall, network, and client discovery state.

Root Cause
→ Identify the specific failed layer.

Resolution
→ Change only the required configuration.

Verification
→ Confirm export discovery, mount state, and data access.
```

Do not fabricate an incident result before reproducing the failure in the lab.

## Verification Checklist

- NFS was understood as network-based file sharing.
- The NFS server and client roles were distinguished.
- `nfs-utils` was installed or reviewed on both sides.
- `/etc/exports` was identified as the export configuration file.
- The course `/share *(rw)` example was understood.
- Read-write and read-only export concepts were reviewed.
- The security implications of broad exports were recognized.
- The export directory was created or reviewed.
- Export configuration was applied with `exportfs -ra`.
- Active exports were inspected with `exportfs`.
- The `nfs-server` systemd service was inspected.
- `active (exited)` was not automatically interpreted as a service failure.
- Firewall service configuration was inspected.
- Client export discovery was performed or reviewed with `showmount -e`.
- A local NFS mount point was created or reviewed.
- NFS source syntax `SERVER:/EXPORT` was understood.
- A remote export was mounted or the mount workflow was reviewed.
- The final mount was independently verified.
- NFS mount options introduced by the course were reviewed.
- Runtime and persistent NFS mounting were distinguished.
- `/etc/fstab` was recognized as a persistent NFS mount configuration mechanism.
- Lecture hostnames, addresses, filesystem sizes, and outputs were not recorded as actual lab evidence.

## What I Learned

- NFS allows remote filesystem data to be accessed through a local mount point.
- `/etc/exports` defines server-side NFS exports.
- An export specifies both a directory and the clients or networks allowed to access it.
- `rw` and `ro` define different access levels.
- `exportfs -ra` reapplies export configuration.
- `exportfs` can be used to inspect active exports.
- A running NFS server is only one layer of successful NFS access.
- Firewall and network connectivity must also permit the client-server communication.
- `showmount -e` can help determine whether a client can discover the expected export.
- NFS mount sources use the `SERVER:/EXPORT` format.
- A successful mount should be independently verified.
- NFS mount behavior can be modified with options such as `hard`, `soft`, `bg`, `fg`, `timeo`, and `retrans`.
- Manual mounts represent runtime state, while `/etc/fstab` provides persistent mount configuration.
- NFS troubleshooting should inspect both server-side and client-side layers.
- Broad lab settings such as `*(rw)` and `1777` should not be treated as default production security choices.
