## Standard Input, Output, and Error

Linux processes use three standard streams:

```text
0 = stdin  (standard input)
1 = stdout (standard output)
2 = stderr (standard error)
```

Understanding these file descriptors makes it possible to control where normal output and error messages are sent.

## Redirect Standard Output

Redirect standard output to a file:

```bash
ls /etc > output.txt
```

`>` overwrites the destination file.

Append output instead of overwriting it:

```bash
date >> output.txt
```

`>>` appends new output to the existing file.

## Redirect Standard Error

Redirect only error messages:

```bash
ls /not-exist 2> error.txt
```

Here:

```text
2 = stderr
```

The normal output remains on the terminal, while error messages are written to `error.txt`.

## Separate Standard Output and Standard Error

Normal output and error output can be stored separately.

```bash
ls /etc /not-exist 1> output.txt 2> error.txt
```

The result is:

```text
stdout → output.txt
stderr → error.txt
```

Because `stdout` is file descriptor `1`, the following two commands are equivalent:

```bash
command > output.txt
command 1> output.txt
```

## Combine Standard Output and Standard Error

Redirect standard output to a file and then send standard error to the same destination:

```bash
command > combined.log 2>&1
```

For example:

```bash
ls /etc /not-exist > combined.log 2>&1
```

The flow is:

```text
stdout ──┐
         ├──> combined.log
stderr ──┘
```

`2>&1` means:

```text
Send file descriptor 2 (stderr)
to the same destination currently used by
file descriptor 1 (stdout).
```

This pattern is commonly used when both normal output and errors need to be stored in the same log file.

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

The command still runs, but its normal output is not displayed.

## Discard Only Error Messages

Redirect only standard error to `/dev/null`:

```bash
command 2> /dev/null
```

Example:

```bash
find / -name "test.conf" 2> /dev/null
```

This keeps normal search results visible while hiding error messages such as permission errors.

The flow is:

```text
stdout → Terminal
stderr → /dev/null
```

## Discard Both Standard Output and Standard Error

Discard both normal output and error messages:

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

In Bash, the following syntax can also redirect both standard output and standard error:

```bash
command &> output.log
```

For example:

```bash
ls /etc /not-exist &> combined.log
```

To discard both streams:

```bash
command &> /dev/null
```

This is a Bash-specific shorthand for redirecting both `stdout` and `stderr`.

## Redirection Order Matters

The order of redirection operators is important.

This command:

```bash
command > output.log 2>&1
```

means:

```text
1. Redirect stdout to output.log
2. Redirect stderr to the current stdout destination

Result:
stdout → output.log
stderr → output.log
```

However:

```bash
command 2>&1 > output.log
```

is different.

It means:

```text
1. Redirect stderr to the current stdout destination (terminal)
2. Redirect stdout to output.log

Result:
stdout → output.log
stderr → Terminal
```

Therefore, when both normal output and errors should go to the same file, the commonly used form is:

```bash
command > output.log 2>&1
```

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

## Practical Examples

Save both normal output and errors to a log file:

```bash
./script.sh > script.log 2>&1
```

Hide permission errors while searching the file system:

```bash
find / -name "*.conf" 2> /dev/null
```

Run a command silently:

```bash
some-command > /dev/null 2>&1
```

Append both normal output and error messages to an existing log:

```bash
some-command >> application.log 2>&1
```

## Verification

Verify the following:

- File descriptor `0` represents standard input.
- File descriptor `1` represents standard output.
- File descriptor `2` represents standard error.
- `>` redirects and overwrites standard output.
- `>>` appends standard output.
- `2>` redirects standard error.
- `2>&1` redirects standard error to the current standard output destination.
- `/dev/null` discards data written to it.
- `2> /dev/null` hides only error messages.
- `> /dev/null 2>&1` discards both standard output and standard error.
- The order of redirection operators affects the result.

## What I Learned

- Linux treats standard input, standard output, and standard error as separate data streams.
- File descriptors make it possible to redirect these streams independently.
- `2>&1` is commonly used to combine normal output and error messages.
- `/dev/null` is useful when output should intentionally be discarded.
- Error redirection can make system searches easier to read by hiding expected permission errors.
- Redirection order matters because each redirection is processed from left to right.
- Understanding redirection is important for logging, shell scripting, automation, and troubleshooting.
