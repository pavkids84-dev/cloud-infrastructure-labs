# Linux Shell Programming Labs

This directory contains hands-on Bash shell programming exercises.

The labs progress from basic script execution to variables, arguments, conditions, loops, input processing, and reusable functions.

The goal is to understand how Linux commands and Bash programming features can be combined to build reusable automation scripts.

## Environment

- OS: Rocky Linux
- Shell: Bash
- Editor: Vi/Vim

## Topics Covered

- Shell script structure
- Shebang
- Comments
- Execute permissions
- Script execution
- Child shells
- Current-shell execution with `source`
- Variable scope
- Environment variable inheritance
- Special shell variables
- Arithmetic expressions
- String pattern removal
- Parameter expansion
- Positional parameters
- Command-line arguments
- `"$@"` and `"$*"`
- `shift`
- Exit status
- Argument validation
- Numeric comparison
- String comparison
- File tests
- Conditional statements
- `if`
- `elif`
- `else`
- Pattern matching
- `case`
- `exit`
- `for`
- `while`
- `until`
- `break`
- `continue`
- `read`
- Input redirection
- `IFS`
- Here documents
- Bash functions
- Function arguments
- Local variables

## Script Execution

A shell script is a text file interpreted by a shell.

A Bash script commonly begins with:

```bash
#!/bin/bash
```

The shebang specifies the interpreter used when the script is executed directly.

Example:

```bash
chmod +x script.sh
./script.sh
```

## Script Execution Methods

```text
./script.sh
→ Execute the script directly
→ Execute permission required
→ Interpreter selected by the shebang

bash script.sh
→ Bash reads and executes the script
→ Script execute permission is not required

bash -x script.sh
→ Execute with Bash tracing enabled

source script.sh
or
. script.sh
→ Execute inside the current shell
```

## Shell Process Scope

Normal script execution uses a separate shell or interpreter process.

```text
Parent Shell
     |
     v
Child Shell
     |
     v
Script
```

Variables created in the child shell do not modify the parent shell.

Using `source` changes the behavior.

```text
Current Shell
     |
     v
source script.sh
     |
     v
Script executes in the same shell
```

This distinction is important when loading shell environment configuration.

## Variables and Environment

A variable created in the current shell is not automatically inherited by child processes.

```bash
VAR="value"
```

Exporting a variable makes it part of the environment inherited by child processes.

```bash
export VAR
```

```text
Parent Shell
     |
     | exported environment
     v
Child Process
```

Changes made by a child process do not directly modify the parent process environment.

## Special Variables

```text
$$
→ PID of the current shell

$?
→ Exit status of the previous foreground command

$!
→ PID of the most recent background process
```

Exit status convention:

```text
0
→ Success

non-zero
→ Failure
```

## Arithmetic Expressions

Bash supports integer arithmetic using double parentheses.

```bash
(( result = a + b ))
```

Common arithmetic operators:

```text
+
-
*
/
%
```

Example:

```bash
a=10
b=3

(( remainder = a % b ))

echo "$remainder"
```

## Parameter Expansion

Parameter expansion can provide default values and validate variables.

```text
${var:-word}
→ Use word if var is unset or null

${var-word}
→ Use word only if var is unset

${var:=word}
→ Use word and assign it if var is unset or null

${var:?word}
→ Return an error if var is unset or null

${var:+word}
→ Use word when var contains a value
```

## String Pattern Removal

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

Example:

```bash
path="/usr/bin/local/bin"

echo "${path##*/}"
```

Result:

```text
bin
```

## Positional Parameters

Arguments passed to a script are automatically assigned to positional parameters.

```bash
./script.sh first second
```

```text
$0
→ Script name

$1
→ first

$2
→ second

$#
→ Number of arguments

$@
→ All arguments

$*
→ All arguments
```

Arguments greater than nine use braces.

```text
${10}
${11}
${12}
```

## `"$@"` vs `"$*"`

Quoted forms behave differently.

```text
"$*"
→ Treats all positional parameters as one combined string

"$@"
→ Preserves each positional parameter as a separate argument
```

Example:

```bash
./script.sh "hello world" linux shell
```

With `"$*"`:

```text
hello world linux shell
```

With `"$@"`:

```text
hello world
linux
shell
```

For processing user-supplied arguments individually, `"$@"` preserves argument boundaries.

## `shift`

`shift` moves positional parameters to the left.

Before:

```text
$1 = one
$2 = two
$3 = three
```

After:

```bash
shift
```

```text
$1 = two
$2 = three
```

This allows scripts to process positional parameters sequentially.

## Conditional Execution

Shell conditions are based on command exit status.

```text
0
→ Success / True

non-zero
→ Failure / False
```

Basic structure:

```bash
if command
then
    ...
fi
```

Extended structure:

```bash
if condition
then
    ...
elif condition
then
    ...
else
    ...
fi
```

## Numeric Comparison

Arithmetic expressions can be used directly.

```bash
(( a > b ))
```

Traditional numeric test operators include:

```text
-eq
→ Equal

-ne
→ Not equal

-lt
→ Less than

-gt
→ Greater than

-le
→ Less than or equal

-ge
→ Greater than or equal
```

## String Comparison

Example:

```bash
if [[ "$name" == "linux" ]]
then
    echo "Match"
fi
```

Pattern matching can also be used.

```bash
if [[ "$name" == l* ]]
then
    echo "Starts with l"
fi
```

## File Tests

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

Example:

```bash
if [[ -f "$file" ]]
then
    echo "Regular file"
fi
```

## Case Statements

`case` is useful when a value can match several predefined options.

```bash
case "$value" in
    start)
        ...
        ;;
    stop)
        ...
        ;;
    *)
        ...
        ;;
esac
```

The `*` pattern is commonly used as the default case.

## Loop Fundamentals

### `for`

`for` processes a list of values one at a time.

```bash
for value in list
do
    echo "$value"
done
```

A common argument-processing pattern is:

```bash
for arg in "$@"
do
    echo "$arg"
done
```

### `while`

`while` repeats while its control condition is true.

```bash
while (( count <= 5 ))
do
    echo "$count"
    (( count = count + 1 ))
done
```

### `until`

`until` repeats until its control condition becomes true.

```bash
until (( count == 6 ))
do
    echo "$count"
    (( count = count + 1 ))
done
```

## Loop Flow Control

`break` exits the current loop.

```text
break
→ Stop the loop completely
```

`continue` skips the remaining commands in the current iteration.

```text
continue
→ Continue with the next iteration
```

## Reading Input

`read` stores standard input in variables.

```bash
read value
```

A file can be processed line by line.

```bash
while read line
do
    echo "$line"
done < file
```

This combines:

```text
Input Redirection
       |
       v
while
       |
       v
read
       |
       v
Line-by-Line Processing
```

## Internal Field Separator

`IFS` controls how the shell separates input fields.

Example:

```bash
IFS=":"
```

A colon-separated input line can then be divided into separate values.

## Sequential Argument Processing

Arguments can be consumed one at a time using `shift`.

```bash
while (( $# > 0 ))
do
    echo "$1"
    shift
done
```

The loop ends when no positional parameters remain.

## Here Documents

A here document provides multiple lines of standard input directly inside a script.

```bash
command <<EOF
input1
input2
input3
EOF
```

Conceptually:

```text
Script Text
    |
    | stdin
    v
Command
```

## Bash Functions

Functions group reusable shell commands.

Basic structure:

```bash
function_name()
{
    commands
}
```

Example:

```bash
show_hostname()
{
    hostname
}
```

Call the function:

```bash
show_hostname
```

## Function Arguments

Functions can receive positional parameters.

```bash
show_value()
{
    echo "$1"
}

show_value "linux"
```

Inside the function:

```text
$1
→ First function argument
```

Function positional parameters are used during the function call without replacing the script's original positional parameters.

## Local Function Variables

Function-specific variables can be declared with `local`.

```bash
show_info()
{
    local label="System Information"
    echo "$label"
}
```

This helps prevent function variables from unintentionally changing variables used elsewhere in the script.

## Lab Files

### `basic.sh`

Introduces the basic structure of a shell script.

Topics:

- Shebang
- Comments
- Basic commands
- Script execution

---

### `args.sh`

Introduces command-line arguments and positional parameters.

Topics:

- `$0`
- `$1`
- `$2`
- `$#`
- `$@`
- `$*`

---

### `shift.sh`

Introduces positional parameter shifting.

Topics:

- Positional parameters
- `shift`
- Sequential argument processing

---

### `execution-scope.sh`

Demonstrates variable scope between child-shell execution and current-shell execution.

Topics:

- Child shell
- Current shell
- Script PID
- Variable scope
- `source`

Example:

```bash
./execution-scope.sh
echo "$LAB_VAR"
```

Then:

```bash
source ./execution-scope.sh
echo "$LAB_VAR"
```

---

### `variables-and-expansion.sh`

Demonstrates variable and parameter expansion features.

Topics:

- Local variables
- Environment variables
- Special variables
- Arithmetic expressions
- String pattern removal
- Parameter expansion
- Default values

---

### `argument-loop.sh`

Demonstrates positional parameter behavior.

Topics:

- `$0`
- `$1`
- `$2`
- `$#`
- `"$*"`
- `"$@"`
- `shift`

Example:

```bash
./argument-loop.sh "hello world" linux shell
```

---

### `compare-numbers.sh`

Demonstrates argument validation and numeric conditional expressions.

Topics:

- Argument count validation
- `$#`
- Numeric comparison
- `if`
- `elif`
- `else`
- Usage messages
- Exit status

Example:

```bash
./compare-numbers.sh 10 5
```

---

### `file-check.sh`

Inspects a file or directory using shell file tests.

Topics:

- Argument validation
- File existence
- Regular files
- Directories
- Symbolic links
- Read permission
- Write permission
- Execute permission
- Exit status

Examples:

```bash
./file-check.sh /etc/passwd
```

```bash
./file-check.sh /etc
```

---

### `service-action.sh`

Demonstrates multi-option command processing with a `case` statement.

Topics:

- Argument validation
- `case`
- Pattern selection
- Default case
- Usage messages
- Exit status

Example:

```bash
./service-action.sh start
```

The script demonstrates input handling only and does not directly control system services.

---

### `argument-for.sh`

Processes command-line arguments with a `for` loop.

Topics:

- `for`
- `"$@"`
- Argument validation
- Exit status

Example:

```bash
./argument-for.sh "hello world" linux shell
```

---

### `read-lines.sh`

Processes a text file one line at a time.

Topics:

- File validation
- `while`
- `read`
- Input redirection
- Line-by-line processing

Example:

```bash
./read-lines.sh servers.txt
```

---

### `process-arguments.sh`

Processes positional parameters sequentially.

Topics:

- `while`
- `$#`
- `$1`
- `shift`
- Argument consumption

Example:

```bash
./process-arguments.sh one two three four
```

---

### `function-basics.sh`

Demonstrates reusable Bash functions.

Topics:

- Function declaration
- Function calls
- Function arguments
- Script argument scope
- Function argument scope
- Local variables
- Command substitution inside functions

Example:

```bash
./function-basics.sh script-value
```

## Running the Labs

Make scripts executable when direct execution is required.

```bash
chmod +x *.sh
```

Run a script:

```bash
./script-name.sh
```

Run with Bash tracing:

```bash
bash -x script-name.sh
```

Run inside the current shell when a lab specifically requires it:

```bash
source ./script-name.sh
```

## Verification Approach

Each shell programming lab follows a practical verification cycle.

```text
Write Script
    |
    v
Execute
    |
    v
Inspect Output
    |
    v
Inspect Exit Status
    |
    v
Modify Input
    |
    v
Compare Behavior
```

For troubleshooting:

```text
Problem
   |
   v
Check Input
   |
   v
Check Variables
   |
   v
Check Conditions
   |
   v
Check Loop State
   |
   v
Use bash -x
   |
   v
Identify Root Cause
   |
   v
Fix
   |
   v
Verify
```

## What I Have Learned

Through these labs, I have practiced how Bash can be used as both a command interpreter and a programming language.

Key lessons include:

- Shell scripts are interpreted rather than compiled.
- Scripts can execute through a child shell or inside the current shell.
- Variables have different scopes depending on how they are defined and exported.
- Child processes inherit exported environment variables but do not directly modify the parent environment.
- Special variables expose process and command execution information.
- Arithmetic expressions provide integer calculation and numeric conditions.
- Parameter expansion provides compact ways to manipulate and validate variables.
- Positional parameters allow scripts to accept reusable command-line input.
- `"$@"` preserves individual command-line arguments.
- `shift` enables sequential positional parameter processing.
- Exit status is fundamental to shell control flow.
- Conditional statements allow scripts to make decisions based on commands, values, files, and user input.
- `case` provides a clear structure for handling predefined options.
- `for` processes lists of values.
- `while` and `until` support condition-based repetition.
- `break` and `continue` control loop execution.
- `read` allows scripts to process standard input.
- Input redirection allows files to be processed line by line.
- Here documents provide multi-line input inside scripts.
- Functions reduce repeated code and organize scripts into reusable units.
- Function arguments and local variables provide controlled data handling inside reusable logic.

These fundamentals provide the basis for more advanced Linux automation and infrastructure operations.
