# Linux Shell Script Basics

## Objective

Practice the basic structure of Linux shell scripts, including shebangs, comments, execution permissions, conditional command operators, positional parameters, and the `shift` command.

## Environment

- OS: Rocky Linux
- Virtualization: VMware
- Shell: Bash / POSIX-compatible shell
- Script Extension: `.sh`

## Shell Script Structure

A shell script is a text file containing shell commands and comments.

Example:

```bash
#!/bin/sh

# Display files in the current directory.
ls -l
```

The first line defines the shell interpreter used to execute the script.

## Script Execution

Create a script:

```bash
vi basic.sh
```

Add execute permission:

```bash
chmod u+x basic.sh
```

Execute the script:

```bash
./basic.sh
```

## Basic System Information Script

File:

```text
basic.sh
```

The script displays basic information about the current Linux environment.

```bash
#!/bin/sh

# Display basic Linux system information.

echo "Current user: $(whoami)"
echo "Hostname: $(hostname)"
echo "Current directory: $(pwd)"
```

## Conditional Command Execution

The `&&` operator executes the second command only when the first command succeeds.

```bash
mkdir test-dir && echo "Directory creation succeeded"
```

The `||` operator executes the second command when the first command fails.

```bash
mkdir test-dir || echo "Directory creation failed"
```

The operators can be summarized as follows:

```text
command1 ; command2
Run command2 regardless of whether command1 succeeds or fails.

command1 && command2
Run command2 only if command1 succeeds.

command1 || command2
Run command2 only if command1 fails.
```

## Positional Parameters

Shell scripts can receive arguments from the command line.

Example:

```bash
./args.sh Rocky Linux
```

The positional parameters are:

```text
$0 = script name
$1 = first argument
$2 = second argument
$# = number of arguments
$@ = all arguments
$* = all arguments
```

## Argument Script

File:

```text
args.sh
```

```bash
#!/bin/sh

# Display command-line arguments passed to this script.

echo "Script name: $0"
echo "First argument: $1"
echo "Second argument: $2"
echo "Argument count: $#"
echo "All arguments: $@"
```

Run the script:

```bash
chmod u+x args.sh
./args.sh Rocky Linux
```

## Shift Command

The `shift` command moves positional parameters one position to the left.

Before `shift`:

```text
$1 = one
$2 = two
$3 = three
```

After one `shift`:

```text
$1 = two
$2 = three
```

## Shift Script

File:

```text
shift.sh
```

```bash
#!/bin/sh

# Demonstrate how the shift command changes positional parameters.

echo "Before shift"
echo "First argument: $1"
echo "Second argument: $2"

shift

echo "After shift"
echo "First argument: $1"
echo "Second argument: $2"
```

Run the script:

```bash
chmod u+x shift.sh
./shift.sh one two three
```

## Debugging

The `-x` option can be used to trace commands while a shell script is running.

```bash
sh -x basic.sh
```

This helps identify how commands and variables are interpreted during execution.

## Verification

Verify the following:

- A shell script can contain multiple Linux commands.
- `#!` defines the interpreter used to execute the script.
- `#` is used to write comments.
- Execute permission can be added with `chmod`.
- `&&` executes the next command after a successful command.
- `||` executes the next command after a failed command.
- `$0` contains the script name.
- `$1`, `$2`, and other positional parameters contain command-line arguments.
- `$#` contains the number of arguments.
- `$@` represents all command-line arguments.
- `shift` moves positional parameters to the left.
- `sh -x` can be used to trace script execution.

## What I Learned

- Shell scripts can automate repetitive Linux command-line tasks.
- A shebang specifies which shell interpreter should execute a script.
- Linux file permissions determine whether a script can be executed directly.
- Conditional operators can control whether commands are executed based on the success or failure of previous commands.
- Positional parameters allow scripts to receive input from users or other processes.
- The `shift` command makes it possible to process positional arguments sequentially.
- Debug tracing is useful for identifying problems in shell scripts.
- Shell scripting provides a foundation for Linux automation and infrastructure operations.
