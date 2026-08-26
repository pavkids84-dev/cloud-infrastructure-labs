# Linux Shell Environment Lab

## Objective

Explore Bash initialization files, environment variables, variable inheritance, quoting behavior, and command substitution in a Rocky Linux environment.

## Environment

* OS: Rocky Linux
* Virtualization: VMware
* Shell: Bash

## Inspect Shell Initialization Files

List hidden files in the home directory.

```bash
ls -la ~
```

Inspect the user login configuration.

```bash
cat ~/.bash_profile
```

Inspect the Bash configuration file.

```bash
cat ~/.bashrc
```

These files are used to configure the user's shell environment.

## Inspect Environment Variables

Check the home directory.

```bash
echo $HOME
```

Check the command search path.

```bash
echo $PATH
```

Check the current shell.

```bash
echo $SHELL
```

Check the shell prompt definition.

```bash
echo $PS1
```

## PATH

`PATH` contains a colon-separated list of directories that the shell searches when locating executable commands.

```bash
echo $PATH
```

When a command is entered without an absolute path, the shell searches the directories listed in `PATH`.

## Create a Shell Variable

Create a variable.

```bash
LAB_NAME=linux
```

Verify the value.

```bash
echo $LAB_NAME
```

## Export an Environment Variable

Create and export a variable.

```bash
LAB_ENV=cloud
export LAB_ENV
```

Start a child Bash shell.

```bash
bash
```

Verify that the exported variable is available in the child shell.

```bash
echo $LAB_ENV
```

Return to the parent shell.

```bash
exit
```

This demonstrates that exported environment variables can be inherited by child processes.

## Remove a Variable

Remove the variable.

```bash
unset LAB_ENV
```

Verify that the value has been removed.

```bash
echo $LAB_ENV
```

## Compare Single and Double Quotes

Create a variable.

```bash
name=student
```

Use single quotes.

```bash
echo '$name'
```

The variable is treated as literal text.

Use double quotes.

```bash
echo "$name"
```

The variable is expanded to its value.

## Escape a Metacharacter

Use a backslash to prevent variable expansion.

```bash
echo "\$name"
```

The `$` character is treated as a literal character.

## Command Substitution

Insert the output of another command into a command line.

```bash
echo "Current user: $(whoami)"
```

```bash
echo "Hostname: $(hostname)"
```

```bash
echo "Current time: $(date +%H:%M)"
```

`$(command)` executes the command and substitutes its output into the original command line.

## Verification

Verify the following:

* `~/.bash_profile` and `~/.bashrc` contain user shell configuration.
* `$HOME` identifies the user's home directory.
* `$PATH` defines directories used to search for executable commands.
* Shell variables can be created using `VAR=value`.
* `export` makes a variable available to child processes.
* `unset` removes a variable.
* Single quotes prevent variable expansion.
* Double quotes allow variable expansion.
* A backslash can escape a metacharacter.
* `$(command)` performs command substitution.

## What I Learned

* Linux users can customize their shell environment through initialization files.
* `/etc/profile` provides system-wide login environment settings.
* `~/.bash_profile` and `~/.bashrc` provide user-specific shell configuration.
* Environment variables control important parts of the shell environment, including command search paths and user directories.
* `PATH` allows commands to be executed without specifying their full absolute paths.
* Exported variables can be inherited by child processes.
* Quoting rules determine whether shell metacharacters and variables are interpreted or treated literally.
* Command substitution allows the output of one command to be embedded inside another command.
* Understanding environment variables and shell initialization is important for Linux administration, automation, and troubleshooting.
