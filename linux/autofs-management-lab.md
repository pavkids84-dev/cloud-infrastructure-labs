# AutoFS Management Lab

## Objective

Understand Linux AutoFS map configuration and how NFS resources can be associated with direct and indirect automount maps.

The goal is to distinguish manual or persistent NFS mounting from AutoFS map-based mounting and understand the relationship between master maps, direct maps, indirect maps, wildcard keys, and NFS sources.

## Environment

- OS: Rocky Linux lab environment
- Service: `autofs`
- Package: `autofs`
- Network Filesystem: NFS
- Master Map Directory: `/etc/auto.master.d/`
- Direct Map Example: `/etc/auto.direct`
- Indirect Map Example: `/etc/auto.home`

## AutoFS Overview

The course introduces AutoFS as an NFS client-side filesystem management mechanism.

The map structure is:

```text
Master Map
    ↓
Map File
    ↓
Mount Key / Path
    ↓
NFS Source
```

The course demonstrates both:

```text
Direct Map
Indirect Map
```

## Install AutoFS

The course uses:

```bash
yum install -y autofs
```

On a Rocky Linux environment using DNF, the package can be installed with:

```bash
sudo dnf install -y autofs
```

Do not copy package-version output from the course as actual lab evidence.

## Inspect AutoFS

The course uses:

```bash
systemctl status autofs
```

Inspect the actual service state in the current VM.

Do not fabricate:

```text
PID
Active state
Timestamp
Log output
```

## Master Map

The course creates:

```text
/etc/auto.master.d/class.autofs
```

with:

```text
/- /etc/auto.direct

/home /etc/auto.home
```

These entries register two different map types.

Conceptually:

```text
Master Map
  |
  +-- /-     → /etc/auto.direct
  |
  +-- /home  → /etc/auto.home
```

## Direct Map

The course uses:

```text
/- /etc/auto.direct
```

The special:

```text
/-
```

entry indicates a direct map.

The actual mount path is then defined inside the direct map file.

## Direct Map File

The course configures:

```text
/etc/auto.direct
```

with:

```text
/usr/share/man -ro server1:/usr/share/man
```

The fields can be understood as:

```text
/usr/share/man
→ Client mount path

-ro
→ Read-only mount option

server1:/usr/share/man
→ NFS source
```

Conceptually:

```text
Client
/usr/share/man
       ↓
AutoFS
       ↓
server1:/usr/share/man
```

Use actual authorized server names and paths from the lab environment.

## Direct Map Concept

A direct map defines the complete absolute mount path inside the map.

```text
Master
  ↓
/-
  ↓
Direct Map
  ↓
/absolute/mount/path
```

This differs from an indirect map, where a parent mount directory is defined separately.

## Indirect Map

The course registers:

```text
/home /etc/auto.home
```

This creates an indirect-map relationship.

Conceptually:

```text
/home
  ↓
/etc/auto.home
```

Keys inside the map are interpreted beneath:

```text
/home
```

## Indirect Map File

The course configures:

```text
/etc/auto.home
```

with:

```text
* -rw,sync server1:/home/&
```

The fields include:

```text
*
→ Wildcard key

-rw,sync
→ Mount options

server1:/home/&
→ NFS source pattern
```

## Wildcard Key

The wildcard:

```text
*
```

can match a requested key.

For example, an access to:

```text
/home/autouser1
```

can conceptually match:

```text
*
→ autouser1
```

## `&` Substitution

The:

```text
&
```

in the source path represents the matched key.

Therefore:

```text
server1:/home/&
```

can become conceptually:

```text
server1:/home/autouser1
```

when the requested key is:

```text
autouser1
```

## Indirect Map Flow

The course ends the example with:

```bash
su - autouser1
```

A conceptual resolution flow is:

```text
User accesses
/home/autouser1
        ↓
Master Map
/home → /etc/auto.home
        ↓
Wildcard Match
* → autouser1
        ↓
Substitution
& → autouser1
        ↓
NFS Source
server1:/home/autouser1
```

Actual mount behavior and output must be verified in the current lab environment.

## Direct vs Indirect Maps

### Direct Map

```text
Master Entry
→ /-

Map Entry
→ Full absolute mount path
```

Example structure:

```text
/- /etc/auto.direct

/usr/share/man -ro SERVER:/usr/share/man
```

### Indirect Map

```text
Master Entry
→ Parent directory

Map Entry
→ Child key or wildcard
```

Example structure:

```text
/home /etc/auto.home

* -rw,sync SERVER:/home/&
```

## Direct and Indirect Comparison

| Concept | Direct Map | Indirect Map |
|---|---|---|
| Parent path in master | `/-` | Specific directory such as `/home` |
| Full path in map | Yes | No |
| Child keys | Not required in the same way | Used beneath parent directory |
| Wildcards | Possible depending on design | Common use case |

## AutoFS and Manual NFS Mounting

A manual NFS mount uses a command such as:

```bash
mount -t nfs SERVER:/EXPORT MOUNT_POINT
```

AutoFS instead uses map configuration to associate path access with a remote NFS source.

Conceptually:

```text
Manual Mount

Administrator
     ↓
mount command
     ↓
Mounted Filesystem
```

```text
AutoFS

Configured Map
     ↓
Path Access
     ↓
Automount Handling
```

## AutoFS and `/etc/fstab`

The course does not compare AutoFS and `/etc/fstab` directly in this section.

A useful operational distinction is:

```text
/etc/fstab
→ Defines filesystem mount configuration.

AutoFS
→ Uses automount maps and path access patterns.
```

The exact design should depend on the environment and availability requirements.

## NFS Dependency

AutoFS does not replace the NFS server configuration.

The complete architecture is still:

```text
NFS Server
     ↓
Exported Directory
     ↓
Network
     ↓
AutoFS Client Map
     ↓
Client Path
```

If the NFS server or export is unavailable, AutoFS cannot make the underlying service available.

## Troubleshooting Model

When an AutoFS path does not work:

```text
Is the NFS server reachable?
        ↓
Does the required export exist?
        ↓
Is AutoFS installed?
        ↓
Is the autofs service available?
        ↓
Is the master map correct?
        ↓
Is the correct map file registered?
        ↓
Is the direct or indirect path correct?
        ↓
Does the wildcard resolve as expected?
        ↓
Is the remote NFS path correct?
        ↓
Access the target path and verify
```

Change one layer at a time.

## Master Map Troubleshooting

Inspect the master map file:

```bash
cat /etc/auto.master.d/class.autofs
```

Confirm that the intended files are registered.

Conceptually:

```text
/-
→ Direct map

/home
→ Indirect map
```

Do not assume that a correct child map is useful if it is not registered through the master configuration.

## Direct Map Troubleshooting

Inspect:

```bash
cat /etc/auto.direct
```

Check:

```text
Client absolute path
Mount options
NFS server
NFS export path
```

A typo in any one of these fields can prevent the expected path from resolving.

## Indirect Map Troubleshooting

Inspect:

```bash
cat /etc/auto.home
```

Check the relationship between:

```text
Parent path
Wildcard key
& substitution
Remote path
```

For example:

```text
/home/autouser1
```

should resolve consistently with the configured source pattern.

## Evidence Collection

Useful evidence can include:

```text
systemctl status autofs
Master map content
Direct map content
Indirect map content
NFS export availability
Current mount state
Actual path-access result
```

Do not record course hostnames or outputs as actual runtime evidence.

## Verification Checklist

- AutoFS was identified as a client-side automount mechanism.
- The `autofs` package was installed or reviewed.
- The `autofs` systemd service was inspected.
- The master-map concept was understood.
- `/etc/auto.master.d/*.autofs` was identified as a master-map location used by the course.
- Direct maps were distinguished from indirect maps.
- `/-` was associated with a direct map.
- `/etc/auto.direct` was reviewed.
- `/home /etc/auto.home` was recognized as an indirect map.
- `/etc/auto.home` was reviewed.
- The wildcard `*` was understood.
- The `&` substitution was understood.
- NFS source syntax was recognized.
- Mount options such as `ro`, `rw`, and `sync` were reviewed.
- The AutoFS client was understood to depend on an available NFS server and export.
- Course server names, user names, paths, and outputs were not recorded as actual runtime evidence.

## What I Learned

- AutoFS uses map files to associate local paths with remote filesystems.
- A master map registers direct and indirect maps.
- A direct map contains complete mount paths.
- An indirect map manages keys beneath a configured parent directory.
- `*` can act as a wildcard map key.
- `&` can substitute the matched key into the remote path.
- AutoFS and NFS solve different parts of the same file-sharing workflow.
- AutoFS configuration should be verified together with NFS reachability and export availability.
