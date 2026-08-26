# Linux Shell Basics Lab

## Objective

Practice basic Linux shell operations including standard input and output, redirection, file descriptors, filename expansion, pipelines, aliases, and commonly used output-handling patterns.

## Environment

- OS: Rocky Linux
- Virtualization: VMware
- Shell: Bash
- Access Method: SSH

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

Move to the home directory and create a dedicated lab directory.

```bash
cd ~
mkdir shell-basic-lab
cd shell-basic-lab
pwd
```

## Standard Input, Output, and Error

Linux processes use three standard streams represented by file descriptors.

```text
0 = stdin  (standard input)
1 = stdout (standard output)
2 = stderr (standard error)
```

These streams make it possible to control where input comes from and where normal output and error messages are sent.

## Redirect Standard Output

Redirect the output of a command to a file.

```bash
ls /etc > etc-list.txt
```

Verify the result.

```bash
cat etc-list.txt
```

The `>` operator redirects standard output and overwrites the destination file.

The following two commands are equivalent because standard output uses file descriptor `1`.

```bash
ls /etc > output.txt
```

```bash
ls /etc 1> output.txt
```

## Append Standard Output

Append new output to an existing file.

```bash
date >> etc-list.txt
```

Verify the result.

```bash
tail etc-list.txt
```

The `>>` operator appends output without replacing the existing contents.

The difference is:

```text
>   = overwrite
>>  = append
```

## Redirect Standard Input

The `<` operator redirects a file to the standard input of a command.

General form:

```bash
command < input.txt
```

The input flow changes from:

```text
Keyboard
   |
   v
Command
```

to:

```text
File
 |
 v
Command
```

## Redirect Standard Error

Redirect only error messages to a file.

```bash
ls /not-exist 2> error.txt
```

Verify the error output.

```bash
cat error.txt
```

Here:

```text
2 = stderr
```

The standard error stream is written to `error.txt`.

## Separate Standard Output and Standard Error

Run a command that produces both normal output and an error.

```bash
ls /etc /not-exist 1> output.txt 2> error.txt
```

Verify each file.

```bash
cat output.txt
```

```bash
cat error.txt
```

The output flow is:

```text
stdout → output.txt
stderr → error.txt
```

This makes it possible to store normal command results and error messages separately.

## Combine Standard Output and Standard Error

Redirect standard output to a file and then redirect standard error to the same destination.

```bash
ls /etc /not-exist > combined.txt 2>&1
```

Verify the result.

```bash
cat combined.txt
```

The flow is:

```text
stdout ──┐
         ├──> combined.txt
stderr ──┘
```

`2>&1` means:

```text
Send file descriptor 2 (stderr)
to the same destination currently used by
file descriptor 1 (stdout).
```

This pattern is commonly used when both normal output and error messages need to be stored in the same log file.

## Redirection Order Matters

Redirection operators are processed from left to right.

This command:

```bash
command > output.log 2>&1
```

means:

```text
1. Redirect stdout to output.log
2. Redirect stderr to the current stdout destination
```

Result:

```text
stdout → output.log
stderr → output.log
```

However, this command is different:

```bash
command 2>&1 > output.log
```

It means:

```text
1. Redirect stderr to the current stdout destination
2. Redirect stdout to output.log
```

Result:

```text
stdout → output.log
stderr → Terminal
```

Therefore, when both standard output and standard error should be stored in the same file, the commonly used form is:

```bash
command > output.log 2>&1
```

## Redirect Output to /dev/null

`/dev/null` is a special Linux device that discards anything written to it.

It is useful when command output is not needed.

Discard standard output:

```bash
command > /dev/null
```

Example:

```bash
ls /etc > /dev/null
```

The command still runs, but its normal output is discarded.

The flow is:

```text
stdout → /dev/null
stderr → Terminal
```

## Discard Only Error Messages

Redirect only standard error to `/dev/null`.

```bash
command 2> /dev/null
```

A practical example is searching the entire file system.

```bash
find / -name "*.conf" 2> /dev/null
```

Without error redirection, `find /` may display permission errors for directories that the current user cannot access.

With:

```bash
2> /dev/null
```

normal search results remain visible while error messages are discarded.

The flow is:

```text
stdout → Terminal
stderr → /dev/null
```

## Discard Both Standard Output and Standard Error

Discard both normal output and error messages.

```bash
command > /dev/null 2>&1
```

The flow is:

```text
stdout ──┐
         ├──> /dev/null
stderr ──┘
```

Example:

```bash
some-command > /dev/null 2>&1
```

This is useful when only the command's execution result matters and no output needs to be displayed or stored.

## Bash Shorthand for stdout and stderr

Bash also provides a shorthand for redirecting both standard output and standard error.

```bash
command &> output.log
```

Example:

```bash
ls /etc /not-exist &> combined.log
```

Both streams are written to `combined.log`.

To discard both streams:

```bash
command &> /dev/null
```

This syntax is Bash-specific.

## Common Redirection Patterns

```text
command > file
stdout → file

command >> file
stdout → append to file

command 2> file
stderr → file

command > file 2>&1
stdout + stderr → file

command > /dev/null
stdout → discarded

command 2> /dev/null
stderr → discarded

command > /dev/null 2>&1
stdout + stderr → discarded
```

## Practical Redirection Examples

Save both normal output and errors to a log file.

```bash
./script.sh > script.log 2>&1
```

Append both normal output and errors to an existing log.

```bash
./script.sh >> script.log 2>&1
```

Hide permission errors while searching the file system.

```bash
find / -name "nginx.conf" 2> /dev/null
```

Run a command silently.

```bash
some-command > /dev/null 2>&1
```

## Filename Expansion

Create test files.

```bash
touch file1 file2 file3 test1.txt test2.txt
```

Use the `*` wildcard.

```bash
ls file*
```

```bash
ls *.txt
```

The `*` wildcard can match zero or more characters.

Use the `?` wildcard.

```bash
ls file?
```

The `?` wildcard matches exactly one character.

Use a character set.

```bash
ls [ft]*
```

This matches file names beginning with either `f` or `t`.

Filename expansion is performed by the shell before the command is executed.

## Pipelines

A pipeline sends the standard output of one command to the standard input of another command.

```bash
who | wc -l
```

The flow is:

```text
who
 |
 | stdout
 v
Pipe
 |
 | stdin
 v
wc -l
```

The output of `who` becomes the input of `wc -l`.

Inspect processes related to SSH.

```bash
ps -ef | grep ssh
```

The flow is:

```text
ps -ef
   |
   | process list
   v
grep ssh
   |
   v
matching lines
```

Pipelines allow multiple small Linux commands to be combined into more useful command workflows.

## Redirection vs Pipeline

Redirection sends command output to or from a file or device.

```bash
ls > files.txt
```

Flow:

```text
Command
   |
   v
File
```

A pipeline connects one command to another command.

```bash
ls | more
```

Flow:

```text
Command A
    |
    v
Command B
```

The key difference is:

```text
Redirection
→ connects commands with files or devices

Pipeline
→ connects commands with other commands
```

## Execute Multiple Commands

Use a semicolon to execute commands sequentially.

```bash
date ; uname -a ; whoami
```

Each command runs in sequence.

The next command is executed regardless of whether the previous command succeeds or fails.

## Aliases

Create a simple alias.

```bash
alias ll='ls -l'
```

Run the alias.

```bash
ll
```

Create an alias that executes multiple commands.

```bash
alias sysinfo='uname -a; id; date'
```

Run it.

```bash
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

Aliases can make frequently used commands shorter and easier to execute.

## Verification

Verify the following:

- The shell provides an interface between the user and the operating system.
- Standard input uses file descriptor `0`.
- Standard output uses file descriptor `1`.
- Standard error uses file descriptor `2`.
- `>` redirects standard output and overwrites the destination file.
- `>>` appends standard output to an existing file.
- `<` redirects a file to standard input.
- `2>` redirects standard error.
- Standard output and standard error can be redirected independently.
- `2>&1` redirects standard error to the current standard output destination.
- Redirection operators are processed from left to right.
- `/dev/null` discards data written to it.
- `2> /dev/null` discards only standard error.
- `> /dev/null 2>&1` discards both standard output and standard error.
- Bash supports `&>` as a shorthand for redirecting both output streams.
- `*`, `?`, and `[]` can be used for shell filename expansion.
- A pipeline connects the standard output of one command to the standard input of another.
- Multiple commands can be executed sequentially using `;`.
- Aliases can simplify frequently used commands.

## What I Learned

- The shell acts as an interface between the user and the Linux operating system.
- Linux commands communicate through standard input, standard output, and standard error streams.
- File descriptors make it possible to redirect standard output and error streams independently.
- `2>&1` is commonly used to combine normal output and error messages.
- Redirection order matters because redirection operations are processed from left to right.
- `/dev/null` is a special device used to intentionally discard command output.
- Redirecting only standard error to `/dev/null` is useful when expected permission errors would otherwise make command output difficult to read.
- Pipelines make it possible to combine small Linux utilities into more powerful command workflows.
- Filename expansion allows the shell to select files using wildcard patterns.
- Aliases can improve command-line efficiency by shortening frequently used commands.
- Understanding shell input and output handling is fundamental for Linux logging, automation, shell scripting, and troubleshooting.
