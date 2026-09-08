# Linux Filesystem Management Lab

## Objective

Practice Linux filesystem administration on Rocky Linux.

The goal of this lab is to understand filesystem types, inspect inode and filesystem information, create ext4 and XFS filesystems, mount and unmount filesystems, inspect persistent mount configuration, and practice basic XFS recovery.

## Environment

- OS: Rocky Linux
- Shell: Bash
- Virtualization: VMware
- Filesystems: ext4 and XFS
- Test partitions: Separate disposable partitions
- Privilege: root or sudo-enabled user

## Safety Notice

Filesystem creation and repair commands can destroy existing data.

Before running `mkfs`, `dd`, or filesystem repair commands, identify the target device carefully.

Example lab layout:

```text
/dev/sda
→ Operating-system disk
→ Do not modify

/dev/sdb1
→ Disposable partition for ext4

/dev/sdb2
→ Disposable partition for XFS
```

Actual device names must always be verified with:

```bash
lsblk
```

Never assume that `/dev/sdb1` or `/dev/sdb2` is safe on another system.

## Storage Layer Overview

The complete storage workflow is:

```text
Disk
 |
 v
Partition
 |
 v
Filesystem
 |
 v
Mount Point
 |
 v
Files and Directories
```

These layers should not be treated as the same object.

```text
Disk
≠ Partition
≠ Filesystem
≠ Mount Point
```

## Filesystem Types

The two main filesystem types used in this lab are:

```text
ext4
XFS
```

ext4 is part of the ext filesystem family and maintains compatibility with earlier ext filesystem generations.

XFS is a journaling filesystem and is widely used on Red Hat-based Linux systems.

## Inspect Mounted Filesystem Types

Display mounted filesystem usage and filesystem types.

```bash
df -T
```

Important columns include:

```text
Filesystem
Type
1K-blocks
Used
Available
Use%
Mounted on
```

The `Type` column identifies filesystem types such as:

```text
xfs
ext4
tmpfs
```

## Inspect Filesystem Usage in Human-Readable Form

Use:

```bash
df -hT
```

The options provide:

```text
-h
→ Human-readable sizes

-T
→ Filesystem type
```

## Inspect Supported Filesystems

Display filesystem types supported by the running kernel.

```bash
cat /proc/filesystems
```

The output can include entries such as:

```text
nodev   sysfs
nodev   tmpfs
nodev   proc
xfs
```

This is different from `df -T`.

```text
df -T
→ Filesystems currently mounted

/proc/filesystems
→ Filesystem types supported by the kernel
```

## ext4 Filesystem Structure

An ext4 filesystem is organized into block groups.

Important structures include:

```text
Superblock
Group Descriptor
Data Block Bitmap
Inode Bitmap
Inode Table
Data Blocks
```

A simplified relationship is:

```text
Filesystem
   |
   +-- Block Group
   |     |
   |     +-- Superblock information
   |     +-- Group information
   |     +-- Block bitmap
   |     +-- Inode bitmap
   |     +-- Inode table
   |     +-- Data blocks
   |
   +-- Block Group
         |
         +-- Metadata
         +-- Data blocks
```

Backup filesystem metadata can also exist in additional block groups.

## Inode Concept

An inode stores metadata about a filesystem object.

Information associated with an inode can include:

```text
File type
Permissions
File size
Owner
Group
Access time
Modification time
Link count
Data block references
```

A simplified relationship is:

```text
File Metadata
      |
      v
    Inode
      |
      v
Data Block References
      |
      v
File Data
```

## Direct and Indirect Block References

An inode can reference file data through multiple levels.

```text
Inode
 |
 +-- Direct block references
 |
 +-- Indirect block references
 |
 +-- Double-indirect block references
```

This allows larger files to reference more data blocks.

## Inspect Inode Information with `stat`

Inspect `/etc/passwd`.

```bash
stat /etc/passwd
```

Review fields such as:

```text
File
Size
Blocks
IO Block
Device
Inode
Links
Access permissions
UID
GID
Access time
Modify time
Change time
Birth time
```

The inode number identifies the inode associated with the filesystem object.

## Verify Lab Partitions

Before creating filesystems, inspect the test disk.

```bash
lsblk
```

Verify that the intended partitions exist and are not the operating-system partitions.

Example:

```text
sdb
├─sdb1
└─sdb2
```

## Create an ext4 Filesystem

Create an ext4 filesystem on the disposable test partition.

```bash
mkfs -t ext4 /dev/sdb1
```

The creation output can include:

```text
Filesystem UUID
Superblock backup locations
Group-table allocation
Inode-table creation
Journal creation
Superblock creation
```

These structures are created as part of filesystem initialization.

## Create an ext4 Mount Point

Create a directory that will act as the mount point.

```bash
mkdir /ext4
```

Mount the filesystem.

```bash
mount /dev/sdb1 /ext4
```

Verify it.

```bash
df -hT /ext4
```

Confirm:

```text
Filesystem
→ /dev/sdb1

Type
→ ext4

Mounted on
→ /ext4
```

## Create an XFS Filesystem

Verify the second disposable partition.

```bash
lsblk
```

Create an XFS filesystem.

```bash
mkfs -t xfs /dev/sdb2
```

The XFS creation output can include sections such as:

```text
meta-data
data
naming
log
```

It can also display information about allocation groups, block sizes, and the internal log.

## XFS Allocation Groups

XFS divides storage management into allocation groups.

A simplified view is:

```text
XFS Filesystem
 |
 +-- Allocation Group 0
 +-- Allocation Group 1
 +-- Allocation Group 2
 +-- Allocation Group 3
```

The actual allocation-group count depends on the filesystem configuration.

## Create an XFS Mount Point

Create the mount point.

```bash
mkdir /xfs
```

Mount the filesystem.

```bash
mount /dev/sdb2 /xfs
```

Verify:

```bash
df -hT /xfs
```

## Store Test Files on XFS

Copy files beginning with `p` from `/etc`.

```bash
cp /etc/p* /xfs
```

Some matched paths can be directories.

Without recursive copy, `cp` can report messages similar to:

```text
-r not specified; omitting directory
```

Inspect the files that were successfully copied.

```bash
ls /xfs
```

The exact files depend on the current system.

## Mount Concept

Mounting connects a filesystem to the Linux directory tree.

```text
Filesystem on Device
        |
        v
    Mount Point
        |
        v
Linux Directory Tree
```

General syntax:

```bash
mount DEVICE MOUNT_POINT
```

Example:

```bash
mount /dev/sdb1 /ext4
```

## Unmount a Filesystem

Unmount the filesystem.

```bash
umount /ext4
```

The command is named:

```text
umount
```

not `unmount`.

Mount it again when needed.

```bash
mount /dev/sdb1 /ext4
```

## Mount All Configured Filesystems

The course material introduces:

```bash
mount -a
```

This processes filesystem mount configuration such as entries in `/etc/fstab`.

## Remount a Filesystem

The course material also introduces the remount form:

```bash
mount -o remount,rw /
```

The options mean:

```text
remount
→ Apply mounting again to an already mounted filesystem

rw
→ Read/write access
```

Do not change root-filesystem mount options unnecessarily on a working system.

## Inspect `/etc/fstab`

Display the persistent filesystem configuration.

```bash
cat /etc/fstab
```

An `/etc/fstab` entry contains six main fields.

```text
DEVICE
MOUNT_POINT
FILESYSTEM_TYPE
OPTIONS
DUMP_SETTING
FILESYSTEM_CHECK_SETTING
```

Example structure:

```text
UUID=<filesystem-uuid>  /mountpoint  xfs  defaults  0  0
```

Actual UUID values must come from the current system and should not be fabricated.

## `/etc/fstab` Field Relationship

```text
Device
   |
   v
Mount Point
   |
   v
Filesystem Type
   |
   v
Mount Options
   |
   v
Dump Setting
   |
   v
Filesystem Check Setting
```

## Device Paths and UUIDs

The course example demonstrates that an `/etc/fstab` entry can identify a filesystem with a UUID.

Example form:

```text
UUID=<value>
```

Other entries can refer to device-mapper paths.

Always use identifiers from the actual system when configuring persistent mounts.

## Mount Options

The course material introduces the following mount options.

### `defaults`

A general default set of filesystem mount properties.

The course describes it as including behavior such as:

```text
rw
nouser
auto
exec
suid
```

### `auto`

```text
Mount automatically during boot
```

### `noauto`

```text
Do not mount automatically during boot
```

### `exec`

```text
Allow executable files to be executed
```

### `noexec`

```text
Do not allow executable-file execution
```

### `suid`

```text
Allow setuid and setgid behavior
```

### `nosuid`

```text
Disable setuid and setgid behavior
```

### `ro`

```text
Read-only
```

### `rw`

```text
Read/write
```

### `user`

```text
Allow a normal user to mount the filesystem
```

### `nouser`

```text
Do not allow normal-user mounting
```

### `usrquota`

```text
User-based disk quota support
```

### `grpquota`

```text
Group-based disk quota support
```

## Mount Option Pairs

Several mount options form useful conceptual pairs.

```text
rw       ↔ ro
auto     ↔ noauto
exec     ↔ noexec
suid     ↔ nosuid
user     ↔ nouser
```

## Inspect Current Mount Information

Display current mount information.

```bash
cat /etc/mtab
```

Conceptually:

```text
/etc/fstab
→ Persistent mount configuration

/etc/mtab
→ Current mount information
```

## Filesystem Creation and Mount Workflow

```text
Identify Partition
      |
      v
Create Filesystem
      |
      v
mkfs
      |
      v
Create Mount Point
      |
      v
mkdir
      |
      v
Mount Filesystem
      |
      v
mount
      |
      v
Verify
      |
      v
df -hT
```

## XFS Repair Concept

XFS provides `xfs_repair` for filesystem consistency checking and repair.

General form:

```bash
xfs_repair DEVICE
```

Repair output can proceed through multiple phases involving:

```text
Superblock verification
Internal log processing
Free-space information
Inode maps
Allocation groups
Inode connectivity
Link-count verification
```

Repair testing must be performed only on a disposable lab filesystem.

## XFS Failure and Recovery Lab

The following exercise intentionally damages the disposable XFS test partition.

Do not run this against an operating-system disk or valuable data.

First verify the target.

```bash
lsblk
```

Confirm that `/dev/sdb2` is the disposable XFS lab partition.

Inspect the files stored in the filesystem.

```bash
ls /xfs
```

Unmount it.

```bash
umount /xfs
```

## Intentionally Corrupt the Disposable XFS Filesystem

The course exercise overwrites part of the beginning of the test filesystem.

```bash
dd if=/dev/zero of=/dev/sdb2 bs=4096 count=10
```

This command is destructive.

Its components are:

```text
if=/dev/zero
→ Input source containing zero bytes

of=/dev/sdb2
→ Target test partition

bs=4096
→ 4096-byte block size

count=10
→ Write ten blocks
```

The operation writes:

```text
4096 × 10 = 40960 bytes
```

to the beginning of the test partition.

## Observe the Failure

Attempt to mount the damaged XFS filesystem.

```bash
mount /dev/sdb2 /xfs
```

The mount should fail if the intended filesystem metadata was damaged.

The course example displays an error containing:

```text
bad superblock
```

The exact error message can differ by system version.

## Repair the XFS Filesystem

Run the XFS repair tool against the unmounted disposable filesystem.

```bash
xfs_repair /dev/sdb2
```

The course example demonstrates recovery behavior including:

```text
Detect bad primary superblock
Search for a secondary superblock
Verify a candidate secondary superblock
Rebuild filesystem metadata
Verify inode connectivity
Verify link counts
```

Do not fabricate repair output in documentation.

Record only what the actual VM produces.

## Verify XFS Recovery

Mount the filesystem again.

```bash
mount /dev/sdb2 /xfs
```

Inspect its contents.

```bash
ls /xfs
```

Verify that the expected test files are accessible.

Also verify the mounted filesystem.

```bash
df -hT /xfs
```

This follows the troubleshooting pattern:

```text
Working Filesystem
       |
       v
Failure Introduced
       |
       v
Mount Failure
       |
       v
Evidence Collected
       |
       v
xfs_repair
       |
       v
Mount Again
       |
       v
Verify Data
```

## Inspect XFS Management Tools

Search XFS-related manual-page entries.

```bash
man -k xfs
```

The course material shows tools including:

```text
mkfs.xfs
xfs_admin
xfs_bmap
xfs_copy
xfs_db
xfs_estimate
xfs_freeze
xfs_fsr
xfs_growfs
xfs_info
xfs_io
xfs_logprint
xfs_mdrestore
xfs_metadump
xfs_mkfile
```

Not every tool needs to be used in this lab.

The main tools practiced here are:

```text
mkfs.xfs
→ Create an XFS filesystem

xfs_repair
→ Repair an XFS filesystem

xfs_info
→ Display XFS filesystem information
```

## `fsck.xfs` Concept

The course output describes `fsck.xfs` as:

```text
do nothing, successfully
```

XFS repair in this lab is therefore performed with:

```bash
xfs_repair
```

rather than using `fsck.xfs` as the repair operation.

## Inspect XFS Geometry

Display XFS filesystem information.

Use the disposable XFS partition:

```bash
xfs_info /dev/sdb2
```

The output can contain sections such as:

```text
meta-data
data
naming
log
realtime
```

and values including:

```text
isize
agcount
agsize
sectsz
bsize
blocks
```

The exact values depend on the filesystem created in the current VM.

## XFS Information Concept

```text
XFS Filesystem
     |
     +-- Metadata information
     +-- Allocation groups
     +-- Data block information
     +-- Directory/naming information
     +-- Journal/log information
     +-- Realtime information
```

`xfs_info` provides a way to inspect this filesystem geometry.

## Filesystem Troubleshooting Workflow

A useful workflow is:

```text
Filesystem Problem
       |
       v
Identify Device
       |
       v
lsblk
       |
       v
Check Filesystem and Mount State
       |
       v
df -T / mount information
       |
       v
Collect Error Evidence
       |
       v
Unmount the Target Filesystem
       |
       v
Run the Appropriate Repair Tool
       |
       v
xfs_repair
       |
       v
Mount Again
       |
       v
Verify Files and Filesystem State
```

## Verification Checklist

- Mounted filesystem types were inspected with `df -T`.
- Kernel-supported filesystem types were inspected through `/proc/filesystems`.
- The ext4 block-group structure was reviewed.
- The inode concept was reviewed.
- File metadata and inode information were inspected with `stat`.
- An ext4 filesystem was created on a disposable partition.
- The ext4 filesystem was mounted and verified.
- An XFS filesystem was created on a separate disposable partition.
- The XFS filesystem was mounted and verified.
- Test files were copied into the XFS filesystem.
- `mount` and `umount` were practiced.
- `/etc/fstab` structure was inspected.
- Mount options were reviewed.
- `/etc/mtab` was inspected.
- The XFS repair workflow was reviewed or practiced on a disposable filesystem.
- A mount failure was used as troubleshooting evidence during the repair exercise.
- The filesystem was remounted after repair.
- Test files were verified after recovery.
- XFS management tools were identified with `man -k xfs`.
- XFS geometry was inspected with `xfs_info`.

## What I Learned

- A partition must contain a filesystem before it can be used for normal file storage.
- A filesystem must be mounted into the Linux directory tree before it can be accessed through a mount point.
- `df -T` shows mounted filesystem types and capacity information.
- `/proc/filesystems` shows filesystem types supported by the kernel.
- ext4 organizes filesystem storage into block groups.
- Superblocks, bitmaps, inode tables, and data blocks have different filesystem roles.
- Inodes store file metadata and references to file data.
- `stat` exposes inode and metadata information for a filesystem object.
- `mkfs -t ext4` creates an ext4 filesystem.
- `mkfs -t xfs` creates an XFS filesystem.
- `mount` connects a filesystem to a directory.
- `umount` disconnects a mounted filesystem.
- `/etc/fstab` defines persistent filesystem mount configuration.
- Mount options control behaviors such as read/write access, automatic mounting, execution, and setuid handling.
- `/etc/mtab` represents current mount information.
- XFS uses allocation groups and an internal log structure.
- `xfs_repair` is used for XFS filesystem repair.
- Filesystem repair should be performed only after identifying the correct device and establishing a safe repair condition.
- Destructive corruption tests belong only on disposable lab storage.
- `xfs_info` displays XFS filesystem geometry.
- Storage administration should always follow a create, verify, modify, and verify-again workflow.
