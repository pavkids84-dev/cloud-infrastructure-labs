# Linux File, Directory, Link, and Permission Lab

## Objective

Practice basic Linux file and directory operations, understand absolute and relative paths, compare symbolic and hard links, and verify Linux file permissions.

## Environment

* OS: Rocky Linux
* Virtualization: VMware
* Shell: Bash

## Create the Lab Environment

Move to the home directory and create a dedicated lab directory.

```bash
cd ~
mkdir linux-file-lab
cd linux-file-lab
pwd
```

## Create Files and Directories

Create three empty files and one directory.

```bash
touch file1 file2 file3
mkdir dir1
ls -l
```

## Copy a File

Create a copy of `file1`.

```bash
cp file1 file1.copy
ls -l
```

## Move and Rename a File

Rename `file2`.

```bash
mv file2 renamed-file
ls -l
```

## Verify Absolute and Relative Paths

Display the current working directory.

```bash
pwd
```

Move to the parent directory using a relative path.

```bash
cd ..
pwd
```

Return to the lab directory.

```bash
cd linux-file-lab
```

An absolute path starts from `/`, while a relative path is interpreted from the current working directory.

## Create a Symbolic Link

Create a symbolic link to `file1`.

```bash
ln -s file1 symbolic-link
```

Inspect the files and inode numbers.

```bash
ls -li
```

A symbolic link has its own inode and refers to another file by its path.

## Create a Hard Link

Create a hard link to `file1`.

```bash
ln file1 hard-link
```

Inspect the inode numbers again.

```bash
ls -li
```

Verify that `file1` and `hard-link` reference the same inode.

## Compare Symbolic and Hard Links

Check all link information.

```bash
ls -li
```

Observe the following:

* `file1` and `hard-link` should have the same inode number.
* `symbolic-link` should have a different inode number.
* A symbolic link refers to the path of the target file.
* A hard link refers to the same inode as the original file.

Delete the original file.

```bash
rm file1
```

Inspect the links again.

```bash
ls -li
```

Verify how the symbolic link and hard link behave after the original file name is removed.

## Inspect File Permissions

Create a new test file.

```bash
touch permission-test
ls -l permission-test
```

Linux permissions are divided into three classes:

```text
Owner | Group | Other
```

The basic permission types are:

```text
r = read
w = write
x = execute
```

## Change Permissions with Octal Mode

Set the file permission to `644`.

```bash
chmod 644 permission-test
ls -l permission-test
```

`644` represents:

```text
Owner : rw-
Group : r--
Other : r--
```

Set the permission to `755`.

```bash
chmod 755 permission-test
ls -l permission-test
```

`755` represents:

```text
Owner : rwx
Group : r-x
Other : r-x
```

## Change Permissions with Symbolic Mode

Remove the execute permission from the owner.

```bash
chmod u-x permission-test
ls -l permission-test
```

Add the execute permission again.

```bash
chmod u+x permission-test
ls -l permission-test
```

## Verification

Verify the following:

* `pwd` displays the current working directory.
* `cd` changes the current directory.
* `touch` creates empty files.
* `mkdir` creates directories.
* `cp` copies files.
* `mv` moves or renames files and directories.
* `rm` removes files.
* Symbolic links and hard links behave differently.
* Hard links share the same inode as the original file.
* File permissions are divided into Owner, Group, and Other.
* `chmod` can modify permissions using both symbolic and octal modes.

## What I Learned

* Linux organizes files and directories in a hierarchical structure starting from `/`.
* Absolute paths start from `/`, while relative paths depend on the current working directory.
* A Linux file can be understood through its file name, inode, and data blocks.
* Symbolic links reference another file by path, while hard links reference the same inode.
* Linux file access is controlled through Owner, Group, and Other permissions.
* The `r`, `w`, and `x` permissions represent read, write, and execute access.
* Octal permissions use `4` for read, `2` for write, and `1` for execute.
* File permissions should be limited to the access that is actually required.
