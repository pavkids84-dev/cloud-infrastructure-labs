# Linux Shell Programming Labs

This directory contains hands-on Bash shell programming exercises.

The labs build from basic script execution and command-line arguments to variable scope, parameter expansion, input validation, conditional logic, and file inspection.

The goal is to understand how Linux commands can be combined with shell programming features to create reusable automation scripts.

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
- Arithmetic expansion
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

## Script Execution

A shell script is a text file interpreted by a shell.

A common Bash script begins with:

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

Different execution methods have different behavior.

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

Using `source` changes the behavior:

```text
Current Shell
     |
     v
source script.sh
     |
     v
Script executes in the same shell
```

This distinction is important when loading environment configuration.

## Variables and Environment

A variable created in the current shell is not automatically inherited by child processes.

```bash
VAR="value"
```

Exporting the variable makes it part of the environment inherited by child processes.

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

Changes made by the child process still do not modify the parent process.

## Special Variables

Useful shell special variables include:

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

## Arithmetic Expansion

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
→ Use word and assign it to var if unset or null

${var:?word}
→ Return an error if var is unset or null

${var:+word}
→ Use word when var contains a value
```

## String Pattern Removal

Bash parameter expansion can also remove matching portions of strings.

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
```

Additional parameters:

```text
$#
→ Number of arguments

$@
→ All arguments

$*
→ All arguments
```

Arguments greater than nine should use braces.

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

Example input:

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

For processing user-supplied arguments individually, `"$@"` is generally the appropriate form.

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

This is useful when processing an unknown number of arguments one at a time.

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

Using arithmetic expressions:

```bash
(( a > b ))
```

Traditional test operators include:

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

Example:

```bash
if (( a > b ))
then
    echo "$a is greater than $b"
fi
```

## String Comparison

Example:

```bash
if [[ "$name" == "linux" ]]
then
    echo "Match"
fi
```

Pattern matching can also be used:

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
→ File or directory exists

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

## Exit Status

A script can explicitly return an exit status.

```bash
exit 0
```

indicates successful completion.

```bash
exit 1
```

indicates failure.

The calling shell can inspect the result using:

```bash
echo $?
```

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

Demonstrates sequential command-line argument processing.

Topics:

- Positional parameters
- `shift`
- Argument processing

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

The comparison demonstrates whether the variable remains in the current shell.

---

### `variables-and-expansion.sh`

Demonstrates shell variables and expansion features.

Topics:

- Local variables
- Environment variables
- Special variables
- Arithmetic expansion
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

The script demonstrates how `"$*"` and `"$@"` handle arguments differently.

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

Examples:

```bash
./service-action.sh start
```

```bash
./service-action.sh status
```

The current script demonstrates input handling only and does not directly control system services.

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

Run inside the current shell when the lab specifically requires it:

```bash
source ./script-name.sh
```

## Verification Approach

Each shell programming lab should follow this pattern:

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
- Script execution can occur in a child shell or the current shell.
- Variables have different scopes depending on how they are defined and exported.
- Child processes inherit exported environment variables but cannot directly modify the parent process environment.
- Special variables expose process and command execution information.
- Arithmetic expressions allow integer calculations inside Bash.
- Parameter expansion provides compact ways to manipulate and validate variables.
- Positional parameters allow scripts to accept reusable command-line input.
- `"$@"` preserves individual command-line arguments.
- `shift` enables sequential argument processing.
- Exit status is fundamental to Shell control flow.
- Conditional statements allow scripts to make decisions based on command results, numeric values, strings, files, and user input.
- `case` provides a clean structure for handling multiple predefined options.

These fundamentals provide the basis for more advanced shell automation and Linux administration tasks.
