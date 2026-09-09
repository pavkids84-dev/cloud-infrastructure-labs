# Linux Backup and Recovery Lab

## Objective

Practice Linux backup and recovery concepts with filesystem-aware backup tools and `rsync`.

The goal of this lab is to understand full, incremental, and differential backup strategies, review backup levels, distinguish ext4 and XFS backup tools, practice backup verification and recovery concepts, and use `rsync` for remote synchronization.

## Environment

- OS: Rocky Linux
- Shell: Bash
- Filesystem Concepts: ext4 and XFS
- Remote Synchronization: rsync over SSH
- Privilege: root or sudo-enabled user

## Backup Principle

Important filesystems and files should be backed up regularly so that data can be recovered after data loss.

```text
Production Data
      |
      v
Regular Backup
      |
      v
Data Loss
      |
      v
Restore
      |
      v
Verify Recovery
```

A backup should not be considered complete until recovery is possible.

## Backup Media

The course introduces backup media such as:

```text
Tape Drive
CD-R / CD-RW / DVD
Hard Disk
Network-based storage
```

The important concept is that backup data is stored separately from the working copy so that it can later be used for recovery.

## Backup Methods

The course introduces three main backup strategies.

```text
Full Backup
Incremental Backup
Differential Backup
```

## Full Backup

A full backup copies the complete backup target.

```text
Source Data
A
B
C
D
E

    |
    v

Full Backup
A
B
C
D
E
```

A full backup provides a complete baseline for later recovery.

## Incremental Backup

An incremental backup stores changes following the previous backup point.

```text
Day 1
Full

Day 2
Increment 1

Day 3
Increment 2

Day 4
Increment 3
```

The course diagram shows the incremental backup levels building sequentially from earlier backup states.

## Differential Backup

A differential backup stores changes relative to the full-backup baseline.

```text
Day 1
Full

Day 2
Changes since Full

Day 3
Changes since Full

Day 4
Changes since Full
```

## Backup Strategy Comparison

```text
Full
→ Complete backup copy

Incremental
→ Changes since the previous backup

Differential
→ Changes since the most recent full backup
```

These strategies provide different trade-offs between backup size, backup time, and recovery complexity.

## Backup Levels

The course introduces a multi-level backup schedule.

The example includes:

```text
Level 0
Level 1
Level 2
Level 3
Level 4
Level 5
```

Level 0 is used as the full-backup baseline in the course schedule.

Higher backup levels can be used as part of an incremental backup policy.

The exact schedule depends on the backup policy designed for the system.

## Backup Tools Introduced by the Course

The lecture lists the following backup tools:

```text
tar
cpio
dd
dump / restore
xfsdump / xfsrestore
rsync
Relax and Recover (ReaR)
Acronis
NetBackup
```

This section of the course provides detailed command examples primarily for:

```text
dump / restore
xfsdump / xfsrestore
rsync
```

The other listed tools are recorded as tools introduced by the course and are not expanded into hands-on exercises here without additional source material.

## Filesystem-Aware Backup Tools

The course distinguishes:

```text
ext4
 |
 +-- dump
 +-- restore


XFS
 |
 +-- xfsdump
 +-- xfsrestore
```

This reinforces the need to identify the filesystem before selecting filesystem-specific administration tools.

Inspect mounted filesystem types with:

```bash
df -T
```

## dump and restore

The course demonstrates a level-0 backup using a command structure such as:

```bash
dump -0uf /bk/home.dump /home
```

Conceptually:

```text
/home
   |
   v
Level 0 dump
   |
   v
/bk/home.dump
```

The backup destination and source must be selected according to the actual lab environment.

## Inspect a dump Backup

The course uses:

```bash
restore -tvf /bk/home.dump
```

to inspect the contents of the dump archive.

The operational workflow is:

```text
Create Backup
     |
     v
Inspect Backup
     |
     v
Confirm Expected Data Exists
```

A backup file should not be trusted only because the backup command completed.

## Restore from a dump Backup

The course introduces:

```bash
restore -xvf /bk/home.dump
```

for extraction and recovery.

Restore exercises should be performed only in a disposable recovery directory.

Do not restore course examples directly over important production data.

## Interactive dump Restore

The course also introduces interactive recovery:

```bash
restore -ivf /bk/home.dump
```

Interactive commands shown in the course include:

```text
ls
add
extract
```

Conceptually:

```text
Open Backup
    |
    v
List Contents
    |
    v
Select Required Data
    |
    v
Extract
```

This allows selected data to be restored instead of restoring the entire backup set.

## XFS Backup with xfsdump

The course demonstrates a level-0 XFS backup:

```bash
xfsdump -l 0 -f /bk/home.xfsdump0 /home
```

Command components:

```text
-l 0
→ Backup level 0

-f /bk/home.xfsdump0
→ Backup output file

/home
→ Backup source
```

The resulting relationship is:

```text
XFS Source
    |
    v
xfsdump Level 0
    |
    v
Backup File
```

## xfsdump Labels

The course shows prompts for labels during the backup process.

Labels can help distinguish backup sessions.

The lecture suggests values such as:

```text
Date
Backup level
```

as possible identifying information.

## XFS Incremental Backup

The course then demonstrates a level-1 backup:

```bash
xfsdump -l 1 -f /bk/home.xfsdump1 /home
```

The lab concept is:

```text
Level 0 Backup
/home.xfsdump0

       |
       v

Level 1 Backup
/home.xfsdump1
```

## Inspect an XFS Backup

The course introduces:

```bash
xfsrestore -tf /bk/home.xfsdump0
```

for inspecting backup contents.

Verification is performed before recovery.

## Restore XFS Backup Levels

The course demonstrates restoring backup levels in sequence.

```bash
xfsrestore -rf /bk/home.xfsdump0 .
```

followed by:

```bash
xfsrestore -rf /bk/home.xfsdump1 .
```

Conceptually:

```text
Level 0
   |
   v
Restore Baseline
   |
   v
Level 1
   |
   v
Apply Later Backup
```

Perform recovery only inside a dedicated disposable recovery directory.

## Interactive XFS Restore

The course introduces:

```bash
xfsrestore -if /bk/home.xfsdump1 .
```

Interactive commands shown include:

```text
ls
add
extract
```

This allows selected files to be recovered.

## rsync Overview

The course introduces two rsync connection styles.

```text
rsync
 |
 +-- SSH-based
 |
 +-- rsync daemon
```

The hands-on examples in this section use SSH-based remote synchronization.

General structure:

```bash
rsync [OPTIONS] SOURCE DESTINATION
```

Possible synchronization directions include:

```text
Local → Local
Local → Remote
Remote → Local
```

## Important rsync Options

The course introduces the following options.

### Archive Mode

```text
-a
--archive
```

The course describes archive mode as a commonly used collection of options.

```text
-a
= -rlptgoD
```

The included behaviors shown in the course are:

```text
-r
→ Recursive directory copy

-l
→ Preserve symbolic links

-p
→ Preserve permissions

-t
→ Preserve timestamps

-g
→ Preserve group information

-o
→ Preserve owner information

-D
→ Preserve device-related information
```

## Additional rsync Options

```text
-h
→ Human-readable output

-v
→ Verbose output

-q
→ Quiet output

-z
→ Compress transferred data

-n
→ Dry run

-b
→ Backup behavior

-u
→ Update behavior

--delete
→ Delete destination files that do not exist in the source

--exclude
→ Exclude selected files

--include
→ Include selected files

-e
→ Select the remote shell or remote-shell options
```

## Dry Run

The course describes `-n` as a dry-run option.

A dry run shows what would be processed without performing the actual file copy.

Conceptually:

```text
Planned Synchronization
       |
       v
rsync -n
       |
       v
Review Changes
       |
       v
Run Actual Synchronization
```

This is especially useful before operations that can delete destination files.

## Remote Lab Preparation

The course demonstrates two systems with a hostname alias such as:

```text
s1
```

The remote backup host has a backup directory such as:

```text
/bk
```

The exact hostname, IP address, user, and directory must come from the actual lab environment.

Do not copy the lecture IP addresses into documentation as if they were current VM values.

## Basic Remote rsync

The course demonstrates a command structure such as:

```bash
rsync -azvh /root s1:/bk
```

The options represent:

```text
-a
→ Archive mode

-z
→ Compression

-v
→ Verbose output

-h
→ Human-readable output
```

When SSH is used for the first connection, the system can request host-key verification and remote authentication.

Actual host fingerprints and passwords must never be fabricated or committed to the repository.

## Verify the Remote Result

The course demonstrates that synchronizing:

```text
/root
```

to:

```text
s1:/bk
```

creates a structure similar to:

```text
/bk/root
```

on the destination.

Verify the actual remote directory after synchronization.

## Trailing Slash Behavior

The course demonstrates an important rsync path difference.

### Source without a trailing slash

```bash
rsync -azvh /root s1:/bk
```

Conceptually:

```text
/root
    |
    v
/bk/root
```

The source directory itself is transferred.

### Source with a trailing slash

```bash
rsync -azvh /root/ s1:/bk/files
```

Conceptually:

```text
Contents of /root
        |
        v
/bk/files/
```

The contents of the source directory are synchronized into the destination.

The difference between:

```text
/root
```

and:

```text
/root/
```

must be checked carefully before running rsync.

## Incremental Synchronization Behavior

The course demonstrates running rsync repeatedly after creating new files.

Example workflow:

```text
Initial Synchronization
        |
        v
Create New File
        |
        v
Run rsync Again
        |
        v
Only New or Changed Data Requires Synchronization
```

The course refers to this behavior as using a delta algorithm.

## Display Transfer Progress

The course uses:

```text
--progress
```

to display transfer progress.

Example structure:

```bash
rsync -azvh SOURCE DESTINATION --progress
```

The output can display information about the transfer while synchronization is running.

## Synchronize Source Deletions

The course demonstrates:

```text
--delete
```

If a file is removed from the source and rsync is run with `--delete`, that file can also be removed from the destination.

```text
Source File Deleted
       |
       v
rsync --delete
       |
       v
Destination File Deleted
```

This option can be destructive.

Verify source and destination paths carefully before execution.

## Safe Delete Review

A safer administrative workflow is to review the operation first.

```bash
rsync -n --delete SOURCE DESTINATION
```

Then run the actual command only after confirming that the planned deletions are correct.

This dry-run workflow combines options introduced in the course and is intended as a safety practice.

## Update Behavior

The course demonstrates the `-u` option while restoring data from the remote copy.

```text
-u
→ Update
```

The example keeps a newer destination file instead of replacing it with an older source version.

Conceptually:

```text
Remote Backup
Older File

Local Destination
Newer File

       |
       | rsync -u
       v

Newer Local File Is Preserved
```

This behavior is important during recovery when existing destination files may contain more recent data.

## rsync Backup and Restore Direction

### Backup

```text
Local Source
     |
     v
Remote Backup Server
```

Example structure:

```bash
rsync -azvh SOURCE REMOTE:DESTINATION
```

### Restore

```text
Remote Backup Server
     |
     v
Local Recovery Destination
```

Example structure:

```bash
rsync -azuh REMOTE:SOURCE/ LOCAL_DESTINATION
```

Use the actual lab paths rather than copying the lecture paths blindly.

## Synchronization Is Not Automatically Historical Backup

rsync synchronizes data according to the selected options.

For example:

```text
--delete
```

can make the destination reflect source deletions.

Therefore a synchronized copy and a historical backup policy are not automatically the same thing.

A backup policy should define:

```text
What is protected?
How often is it backed up?
Where is the backup stored?
How long is it retained?
How is recovery tested?
```

## Backup Verification Workflow

```text
Create Backup
      |
      v
Inspect Backup Contents
      |
      v
Perform Recovery Test
      |
      v
Inspect Restored Files
      |
      v
Confirm Recovery
```

A backup that has never been verified or restored should not be assumed to be recoverable.

## Troubleshooting rsync

When remote synchronization fails:

```text
rsync Failure
     |
     v
Verify Source Path
     |
     v
Verify Destination Path
     |
     v
Check Hostname Resolution
     |
     v
Check Network Connectivity
     |
     v
Check SSH Access
     |
     v
Check Permissions
     |
     v
Check rsync Options
     |
     v
Verify Result
```

Also confirm whether the source path intentionally includes a trailing slash.

## Verification Checklist

- The purpose of backup and recovery was understood.
- Backup media introduced in the course were reviewed.
- Full, incremental, and differential backup methods were distinguished.
- Backup levels were reviewed.
- Backup tools listed in the course were identified.
- Tools listed only by name were not documented as completed hands-on exercises.
- ext4 and XFS backup tools were distinguished.
- A dump backup workflow was reviewed.
- Dump archive inspection and restore concepts were reviewed.
- Interactive restore was reviewed.
- XFS level-0 and level-1 backup concepts were reviewed.
- XFS backup inspection and recovery order were reviewed.
- `rsync` SSH-based synchronization was reviewed.
- Archive mode and its preservation behavior were understood.
- Important rsync options were reviewed.
- Source paths with and without trailing slashes were distinguished.
- Repeated rsync synchronization behavior was observed or reviewed.
- `--progress` was reviewed.
- `--delete` behavior and its risk were understood.
- `-u` update behavior was reviewed.
- Backup creation was connected to explicit verification and recovery testing.

## What I Learned

- Backup exists to make recovery possible after data loss.
- Full, incremental, and differential backups use different backup baselines.
- Backup levels can be used to implement multi-level backup schedules.
- The course distinguishes `dump/restore` for ext4 and `xfsdump/xfsrestore` for XFS.
- Backup contents should be inspected rather than assuming a successful command created a usable recovery set.
- Interactive restore allows selected data to be recovered.
- XFS backup levels should be applied in the appropriate recovery sequence.
- `rsync` can synchronize data locally or across a network.
- The course demonstrates rsync over SSH as a remote backup mechanism.
- Archive mode preserves important filesystem metadata.
- A trailing slash on an rsync source path changes whether the source directory or only its contents are synchronized.
- Repeated rsync operations synchronize changed data rather than requiring a complete copy every time.
- `--delete` can remove destination files and must be used carefully.
- `-u` can preserve a newer destination file during synchronization.
- Synchronization and historical backup are related but are not identical concepts.
- A reliable backup workflow includes backup creation, inspection, restore testing, and final verification.
