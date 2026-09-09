# Linux Memory and Swap Management Lab

## Objective

Practice Linux memory inspection and swap management on Rocky Linux.

The goal of this lab is to inspect memory hardware information, understand virtual memory concepts, monitor system and process memory usage, compare device swap and file swap, create and activate swap space, and verify swap configuration.

## Environment

- OS: Rocky Linux
- Shell: Bash
- Memory Tools: `dmidecode`, `free`, `vmstat`, `top`, `pmap`
- Swap Tools: `mkswap`, `swapon`, `swapoff`
- Privilege: root or sudo-enabled user

## Memory Management Overview

Linux memory management can be inspected at several levels.

```text
Hardware Memory
      |
      v
System Memory
      |
      v
Process Memory
      |
      v
Swap
```

Useful tools include:

```text
dmidecode
→ Memory hardware information

free
→ System memory summary

vmstat
→ Memory, swap, I/O, system, and CPU activity

/proc/meminfo
→ Detailed kernel memory information

top
→ Per-process memory information

pmap
→ Memory map of a specific process
```

## Inspect Memory Hardware Information

Display DMI information related to memory.

```bash
sudo dmidecode | grep -A 5 -B 5 -i memory | more
```

The output can contain information such as:

```text
Memory controller information
Maximum memory-module size
Maximum total memory size
Supported memory speeds
Supported memory types
```

In a virtual machine, the information can represent virtual hardware presented to the guest operating system.

## Virtual Memory Concept

The course introduces virtual memory with the simplified relationship:

```text
RAM + Swap = Virtual Memory
```

The important operational concept is that swap provides disk-backed space that can support memory management when physical RAM is under pressure.

```text
Physical RAM
     +
Swap Space
     |
     v
Memory Management
```

Swap is slower than physical RAM because it uses storage rather than normal memory.

## Inspect System Memory

Display memory information in MiB.

```bash
free -m
```

Important fields include:

```text
total
→ Total memory

used
→ Used memory

free
→ Completely unused memory

shared
→ Shared-memory usage

buff/cache
→ Memory used for buffers and cache

available
→ Memory estimated to be available for new workloads
```

The command also displays swap information.

```text
Swap total
Swap used
Swap free
```

## Inspect Memory in Human-Readable Form

A human-readable view can also be used.

```bash
free -h
```

Do not judge memory pressure only from the `free` column.

Linux can use otherwise idle memory for buffers and cache.

The `available` value is also useful when evaluating current memory capacity.

## Monitor Memory Activity with `vmstat`

Display five samples at one-second intervals.

```bash
vmstat 1 5
```

The output is grouped into areas such as:

```text
procs
memory
swap
io
system
cpu
```

Important swap-related fields include:

```text
swpd
→ Amount of swap currently used

si
→ Swap-in activity

so
→ Swap-out activity
```

This makes `vmstat` useful for observing whether swapping is actively occurring over time.

## `free` and `vmstat`

```text
free
→ Current memory summary

vmstat
→ Memory and swap activity over time
```

Both views can be useful during troubleshooting.

## Inspect Kernel Memory Information

Display the beginning of `/proc/meminfo`.

```bash
head /proc/meminfo
```

The output can include:

```text
MemTotal
MemFree
MemAvailable
Buffers
Cached
SwapCached
Active
Inactive
```

`/proc/meminfo` provides detailed memory information exposed by the kernel.

## Inspect Process Memory with `top`

Start the interactive process monitor.

```bash
top
```

Important process-memory columns include:

```text
VIRT
→ Virtual memory associated with the process

RES
→ Resident memory currently held in physical memory

SHR
→ Shared memory associated with the process
```

A large `VIRT` value does not mean that the same amount of physical RAM is currently resident.

## Virtual and Resident Memory

```text
Process
   |
   +-- VIRT
   |    |
   |    └-- Virtual address-space view
   |
   +-- RES
        |
        └-- Resident physical-memory view
```

Understanding the distinction is important when analyzing process memory usage.

## Inspect a Process Memory Map

Use `pmap` with a process ID.

The current shell PID is available through:

```text
$$
```

Inspect the current shell.

```bash
pmap $$
```

The output can show mappings such as:

```text
Executable code
Shared libraries
Anonymous memory
Stack
Locale data
Other mapped regions
```

This provides a more detailed view of how a process uses its virtual address space.

## Memory Inspection Workflow

```text
Memory Problem
     |
     v
Inspect Overall Memory
     |
     v
free
     |
     v
Observe Activity
     |
     v
vmstat
     |
     v
Identify Memory-Heavy Processes
     |
     v
top
     |
     v
Inspect a Specific Process
     |
     v
pmap
```

## Swap Overview

The course introduces swap as an additional memory-management area.

The main swap forms practiced in the course are:

```text
Device Swap
File Swap
```

The course also lists:

```text
Pseudo Swap
```

but does not provide a detailed implementation exercise for it.

## Device Swap

Device swap uses a dedicated block device or partition.

Conceptually:

```text
Disk
 |
 v
Partition
 |
 v
Swap Space
```

Example course structure:

```text
/dev/sda5
```

Device names in the course are examples only.

Always identify a disposable lab partition before creating swap.

## File Swap

File swap uses a regular file as swap space.

Conceptually:

```text
Existing Filesystem
       |
       v
    Swap File
       |
       v
    Swap Space
```

The course example uses:

```text
/var/tmp/swapfile
```

## Swap Management Tools

Important swap-management components include:

```text
mkswap
→ Initialize swap space

swapon
→ Activate swap

swapoff
→ Deactivate swap

/etc/fstab
→ Persistent swap configuration

free
→ Inspect swap usage

top
→ Inspect memory state

/proc/sys/vm/swappiness
→ Kernel swap-behavior parameter
```

## Inspect Current Swap

Display memory and swap usage.

```bash
free -m
```

Display currently active swap areas using the course command.

```bash
swapon -s
```

The output can include:

```text
Filename
Type
Size
Used
Priority
```

Do not fabricate the values in documentation.

Record the output from the actual lab system.

## Inspect Swappiness

Display the current swappiness setting.

```bash
cat /proc/sys/vm/swappiness
```

The course CentOS 7 example displays:

```text
30
```

The course describes this value as controlling swapping sensitivity.

The value should not be interpreted as a direct percentage threshold for when swapping begins.

Record the actual value from the current Rocky Linux VM.

## Device Swap Safety

Creating swap on a block device changes its storage contents.

Before continuing, inspect block devices.

```bash
lsblk
```

Use only a dedicated disposable partition.

The following placeholder represents the intended lab partition:

```text
/dev/sdX1
```

Replace it only after identifying the correct device.

Do not use an operating-system, filesystem, LVM, or RAID partition that contains required data.

## Create Device Swap

Initialize the disposable partition as swap space.

```bash
mkswap /dev/sdX1
```

This prepares the partition for swap use.

It does not activate the swap yet.

## Activate Device Swap

Activate it.

```bash
swapon /dev/sdX1
```

Verify:

```bash
swapon -s
```

Also check:

```bash
free -m
```

The workflow is:

```text
Disposable Partition
       |
       v
mkswap
       |
       v
Swap Format
       |
       v
swapon
       |
       v
Active Swap
```

## Inspect Swap Device Information

Inspect block-device identifiers.

```bash
blkid
```

Swap space can have information such as:

```text
UUID
TYPE
```

The exact values must come from the actual VM.

## Persistent Device Swap

The course configures persistent swap through `/etc/fstab`.

Course-style entry:

```text
/dev/sdX1 swap swap defaults 0 0
```

The fields represent:

```text
Device
Swap target
Swap filesystem type
Options
Dump field
Check field
```

Use the real disposable device identified in the lab.

Do not copy `/dev/sda5` from the lecture blindly.

## Activate Swap Entries from `/etc/fstab`

The course uses:

```bash
swapon -a
```

This activates configured swap entries.

Verify the result afterward.

```bash
swapon -s
```

```bash
free -m
```

## Verify Storage State

Inspect block devices.

```bash
lsblk
```

Swap changes should be verified rather than assumed to have succeeded.

## Deactivate Device Swap

If the device swap is temporary, deactivate it before cleanup.

```bash
swapoff /dev/sdX1
```

Verify:

```bash
swapon -s
```

If a temporary `/etc/fstab` entry was added for the lab, remove that entry before disposing of the test partition.

## Create a Swap File

The course creates a 100 MiB swap file using `dd`.

For the lab, use a clearly named temporary file.

```bash
dd if=/dev/zero of=/var/tmp/swapfile-lab bs=1M count=100
```

Command components:

```text
if=/dev/zero
→ Input source containing zero bytes

of=/var/tmp/swapfile-lab
→ Output file

bs=1M
→ One MiB per block

count=100
→ Write one hundred blocks
```

This creates a file of approximately 100 MiB.

## Inspect the Swap File

Check its size and permissions.

```bash
ls -lh /var/tmp/swapfile-lab
```

The lecture demonstrates that a file with permissions such as `0644` produces an insecure-permissions warning when used for swap.

## Restrict Swap File Permissions

Set owner-only read/write permission.

```bash
chmod 600 /var/tmp/swapfile-lab
```

Verify:

```bash
ls -l /var/tmp/swapfile-lab
```

Expected permission structure:

```text
-rw-------
```

Restricting the file is appropriate because swap can contain process-memory data.

## Initialize the Swap File

Prepare the file as swap space.

```bash
mkswap /var/tmp/swapfile-lab
```

The command can display information such as:

```text
Swap-space version
Size
UUID
```

Record only actual values from the lab environment.

## Activate the Swap File

Enable it.

```bash
swapon /var/tmp/swapfile-lab
```

Verify:

```bash
swapon -s
```

A system using both device and file swap can display different types.

Conceptually:

```text
Filename                 Type

/dev/...                 partition
/var/tmp/swapfile-lab    file
```

## Verify Total Swap

Check memory and swap information again.

```bash
free -m
```

Compare the swap total before and after activating the new swap area.

## Swap Priority

`swapon -s` can display a `Priority` field.

This value is associated with the priority of multiple active swap areas.

The course displays the field but does not require priority configuration in this lab.

## Deactivate the Swap File

After the lab:

```bash
swapoff /var/tmp/swapfile-lab
```

Verify:

```bash
swapon -s
```

## Remove the Temporary Swap File

After confirming that the swap file is inactive:

```bash
rm -f /var/tmp/swapfile-lab
```

Do not remove a file while it is still being used as active swap.

## Device Swap and File Swap Comparison

```text
Device Swap
-------------------------
Uses a block device or partition
Initialized with mkswap
Activated with swapon


File Swap
-------------------------
Uses a regular file
File must be created first
Permissions should be restricted
Initialized with mkswap
Activated with swapon
```

Both follow the same fundamental activation model:

```text
Prepare Storage
      |
      v
mkswap
      |
      v
swapon
      |
      v
Verify
```

## Swap Lifecycle

```text
Create or Select Swap Storage
          |
          v
        mkswap
          |
          v
        swapon
          |
          v
  free / swapon -s
          |
          v
       swapoff
```

Persistent swap additionally involves:

```text
/etc/fstab
```

## Memory Troubleshooting Workflow

When investigating a memory problem:

```text
Memory Issue
     |
     v
free -m
     |
     v
Check Available Memory and Swap
     |
     v
vmstat
     |
     v
Check Swap-In / Swap-Out Activity
     |
     v
top
     |
     v
Identify High-Memory Processes
     |
     v
pmap PID
     |
     v
Inspect Process Memory Map
```

## Swap Troubleshooting Workflow

```text
Swap Problem
     |
     v
Check Current Swap
     |
     v
swapon -s
     |
     v
Check Memory State
     |
     v
free -m
     |
     v
Verify Swap Device or File
     |
     v
Check mkswap / swapon State
     |
     v
Check Persistent Configuration
     |
     v
/etc/fstab
     |
     v
Verify Again
```

## Verification Checklist

- Memory hardware information was inspected with `dmidecode`.
- Virtual memory and swap concepts were reviewed.
- System memory usage was inspected with `free`.
- Memory and swap activity were inspected with `vmstat`.
- `/proc/meminfo` was inspected.
- Process memory was inspected with `top`.
- `VIRT` and `RES` were distinguished.
- A process memory map was inspected with `pmap`.
- Current swap areas were inspected.
- The current swappiness value was inspected.
- Device swap and file swap were distinguished.
- `mkswap` and `swapon` responsibilities were distinguished.
- A disposable device-swap workflow was reviewed or practiced.
- Persistent swap configuration through `/etc/fstab` was reviewed.
- A swap file was created using `dd`.
- Swap-file permissions were restricted to `0600`.
- The swap file was initialized and activated.
- Device and file swap types were compared through swap-status output.
- Temporary swap was deactivated with `swapoff`.
- Changes were explicitly verified after activation and deactivation.

## What I Learned

- Linux memory can be inspected at hardware, system, and process levels.
- `dmidecode` can expose memory-related DMI information.
- `free` provides a summary of physical memory and swap usage.
- `available` memory is useful when evaluating current memory capacity.
- `vmstat` can show swap-in and swap-out activity over time.
- `/proc/meminfo` exposes detailed memory statistics from the kernel.
- `top` provides process-level memory information.
- `VIRT` and `RES` describe different aspects of process memory.
- `pmap` displays the memory mappings of a specific process.
- Swap can be implemented with a dedicated device or a regular file.
- `mkswap` prepares storage as swap space.
- `swapon` activates swap and `swapoff` deactivates it.
- `/etc/fstab` can define swap that should be activated persistently.
- `swappiness` is a kernel parameter associated with swap behavior.
- Swap-file permissions should be restricted because the file can contain process-memory data.
- A memory problem should be investigated using both current capacity and actual swap activity rather than a single memory value.
