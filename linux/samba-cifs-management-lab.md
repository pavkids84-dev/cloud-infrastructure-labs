# Samba and CIFS Management Lab

## Objective

Understand Linux SMB file sharing using Samba and access SMB shares from Linux using the CIFS mount interface.

The goal is to distinguish the SMB protocol, the Samba server implementation, Linux operating-system users, Samba authentication users, share definitions, and Linux CIFS client mounting.

## Environment

- OS: Rocky Linux lab environment
- SMB Server Software: Samba
- Server Service: `smb`
- Server Configuration: `/etc/samba/smb.conf`
- Samba User Management: `smbpasswd`
- Linux SMB Client Package: `cifs-utils`
- Client Filesystem Type: `cifs`

## File-Sharing Model

The course demonstrates Linux acting as a Samba server for Windows and Linux clients.

Conceptually:

```text
Linux Samba Server
        |
        | SMB
        |
   +----+----+
   |         |
Windows    Linux
Client     Client
```

## SMB, Samba, and CIFS

These terms should be distinguished.

```text
SMB
→ Network file-sharing protocol family
```

```text
Samba
→ Software that implements SMB services on Linux and Unix-like systems
```

```text
CIFS
→ Historical SMB-related terminology and the Linux `mount.cifs` interface name
```

A Linux client commonly mounts an SMB share using:

```bash
mount -t cifs
```

This command can be used with modern SMB environments and should not automatically be interpreted as meaning that only an old SMB1 dialect is being used.

## NFS vs Samba

A simplified comparison is:

```text
NFS
→ Traditionally common for Unix/Linux file sharing
```

```text
SMB / Samba
→ Strongly associated with Windows-compatible file sharing
```

Both provide network filesystem access but use different protocols and configuration models.

## Install Samba

The course uses:

```bash
dnf install samba
```

Do not copy package-version output from the lecture as actual lab evidence.

## Start the SMB Service

The course uses:

```bash
systemctl start smb
```

Verify:

```bash
systemctl status smb
```

Actual state must come from the current VM.

## Enable the SMB Service

The course uses:

```bash
systemctl enable smb
```

This should be distinguished from starting the service.

```text
start
→ Current runtime state

enable
→ Boot-time configuration
```

This follows the Linux runtime-versus-persistent configuration principle.

## Samba Configuration File

The course uses:

```text
/etc/samba/smb.conf
```

The file contains global configuration and share sections.

Conceptually:

```text
[global]
→ Server-wide configuration

[Music]
→ One share

[Public]
→ Another share
```

## Global Configuration

The course example includes:

```ini
[global]
server string = File Server
workgroup = HOME-NET
security = user
map to guest = Bad User
name resolve order = bcast hosts wins
```

These settings describe global Samba behavior.

## `server string`

The course uses:

```ini
server string = File Server
```

This provides a server-description string.

## `workgroup`

The course uses:

```ini
workgroup = HOME-NET
```

This associates the Samba server with the configured SMB workgroup context.

The course does not provide a deeper workgroup-management exercise in this section.

## `security = user`

The course configures:

```ini
security = user
```

This represents a user-oriented Samba authentication model.

The course then creates a Linux user and registers that user with Samba.

## `map to guest`

The course uses:

```ini
map to guest = Bad User
```

This setting is related to mapping certain invalid user requests to guest access.

The course does not provide a detailed guest-mapping algorithm exercise.

Treat it as a server policy setting rather than a universal Samba default.

## Name Resolution Order

The course uses:

```ini
name resolve order = bcast hosts wins
```

This defines a Samba name-resolution preference order.

The course does not provide a detailed WINS configuration lab in this section.

## Course `include` Example

The course displays:

```text
include = /etc/samba/smbshared.conf)
```

The trailing `)` appears to be extraneous in the slide.

The intended path structure should be treated as:

```text
include = /etc/samba/smbshared.conf
```

when interpreting the course example.

Do not change an actual Samba configuration without checking the syntax required by the installed version.

## Create a Linux User

The course uses:

```bash
useradd -s /sbin/nologin smbuser1
```

This creates a Linux account whose login shell prevents normal interactive shell login.

Conceptually:

```text
Linux Account
→ Exists for ownership / identity purposes

Interactive Shell
→ Disabled by nologin
```

Use a disposable lab account.

## Install Samba Client Utilities

The course also uses:

```bash
dnf install -y samba-client
```

This provides Samba client-side utilities.

The exact installed packages should be verified from the current environment.

## Add a Samba User

The course uses:

```bash
smbpasswd -a smbuser1
```

This adds Samba authentication information for the Linux user.

The important distinction is:

```text
useradd
→ Linux operating-system user
```

```text
smbpasswd
→ Samba authentication user information
```

A Linux account and Samba authentication state are related but not identical concepts.

## User Management Flow

Conceptually:

```text
Create Linux User
        ↓
Register Samba Authentication
        ↓
Use Samba Credentials
        ↓
Access Share
```

Do not store actual passwords in this repository.

## Samba Share Structure

A share is defined using a named section.

Example structure:

```ini
[ShareName]
path = /actual/linux/path
```

The section name is the network share name.

The `path` identifies the actual Linux filesystem directory.

Conceptually:

```text
SMB Share Name
     ↓
[Public]
     ↓
Linux Directory
/share/public
```

## Music Share

The course defines:

```ini
[Music]
path = /share/music
public = yes
writable = no
```

Conceptually:

```text
Share
→ Music

Linux Path
→ /share/music

Public / Guest-Related Access
→ Enabled

Write Access
→ Disabled
```

The course uses this as a read-oriented share example.

## Public Share

The course defines:

```ini
[Public]
path = /share/public
create mask = 0664
force create mode = 0664
directory mask = 0777
force directory mode = 0777
public = yes
writable = yes
```

The course uses this as a writable public-share example.

The permission values are lab examples and should not be treated as universal production defaults.

## `public`

The course uses:

```ini
public = yes
```

This is associated with guest/public access behavior.

Actual guest access still depends on the complete Samba and filesystem configuration.

Do not assume that one parameter alone proves that anonymous access will work.

## `writable`

The course uses:

```ini
writable = yes
```

or:

```ini
writable = no
```

Conceptually:

```text
yes
→ Share permits write operations according to other applicable controls.

no
→ Share is not writable through that share definition.
```

Filesystem permissions still matter.

## Samba and Linux Filesystem Permissions

A Samba share does not replace Linux filesystem access control.

A useful layered model is:

```text
SMB Request
     ↓
Samba Authentication
     ↓
Share Configuration
     ↓
Linux User / Group Identity
     ↓
Linux Filesystem Permission
     ↓
File Access
```

A share can appear writable in `smb.conf` while filesystem permissions still prevent the underlying operation.

## `create mask`

The course uses:

```ini
create mask = 0664
```

This setting controls permission bits that can be present on newly created files.

The detailed Samba permission calculation is outside the course section.

The important concept is:

```text
File creation permission policy
```

## `force create mode`

The course uses:

```ini
force create mode = 0664
```

This setting forces selected file permission bits when Samba creates a file.

A simplified distinction is:

```text
create mask
→ Restricts allowed file-mode bits

force create mode
→ Forces selected file-mode bits
```

## Directory Permission Options

The course also uses:

```ini
directory mask = 0777
force directory mode = 0777
```

These perform corresponding permission-control roles for directories.

The course's `0777` value is a permissive lab example.

Do not assume that production shares should use world-writable directories.

## Share Permission Safety

Before making a share writable, determine:

```text
Which users require access?
Which users require write access?
Which Linux group owns the data?
What filesystem mode is required?
Should guest access be allowed?
```

Use the minimum required access in a real environment.

## Windows Client Concept

The course shows a Windows client browsing Samba network shares.

Conceptually:

```text
Linux Samba Server
        ↓
       SMB
        ↓
Windows Client
        ↓
Network Share
```

This demonstrates the interoperability purpose of Samba.

## Linux SMB Client

The course also demonstrates Linux acting as an SMB client.

Install:

```bash
yum install -y cifs-utils
```

On a Rocky Linux environment using DNF:

```bash
sudo dnf install -y cifs-utils
```

## CIFS Mount Source Syntax

An SMB share source is written in the form:

```text
//SERVER/SHARE
```

This differs from NFS syntax.

```text
NFS
→ SERVER:/EXPORT
```

```text
SMB / CIFS
→ //SERVER/SHARE
```

## Create a Mount Point

Before mounting, ensure the intended local mount point exists.

General structure:

```bash
sudo mkdir -p MOUNT_POINT
```

Use only a disposable lab path.

## Mount an SMB Share

The course demonstrates:

```bash
mount -t cifs //10.10.10.101/Public -o username=smbuser1 /mnt/samba/Public
```

Generalized form:

```bash
sudo mount -t cifs \
  //SERVER/SHARE \
  -o username=SMB_USER \
  MOUNT_POINT
```

Do not copy the lecture server address as an actual environment value.

## CIFS Mount Fields

Conceptually:

```text
-t cifs
→ CIFS/SMB mount interface

//SERVER/SHARE
→ Remote SMB share

username=SMB_USER
→ Samba authentication user

MOUNT_POINT
→ Local Linux directory
```

## Verify a CIFS Mount

After mounting, inspect the actual mount state.

Useful questions include:

```text
Is the expected remote share mounted?
Is it mounted at the intended path?
Can the authorized user read the expected files?
Can write operations succeed when the share is intended to be writable?
```

Do not consider the operation complete solely because the mount command returned without an obvious error.

## Persistent CIFS Mount

The course shows `/etc/fstab` entries such as:

```text
//SERVER/Public /samba cifs username=SMB_USER 0 0
```

This defines a CIFS filesystem using the standard fstab structure:

```text
Source
Mount Point
Filesystem Type
Options
Dump
Filesystem Check
```

## Runtime vs Persistent CIFS Mount

Manual mount:

```bash
mount -t cifs ...
```

represents current runtime mount state.

An entry in:

```text
/etc/fstab
```

provides stored mount configuration.

Conceptually:

```text
Manual mount
→ Runtime

/etc/fstab
→ Persistent configuration
```

## `noauto`

The course also shows:

```text
noauto
```

in a CIFS fstab entry.

This indicates that the filesystem should not be mounted automatically through the normal automatic fstab mount flow.

The definition remains available for explicit use.

## Credential Security

The course examples show the username in mount options and do not place a password directly in the displayed fstab entry.

Do not store plaintext passwords in this repository.

For a real system, credential-storage design should avoid exposing authentication secrets in world-readable configuration.

Never commit:

```text
SMB Passwords
Credentials Files
Private Keys
Secrets
```

to GitHub.

## NFS vs SMB Source Syntax

A useful comparison is:

```text
NFS

SERVER:/export
```

```text
SMB / CIFS

//SERVER/share
```

This distinction helps prevent mount-command syntax mistakes.

## Samba Server Flow

```text
Install Samba
      ↓
Create Linux User
      ↓
Register Samba User
      ↓
Configure smb.conf
      ↓
Define Share
      ↓
Start smb
      ↓
Client Access
```

The course section does not provide firewall or SELinux configuration here; those security areas are addressed separately later in the network-services material.

## Linux CIFS Client Flow

```text
Install cifs-utils
       ↓
Identify SMB Share
       ↓
Create Local Mount Point
       ↓
Mount //SERVER/SHARE
       ↓
Authenticate
       ↓
Verify Mounted Filesystem
```

## Samba Troubleshooting Model

When a Samba share cannot be used:

```text
Is the SMB service available?
        ↓
Does the Samba user exist?
        ↓
Is the share defined?
        ↓
Does `path` point to the intended directory?
        ↓
Is the requested operation allowed by the share?
        ↓
Do Linux filesystem permissions allow it?
        ↓
Can the client reach the server?
        ↓
Can the client authenticate?
        ↓
Verify actual file access
```

Avoid changing all permission layers simultaneously.

## CIFS Client Troubleshooting Model

When a Linux CIFS mount fails:

```text
Is the server reachable?
        ↓
Is the share name correct?
        ↓
Is cifs-utils installed?
        ↓
Does the local mount point exist?
        ↓
Is the Samba username correct?
        ↓
Can authentication succeed?
        ↓
Does the mount complete?
        ↓
Verify the mount state
```

Use actual error messages as evidence.

## Permission Troubleshooting

When a share mounts but file creation fails:

```text
Mounted Successfully
       ↓
Authentication Succeeded
       ↓
Share writable?
       ↓
Samba permission options?
       ↓
Linux directory ownership?
       ↓
Linux filesystem mode?
       ↓
Actual requested operation
```

A successful network mount does not prove that every file operation is authorized.

## Verification Checklist

- SMB was distinguished from Samba.
- Samba was identified as a Linux/Unix SMB implementation.
- CIFS mount terminology was understood.
- Samba was installed or reviewed.
- The `smb` service was started or inspected.
- Runtime `start` and persistent `enable` were distinguished.
- `/etc/samba/smb.conf` was identified as the server configuration file.
- `[global]` was distinguished from share sections.
- `security = user` was reviewed.
- `map to guest = Bad User` was reviewed.
- A Linux user and Samba user were distinguished.
- `smbpasswd -a` was understood.
- `[Music]` and `[Public]` share examples were reviewed.
- `path` was understood as the underlying Linux directory.
- `public` and `writable` were reviewed.
- File and directory mask concepts were introduced.
- Course `0777` settings were not treated as production defaults.
- Windows Samba-client interoperability was understood.
- `cifs-utils` was identified as a Linux SMB client package.
- SMB source syntax `//SERVER/SHARE` was understood.
- NFS and CIFS source syntax were distinguished.
- `mount -t cifs` was reviewed.
- `/etc/fstab` CIFS configuration was reviewed.
- `noauto` was understood.
- Passwords and credentials were not committed to the repository.
- Lecture server addresses, usernames, permissions, and output were not recorded as actual runtime evidence.

## What I Learned

- SMB is a network file-sharing protocol family.
- Samba provides SMB services on Linux and Unix-like systems.
- A Samba user and a Linux operating-system user are related but represent different configuration layers.
- Samba shares are defined as named sections in `/etc/samba/smb.conf`.
- The share name and underlying Linux filesystem path are different concepts.
- Samba share permissions and Linux filesystem permissions both affect file access.
- Linux clients can mount SMB shares through the CIFS mount interface.
- SMB shares use `//SERVER/SHARE` syntax.
- NFS uses a different `SERVER:/EXPORT` syntax.
- Manual CIFS mounts and `/etc/fstab` configuration represent runtime and persistent configuration respectively.
- File-sharing troubleshooting should separate service state, authentication, share policy, filesystem permissions, network reachability, and client mount state.
