# Linux

This directory contains hands-on Linux administration labs completed while studying cloud infrastructure.

The goal is not only to learn Linux commands, but also to understand how Linux systems behave, verify concepts through hands-on practice, and build troubleshooting skills relevant to cloud infrastructure operations.

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
- File permissions and ownership concepts
- Symbolic and hard links
- Shell input/output and pipelines
- Environment variables and shell initialization
- Vi/Vim basics
- Shell scripting and command-line arguments

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
- Symbolic links
- Hard links
- Inodes
- Owner, Group, and Other permissions
- Symbolic and octal permission modes
- `chmod`

---

### Shell Basics

[Linux Shell Basics Lab](./shell-basics-lab.md)

Topics:

- Standard input, output, and error
- File descriptors
- Output redirection
- Error redirection
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
- Text editing
- Search and replacement
- Copy and paste
- File save and exit operations
- `.vimrc`

---

### Shell Scripting

[Linux Shell Script Basics](./shell-script/README.md)

Topics:

- Shell script structure
- Shebang
- Script permissions
- Script debugging
- Conditional command execution
- Positional parameters
- Command-line arguments
- `shift`

Example scripts:

- [`basic.sh`](./shell-script/basic.sh)
- [`args.sh`](./shell-script/args.sh)
- [`shift.sh`](./shell-script/shift.sh)

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

The shell provides an interface for users and applications, while the kernel manages system resources such as CPU, memory, processes, devices, networking, and file systems.

### Linux File Structure

Linux uses a hierarchical file system starting from the root directory:

```text
/
├── etc
├── home
├── usr
├── var
└── ...
```

### Standard Streams

```text
0 = stdin
1 = stdout
2 = stderr
```

Understanding standard streams and file descriptors is important for command pipelines, logging, automation, and troubleshooting.

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

As the course progresses, this directory will continue to include hands-on labs and practical Linux automation examples.
