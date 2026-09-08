# Linux Storage and Partition Management Lab

## Objective

Practice basic Linux storage administration on Rocky Linux.

The goal of this lab is to identify block devices, detect newly added disks, understand MBR and GPT partition tables, create partitions with `fdisk` and `parted`, and verify storage changes.

## Environment

- OS: Rocky Linux
- Shell: Bash
- Virtualization: VMware
- Storage Tools: `lsblk`, `fdisk`, `parted`
- Privilege: root or sudo-enabled user

## Safety Notice

Partition-management commands can destroy existing data.

Before changing a disk, always identify the operating-system disk and the separate lab disks.

```text
Example lab layout:

/dev/sda
→ Operating-system disk
→ Do not modify for this lab

/dev/sdb
→ Empty test disk for fdisk

/dev/sdc
→ Empty test disk for parted
```

Actual device names must be verified on the current system.

Never assume that `/dev/sdb` or `/dev/sdc` is safe without checking first.

## Inspect Block Devices

Display the block-device hierarchy.

```bash
lsblk
```

Important device types include:

```text
disk
→ Disk device

part
→ Partition

lvm
→ Logical volume

rom
→ Optical or read-only device
```

A typical device relationship can look like:

```text
Disk
 |
 +-- Partition
      |
      +-- LVM
           |
           +-- Mounted storage
```

## Disk and Partition Device Names

A disk and its partitions use related device names.

```text
/dev/sdb
→ Entire disk

/dev/sdb1
→ First partition on /dev/sdb

/dev/sdb2
→ Second partition on /dev/sdb
```

A partition is part of a disk, not a separate physical disk.

## Detect a Newly Added Disk

After adding a virtual disk in VMware, inspect the current block devices.

```bash
lsblk
```

If the new disk is not immediately visible, inspect the available SCSI hosts.

```bash
ls /sys/class/scsi_host/
```

The exact host names depend on the system.

A SCSI host can be rescanned through its scan interface.

Example form:

```bash
echo "- - -" > /sys/class/scsi_host/host0/scan
```

Repeat only for SCSI hosts that actually exist on the current system.

Verify again:

```bash
lsblk
```

## Inspect `sg3_utils`

Check whether the `sg3_utils` package is installed.

```bash
rpm -q sg3_utils
```

Inspect files provided by the package.

```bash
rpm -ql sg3_utils
```

One utility that may be provided is:

```text
/usr/bin/rescan-scsi-bus.sh
```

A SCSI rescan can be performed with:

```bash
rescan-scsi-bus.sh -a
```

The exact result depends on the devices attached to the system.

Verify block devices after the scan.

```bash
lsblk
```

## Partition Table Overview

Two partition-table formats covered in this lab are MBR and GPT.

```text
MBR
→ Master Boot Record

GPT
→ GUID Partition Table
```

## MBR Concept

The course material describes MBR with the following characteristics:

```text
Maximum disk size
→ Approximately 2 TB

Primary partitions
→ Maximum of four

Additional partition structure
→ Extended partition containing logical partitions

Lab tool
→ fdisk
```

A simplified MBR layout can look like:

```text
Disk
 |
 +-- Primary Partition
 |
 +-- Primary Partition
 |
 +-- Extended Partition
      |
      +-- Logical Partition
      +-- Logical Partition
```

## GPT Concept

The course material describes GPT with the following characteristics:

```text
Large disk support
→ Up to approximately 9.4 ZB in the course example

Partition count
→ Up to 128 partitions in the course material

Lab tool
→ parted
```

GPT does not use the MBR primary/extended/logical partition structure.

## Inspect Partition Tables with `fdisk`

List disks and partition tables.

```bash
fdisk -l
```

Information can include:

```text
Disk size
Sector count
Logical and physical sector size
Partition-table type
Partition start and end sectors
Partition size
Partition type
```

A line such as:

```text
Disklabel type: dos
```

indicates a DOS/MBR partition table.

## Understand Sector Information

`fdisk -l` can display information such as:

```text
Units: sectors of 1 * 512 = 512 bytes
```

This means the example device uses 512-byte logical sectors.

Partitions occupy ranges of sectors on a disk.

```text
Start Sector
      |
      |----- Partition -----|
                             |
                         End Sector
```

## Common MBR Partition Type IDs

The course example includes:

```text
83
→ Linux

8e
→ Linux LVM
```

These values can appear in `fdisk -l` output for MBR partitions.

## Inspect `fdisk` Help

Start `fdisk` only on an empty lab disk.

Example:

```bash
fdisk /dev/sdb
```

At the interactive prompt:

```text
Command (m for help):
```

Enter:

```text
m
```

Useful commands include:

```text
n
→ Add a new partition

d
→ Delete a partition

p
→ Print the partition table

t
→ Change a partition type

w
→ Write changes to disk and exit

q
→ Quit without saving changes

g
→ Create a new GPT partition table

o
→ Create a new DOS partition table
```

## Understand `w` and `q`

Changes made during an `fdisk` session remain pending until they are written.

```text
w
→ Write the partition table to disk and exit

q
→ Exit without saving pending changes
```

Always verify the selected disk before using `w`.

## Create an MBR Partition with `fdisk`

Use only an empty test disk.

Start the tool:

```bash
fdisk /dev/sdb
```

The course workflow creates a new primary partition.

```text
Command:
n

Partition type:
p

Partition number:
Use the available/default partition number

First sector:
Use the appropriate/default starting sector

Last sector:
+200M
```

Write the changes:

```text
w
```

The expected device relationship is:

```text
/dev/sdb
└── /dev/sdb1
```

## Context of `p` in `fdisk`

The meaning of `p` depends on the current prompt.

At the main `fdisk` command prompt:

```text
p
→ Print the partition table
```

During MBR partition-type selection:

```text
p
→ Primary partition
```

The same character can therefore have different meanings in different command contexts.

## Verify the New Partition

After writing the partition table, inspect the block devices.

```bash
lsblk
```

Verify that the new partition appears under the intended test disk.

Example structure:

```text
sdb
└─sdb1
```

Do not rely only on the success message from `fdisk`.

## Create a GPT Partition Table with `parted`

Use a separate empty test disk.

The course example uses `/dev/sdc`.

Create a GPT partition table:

```bash
parted -s /dev/sdc mklabel gpt
```

Command components:

```text
parted
→ Partition-management tool

-s
→ Script mode

/dev/sdc
→ Target disk

mklabel gpt
→ Create a GPT partition table
```

Creating a new partition table can destroy access to existing partition information, so this must only be performed on an intended lab disk.

## Create GPT Partitions

Create the first partition using the range shown in the course material.

```bash
parted -s /dev/sdc mkpart primary 1M 250M
```

Create the second partition.

```bash
parted -s /dev/sdc mkpart primary 251M 500M
```

Verify the resulting block-device hierarchy.

```bash
lsblk
```

The expected structure is similar to:

```text
sdc
├─sdc1
└─sdc2
```

## GPT and the `primary` Argument

GPT does not use the MBR primary/extended/logical partition limitation.

In the course example:

```bash
parted -s /dev/sdc mkpart primary 1M 250M
```

the word `primary` should not be interpreted as an MBR primary partition with the four-partition limit.

The `parted print` output in the course example shows it in the partition name field.

## Inspect the GPT Partition Table

Display the partition table.

```bash
parted -s /dev/sdc print
```

Verify information such as:

```text
Disk device
Disk size
Sector size
Partition Table: gpt
Partition number
Start
End
Size
Name
Flags
```

Confirm that the intended partitions were created.

## `fdisk` and `parted` Lab Comparison

```text
fdisk workflow
----------------------------

fdisk /dev/sdb
      |
      v
Interactive commands
      |
      v
Create partition
      |
      v
w
      |
      v
lsblk


parted workflow
----------------------------

parted ... mklabel gpt
      |
      v
parted ... mkpart
      |
      v
parted ... mkpart
      |
      v
parted ... print
      |
      v
lsblk
```

## Storage Layer Concept

This lab focuses on disks and partitions.

```text
Disk
 |
 v
Partition
```

A partition alone is not yet the complete usable filesystem workflow.

The next storage layer is:

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
```

Filesystem creation and mounting are handled separately.

## Storage Verification Workflow

A useful storage-administration workflow is:

```text
Identify Devices
      |
      v
lsblk
      |
      v
Identify the Empty Lab Disk
      |
      v
Inspect Partition Table
      |
      v
fdisk -l
      |
      v
Create or Modify Partition
      |
      v
Verify
      |
      +----------------+
      |                |
      v                v
    lsblk        parted print
```

## Troubleshooting a Newly Added Disk

If a newly added virtual disk is not visible:

```text
Disk Added in VMware
        |
        v
Run lsblk
        |
        v
Disk Missing?
        |
        v
Inspect SCSI Hosts
        |
        v
Rescan SCSI Bus
        |
        v
Run lsblk Again
        |
        v
Verify New Device
```

## Verification Checklist

- Block devices were inspected with `lsblk`.
- Disk and partition device names were distinguished.
- The operating-system disk was identified before making changes.
- A separate empty test disk was used for partition practice.
- SCSI disk-rescan methods were reviewed.
- Files provided by `sg3_utils` were inspected.
- MBR and GPT partition tables were compared.
- Disk and partition information was inspected with `fdisk -l`.
- Important `fdisk` interactive commands were reviewed.
- The difference between `w` and `q` was understood.
- An MBR partition was created on a test disk using the course workflow.
- The new partition was verified with `lsblk`.
- A GPT partition table was created on a separate test disk with `parted`.
- Two GPT partitions were created using the course workflow.
- The GPT partition table was verified with `parted print`.
- Disk, partition, filesystem, and mount concepts were kept separate.

## What I Learned

- `lsblk` displays Linux block devices and their hierarchy.
- A disk such as `/dev/sdb` and a partition such as `/dev/sdb1` are different storage objects.
- Newly attached SCSI disks can require a rescan before they appear in the operating system.
- `sg3_utils` can provide SCSI management utilities such as `rescan-scsi-bus.sh`.
- MBR and GPT are different partition-table formats.
- MBR uses primary, extended, and logical partition concepts.
- GPT supports a different partition model and is designed for larger storage configurations.
- `fdisk -l` displays disk and partition-table information.
- `fdisk` can interactively create and modify partitions.
- `fdisk` keeps pending changes until `w` writes them to disk.
- `q` exits `fdisk` without writing pending changes.
- The meaning of an interactive command character depends on the current prompt.
- `parted` can create and inspect GPT partition tables.
- `parted -s` performs operations in script mode.
- Partition changes must always be verified after they are made.
- A partition is not yet a filesystem and is not automatically ready for file storage.
- Storage administration should always begin by identifying the correct target device before making destructive changes.
