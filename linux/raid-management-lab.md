# Linux RAID Management Lab

## Objective

Practice Linux RAID concepts and software RAID administration on Rocky Linux.

The goal of this lab is to understand RAID 0, RAID 1, RAID 5, RAID 6, and RAID 10, compare performance and fault-tolerance characteristics, create software RAID arrays with `mdadm`, create filesystems on RAID devices, inspect RAID status, and understand the disk-replacement workflow.

## Environment

- OS: Rocky Linux
- Shell: Bash
- Virtualization: VMware
- RAID Management: mdadm
- Filesystem: ext4
- Privilege: root or sudo-enabled user

## Safety Notice

RAID creation and disk-management commands can destroy existing data.

Always identify the operating-system disk and dedicated RAID lab disks before running commands.

```bash
lsblk
```

Use only disposable disks or partitions created specifically for this lab.

Never assume that device names used in an example are safe on another system.

## RAID Overview

RAID stands for:

```text
Redundant Array of Independent/Inexpensive Disks
```

RAID combines multiple disks into a logical storage structure.

```text
Disk 1 ----\
            \
Disk 2 ------> RAID ----> Logical Storage
            /
Disk 3 ----/
```

RAID can be used to improve different storage characteristics such as:

```text
Performance
Fault tolerance
Storage utilization
Availability
```

Different RAID levels provide different trade-offs.

## Hardware and Software RAID

### Hardware RAID

Hardware RAID uses dedicated storage hardware or a RAID controller.

Conceptually:

```text
Operating System
      |
      v
RAID Controller
      |
      +-- Disk
      +-- Disk
      +-- Disk
```

The course material describes hardware RAID as generally more stable but more expensive.

### Software RAID

Software RAID is implemented by the operating system.

The course material introduces technologies such as:

```text
LVM
mdadm
ZFS
```

This lab focuses primarily on `mdadm`.

## RAID Level Overview

The RAID levels introduced in this lab are:

```text
RAID 0
RAID 1
RAID 5
RAID 6
RAID 10
```

They prioritize different properties.

```text
RAID 0
→ Performance

RAID 1
→ Fault tolerance

RAID 5
→ Capacity efficiency and single-disk fault tolerance

RAID 6
→ Higher fault tolerance

RAID 10
→ Performance and fault tolerance
```

## RAID 0

RAID 0 uses striping.

```text
Data:

A B C D E F

Disk 1    Disk 2    Disk 3
------    ------    ------
A         B         C
D         E         F
```

Data is distributed across multiple disks.

### Characteristics

```text
High performance
High storage efficiency
No fault tolerance
```

The course describes RAID 0 as providing 100% storage utilization because no mirror or parity capacity is reserved.

### Failure Behavior

If one member disk fails, part of the striped data is lost.

```text
Disk 1    Disk 2    Disk 3
------    ------    ------
A         B         C
D         E         F
          X

Missing striped data
→ Complete data set cannot be reconstructed
```

RAID 0 should therefore not be selected when disk fault tolerance is required.

## Concatenation and RAID 0

The course slide compares concatenation and RAID 0.

Conceptually:

```text
Concatenation
→ Storage spaces are joined sequentially

RAID 0
→ Data is striped across multiple disks
```

RAID 0 should be understood primarily as striping rather than simple disk concatenation.

## RAID 1

RAID 1 uses mirroring.

```text
Disk 1        Disk 2
------        ------
A             A
B             B
C             C
D             D
```

The same data is stored on multiple member disks.

### Characteristics

```text
Mirroring
Fault tolerance
Higher reliability
Reduced usable capacity
```

For a simple two-disk mirror:

```text
Raw capacity
= 2 × disk size

Usable data capacity
≈ 1 × disk size
```

This gives approximately 50% capacity efficiency.

## RAID 0 and RAID 1 Comparison

```text
RAID 0
----------------
Performance: High
Fault tolerance: No
Storage efficiency: High


RAID 1
----------------
Performance: Not the primary goal
Fault tolerance: Yes
Storage efficiency: Lower
```

## RAID 5

RAID 5 combines striping with parity.

```text
RAID 5
→ Stripe + Parity
```

The course requires at least three disks.

A simplified distribution can look like:

```text
          Disk 1   Disk 2   Disk 3   Disk 4

Stripe 1     D        D        D        P
Stripe 2     D        D        P        D
Stripe 3     D        P        D        D
Stripe 4     P        D        D        D
```

`D` represents data and `P` represents parity information.

Parity is distributed rather than permanently assigned to only one disk.

## RAID 5 Fault Tolerance

Parity can be used to reconstruct missing data when one member disk fails.

```text
Data
+
Parity
+
Remaining disks
        |
        v
Reconstruct missing data
```

RAID 5 tolerates one member-disk failure.

Two simultaneous member-disk failures cannot be recovered by the RAID 5 protection described in the course.

## RAID 5 Capacity

The course describes RAID 5 usable capacity as approximately:

```text
(Number of disks - 1) × size of one disk
```

Example with four equal 100 GB disks:

```text
Raw capacity:
400 GB

Approximate usable RAID 5 capacity:
300 GB
```

One disk's worth of capacity is effectively consumed by distributed parity.

## RAID 6

The course describes RAID 6 as an improvement on RAID 5.

Important characteristics include:

```text
Minimum disks
→ 4

Simultaneous disk failures tolerated
→ 2

Reliability
→ Higher than RAID 5

Capacity efficiency
→ Lower than RAID 5

Performance
→ Some additional overhead compared with RAID 5
```

RAID 6 trades additional capacity and performance overhead for greater fault tolerance.

## RAID 5 and RAID 6 Comparison

```text
RAID 5
├── Minimum 3 disks
├── One-disk failure tolerance
└── Better capacity efficiency

RAID 6
├── Minimum 4 disks
├── Two-disk failure tolerance
└── Higher fault tolerance
```

## RAID 10

RAID 10 combines RAID 1 mirroring with RAID 0 striping.

A simplified structure is:

```text
             RAID 0
            /      \
           /        \
      RAID 1        RAID 1
      /    \        /    \
   Disk   Disk   Disk   Disk
```

The course emphasizes:

```text
Fault tolerance
+
Performance
```

The capacity efficiency is approximately 50%.

## RAID Level Comparison

| RAID Level | Main Method | Minimum Disks | Fault Tolerance | Capacity Characteristic |
|---|---|---:|---|---|
| RAID 0 | Striping | 2 | None | High utilization |
| RAID 1 | Mirroring | 2 | Mirror-based | About 50% for a two-disk mirror |
| RAID 5 | Striping + parity | 3 | One disk | Approximately N-1 disks |
| RAID 6 | Enhanced parity | 4 | Two disks | Lower than RAID 5 |
| RAID 10 | Mirroring + striping | Typically 4 | Mirror-based | About 50% |

## LVM RAID Concept

The course also introduces RAID-style Logical Volumes using LVM.

### Stripe Volume

Course example:

```bash
lvcreate -L 300 -i 2 -I 8 -n stripe_lv vg01
```

The important concept is that LVM can create striped Logical Volumes.

### Mirror Volume

Course example:

```bash
lvcreate -L 200 -m 1 -n mirror_lv vg01
```

This demonstrates a mirrored Logical Volume.

### RAID 5 Logical Volume

Course example:

```bash
lvcreate -L 300 --type raid5 -i 3 -I 64 -n r5 vg01
```

The course uses these commands to show that RAID behavior can also be implemented at the LVM layer.

Exact sizing and device requirements should be verified in the actual environment before execution.

## mdadm Overview

`mdadm` is used to create and manage Linux software RAID arrays.

A software RAID array appears as an MD block device.

```text
RAID member devices
        |
        v
      mdadm
        |
        v
    /dev/mdX
```

The resulting `/dev/mdX` device can then be used as a normal block-storage layer.

## Verify RAID Lab Devices

Before creating an array, inspect the current block devices.

```bash
lsblk
```

Use only dedicated disposable partitions for the RAID exercise.

The following device names are examples based on the course workflow.

## Create RAID 1 with mdadm

The course creates RAID 1 using three member partitions.

```bash
mdadm -C -v /dev/md1 -l 1 -n 3 /dev/sdc1 /dev/sdd1 /dev/sde1
```

Command components:

```text
-C
→ Create array

-v
→ Verbose output

/dev/md1
→ RAID device

-l 1
→ RAID level 1

-n 3
→ Three RAID member devices
```

The resulting structure is:

```text
/dev/sdc1 ----\
               \
/dev/sdd1 ------> RAID 1 ------> /dev/md1
               /
/dev/sde1 ----/
```

## Inspect RAID 1

Inspect array information.

```bash
mdadm -QD /dev/md1
```

Inspect detected RAID-array information.

```bash
mdadm -Ds
```

Inspect the current software RAID state.

```bash
cat /proc/mdstat
```

Runtime values should be recorded from the actual VM rather than fabricated.

## Create a Filesystem on RAID 1

The RAID array itself is a block device.

Create an ext4 filesystem.

```bash
mkfs -t ext4 /dev/md1
```

Create a mount point.

```bash
mkdir /m1
```

Mount the RAID filesystem.

```bash
mount /dev/md1 /m1
```

Verify:

```bash
df -hT /m1
```

The storage path becomes:

```text
RAID Member Disks
        |
        v
     /dev/md1
        |
        v
      ext4
        |
        v
       /m1
```

## RAID Device as an LVM Physical Volume

The course also shows that an MD RAID device can be used as an LVM Physical Volume.

```bash
pvcreate /dev/md1
```

Conceptually:

```text
Physical Disks
      |
      v
Software RAID
      |
      v
/dev/md1
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
```

## Partitioning an MD Device

The course indicates that an MD device can also be partitioned.

Example:

```bash
fdisk /dev/md1
```

A resulting partition can appear with a name such as:

```text
/dev/md1p1
```

This demonstrates that the RAID array is exposed to Linux as a block device.

## Create RAID 5 with mdadm

The course RAID 5 example uses three partitions.

```bash
mdadm -C -v /dev/md5 -l 5 -n 3 /dev/sdc2 /dev/sdd2 /dev/sde2
```

Command components:

```text
/dev/md5
→ RAID device

-l 5
→ RAID level 5

-n 3
→ Three member devices
```

## Inspect RAID 5

Inspect array information.

```bash
mdadm -QD /dev/md5
```

Inspect RAID configuration information.

```bash
mdadm -Ds
```

Check current software RAID state.

```bash
cat /proc/mdstat
```

## Create and Mount the RAID 5 Filesystem

Create ext4.

```bash
mkfs -t ext4 /dev/md5
```

Create the mount point.

```bash
mkdir /m5
```

Mount the filesystem.

```bash
mount /dev/md5 /m5
```

Verify:

```bash
df -hT /m5
```

## Monitor RAID Status

The course uses `watch` with `/proc/mdstat`.

```bash
watch -n1 -d cat /proc/mdstat
```

Command components:

```text
watch
→ Repeatedly execute a command

-n1
→ Run every one second

-d
→ Highlight output changes

cat /proc/mdstat
→ Display software RAID status
```

This is useful while RAID synchronization or rebuild status is changing.

## RAID Disk Failure Workflow

The course introduces a failed-disk replacement process.

The important sequence is:

```text
Identify problem member
        |
        v
Mark member failed
        |
        v
Remove failed member
        |
        v
Add replacement member
        |
        v
Monitor rebuild
        |
        v
Verify array state
```

## Mark a RAID Member as Failed

General form:

```bash
mdadm ARRAY --fail MEMBER
```

The course uses the short `-f` form.

Example structure:

```bash
mdadm --manage ARRAY -f FAILED_DEVICE
```

The actual array and member device must be taken from the current lab system.

## Remove the Failed Member

General structure:

```bash
mdadm ARRAY -r FAILED_DEVICE
```

`-r` removes the member from the array.

## Add a Replacement Member

General structure:

```bash
mdadm ARRAY -a NEW_DEVICE
```

`-a` adds a new member to the array.

## Verify Rebuild

Monitor the software RAID state.

```bash
cat /proc/mdstat
```

or:

```bash
watch -n1 -d cat /proc/mdstat
```

The exact rebuild status depends on the actual RAID array.

## Course Device-Name Inconsistency

The disk-replacement slide changes between:

```text
/dev/md1
```

and:

```text
/dev/md0
```

during what appears to be one replacement workflow.

The slide also contains a device name that appears as:

```text
/dev/adc1
```

These names should not be copied literally.

Use the actual array and replacement device discovered on the current system.

The intended workflow is:

```text
mdadm ARRAY -f FAILED_DEVICE
mdadm ARRAY -r FAILED_DEVICE
mdadm ARRAY -a NEW_DEVICE
```

## Stop an Array

The course also introduces:

```bash
mdadm -S ARRAY
```

This stops the RAID array.

Stopping an array is different from removing a single failed member.

Do not stop an active array containing required data without understanding the impact.

## RAID Troubleshooting Workflow

```text
Storage Problem
      |
      v
Inspect Block Devices
      |
      v
lsblk
      |
      v
Inspect RAID State
      |
      v
cat /proc/mdstat
      |
      v
Inspect Array Details
      |
      v
mdadm
      |
      v
Identify Failed Member
      |
      v
Fail / Remove Member
      |
      v
Add Replacement
      |
      v
Monitor Rebuild
      |
      v
Verify Final State
```

## RAID and Backup

RAID and backup solve different problems.

```text
RAID
→ Provides protection against certain disk failures

Backup
→ Provides a separate copy of data for recovery
```

Deleting or corrupting a file can affect all members of a RAID array.

RAID should therefore not be treated as a substitute for independent backups.

## Storage Layer Relationship

RAID introduces another possible storage layer.

### Direct RAID Filesystem

```text
Physical Disks
      |
      v
RAID Array
      |
      v
Filesystem
      |
      v
Mount Point
```

### RAID with LVM

```text
Physical Disks
      |
      v
RAID Array
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

Understanding the active storage layer is important during troubleshooting.

## Verification Checklist

- RAID and its main goals were understood.
- Hardware RAID and software RAID were distinguished.
- RAID 0 striping was reviewed.
- RAID 1 mirroring was reviewed.
- RAID 5 parity and single-disk fault tolerance were reviewed.
- RAID 6 two-disk fault tolerance was reviewed.
- RAID 10 mirroring and striping were reviewed.
- RAID-level capacity trade-offs were compared.
- LVM-based RAID concepts were reviewed.
- Dedicated RAID lab devices were identified before modification.
- RAID 1 was created or its `mdadm` workflow was reviewed.
- RAID 1 status was inspected with `/proc/mdstat`.
- An ext4 filesystem was created and mounted on an MD device.
- RAID 5 was created or its `mdadm` workflow was reviewed.
- RAID 5 synchronization status was monitored.
- The failed-member workflow was understood.
- `fail`, `remove`, and `add` operations were distinguished.
- Device names were verified rather than copied blindly from the course slide.
- RAID was distinguished from backup.

## What I Learned

- RAID combines multiple physical disks into a logical storage structure.
- Different RAID levels trade performance, capacity, and fault tolerance differently.
- RAID 0 uses striping for performance but provides no disk-failure tolerance.
- RAID 1 uses mirroring to improve fault tolerance at the cost of storage capacity.
- RAID 5 combines striping and parity and tolerates one member-disk failure.
- RAID 6 increases fault tolerance to two simultaneous member-disk failures.
- RAID 10 combines mirroring and striping to provide both performance and reliability.
- Linux can implement software RAID with `mdadm`.
- Software RAID arrays are exposed through devices such as `/dev/md1` and `/dev/md5`.
- `/proc/mdstat` provides software RAID status information.
- A RAID device still requires a filesystem before normal file storage can be mounted.
- An MD RAID device can also become an LVM Physical Volume.
- RAID member replacement follows a fail, remove, add, and rebuild-verification workflow.
- Device names must always be verified on the actual system before destructive storage operations.
- RAID protects against certain disk failures but is not a substitute for backup.
