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

## Practical Focus

The Linux labs in this directory focus on:

```text
Understand the concept
        |
        v
Execute commands
        |
        v
Verify the result
        |
        v
Understand system behavior
        |
        v
Apply the knowledge to troubleshooting
```

The goal is to move beyond command memorization and develop practical Linux administration skills.

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
