# Linux System Information Lab

## Objective

Inspect the operating system, kernel, CPU, memory, swap, and disk information of a Rocky Linux virtual machine.

## Environment

- OS: Rocky Linux
- Virtualization: VMware
- Shell: Bash

## System Architecture

A Linux system can be viewed as several layers:

```text
User
  |
  v
Application
  |
  v
Shell
  |
  v
Kernel
  |
  v
Hardware
```

The kernel manages system resources such as CPU, memory, devices, processes, networking, and file systems.

## Kernel Information

Check the kernel release:

```bash
uname -r
```

Display detailed system and kernel information:

```bash
uname -a
```

## Distribution Information

Check the installed Linux distribution:

```bash
cat /etc/*release
```

This helps distinguish the Linux distribution version from the Linux kernel version.

## CPU Information

```bash
cat /proc/cpuinfo
```

Verify the CPU information recognized by the operating system.

## Memory Information

```bash
cat /proc/meminfo
```

Review values such as:

- `MemTotal`
- `MemFree`
- `MemAvailable`
- `SwapTotal`
- `SwapFree`

## Swap Information

```bash
swapon -s
```

Verify whether swap space is configured and active.

## Disk and Partition Information

```bash
cat /proc/diskstats
cat /proc/partitions
```

Use these files to inspect disk statistics and the partitions recognized by the kernel.

## Verification

Verify the following information from the Rocky Linux VM:

- Linux distribution
- Kernel release
- CPU information
- Total and available memory
- Swap configuration
- Disk and partition information

Compare the CPU and memory values reported by Linux with the resources assigned to the virtual machine in VMware.

## What I Learned

- The shell provides an interface between the user and the operating system.
- The kernel is the core component of the operating system and manages system resources.
- Linux organizes files and directories under a hierarchical file system starting from `/`.
- `/proc` provides access to kernel and system information through a file-like interface.
- `uname` can be used to inspect kernel and system information.
- Linux distribution information and kernel version are separate concepts.
- System resource inspection is a fundamental skill for Linux server administration and troubleshooting.
