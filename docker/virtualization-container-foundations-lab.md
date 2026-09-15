# Virtualization and Container Foundations Lab

## Objective

Understand the infrastructure concepts that lead from traditional virtualization to container-based application execution.

This lab covers hypervisors, QEMU, KVM, libvirt, full and paravirtualization, virtual disk formats, VM migration, and the architectural differences between virtual machines and containers.

The goal is to establish the foundation required to understand Docker and later container orchestration technologies.

## Scope

```text
Emulation
Virtualization
Hypervisors
Type 1
Type 2
QEMU
KVM
Full Virtualization
Paravirtualization
libvirt
virsh
virt-manager
VM Cloning
RAW
QCOW2
Copy-on-Write
Snapshots
VM Migration
Virtual Machines
Containers
Namespaces
cgroups
```

---

# Emulation

Emulation can reproduce hardware or CPU behavior in software.

Conceptually:

```text
Guest Instruction
       ↓
Emulator
       ↓
Host-Compatible Operation
       ↓
Host CPU
```

An emulator can support a guest architecture different from the host architecture.

This flexibility can introduce more overhead than directly using hardware virtualization.

---

# Virtualization

Virtualization allows physical resources to be shared by multiple isolated virtual machines.

```text
Physical CPU
Physical Memory
Physical Storage
Physical Network
        ↓
Virtualization Layer
        ↓
VM 1
VM 2
VM 3
```

The goal is to divide and manage physical infrastructure resources efficiently.

---

# Emulation vs Virtualization

A simplified distinction is:

```text
Emulation
→ Can reproduce a different hardware architecture

Virtualization
→ Shares and virtualizes underlying hardware resources
```

The exact implementation can combine both techniques.

---

# QEMU

QEMU is an open-source machine emulator and virtualizer.

It can emulate:

```text
CPU architectures
Storage devices
Network devices
Video devices
USB
PCI
Serial devices
```

QEMU can be used independently for emulation or together with hardware virtualization technologies such as KVM.

---

# QEMU and KVM

QEMU and KVM perform different roles.

```text
QEMU
→ Virtual hardware and device emulation
```

```text
KVM
→ Linux kernel hardware virtualization support
```

A common architecture is:

```text
Guest VM
    ↓
QEMU
    ↓
KVM
    ↓
Linux Kernel
    ↓
Hardware Virtualization Extensions
    ↓
Physical Hardware
```

---

# `qemu-img`

`qemu-img` manages virtual disk images used by QEMU-based virtualization environments.

Relevant concepts include:

```text
Create
Inspect
Convert
Resize
Snapshot-related operations
```

Virtual disk formats such as RAW and QCOW2 can be managed with this tool.

---

# Hypervisor

A hypervisor manages virtual machines and mediates their use of hardware resources.

```text
Virtual Machines
       ↓
Hypervisor
       ↓
Physical Hardware
```

Traditional hypervisors are commonly classified as Type 1 or Type 2.

---

# Type 1 Hypervisor

Type 1 is also commonly called:

```text
Native Hypervisor
Bare-Metal Hypervisor
```

Conceptually:

```text
VM
VM
VM
 ↓
Hypervisor
 ↓
Physical Hardware
```

Examples in the course include:

```text
VMware ESX / ESXi
XenServer
Microsoft Hyper-V
```

---

# Type 2 Hypervisor

Type 2 is commonly called:

```text
Hosted Hypervisor
```

Conceptually:

```text
Virtual Machines
       ↓
Hypervisor Application
       ↓
Host Operating System
       ↓
Physical Hardware
```

Examples in the course include:

```text
VMware Workstation
VirtualBox
```

---

# KVM Classification

KVM is implemented as Linux kernel modules and gives the Linux kernel virtualization capabilities.

A useful architecture model is:

```text
Guest
 ↓
QEMU
 ↓
KVM
 ↓
Linux Kernel
 ↓
Physical Hardware
```

KVM is commonly described as having Type 1 hypervisor characteristics.

Understanding the architecture is more useful than relying only on the Type 1 / Type 2 label.

---

# Full Virtualization

Full virtualization allows an unmodified guest operating system to execute in a virtual machine.

Conceptually:

```text
Guest OS
    ↓
Virtual Hardware
    ↓
Hypervisor
    ↓
Physical Hardware
```

The guest can behave as though it controls physical hardware even though the hypervisor mediates access.

---

# Hardware-Assisted Virtualization

Modern processors provide hardware virtualization extensions.

Examples introduced in the course include:

```text
Intel VT
AMD-V
```

These capabilities allow hypervisors to execute virtual machines more efficiently.

---

# Paravirtualization

Paravirtualization allows the guest operating system to cooperate with the hypervisor.

Conceptually:

```text
Guest OS
   ↓
Hypervisor-Aware Interface
   ↓
Hypervisor
   ↓
Hardware
```

Historically this could reduce virtualization overhead, but it required guest operating-system support or modification.

---

# Modern Virtualization Model

Modern virtualization can combine multiple techniques.

For example:

```text
Hardware-Assisted CPU Virtualization
+
Paravirtualized I/O Drivers
```

A virtual machine should therefore not always be interpreted as purely full virtualization or purely paravirtualization.

---

# Traditional Hosted Virtualization

A Type 2 architecture can be represented as:

```text
Guest Application
Guest OS
Virtual Devices
      ↓
Hosted Hypervisor
      ↓
Host OS
      ↓
Physical Drivers
      ↓
Hardware
```

The host operating system participates directly in hardware management.

---

# Xen Architecture

The course presents Xen as a Type 1 hypervisor.

Conceptually:

```text
Guest VM
Guest VM
    ↓
Xen Hypervisor
    ↓
Physical Hardware
```

A privileged management domain can provide VM-management and device-related functionality for other guests.

---

# VMware ESXi Architecture

The course presents VMware ESXi as a bare-metal virtualization platform.

```text
Virtual Machines
       ↓
VMware Hypervisor
       ↓
Physical Hardware
```

This differs from VMware Workstation, which is a hosted virtualization product.

---

# KVM Architecture

KVM extends the Linux kernel with virtualization capabilities.

Linux continues to provide infrastructure functions such as:

```text
Scheduling
Memory Management
Device Drivers
Process Management
```

while KVM provides virtual-machine execution support.

---

# libvirt

libvirt provides a virtualization-management abstraction layer.

```text
Management Tool
      ↓
libvirt
      ↓
Hypervisor
```

The course shows management tools such as:

```text
virsh
virt-manager
OpenStack
oVirt
```

using libvirt to interact with virtualization technologies.

---

# `virsh`

`virsh` is a command-line virtualization-management tool commonly used with libvirt.

Conceptually:

```text
Administrator
     ↓
virsh
     ↓
libvirt
     ↓
KVM / QEMU
```

---

# `virt-manager`

`virt-manager` provides graphical virtual-machine management through libvirt.

The course also demonstrates VM cloning through this management layer.

The important concept is:

```text
Existing VM
    ↓
Clone
    ↓
New VM with similar configuration
```

---

# RAW Virtual Disk

RAW is a simple virtual-disk image format.

A simplified model is:

```text
Virtual Block Device
      ↓
RAW Image
```

RAW is structurally simple and can provide efficient I/O characteristics.

The allocation strategy is separate from the image-format concept itself.

---

# QCOW2

QCOW2 is a QEMU Copy-on-Write disk-image format.

Features discussed in the course include:

```text
Copy-on-Write
Snapshots
Compression
Encryption
Dynamic Allocation
```

The format contains metadata that enables these additional functions.

---

# Copy-on-Write

Copy-on-Write preserves an existing base while recording changed data separately.

```text
Base Data
   +
Changed Data
```

This concept will also be important when studying container image layers.

---

# Snapshot

A snapshot records a point-in-time state that can help with rollback and state management.

```text
Current VM State
      ↓
Snapshot
      ↓
Possible Rollback Point
```

A snapshot should not be treated as a replacement for an independent backup.

```text
Snapshot
→ Point-in-time state / rollback

Backup
→ Independent recoverable copy
```

A storage failure can affect both a VM and snapshots stored in the same failure domain.

---

# VM Migration

VM migration moves a virtual machine between virtualization hosts.

```text
Host A
   ↓
Virtual Machine
   ↓
Migration
   ↓
Host B
```

Migration can be performed using different methods depending on the virtualization platform.

---

# Live Migration

Live migration attempts to move a running VM while minimizing service interruption.

```text
Running VM
    ↓
Migration
    ↓
Another Host
```

Successful migration depends on compatible compute, storage, and networking infrastructure.

---

# Migration Infrastructure

The course introduces migration considerations such as:

```text
Multiple Virtualization Hosts
Compatible Host Environments
Storage Accessibility
Network Connectivity
Bridge / Network Compatibility
Mount and Directory Consistency
```

Storage examples in the course include:

```text
NFS
GFS2
iSCSI
Fibre Channel
```

Exact migration requirements depend on the virtualization platform.

---

# Migration Benefits

The course identifies migration benefits including:

```text
Load Balancing
Failover
Energy Saving
Geographic Migration
```

Migration can also support infrastructure maintenance by moving workloads away from a physical host.

---

# Virtual Machine Architecture

A virtual machine typically has its own guest kernel.

```text
Application
OS Libraries
Guest Kernel
Virtual Hardware
Hypervisor
Physical Hardware
```

Each VM can maintain an operating-system environment independent from other VMs.

---

# Container Architecture

Containers use operating-system-level isolation and normally share the host kernel.

```text
Container A
Application
Libraries

Container B
Application
Libraries

Container C
Application
Libraries

        ↓
Shared Host Kernel
        ↓
Physical Hardware
```

This architectural difference allows containers to avoid running a complete guest kernel for every application instance.

---

# VM vs Container

| Area | Virtual Machine | Container |
|---|---|---|
| Virtualization Level | Hardware | OS / Process |
| Kernel | Separate guest kernel | Shared host kernel |
| Guest OS | Full guest environment | Application environment |
| Density | Lower | Higher |
| Startup | Generally heavier | Generally lighter |
| Isolation | VM boundary | Namespace/process boundary |
| Resource Control | Hypervisor | Kernel mechanisms |

The technologies solve different infrastructure problems and are often used together.

---

# Namespace

Linux namespaces isolate what a process can see.

Examples include:

```text
PID Namespace
→ Process IDs

Network Namespace
→ Network stack

Mount Namespace
→ Filesystem mounts

UTS Namespace
→ Hostname
```

Namespaces are fundamental to Linux container isolation.

---

# cgroups

cgroups stands for:

```text
Control Groups
```

They provide resource accounting and control.

Examples include:

```text
CPU
Memory
I/O
Process Resources
```

A useful distinction is:

```text
Namespaces
→ Isolation and visibility
```

```text
cgroups
→ Resource control
```

---

# VM and Container Together

Virtual machines and containers are not mutually exclusive.

A common infrastructure model is:

```text
Physical Server
      ↓
Virtual Machine
      ↓
Linux
      ↓
Container Runtime
      ↓
Containers
```

Cloud environments frequently run containers inside virtual machines.

---

# Architecture Summary

The key distinction is:

```text
Virtual Machine
→ Hardware Virtualization
→ Separate Guest Kernel
```

```text
Container
→ OS-Level Isolation
→ Shared Host Kernel
```

This distinction provides the foundation for understanding Docker.

---

# Verification Checklist

- Emulation and virtualization were distinguished.
- QEMU and KVM roles were distinguished.
- `qemu-img` was identified as a virtual disk image tool.
- Type 1 and Type 2 hypervisors were reviewed.
- KVM architecture was understood beyond a simple Type label.
- Full virtualization was reviewed.
- Paravirtualization was reviewed.
- Hardware-assisted virtualization was understood.
- Xen architecture was reviewed.
- VMware ESXi architecture was reviewed.
- libvirt was understood as a virtualization abstraction layer.
- `virsh` and `virt-manager` were identified as management tools.
- RAW and QCOW2 were distinguished.
- Copy-on-Write was understood.
- Snapshot was not treated as an independent backup.
- VM migration concepts were reviewed.
- Live migration was understood.
- VM and container kernel models were compared.
- Namespaces were connected to isolation.
- cgroups were connected to resource control.
- Virtual machines and containers were understood as technologies that can be used together.
- Course diagrams and example infrastructure values were not treated as runtime evidence.

---

# What I Learned

- Emulation can reproduce hardware behavior while virtualization partitions or virtualizes underlying resources.
- QEMU provides machine and device emulation, while KVM provides Linux kernel virtualization support.
- Hypervisors provide the execution environment for virtual machines.
- KVM integrates virtualization into the Linux kernel.
- libvirt provides a common management layer above virtualization technologies.
- QCOW2 provides Copy-on-Write features beyond a simple RAW disk image.
- Snapshots and backups solve different recovery problems.
- Migration depends on compute, storage, and network compatibility.
- Virtual machines generally contain separate guest kernels.
- Containers share the host kernel and isolate processes through Linux kernel features.
- Namespaces isolate views of system resources.
- cgroups control and account for resource consumption.
- Container technology is built on concepts that already exist in the Linux kernel.
