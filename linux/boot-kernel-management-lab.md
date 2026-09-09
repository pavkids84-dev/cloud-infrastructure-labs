# Linux Boot and Kernel Management Lab

## Objective

Practice Linux boot-process inspection, GRUB2 configuration concepts, kernel inspection, kernel parameters, kernel modules, systemd targets, and system shutdown operations on Rocky Linux.

The goal of this lab is to understand the complete path from firmware initialization to a usable Linux system and to identify which boot layer should be investigated during troubleshooting.

## Environment

- OS: Rocky Linux
- Shell: Bash
- Bootloader: GRUB2
- Init System: systemd
- Kernel Management: grubby, sysctl, kmod utilities
- Privilege: root or sudo-enabled user

## Safety Notice

Bootloader, kernel, and recovery operations can prevent a system from booting normally if performed incorrectly.

Commands that modify:

```text
GRUB configuration
Default kernel
Kernel boot parameters
Root password
Kernel parameters
Kernel modules
Default systemd target
```

should be practiced only in a disposable virtual machine with console access and an available snapshot or recovery method.

Do not copy device names or kernel versions from course screenshots.

Always inspect the actual system first.

## Boot Process Overview

The Linux boot sequence introduced in the course is:

```text
Power On
    |
    v
Firmware
    |
    v
Bootloader
    |
    v
Linux Kernel and Initial Boot Environment
    |
    v
systemd
    |
    v
System Ready
```

The course separates the process conceptually into:

```text
Hardware Boot
     |
     +-- Firmware
     +-- Bootloader

Software Boot
     |
     +-- Linux Kernel
     +-- systemd
     +-- System Services
```

Understanding the stage at which a failure occurs helps narrow the troubleshooting scope.

## Firmware Concepts

The course introduces:

```text
BIOS
→ Basic Input/Output System

EFI / UEFI
→ Extensible Firmware Interface

NVRAM
→ Firmware-related persistent configuration storage

POST
→ Power On Self Test
```

Firmware runs before the operating system and prepares the system for loading a bootloader.

## Legacy BIOS and MBR

The course describes the traditional MBR layout as:

```text
MBR
≈ 512 bytes

Boot code
→ 446 bytes

Partition table
→ 64 bytes

Boot signature
→ 2 bytes
```

The lecture slide labels the final field as `masic NO.`, which should be understood as the MBR boot-signature or magic-number area.

A simplified legacy boot path is:

```text
Power On
   |
   v
BIOS
   |
   v
POST
   |
   v
MBR
   |
   v
Bootloader
```

## UEFI Boot Process

The course presents the UEFI flow as:

```text
UEFI Firmware
      |
      v
Read GPT Information
      |
      v
Locate EFI System Partition
      |
      v
Execute EFI Bootloader File
      |
      v
GRUB2
      |
      v
Linux Kernel
      |
      v
Linux OS
```

The EFI System Partition is shown as:

```text
ESP
Filesystem: FAT32
```

An EFI bootloader can appear as a file such as:

```text
grubx64.efi
```

## LBA and GPT

The lecture defines LBA as:

```text
Logical Block Addressing
→ Disk address system
```

GPT uses disk addresses to describe partition positions and sizes.

Conceptually:

```text
LBA
→ Where is the block?

GPT
→ Which blocks belong to each partition?
```

## Legacy BIOS/MBR and UEFI/GPT Comparison

```text
Legacy BIOS + MBR
------------------------------
Partition table: MBR
Bootloader location: MBR-related area
Bootloader form: Binary boot code
ESP: Not required
Disk-size support: More limited


UEFI + GPT
------------------------------
Partition table: GPT
Bootloader location: EFI System Partition
Bootloader form: EFI executable
ESP: Required in the course model
ESP filesystem: FAT32
Partition support: Much larger
GPT metadata: Includes backup structures
```

## Bootloader Overview

Bootloaders introduced in the course include:

```text
LILO
GRUB / GRUB2
EFILinux
U-Boot
```

This lab focuses on GRUB2.

## GRUB2 Responsibilities

The course describes GRUB2 as responsible for:

```text
Loading the Linux kernel into memory
Displaying boot entries
Allowing selection among operating systems or kernel versions
```

A simplified relationship is:

```text
Firmware
   |
   v
GRUB2
   |
   +-- Kernel A
   +-- Kernel B
   +-- Rescue Kernel
```

## Inspect GRUB Configuration Sources

Inspect the main GRUB defaults file.

```bash
cat /etc/default/grub
```

The course shows variables such as:

```text
GRUB_TIMEOUT
GRUB_DEFAULT
GRUB_TERMINAL_OUTPUT
GRUB_CMDLINE_LINUX
GRUB_ENABLE_BLSCFG
```

Inspect GRUB configuration scripts.

```bash
ls /etc/grub.d/
```

The course describes the primary generated GRUB configuration as:

```text
/boot/grub2/grub.cfg
```

The exact layout can depend on the installed Rocky Linux version and firmware mode.

## GRUB Configuration Relationship

Conceptually:

```text
/etc/default/grub
      +
/etc/grub.d/
      |
      v
grub2-mkconfig
      |
      v
Generated GRUB Configuration
```

The generated configuration should not be treated like an ordinary hand-maintained text file.

## Inspect GRUB Configuration Safely

Check whether the course path exists.

```bash
ls -l /boot/grub2/grub.cfg
```

Do not modify the file merely for inspection.

If a GRUB configuration change is intentionally practiced, first preserve a backup of the current lab configuration.

Example course workflow:

```bash
cp /boot/grub2/grub.cfg /boot/grub2/grub.cfg.bk
```

## Generate a GRUB Configuration

The course introduces:

```bash
grub2-mkconfig -o /boot/grub2/grub.cfg
```

This generates GRUB configuration based on the configured GRUB sources.

Only run the command when the current VM firmware mode and GRUB configuration path have been verified.

## GRUB2 Installation Concept

The lecture demonstrates:

```bash
grub2-install /dev/sda
```

as an MBR bootloader reinstall example.

This is a destructive boot-management operation and should not be executed during a basic inspection lab unless a disposable BIOS-mode VM has been prepared specifically for bootloader recovery.

The important course concept is:

```text
GRUB configuration generation
≠
GRUB bootloader installation
```

## Inspect the Running Kernel

Display the running kernel release.

```bash
uname -r
```

Display broader kernel and architecture information.

```bash
uname -a
```

These commands describe the kernel currently running in memory.

## Inspect the Default Boot Kernel

The course uses:

```bash
grubby --default-kernel
```

This identifies the kernel selected as the default boot kernel.

The running kernel and default boot kernel are different concepts.

```text
uname -r
→ Kernel currently running

grubby --default-kernel
→ Kernel selected for future default boot
```

They can differ after a kernel update before the system is rebooted.

## Inspect Installed Kernel Images

List kernel images in `/boot`.

```bash
ls -al /boot/vmlinuz*
```

The system can contain:

```text
Normal kernel images
Rescue kernel images
Multiple installed kernel versions
```

Do not record kernel versions from lecture screenshots as if they came from the current VM.

## Check for Kernel Updates

The course uses:

```bash
dnf check-update kernel
```

The result depends on the configured repositories and current package state.

Kernel installation or upgrades should be performed separately from this inspection lab unless specifically intended.

## Default Kernel Change Concept

The course introduces `grubby` for changing the default kernel.

Before any modification:

```bash
grubby --default-kernel
```

and:

```bash
ls -al /boot/vmlinuz*
```

should be used to identify the real kernel paths.

Do not set a default kernel path that has not been verified on the current VM.

## Root Password Recovery Concept

The course introduces two boot-time root-password recovery methods.

These exercises require:

```text
Direct VM console access
GRUB menu access
Administrative authorization
A disposable lab environment
```

They should not be used as ordinary password-management procedures.

Normal password changes should use `passwd` from an authenticated administrative session.

## Root Password Recovery Method 1

The first course workflow uses the GRUB editor and `rd.break`.

Conceptual sequence:

```text
GRUB Menu
    |
    v
Edit Kernel Entry
    |
    v
Add rd.break
    |
    v
Boot with Ctrl+X
    |
    v
Recovery Shell
```

The course then performs:

```bash
mount -o remount,rw /sysroot
```

and changes the root of the recovery environment:

```bash
chroot /sysroot
```

The installed system can then be administered from the recovery shell.

## SELinux Relabel Concept

The course uses:

```bash
touch /.autorelabel
```

after the password change.

The purpose of this step is to request SELinux relabeling when the system returns to normal boot.

This keeps password recovery connected to the system's SELinux labeling requirements rather than treating password-file modification as an isolated operation.

## Root Password Recovery Method 2

The second lecture workflow edits the boot parameters to use:

```text
init=/bin/bash
```

After booting into the shell, the lecture uses a writable root filesystem and finishes with:

```text
exec /sbin/init
```

The operational concept is that the normal init process is temporarily replaced by a recovery shell.

Password-recovery execution is intentionally not used as a routine step in this lab.

## Kernel Structure

The lecture separates kernel management into:

```text
Core Kernel
Dynamic Kernel Modules
Kernel Parameters
```

These should be treated as different layers.

## Core Kernel

Kernel images are stored under `/boot`.

Inspect them:

```bash
ls -al /boot/vmlinuz*
```

The selected kernel is loaded into memory during the boot process.

```text
GRUB2
   |
   v
Kernel Image
   |
   v
Memory
   |
   v
Running Kernel
```

## Kernel Modules

The course describes dynamically loadable kernel components under:

```text
/lib/modules/<kernel-release>/
```

Inspect the directory for the running kernel.

```bash
ls /lib/modules/"$(uname -r)"/
```

Inspect the kernel module hierarchy.

```bash
ls /lib/modules/"$(uname -r)"/kernel
```

Kernel modules allow functionality to be loaded or removed without rebuilding or rebooting the whole kernel in many cases.

## List Loaded Kernel Modules

Display currently loaded modules.

```bash
lsmod
```

Search for the bonding module.

```bash
lsmod | grep bonding
```

No output means the module was not found in the current loaded-module list.

## Load a Kernel Module

The course uses the bonding module as an example.

```bash
sudo modprobe bonding
```

Verify:

```bash
lsmod | grep bonding
```

Do not assume that every module is safe to load on every production system.

This lab uses a disposable VM.

## Inspect Kernel Module Information

Inspect the bonding module.

```bash
modinfo bonding
```

Information can include:

```text
filename
author
description
license
alias
dependencies
module name
kernel version information
signature information
module parameters
```

The exact output depends on the installed kernel.

## Remove a Kernel Module

The course demonstrates:

```bash
sudo modprobe -r bonding
```

Verify:

```bash
lsmod | grep bonding
```

This demonstrates the basic module lifecycle:

```text
Module Exists
     |
     v
modprobe
     |
     v
Module Loaded
     |
     v
lsmod
     |
     v
modprobe -r
     |
     v
Module Removed
```

A module currently required by active hardware or another module may not be removable.

## Other Kernel Module Tools

The course also introduces:

```text
insmod
rmmod
depmod
```

Conceptually:

```text
insmod
→ Directly insert a module file

rmmod
→ Remove a loaded module

depmod
→ Generate module dependency information

modprobe
→ Load or remove modules while handling dependencies
```

## Kernel Module Configuration

The course introduces persistent module options under:

```text
/etc/modprobe.d/
```

Inspect configuration files.

```bash
ls /etc/modprobe.d/
```

The lecture example uses KVM nested-virtualization options such as:

```text
options kvm_intel nested=1
```

or:

```text
options kvm_amd nested=1
```

These examples demonstrate the concept of providing configuration to a module rather than requiring every option to be supplied manually when loading it.

Do not enable nested virtualization unless the VM and processor environment actually require it.

## Kernel Parameters

The course introduces kernel runtime parameters through:

```text
sysctl
/proc/sys/
/etc/sysctl.conf
```

A kernel parameter can be represented through both the `sysctl` name and `/proc/sys` hierarchy.

Example:

```text
net.ipv4.ip_forward
```

corresponds conceptually to:

```text
/proc/sys/net/ipv4/ip_forward
```

## Inspect a Kernel Parameter

Search for IP-forwarding parameters.

```bash
sysctl -a | grep ip_forward
```

Inspect the main IPv4 forwarding value directly.

```bash
cat /proc/sys/net/ipv4/ip_forward
```

Record the current VM's value instead of assuming it is enabled or disabled.

## Runtime Kernel Parameter Change

The course demonstrates changing a running kernel parameter with:

```bash
sysctl -w net.ipv4.ip_forward=1
```

This modifies the current runtime state.

The resulting value can be checked with:

```bash
sysctl net.ipv4.ip_forward
```

or:

```bash
cat /proc/sys/net/ipv4/ip_forward
```

Changing IP forwarding can affect network behavior, so make such changes only when required by the lab.

## Direct `/proc/sys` Parameter Interface

The lecture also demonstrates the direct kernel interface under:

```text
/proc/sys/
```

This shows that `sysctl` and `/proc/sys` expose the same type of kernel runtime state through different interfaces.

The lab should prefer `sysctl` for intentional administrative changes because the command clearly communicates the parameter being modified.

## Persistent Kernel Parameters

The course introduces:

```text
/etc/sysctl.conf
```

for persistent parameter configuration.

Inspect it:

```bash
cat /etc/sysctl.conf
```

Do not append duplicate test settings to a working system unless the lab intentionally needs a persistent change.

## Load Persistent sysctl Configuration

The course uses:

```bash
sysctl -p
```

to load configuration.

Conceptually:

```text
Runtime Configuration
---------------------
sysctl -w
/proc/sys


Persistent Configuration
------------------------
/etc/sysctl.conf
        |
        v
sysctl -p
```

The distinction between runtime state and persistent configuration is fundamental to Linux administration.

## Kernel Management Layers

```text
Kernel Image
     |
     | /boot/vmlinuz-*
     v
Boot-Time Kernel


Kernel Parameters
     |
     | sysctl
     | /proc/sys
     | /etc/sysctl.conf
     v
Kernel Runtime Behavior


Kernel Modules
     |
     | /lib/modules
     | lsmod
     | modprobe
     | modinfo
     v
Dynamic Kernel Functionality
```

These layers should not be confused during troubleshooting.

## systemd Overview

The course describes systemd as replacing the traditional init system and automating system-process startup.

The boot relationship is:

```text
Kernel
   |
   v
systemd
   |
   v
Targets and Units
   |
   v
Services
   |
   v
System Ready
```

## Inspect PID 1

Inspect PID 1.

```bash
ps -p 1 -f
```

On a systemd-based Rocky Linux system, PID 1 should identify systemd.

Do not fabricate the process output.

## Inspect Boot Messages

The course introduces:

```text
/var/log/boot.log
dmesg
```

Inspect the boot log when available.

```bash
sudo less /var/log/boot.log
```

Inspect kernel messages.

```bash
dmesg | less
```

These are useful evidence sources when troubleshooting boot problems.

## systemd Targets and Traditional Runlevels

The course maps traditional runlevels to systemd targets.

```text
Traditional    systemd
-----------    -----------------
S              emergency.target
1              rescue.target
3              multi-user.target
5              graphical.target
```

Modern systemd administration should focus primarily on target names.

The numeric runlevels are useful for understanding historical compatibility.

## Inspect Target Dependencies

The course uses:

```bash
systemctl list-dependencies graphical.target
```

The output shows the units and targets required by the graphical target.

A filtered form from the lecture is:

```bash
systemctl list-dependencies graphical.target | grep target
```

## Inspect the Current Default Target

Use:

```bash
systemctl get-default
```

This identifies the target selected for future normal boots.

## Change the Current Target

The course introduces:

```bash
systemctl isolate multi-user.target
```

This changes the current system state toward the selected target.

`isolate` can stop units that are not required by the target.

Do not practice this over a remote session that depends on services which might be stopped.

## Change the Default Boot Target

The course introduces:

```bash
systemctl set-default graphical.target
```

This changes the future default boot target.

The distinction is:

```text
systemctl isolate TARGET
→ Current runtime target change

systemctl set-default TARGET
→ Future default boot target change
```

## System Shutdown

The course introduces the `shutdown` command.

Inspect available options.

```bash
shutdown --help
```

Options shown in the lecture include concepts such as:

```text
halt
poweroff
reboot
warning-only mode
cancel a pending shutdown
```

## Immediate Shutdown Concept

The course example is:

```bash
shutdown -h now
```

Do not execute shutdown commands if the VM session must remain available.

## Scheduled Reboot Concept

The course example schedules a reboot after two minutes and supplies a user message.

Conceptually:

```text
shutdown
     |
     +-- Action: reboot
     +-- Time: +2 minutes
     +-- Wall message
```

This demonstrates that shutdown operations can be scheduled rather than always executed immediately.

## Cancel a Pending Shutdown

The `shutdown` help shown in the course includes cancellation support.

A pending shutdown can therefore be treated as a scheduled administrative action that can be canceled before execution.

## Boot Troubleshooting Model

A boot failure should be localized by layer.

```text
System Does Not Boot
        |
        v
Does Firmware Start?
        |
        v
Does GRUB Appear?
        |
        v
Is a Kernel Entry Available?
        |
        v
Does the Kernel Load?
        |
        v
Check Kernel Messages
        |
        v
Does systemd Start?
        |
        v
Which Target or Unit Failed?
```

This prevents treating every boot failure as the same problem.

## Verification Checklist

- The complete Linux boot sequence was reviewed.
- BIOS and UEFI boot concepts were distinguished.
- MBR and GPT boot structures were compared.
- The role of the EFI System Partition was understood.
- GRUB2's role in loading the kernel was understood.
- GRUB configuration sources were inspected.
- The generated GRUB configuration path was inspected.
- The difference between GRUB installation and GRUB configuration generation was understood.
- The running kernel was inspected.
- The default boot kernel was inspected.
- Installed kernel images were inspected.
- Root-password recovery concepts were reviewed in a disposable-console context.
- Core kernel, kernel parameters, and kernel modules were distinguished.
- Loaded kernel modules were inspected.
- A disposable module load/remove workflow was practiced or reviewed.
- Kernel module information was inspected with `modinfo`.
- Kernel module configuration under `/etc/modprobe.d/` was reviewed.
- Kernel parameters were inspected with `sysctl`.
- Runtime and persistent kernel parameter configuration were distinguished.
- PID 1 was inspected.
- Kernel and boot logs were identified.
- Traditional runlevels were mapped to systemd targets.
- Current and default target concepts were distinguished.
- Target dependencies were inspected.
- Shutdown and reboot concepts were reviewed.
- Boot troubleshooting was organized by system layer.

## What I Learned

- Linux booting is a sequence of firmware, bootloader, kernel, and user-space initialization stages.
- BIOS/MBR and UEFI/GPT use different boot structures.
- UEFI loads boot files from an EFI System Partition.
- GRUB2 loads the Linux kernel and can provide multiple boot entries.
- GRUB source configuration and the generated GRUB configuration are different concepts.
- The running kernel and the default future boot kernel can differ.
- Linux kernel images are stored under `/boot`.
- Boot-time administrative recovery can be performed through GRUB in an authorized console environment.
- Kernel images, kernel parameters, and kernel modules are separate management layers.
- `sysctl` exposes and modifies kernel parameters.
- `/proc/sys` exposes kernel runtime parameters through a filesystem-style interface.
- `/etc/sysctl.conf` is used by the course for persistent kernel parameter configuration.
- `lsmod` shows loaded kernel modules.
- `modinfo` displays module information.
- `modprobe` loads or removes modules and handles dependencies.
- Module configuration can be stored under `/etc/modprobe.d/`.
- systemd runs as the primary user-space initialization system on Rocky Linux.
- systemd targets provide modern system operating-state definitions.
- `isolate` changes the current target, while `set-default` changes the default target used for future boots.
- Boot troubleshooting should first identify whether the failure is in firmware, GRUB, kernel, systemd, or a service rather than immediately changing configuration.
