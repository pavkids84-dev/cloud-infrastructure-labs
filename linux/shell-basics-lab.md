# Linux Shell Basics Lab

## Objective

Practice basic Linux shell operations including standard input and output, redirection, file descriptors, filename expansion, pipelines, and aliases.

## Environment

- OS: Rocky Linux
- Virtualization: VMware
- Shell: Bash

## Shell Overview

The shell provides an interface between the user and the operating system.

```text
User
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

The shell interprets commands, executes programs, and provides a user working environment.

## Create the Lab Directory

```bash
cd ~
mkdir shell-basic-lab
cd shell-basic-lab
pwd
```

## Standard Input, Output, and Error

Linux uses standard streams represented by file descriptors:

```text
0 = stdin  (standard input)
1 = stdout (standard output)
2 = stderr (standard error)
```

## Redirect Standard Output

Redirect command output to a file.

```bash
ls /etc > etc-list.txt
cat etc-list.txt
```

The `>` operator redirects standard output and overwrites the destination file.

## Append Standard Output

Append new output to an existing file.

```bash
date >> etc-list.txt
tail etc-list.txt
```

The `>>` operator appends output without replacing the existing contents.

## Separate Standard Output and Standard Error

Run a command that produces both normal output and an error.

```bash
ls /etc /not-exist 1> output.txt 2> error.txt
```

Verify the results.

```bash
cat output.txt
cat error.txt
```

- `1>` redirects standard output.
- `2>` redirects standard error.

## Combine Standard Output and Standard Error

Redirect both output streams to the same file.

```bash
ls /etc /not-exist > combined.txt 2>&1
cat combined.txt
```

`2>&1` redirects standard error to the same destination currently used by standard output.

## Filename Expansion

Create test files.

```bash
touch file1 file2 file3 test1.txt test2.txt
```

Use the `*` wildcard.

```bash
ls file*
ls *.txt
```

Use the `?` wildcard.

```bash
ls file?
```

Use a character set.

```bash
ls [ft]*
```

Filename expansion is performed by the shell before the command is executed.

## Pipelines

Use a pipeline to send the output of one command to another command.

```bash
who | wc -l
```

The output of `who` becomes the input of `wc -l`.

Inspect processes related to SSH.

```bash
ps -ef | grep ssh
```

A pipeline connects the standard output of the command on the left to the standard input of the command on the right.

## Execute Multiple Commands

Use a semicolon to execute commands sequentially.

```bash
date ; uname -a ; whoami
```

Each command is executed in sequence.

## Aliases

Create a simple alias.

```bash
alias ll='ls -l'
ll
```

Create an alias that runs multiple commands.

```bash
alias sysinfo='uname -a; id; date'
sysinfo
```

Display currently defined aliases.

```bash
alias
```

Remove the alias.

```bash
unalias sysinfo
```

## Verification

Verify the following:

- Standard input, output, and error use file descriptors `0`, `1`, and `2`.
- `>` redirects standard output to a file.
- `>>` appends standard output to a file.
- `2>` redirects standard error separately from standard output.
- `2>&1` sends standard error to the same destination as standard output.
- `*`, `?`, and `[]` can be used for shell filename expansion.
- A pipeline connects the output of one command to the input of another.
- Multiple commands can be executed sequentially using `;`.
- Aliases can simplify frequently used commands.

## What I Learned

- The shell acts as an interface between the user and the Linux operating system.
- Linux commands communicate through standard input, standard output, and standard error streams.
- File descriptors allow standard output and error streams to be redirected independently.
- Redirection is useful for saving command results and error messages to files.
- Pipelines make it possible to combine small Linux utilities into more powerful command workflows.
- Filename expansion allows the shell to select files using wildcard patterns.
- Aliases can improve command-line efficiency by shortening frequently used commands.
- Understanding shell input and output handling is fundamental for Linux automation, logging, and troubleshooting.
