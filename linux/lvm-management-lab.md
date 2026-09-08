# Linux LVM Management Lab

## Objective

Practice Logical Volume Management (LVM) on Rocky Linux.

The goal of this lab is to understand the relationship between Physical Volumes, Volume Groups, and Logical Volumes, create an ext4 filesystem on an LV, extend LVM storage, resize the filesystem, practice safe offline shrinking, and create an LVM snapshot for backup.

## Environment

- OS: Rocky Linux
- Shell: Bash
- Virtualization: VMware
- Storage Management: LVM
- Filesystem: ext4
- Privilege: root or sudo-enabled user

## Safety Notice

LVM initialization and resize operations can destroy existing data.

Before running commands such as:

```bash
pvcreate
lvreduce
resize2fs
```

verify every target device with:

```bash
lsblk
```

Use only dedicated disposable disks created for this lab.

Do not run this lab against the operating-system disk or disks used by previous storage labs.

The device names used below are examples only.

```text
/dev/sdd
→ First disposable LVM disk

/dev/sde
→ Second disposable LVM disk

/dev/sdf
→ Additional disposable disk for VG expansion
```

Actual device names must be confirmed on the current VM.

## LVM Overview

LVM adds a logical storage layer between physical storage and filesystems.

```text
Physical Disk
      |
      v
Physical Volume
      |
      v
Volume Group
      |
      v
Logical Volume
      |
      v
Filesystem
      |
      v
Mount Point
```

The three core LVM objects are:

```text
PV
→ Physical Volume

VG
→ Volume Group

LV
→ Logical Volume
```

## Physical Volume

A Physical Volume is storage prepared for use by LVM.

The course material describes possible PV sources such as:

```text
Disk
Partition
RAID device
iSCSI device
```

Conceptually:

```text
Storage Device
      |
      v
   pvcreate
      |
      v
Physical Volume
```

## Volume Group

A Volume Group combines one or more Physical Volumes into a storage pool.

```text
PV 1 --------\
              \
               > Volume Group
              /
PV 2 --------/
```

Logical Volumes can then be allocated from this pool.

## Logical Volume

A Logical Volume is a logical storage area created from a Volume Group.

```text
Volume Group
     |
     +-- Logical Volume
     +-- Logical Volume
     +-- Free Space
```

Logical Volumes can be used for purposes such as:

```text
Filesystems
Swap
Application storage
```

## Physical and Logical Extents

LVM manages storage using allocation units.

```text
Physical Extent (PE)
→ Basic allocation unit at the Physical Volume level

Logical Extent (LE)
→ Basic allocation unit at the Logical Volume level
```

The course introduces these concepts without requiring extent calculations in this lab.

## Verify Dedicated Lab Disks

Inspect all block devices.

```bash
lsblk
```

Identify the operating-system disk and the empty disks reserved for this lab.

Example lab layout:

```text
/dev/sda
→ Operating-system disk
→ Never modify for this lab

/dev/sdd
→ Disposable LVM disk

/dev/sde
→ Disposable LVM disk

/dev/sdf
→ Disposable expansion disk
```

Do not continue until the correct devices have been identified.

## Create Physical Volumes

Initialize the first two disposable disks as LVM Physical Volumes.

```bash
pvcreate /dev/sdd /dev/sde
```

Conceptually:

```text
/dev/sdd ------> PV
/dev/sde ------> PV
```

## Create a Volume Group

Create a Volume Group named `vg01`.

```bash
vgcreate vg01 /dev/sdd /dev/sde
```

The resulting relationship is:

```text
/dev/sdd ----\
              \
               > vg01
              /
/dev/sde ----/
```

The two Physical Volumes now provide storage to the same Volume Group.

## Create a Logical Volume

Create a Logical Volume named `v1`.

```bash
lvcreate -L 100M -n v1 vg01
```

Command components:

```text
-L 100M
→ Logical Volume size

-n v1
→ Logical Volume name

vg01
→ Source Volume Group
```

The resulting structure is:

```text
vg01
 |
 +-- v1
 |
 +-- Free Space
```

## Logical Volume Device Path

The Logical Volume can be accessed through a path such as:

```text
/dev/vg01/v1
```

The same LVM storage can also appear through the device-mapper hierarchy.

Always verify the current system rather than fabricating device output.

## Create an ext4 Filesystem

Create an ext4 filesystem on the Logical Volume.

```bash
mkfs -t ext4 /dev/vg01/v1
```

The storage layers are now:

```text
Physical Volumes
       |
       v
     vg01
       |
       v
      v1
       |
       v
     ext4
```

## Create a Mount Point

Create the application mount point.

```bash
mkdir /app
```

Mount the Logical Volume.

```bash
mount /dev/vg01/v1 /app
```

Verify the filesystem.

```bash
df -hT /app
```

Confirm that:

```text
Filesystem type
→ ext4

Mount point
→ /app
```

The exact size values depend on the current lab environment.

## LVM Creation Workflow

```text
Empty Disks
    |
    v
pvcreate
    |
    v
Physical Volumes
    |
    v
vgcreate
    |
    v
Volume Group
    |
    v
lvcreate
    |
    v
Logical Volume
    |
    v
mkfs
    |
    v
Filesystem
    |
    v
mount
    |
    v
Usable Storage
```

## Extend the Volume Group

Add another dedicated empty disk to the LVM storage pool.

First verify the new disk.

```bash
lsblk
```

Initialize the new disk as a Physical Volume.

```bash
pvcreate /dev/sdf
```

Add it to the existing Volume Group.

```bash
vgextend vg01 /dev/sdf
```

Conceptually:

```text
Before

vg01
├── /dev/sdd
└── /dev/sde


After

vg01
├── /dev/sdd
├── /dev/sde
└── /dev/sdf
```

Extending the Volume Group increases the storage available to the pool.

It does not automatically enlarge an existing Logical Volume.

## Understand VG and LV Expansion

```text
VG Expansion
→ Adds storage to the Volume Group pool

LV Expansion
→ Allocates more of that storage to a Logical Volume

Filesystem Expansion
→ Allows the filesystem to use the enlarged LV
```

These are separate storage layers.

## Inspect Filesystem Size Before Expansion

Check the currently mounted filesystem.

```bash
df -hT /app
```

Record the actual size reported by the VM before making the change.

## Extend the Logical Volume

Increase `v1` by 300 MiB.

```bash
lvextend -L +300M /dev/vg01/v1
```

The plus sign is significant.

```text
-L 300M
→ Set the final LV size to 300 MiB

-L +300M
→ Add 300 MiB to the current LV size

-L -200M
→ Remove 200 MiB from the current LV size
```

## Expand the ext4 Filesystem

After extending the Logical Volume, enlarge the ext4 filesystem.

```bash
resize2fs /dev/vg01/v1
```

The workflow is:

```text
Logical Volume
      |
      | lvextend
      v
Larger Logical Volume

Filesystem
      |
      | resize2fs
      v
Larger Filesystem
```

## Verify Online Expansion

Check the filesystem again.

```bash
df -hT /app
```

Compare the size with the value recorded before expansion.

The course demonstrates ext filesystem growth while the filesystem is mounted.

## Combined Resize Concept

The course also introduces the following form:

```bash
lvresize -r -L +300M /dev/vg01/v1
```

The `-r` option requests filesystem resizing together with the Logical Volume resize.

The important concept is that the LV layer and filesystem layer must both reflect the intended final capacity.

## Online Growth and Offline Shrink

The course demonstrates different behavior for growth and shrink operations.

```text
Growth
→ Performed while the ext filesystem is mounted

Shrink
→ Requires an offline workflow in the course exercise
```

Filesystem shrinking is more dangerous than expansion because reducing the underlying storage incorrectly can destroy data.

## Prepare for Offline Shrink

Inspect the mounted filesystem.

```bash
df -hT /app
```

Unmount the filesystem.

```bash
umount /app
```

The course demonstrates that online shrinking of this ext filesystem is not supported.

## Check the ext Filesystem

Before shrinking, force a filesystem check.

```bash
e2fsck -f /dev/vg01/v1
```

The filesystem must be checked before the shrink operation used in the course workflow.

## Shrink the Filesystem First

Reduce the ext filesystem to 300 MiB.

```bash
resize2fs /dev/vg01/v1 300M
```

At this point, the filesystem has been reduced before the underlying Logical Volume is reduced.

This order is critical.

```text
Correct shrink order:

Filesystem
    |
    v
Shrink filesystem
    |
    v
Shrink Logical Volume
```

## Reduce the Logical Volume

Set the final Logical Volume size to 300 MiB.

```bash
lvreduce -L 300M /dev/vg01/v1
```

Review the warning carefully before confirming the operation.

`-L 300M` means:

```text
Final LV size = 300 MiB
```

It does not mean:

```text
Reduce the LV by 300 MiB
```

## Remount After Shrink

Mount the filesystem again.

```bash
mount /dev/vg01/v1 /app
```

Verify the result.

```bash
df -hT /app
```

Confirm that the filesystem is mounted successfully and that the expected reduced capacity is visible.

## Offline Shrink Workflow

```text
Mounted Filesystem
        |
        v
umount
        |
        v
e2fsck -f
        |
        v
resize2fs
        |
        v
Shrink Filesystem
        |
        v
lvreduce
        |
        v
Shrink Logical Volume
        |
        v
mount
        |
        v
df -hT
        |
        v
Verify
```

## Why Shrink Order Matters

The filesystem must fit inside the Logical Volume.

Incorrect order:

```text
Shrink LV First
      |
      v
Filesystem May Extend Beyond LV
      |
      v
Data Loss Risk
```

Correct order:

```text
Shrink Filesystem First
      |
      v
Filesystem Fits New Size
      |
      v
Shrink LV
```

## LVM Snapshot Concept

The course introduces an LVM snapshot as part of a backup workflow.

A snapshot is created from an existing Logical Volume.

```text
Original LV
/dev/vg01/v1
      |
      v
Snapshot
/dev/vg01/snap
```

## Create a Snapshot

Create a snapshot named `snap`.

```bash
lvcreate -s -L 10M -n snap /dev/vg01/v1
```

Command components:

```text
-s
→ Create a snapshot

-L 10M
→ Snapshot size used in the course workflow

-n snap
→ Snapshot name

/dev/vg01/v1
→ Origin Logical Volume
```

## Mount the Snapshot

Create a mount point.

```bash
mkdir /snap
```

Mount the snapshot.

```bash
mount /dev/vg01/snap /snap
```

Inspect the snapshot contents.

```bash
ls /snap
```

The exact contents depend on the original Logical Volume.

## Create a Backup Archive from the Snapshot

The lecture slide shows a backup destination under `/dev/vg01/bk`, but it does not show how an object named `bk` was created.

For this lab, use a regular archive file instead of assuming that `/dev/vg01/bk` exists.

```bash
tar cvf /tmp/v1-snapshot-backup.tar -C /snap .
```

Inspect the archive.

```bash
tar tvf /tmp/v1-snapshot-backup.tar
```

This keeps the backup exercise explicit and avoids writing to an undefined block-device path.

## Remove the Snapshot After Backup

Return outside the snapshot mount point.

```bash
cd /
```

Unmount the snapshot.

```bash
umount /snap
```

Remove the snapshot Logical Volume.

```bash
lvremove /dev/vg01/snap
```

Confirm the removal when prompted.

The backup archive remains separate from the temporary snapshot.

## Snapshot Backup Workflow

```text
Original Logical Volume
          |
          v
Create Snapshot
          |
          v
Mount Snapshot
          |
          v
Read Snapshot Data
          |
          v
Create tar Archive
          |
          v
Unmount Snapshot
          |
          v
Remove Snapshot
```

## LVM Expansion Workflow

```text
New Disk
   |
   v
pvcreate
   |
   v
New Physical Volume
   |
   v
vgextend
   |
   v
Larger Volume Group
   |
   v
lvextend
   |
   v
Larger Logical Volume
   |
   v
resize2fs
   |
   v
Larger ext4 Filesystem
```

## LVM Layer Troubleshooting

When expected storage capacity is not available, identify the layer that has not been expanded.

```text
New Disk Added
      |
      v
Is it a PV?
      |
      v
Is the PV in the VG?
      |
      v
Was the LV extended?
      |
      v
Was the filesystem resized?
      |
      v
Does df show the new capacity?
```

A change at one LVM layer does not automatically imply that every higher layer has changed.

## Verification Checklist

- Dedicated disposable disks were identified with `lsblk`.
- Two disks were initialized as Physical Volumes.
- A Volume Group named `vg01` was created.
- A Logical Volume named `v1` was created.
- An ext4 filesystem was created on the Logical Volume.
- The filesystem was mounted at `/app`.
- The mounted filesystem was verified with `df -hT`.
- A third Physical Volume was added to the Volume Group.
- The difference between VG expansion and LV expansion was understood.
- The Logical Volume was extended.
- The ext4 filesystem was expanded after LV expansion.
- Online growth was verified.
- The filesystem was unmounted before the shrink exercise.
- `e2fsck -f` was performed before ext filesystem shrinking.
- The filesystem was reduced before the Logical Volume.
- The meaning of absolute and relative `-L` size values was distinguished.
- The filesystem was remounted and verified after shrinking.
- An LVM snapshot was created.
- The snapshot was mounted and inspected.
- A tar archive was created from the mounted snapshot.
- The snapshot was unmounted and removed after the backup exercise.
- LVM changes were verified at each storage layer rather than assumed to have succeeded.

## What I Learned

- LVM introduces logical storage layers between physical devices and filesystems.
- A Physical Volume is storage prepared for LVM use.
- A Volume Group combines one or more Physical Volumes into a storage pool.
- A Logical Volume allocates usable logical storage from a Volume Group.
- Physical Extents and Logical Extents are LVM allocation units.
- An LV still requires a filesystem before it can be used for normal file storage.
- `pvcreate` initializes Physical Volumes.
- `vgcreate` creates a Volume Group.
- `lvcreate` creates a Logical Volume.
- `vgextend` adds another Physical Volume to an existing Volume Group.
- Extending a Volume Group does not automatically enlarge its Logical Volumes.
- `lvextend` enlarges a Logical Volume.
- `resize2fs` resizes the ext filesystem to use the enlarged storage.
- The plus and minus signs in relative LVM size expressions are significant.
- Filesystem shrinking must be handled more carefully than expansion.
- In the course workflow, the ext filesystem is checked and shrunk before the Logical Volume is reduced.
- `lvreduce -L 300M` sets the final LV size to 300 MiB.
- LVM snapshots can provide a temporary view of an origin Logical Volume for a backup workflow.
- A snapshot and an independent backup archive are separate concepts.
- Storage administration should verify each layer independently after a resize or configuration change.
