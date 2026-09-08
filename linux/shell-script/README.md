# Bash Shell Script Labs

Hands-on Bash scripting exercises for Linux system administration.

These scripts were created to practice shell syntax, arguments, variables, conditions, loops, file processing, functions, process handling, and service-related logic.

The goal is to move from simple command execution to reusable administration scripts.

## Environment

- OS: Rocky Linux
- Shell: Bash
- Script Type: Bash Shell Script
- Primary Goal: Linux Administration Automation

## Learning Progression

```text
Basic Script
     |
     v
Variables and Expansion
     |
     v
Arguments
     |
     v
Conditions
     |
     v
File Tests
     |
     v
Loops
     |
     v
Input Processing
     |
     v
Functions
     |
     v
Process and Service Logic
```

## Script Index

### 1. `basic.sh`

Basic Bash script structure.

Topics:

- Shebang
- Command execution
- Basic output
- Script execution

Example execution:

```bash
bash basic.sh
```

or, when execute permission is configured:

```bash
./basic.sh
```

---

### 2. `variables-and-expansion.sh`

Practice Bash variables and parameter expansion.

Topics:

- Shell variables
- Variable assignment
- Variable references
- Quoting
- Parameter expansion
- Default values
- Variable substitution

Concepts include forms such as:

```text
${variable}
${variable:-word}
${variable:=word}
${variable#pattern}
${variable##pattern}
${variable%pattern}
${variable%%pattern}
```

---

### 3. `args.sh`

Practice positional parameters.

Topics:

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
```

Example:

```bash
./args.sh one two three
```

---

### 4. `argument-for.sh`

Process command-line arguments with a `for` loop.

Topics:

- `for`
- Positional arguments
- `"$@"`
- Iterating through arguments

Conceptual flow:

```text
Arguments
    |
    v
"$@"
    |
    v
for Loop
    |
    v
Process Each Argument
```

---

### 5. `argument-loop.sh`

Practice repeated processing of script arguments.

Topics:

- Argument iteration
- Loop control
- Positional parameters
- Repeated command execution

---

### 6. `shift.sh`

Practice changing positional parameters with `shift`.

Example concept:

```text
Before shift

$1 = first
$2 = second
$3 = third


After shift

$1 = second
$2 = third
```

This is useful when the first argument represents an action and the remaining arguments represent targets.

---

### 7. `compare-numbers.sh`

Practice numeric conditions.

Topics:

- Numeric comparison
- `if`
- `elif`
- `else`
- Conditional evaluation

The script demonstrates branching based on numeric values.

---

### 8. `file-check.sh`

Practice filesystem test operators.

Topics include checking whether a path:

```text
Exists
Is a regular file
Is a directory
Is readable
Is writable
Is executable
```

File tests are useful for input validation before a script performs an operation.

---

### 9. `execution-scope.sh`

Practice shell execution scope and parent/child process behavior.

Topics:

- Current shell
- Child shell
- Shell variables
- Environment variables
- `export`
- Process scope

Conceptually:

```text
Parent Shell
     |
     +-- Shell Variable
     |
     +-- Exported Environment Variable
              |
              v
          Child Process
```

A normal shell variable is not automatically inherited by a child process.

An exported environment variable can be inherited.

---

### 10. `process-arguments.sh`

Practice using script arguments for process-related operations.

Topics:

- Process names as arguments
- Argument validation
- Multiple targets
- Process inspection
- Loop-based processing

The script connects Bash argument handling with Linux process management.

---

### 11. `service-action.sh`

Practice selecting service-related actions.

Topics:

- Action argument
- `case`
- Service name argument
- Conditional command execution
- Exit status

A simplified command structure is:

```text
script ACTION SERVICE
```

This demonstrates how administration scripts can use an action-oriented interface.

---

### 12. `read-lines.sh`

Practice reading input line by line.

Topics:

- `while`
- `read`
- Input redirection
- Line-based processing

General pattern:

```bash
while read line
do
    ...
done < file
```

This is useful when targets or configuration values are stored in files rather than hard-coded in the script.

---

### 13. `function-basics.sh`

Practice Bash functions.

Topics:

- Function definition
- Function calls
- Function arguments
- Return status
- Reusable logic

Conceptually:

```text
Main Script
   |
   +-- Function A
   |
   +-- Function B
   |
   +-- Function C
```

Functions help separate responsibilities inside larger administration scripts.

## Bash Argument Concepts

Positional parameters are fundamental to reusable shell scripts.

```text
$0
→ Script name

$1
→ First positional argument

$2
→ Second positional argument

$#
→ Number of positional arguments

"$@"
→ Each argument preserved separately

"$*"
→ All arguments represented together according to shell expansion rules
```

## Exit Status

Linux commands return an exit status.

```text
0
→ Success

non-zero
→ Failure or another non-success condition
```

The status of the most recently executed command is available through:

```bash
echo $?
```

This allows scripts to make decisions based on command results.

Conceptually:

```text
Run Command
     |
     v
Check Exit Status
     |
     +---------+
     |         |
     v         v
    0        non-zero
 Success      Failure
```

## Conditional Statements

Bash supports conditional execution.

General structure:

```bash
if condition
then
    command
elif condition
then
    command
else
    command
fi
```

Conditions can be based on:

```text
Numeric comparison
String comparison
File tests
Command exit status
```

## `case`

`case` is useful when a script accepts predefined actions.

General structure:

```bash
case "$action" in
    start)
        ...
        ;;
    stop)
        ...
        ;;
    status)
        ...
        ;;
    *)
        ...
        ;;
esac
```

This is useful for command interfaces such as:

```text
script start service
script stop service
script status service
```

## Loop Concepts

### `for`

Useful when iterating through a known list or script arguments.

```bash
for item in "$@"
do
    ...
done
```

### `while`

Useful while a condition remains true or when reading data line by line.

```bash
while read line
do
    ...
done < file
```

### `until`

Runs while a condition remains false and stops when the condition becomes true.

## `break` and `continue`

```text
break
→ Exit the current loop

continue
→ Skip the rest of the current iteration
```

## Input with `read`

`read` accepts input into shell variables.

Example form:

```bash
read value
```

It can also be used with input redirection to process files.

```text
File
 |
 v
while read
 |
 v
Process Each Line
```

## IFS

The Internal Field Separator affects how Bash splits input into fields.

It is especially relevant when reading structured text.

The correct separator depends on the input format being processed.

## Functions

Functions group related logic.

General form:

```bash
function_name()
{
    ...
}
```

Functions can receive their own positional parameters.

```text
$1
$2
$#
"$@"
```

inside a function refer to that function's arguments.

## Local Variables

Variables inside functions can be declared with:

```bash
local variable
```

This limits the variable to the function scope and helps avoid unintended modification of variables used elsewhere in the script.

## Here Documents

A here document can provide multi-line input.

General structure:

```bash
cat <<EOF
line 1
line 2
line 3
EOF
```

This is useful for:

```text
Help messages
Multi-line text
Configuration templates
```

## Redirection

Important redirection concepts include:

```text
>
→ Write standard output to a file

>>
→ Append standard output to a file

2>
→ Redirect standard error

2>>
→ Append standard error
```

Standard output and standard error should be treated as separate streams when appropriate.

## Pipelines

A pipeline connects the standard output of one command to the standard input of another.

```bash
command1 | command2
```

Conceptually:

```text
command1
   |
   | stdout
   v
command2
```

This is useful with text-processing tools such as:

```text
grep
sed
awk
```

## Shell Symbols Depend on Context

The meaning of a shell symbol depends on where it appears.

Examples:

```text
#
→ Comment when used as shell syntax

$#
→ Number of positional arguments

${var#pattern}
→ Parameter expansion that removes a matching prefix
```

Another example:

```text
|
→ Shell pipeline

|
→ Alternation in some regular-expression contexts
```

Another:

```text
&
→ Run a shell command in the background

&
→ Represents matched text in a sed replacement expression
```

Symbols should therefore be interpreted according to their syntax context rather than memorized as having one universal meaning.

## Shell Variables and Environment Variables

A shell variable exists in the current shell.

```bash
NAME=value
```

An environment variable can be exported to child processes.

```bash
export NAME
```

Conceptually:

```text
Current Shell
     |
     +-- NAME=value
     |
     +-- export NAME
             |
             v
        Child Process
```

This distinction is important when a script requires values defined by its parent shell.

## Process-Related Special Parameters

Bash provides process-related special parameters.

```text
$$
→ PID of the current shell

$?
→ Exit status of the previous command

$!
→ PID of the most recent background process
```

Example background workflow:

```bash
sleep 3600 &
```

```bash
echo "$!"
```

This allows a script or administrator to capture the PID of a newly started background process.

## Script Execution

A script with execute permission can be run directly:

```bash
./script.sh
```

This requires the script file to have execute permission.

A script can also be passed to Bash:

```bash
bash script.sh
```

In this case, Bash is the executable and reads the script file as input.

This is why a readable script can be processed with:

```bash
bash script.sh
```

even when the script file itself does not have execute permission.

## Verification Approach

Shell scripts should validate their assumptions before performing operations.

Examples:

```text
Was an argument supplied?
Does the target file exist?
Is the file readable?
Does a command succeed?
Does the process exist?
Is the requested action supported?
```

A useful scripting workflow is:

```text
Input
  ↓
Validate
  ↓
Perform Action
  ↓
Check Exit Status
  ↓
Produce Output
```

## Script Development Principles

### Avoid Unnecessary Hard-Coding

When target values can come from arguments or files, avoid embedding them directly into logic.

Instead of:

```text
Fixed target inside the script
```

prefer:

```text
Argument
or
Input file
```

when the script is intended to be reusable.

### Validate Input

Do not assume that required arguments or files exist.

### Use Functions for Responsibilities

Separate different operations into functions when the script grows.

### Use Exit Status

Command results should be evaluated rather than assumed.

### Keep Output Meaningful

Successful and failed states should be distinguishable.

### Verify Scripts in the Actual Environment

Runtime information such as:

```text
PID
Service status
Process state
File paths
Command output
```

should be verified in the lab environment.

## What I Learned

- Bash scripts can turn repeated Linux operations into reusable workflows.
- Positional parameters allow scripts to accept external input.
- `"$@"` preserves multiple command-line arguments for iteration.
- `shift` changes the current positional-parameter list.
- Exit status allows scripts to react to command success or failure.
- Conditional statements control program flow.
- `case` is useful for action-oriented command interfaces.
- File-test operators allow scripts to validate filesystem conditions.
- `for`, `while`, and `until` provide different looping behaviors.
- `read` supports interactive input and line-based file processing.
- Functions separate responsibilities and improve script structure.
- `local` helps control function variable scope.
- Environment variables must be exported when they need to be inherited by child processes.
- Here documents are useful for multi-line output such as help messages.
- Standard output and standard error can be redirected separately.
- Pipelines connect commands through standard streams.
- Shell symbols can have different meanings depending on syntax context.
- Reusable administration scripts should validate input, avoid unnecessary hard-coding, and verify command results.
