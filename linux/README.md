# Linux Labs

This directory contains hands-on Linux administration labs completed while studying cloud infrastructure.

The goal is not only to learn Linux commands, but also to understand how Linux systems behave, verify concepts through hands-on practice, and develop troubleshooting skills relevant to cloud infrastructure operations.

## Environment

- OS: Rocky Linux
- Virtualization: VMware
- Shell: Bash
- Primary Access Method: SSH

## Topics Covered

- Linux system architecture
- Remote administration with SSH
- Kernel and system information
- File and directory management
- Absolute and relative paths
- File permissions
- Inodes
- Symbolic and hard links
- Shell input/output
- Standard streams and file descriptors
- Redirection and pipelines
- Standard output and standard error handling
- `/dev/null`
- Environment variables
- Shell initialization files
- Vi/Vim
- Shell scripting
- Command-line arguments
- File content searching with `grep`
- Basic regular expressions
- File and directory searching with `find`
- Archiving with `tar`
- Compression with `gzip` and `bzip2`
- Process and job management
- Foreground and background execution
- Process monitoring and states
- Linux signals and process control
- systemd service management
- Service runtime state
- Boot-time service configuration
- Service dependencies
- Basic service troubleshooting
- RPM package management
- DNF package management
- Package inspection and verification
- Software repositories
- Package dependencies

## Labs

### SSH Remote Administration

[SSH Basic Lab](./ssh-basic-lab.md)

Topics:

- SSH client and `sshd`
- Remote login
- User identity
- UID, GID, and group information
- Basic remote administration workflow

---

### Linux System Information

[Linux System Information Lab](./system-information-lab.md)

Topics:

- Linux kernel information
- Distribution information
- CPU information
- Memory and swap
- Disk and partition information
- `/proc` system information

---

### Files, Directories, Links, and Permissions

[Linux File, Directory, Link, and Permission Lab](./file-directory-permission-lab.md)

Topics:

- Absolute and relative paths
- File and directory operations
- File creation, copying, moving, and removal
- Symbolic links
- Hard links
- Inodes
- Owner, Group, and Other permissions
- Symbolic permission modes
- Octal permission modes
- `chmod`

---

### Shell Basics

[Linux Shell Basics Lab](./shell-basics-lab.md)

Topics:

- Shell command processing
- Standard input
- Standard output
- Standard error
- File descriptors
- Output redirection
- Error redirection
- `2>&1`
- Redirection order
- `/dev/null`
- Pipelines
- Filename expansion
- Aliases

---

### Shell Environment

[Linux Shell Environment Lab](./shell-environment-lab.md)

Topics:

- `/etc/profile`
- `~/.bash_profile`
- `~/.bashrc`
- Environment variables
- `HOME`
- `PATH`
- Variable inheritance
- `export`
- Shell quoting
- Command substitution

---

### Vi/Vim

[Linux Vi Basic Lab](./vi-basic-lab.md)

Topics:

- Command Mode
- Insert Mode
- Last Line Mode
- Cursor movement
- Text editing
- Search and replacement
- Copy and paste
- Save and exit operations
- `.vimrc`

---

### Shell Scripting

[Linux Shell Script Basics](./shell-script/README.md)

Topics:

- Shell script structure
- Shebang
- Comments
- Execute permissions
- Script debugging
- Conditional command execution
- `&&` and `||`
- Positional parameters
- Command-line arguments
- `shift`

Example scripts:

- [`basic.sh`](./shell-script/basic.sh)
- [`args.sh`](./shell-script/args.sh)
- [`shift.sh`](./shell-script/shift.sh)

---

### Search, Archive, and Compression

[Linux Search, Archive, and Compression Lab](./search-archive-compression-lab.md)

Topics:

- File content searching with `grep`
- `grep` options
- Basic regular expressions
- Beginning and end-of-line matching
- File and directory searching with `find`
- Search conditions
- File type filtering
- File ownership and modification-time searches
- Archive creation with `tar`
- Archive inspection and extraction
- Compression with `gzip`
- Compression with `bzip2`

---

### Process Management

[Linux Process Management Lab](./process-management-lab.md)

Topics:

- Processes, daemons, and shell jobs
- Foreground and background execution
- Job IDs and process IDs
- Job control with `jobs`, `fg`, and `bg`
- Process monitoring with `ps`
- Linux process states
- Real-time monitoring with `top`
- Process lookup with `pgrep`
- Process relationships with `pstree`
- Linux signals
- Process termination with `kill`

---

### Service Management

[Linux Service Management Lab](./service-management-lab.md)

Topics:

- systemd and `systemctl`
- Service status inspection
- Active and inactive runtime states
- Enabled and disabled boot-time states
- Service start and stop
- Service restart and reload
- Boot-time service configuration
- Service dependencies
- Service mask and unmask
- Basic service troubleshooting
- systemd journal inspection

---

### Package Management

[Linux Package Management Lab](./package-management-lab.md)

Topics:

- RPM packages
- Installed package inspection
- Package file lists
- Configuration and documentation files
- RPM package verification
- DNF package management
- Package searching
- Package installation and removal
- Package updates
- Dependency management
- Software repositories
- Repository inspection
- Package and service management workflow

## Key Concepts

### Linux System Layers

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

The shell provides an interface between the user and the operating system, while the kernel manages system resources such as CPU, memory, processes, devices, networking, and file systems.

### Linux File System

Linux uses a hierarchical file system starting from the root directory:

```text
/
├── etc
├── home
├── usr
├── var
├── opt
└── ...
```

### Standard Streams

```text
0 = stdin
1 = stdout
2 = stderr
```

Understanding standard streams and file descriptors is important for command pipelines, logging, automation, and troubleshooting.

Common redirection patterns include:

```text
command > file
→ stdout to file

command 2> file
→ stderr to file

command > file 2>&1
→ stdout and stderr to the same file

command 2> /dev/null
→ discard stderr

command > /dev/null 2>&1
→ discard stdout and stderr
```

Redirection order matters because shell redirections are processed from left to right.

### File Search vs Content Search

```text
find
→ Locate files and directories

grep
→ Search text inside files or command output
```

These tools are commonly used together when investigating Linux systems.

### Archive vs Compression

```text
tar
→ Combine files and directories into an archive

gzip / bzip2
→ Compress files
```

Archiving and compression are related but separate operations.

### Process and Job Management

```text
Program
   |
   v
Process
```

A process is a program currently executing in memory.

A shell job can run in different states:

```text
Foreground
Background
Stopped
```

The shell manages jobs using job IDs, while the operating system identifies processes using process IDs (PIDs).

### Common Process States

```text
R = Running or Runnable
S = Interruptible Sleep
D = Uninterruptible Sleep
I = Idle Kernel Thread
T = Stopped
Z = Zombie
```

Process states help identify whether a process is actively running, waiting, idle, stopped, or waiting for its parent process to collect its exit status.

### Linux Signals

```text
1  = SIGHUP
2  = SIGINT
9  = SIGKILL
15 = SIGTERM
```

Signals provide a mechanism for controlling running processes.

`SIGTERM` requests a normal termination, while `SIGKILL` forces a process to terminate.

### Service Management

Linux services are commonly managed through systemd.

```text
Administrator
      |
      | systemctl
      v
   systemd
      |
      v
   Service
      |
      v
   Process
```

Runtime state and boot-time configuration are separate concepts.

```text
active / inactive
→ Current runtime state

enabled / disabled
→ Boot-time configuration
```

The difference between service commands is important:

```text
start
→ Start the service now

stop
→ Stop the service now

restart
→ Stop and start the service again

reload
→ Reload supported service configuration

enable
→ Configure automatic startup during boot

disable
→ Remove automatic startup configuration

mask
→ Prevent the service from being started
```

### Package Management

Red Hat-based Linux distributions use RPM packages and package managers such as DNF.

```text
Repository
    |
    v
   DNF
    |
    v
RPM Package
    |
    v
Installed Software
```

RPM and DNF serve related but different purposes.

```text
RPM
→ Direct package inspection and management

DNF
→ Repository-based package and dependency management
```

Package installation and service execution are separate operations.

```text
Install Package
      |
      v
Configure Software
      |
      v
Start Service
      |
      v
Enable at Boot
      |
      v
Verify
```

Understanding this distinction is important when configuring and troubleshooting Linux servers.

## Practical Focus

The Linux labs in this directory follow a hands-on learning workflow:

```text
Understand the Concept
        |
        v
Execute Commands
        |
        v
Verify the Result
        |
        v
Understand System Behavior
        |
        v
Apply the Knowledge to Troubleshooting
```

The goal is to move beyond command memorization and develop practical Linux administration skills.

## Troubleshooting Approach

When investigating Linux system problems, I focus on identifying the problem, inspecting the relevant system state, determining the root cause, applying a solution, and verifying the result.

```text
Problem
   |
   v
Investigation
   |
   v
Root Cause
   |
   v
Resolution
   |
   v
Verification
   |
   v
Lesson Learned
```

Linux troubleshooting may involve several system layers:

```text
Software Problem
      |
      v
Package Installed?
      |
      v
Repository Available?
      |
      v
Configuration Correct?
      |
      v
Service Running?
      |
      v
Process Healthy?
      |
      v
Logs / System State
      |
      v
Root Cause
```

As more practical issues are encountered, dedicated troubleshooting records will be added to the repository.

## What I Am Building Toward

These Linux fundamentals provide the foundation for:

- Linux server administration
- Cloud infrastructure operations
- Infrastructure troubleshooting
- Shell automation
- Docker and container environments
- Kubernetes administration
- Infrastructure as Code
- Cloud security

Additional labs will be added as Linux administration topics become more advanced.
