# Linux Labs

This directory contains hands-on Linux administration and shell programming labs completed while studying cloud infrastructure.

The goal is not only to learn Linux commands, but also to understand how Linux systems behave, verify concepts through hands-on practice, and develop troubleshooting and automation skills relevant to infrastructure operations.

## Environment

- OS: Rocky Linux
- Virtualization: VMware
- Shell: Bash
- Primary Access Method: SSH

## Topics Covered

### Linux Fundamentals

- Linux system architecture
- User space and kernel space
- Linux kernel information
- CPU, memory, swap, and disk information
- `/proc` system information

### Remote Administration

- SSH client and server
- `sshd`
- Remote login
- User identity
- UID, GID, and groups

### File System

- Absolute and relative paths
- File and directory management
- File types
- Symbolic links
- Hard links
- Inodes
- File permissions
- Owner, Group, and Other
- Symbolic and octal permission modes

### Shell Fundamentals

- Shell command processing
- Standard input
- Standard output
- Standard error
- File descriptors
- Redirection
- Pipelines
- Filename expansion
- Aliases
- Environment variables
- Shell initialization files
- Command substitution

### Shell Redirection

```text
0 = stdin
1 = stdout
2 = stderr
```

Common patterns:

```text
command > file
→ Redirect stdout

command >> file
→ Append stdout

command 2> file
→ Redirect stderr

command > file 2>&1
→ Redirect stdout and stderr to the same file

command 2> /dev/null
→ Discard stderr

command > /dev/null 2>&1
→ Discard both stdout and stderr
```

Redirection order matters because shell redirections are processed from left to right.

### Vi/Vim

- Command Mode
- Insert Mode
- Last Line Mode
- Cursor movement
- Text editing
- Search and replacement
- Copy and paste
- Save and exit operations
- `.vimrc`

### Shell Programming

- Shell script structure
- Shebang
- Script permissions
- Child shell execution
- Current shell execution with `source`
- Shell variable scope
- Environment variable inheritance
- Special shell variables
- Arithmetic expansion
- Parameter expansion
- String pattern removal
- Positional parameters
- `"$@"` and `"$*"`
- `shift`
- Exit status
- `if`, `elif`, and `else`
- Numeric comparison
- String comparison
- File tests
- Pattern matching
- `case`
- `exit`

### Search and Text Utilities

- `grep`
- Basic regular expressions
- `find`
- File search conditions

### Archive and Compression

- `tar`
- Archive creation
- Archive inspection
- Archive extraction
- `gzip`
- `bzip2`

### Process Management

- Processes
- Daemons
- Shell jobs
- Foreground execution
- Background execution
- Job control
- Process states
- Process monitoring
- Signals
- Process termination

### Service Management

- systemd
- `systemctl`
- Service runtime state
- Boot-time configuration
- Service dependencies
- Service masking
- Basic service troubleshooting

### Package Management

- RPM packages
- RPM package inspection
- DNF package management
- Package dependencies
- Software repositories
- Package installation and removal
- Package verification

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

### Shell Programming

[Linux Shell Programming Labs](./shell-script/README.md)

Topics:

- Basic shell scripts
- Shebang and script execution
- Child shell and current shell execution
- Variable scope
- Environment variable inheritance
- Special variables
- Arithmetic expansion
- Parameter expansion
- Positional parameters
- Command-line arguments
- `"$@"` and `"$*"`
- `shift`
- Input validation
- Conditional statements
- Numeric comparison
- File tests
- `case`
- Exit status

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

### Shell Command Processing

The shell does more than simply execute commands.

A simplified command-processing flow is:

```text
Read Command
     |
     v
Parse
     |
     v
Expansion and Substitution
     |
     v
Command Lookup
     |
     v
Execution
```

The shell can act as:

- A command-line interpreter
- A programming language
- A user working environment

### Shell Execution Scope

A shell script normally executes through a child shell or interpreter process.

```text
Parent Shell
     |
     v
Child Shell
     |
     v
Shell Script
```

Variables created only inside the child shell do not modify the parent shell.

Using:

```bash
source script.sh
```

or:

```bash
. script.sh
```

executes the script in the current shell.

### Shell Variables

```text
Local Shell Variable
→ Available in the current shell

Exported Environment Variable
→ Inherited by child processes
```

Example:

```bash
VAR="value"
export VAR
```

### Special Shell Variables

```text
$$
→ Current shell PID

$?
→ Exit status of the previous foreground command

$!
→ PID of the most recent background process
```

### Shell Arithmetic

Arithmetic operations can be performed using:

```bash
(( result = a + b ))
```

Common operators include:

```text
+
-
*
/
%
```

### Parameter Expansion

Useful parameter expansion forms include:

```text
${var:-word}
→ Use word if var is unset or null

${var:=word}
→ Use and assign word if var is unset or null

${var:?word}
→ Return an error if var is unset or null

${var:+word}
→ Use word when var has a value
```

String pattern removal:

```text
${var#pattern}
→ Remove shortest matching prefix

${var##pattern}
→ Remove longest matching prefix

${var%pattern}
→ Remove shortest matching suffix

${var%%pattern}
→ Remove longest matching suffix
```

### Positional Parameters

Shell scripts can receive command-line arguments.

```text
$0
→ Script name

$1
→ First argument

$2
→ Second argument

$#
→ Number of arguments

$@
→ All arguments

$*
→ All arguments
```

When quoted:

```text
"$@"
→ Preserves each argument separately

"$*"
→ Combines all arguments into one string
```

### Conditional Execution

Shell commands return an exit status.

```text
0
→ Success

non-zero
→ Failure
```

The `if` statement evaluates command success or failure.

```bash
if command
then
    ...
fi
```

Conditional expressions can inspect:

- Numeric values
- Strings
- File existence
- File types
- File permissions
- Patterns
- Command exit status

### File Tests

Common file tests include:

```text
-e
→ Exists

-f
→ Regular file

-d
→ Directory

-L
→ Symbolic link

-r
→ Readable

-w
→ Writable

-x
→ Executable
```

### Case Selection

`case` is useful when a value can match several predefined patterns.

```bash
case "$value" in
    pattern1)
        ...
        ;;
    pattern2)
        ...
        ;;
    *)
        ...
        ;;
esac
```

### File Search vs Content Search

```text
find
→ Locate files and directories

grep
→ Search text inside files or command output
```

These tools are commonly used together during Linux investigations.

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

A shell job can run in different states:

```text
Foreground
Background
Stopped
```

The shell manages jobs using job IDs, while the operating system identifies processes using process IDs.

### Common Process States

```text
R = Running or Runnable
S = Interruptible Sleep
D = Uninterruptible Sleep
I = Idle Kernel Thread
T = Stopped
Z = Zombie
```

### Linux Signals

```text
1  = SIGHUP
2  = SIGINT
9  = SIGKILL
15 = SIGTERM
```

`SIGTERM` requests a normal termination, while `SIGKILL` forces termination.

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

## Practical Focus

The labs follow a practical learning workflow.

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

The goal is to move beyond command memorization and develop practical Linux administration and automation skills.

## Troubleshooting Approach

Troubleshooting should be evidence-driven.

```text
Problem
   |
   v
Investigation
   |
   v
Evidence
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

Linux troubleshooting may involve several connected layers.

```text
Package
   |
   v
Configuration
   |
   v
Service
   |
   v
Process
   |
   v
Logs and System State
```

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

Additional labs will be added as Linux administration and shell programming topics become more advanced.
