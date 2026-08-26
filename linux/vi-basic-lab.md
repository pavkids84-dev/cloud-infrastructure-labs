# Linux Vi Basic Lab

## Objective

Practice the basic Vi editing workflow including mode switching, cursor movement, text editing, searching, replacement, copying, deleting, and saving files.

## Environment

* OS: Rocky Linux
* Virtualization: VMware
* Editor: Vi/Vim
* Shell: Bash

## Create the Lab Directory

```bash
cd ~
mkdir vi-basic-lab
cd vi-basic-lab
```

Open a new file.

```bash
vi practice.txt
```

## Vi Modes

Vi uses three primary modes:

```text
Command Mode
Insert Mode
Last Line Mode
```

* Command Mode is used for navigation and editing commands.
* Insert Mode is used to enter text.
* Last Line Mode is used for operations such as saving, quitting, searching, and configuration.

Press `Esc` to return to Command Mode.

## Enter Text

Press:

```text
i
```

Enter the following text:

```text
Linux server administration
Rocky Linux
Cloud infrastructure
Linux server administration
SSH service
```

Press `Esc` to return to Command Mode.

## Cursor Movement

Use the following keys in Command Mode:

```text
h = move left
j = move down
k = move up
l = move right

0 = move to the beginning of the line
$ = move to the end of the line
G = move to the last line
```

## Delete Text

Delete the current character:

```text
x
```

Delete the current line:

```text
dd
```

Delete from the cursor position to the end of the line:

```text
D
```

## Undo Changes

Undo the previous editing command:

```text
u
```

## Copy and Paste

Copy the current line:

```text
yy
```

Paste the copied line below the current line:

```text
p
```

## Search for Text

Search forward for `Linux`:

```text
/Linux
```

Move to the next matching result:

```text
n
```

Move to the previous matching result:

```text
N
```

## Replace Text

Replace every occurrence of `Linux` with `GNU-Linux`:

```text
:%s/Linux/GNU-Linux/g
```

## Display Line Numbers

Enable line numbers:

```text
:set nu
```

## Save the File

Save the current file:

```text
:w
```

## Save and Quit

Save changes and exit Vi:

```text
:wq
```

## Quit Without Saving

Open the file again:

```bash
vi practice.txt
```

Make a temporary change and press `Esc`.

Exit without saving the modification:

```text
:q!
```

Open the file again and verify that the temporary modification was not saved.

## Vim Configuration

User-specific Vim settings can be stored in:

```text
~/.vimrc
```

The course material provides examples such as:

```text
set nu
set tabstop=4
set ic
set cindent
set smartindent
```

These settings can customize the default editing environment.

## Verification

Verify the following:

* Vi starts in Command Mode.
* `i` enters Insert Mode.
* `Esc` returns to Command Mode.
* `h`, `j`, `k`, and `l` move the cursor.
* `dd` deletes a line.
* `yy` copies a line.
* `p` pastes copied or deleted text.
* `u` undoes the previous command.
* `/pattern` searches for text.
* `n` and `N` navigate between search results.
* `:%s/old/new/g` replaces matching text throughout the file.
* `:w` saves changes.
* `:wq` saves changes and exits.
* `:q!` exits without saving changes.

## What I Learned

* Vi is a modal text editor commonly used in Linux environments.
* Understanding Command Mode, Insert Mode, and Last Line Mode is essential for using Vi effectively.
* Searching and replacing text makes it easier to modify large configuration files.
* Vi can be used entirely from a terminal without requiring a graphical environment.
* User-specific editor settings can be stored in `~/.vimrc`.
* Basic Vi skills are useful for editing Linux server configuration files during remote administration.
