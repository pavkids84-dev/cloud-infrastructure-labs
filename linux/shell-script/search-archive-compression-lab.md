# Linux Search, Archive, and Compression Lab

## Objective

Practice searching file contents with `grep`, locating files and directories with `find`, creating archives with `tar`, and compressing files with `gzip` and `bzip2`.

## Environment

- OS: Rocky Linux
- Virtualization: VMware
- Shell: Bash

## Create the Lab Environment

```bash
cd ~
mkdir search-archive-lab
cd search-archive-lab

mkdir logs configs
```

Create a sample log file.

```bash
printf "INFO Server started\nERROR Connection failed\nINFO Retry started\nERROR Timeout\n" > logs/app.log
```

Create sample configuration files.

```bash
touch configs/app.conf
touch configs/db.conf
touch configs/test.txt
```

## Search File Contents with grep

Search for lines containing `ERROR`.

```bash
grep ERROR logs/app.log
```

Display matching lines with line numbers.

```bash
grep -n ERROR logs/app.log
```

Perform a case-insensitive search.

```bash
grep -i error logs/app.log
```

Display lines that do not contain `INFO`.

```bash
grep -v INFO logs/app.log
```

Count the number of lines containing `ERROR`.

```bash
grep -c ERROR logs/app.log
```

## Regular Expression Search

Find lines that start with `ERROR`.

```bash
grep '^ERROR' logs/app.log
```

Find lines that end with `started`.

```bash
grep 'started$' logs/app.log
```

Regular expressions make it possible to search text using patterns rather than only exact strings.

## Locate Files with find

Find files whose names end with `.conf`.

```bash
find . -name "*.conf"
```

Find regular files.

```bash
find . -type f
```

Find directories.

```bash
find . -type d
```

Combine multiple conditions.

```bash
find . -type f -name "*.conf"
```

Multiple `find` expressions are evaluated together, allowing searches to be narrowed using several conditions.

## Create a tar Archive

Create an archive containing the `configs` directory.

```bash
tar cvf configs.tar configs/
```

List the contents of the archive.

```bash
tar tvf configs.tar
```

## Extract a tar Archive

Create a directory for extraction.

```bash
mkdir extracted
cd extracted
```

Extract the archive.

```bash
tar xvf ../configs.tar
```

Return to the lab directory.

```bash
cd ..
```

## Compress a File with gzip

Create a copy of the log file.

```bash
cp logs/app.log app-copy.log
```

Compress the file.

```bash
gzip app-copy.log
```

Verify the compressed file.

```bash
ls
```

Decompress it.

```bash
gunzip app-copy.log.gz
```

## Compression with bzip2

Create another copy.

```bash
cp logs/app.log app-bzip.log
```

Compress it.

```bash
bzip2 app-bzip.log
```

Decompress it.

```bash
bunzip2 app-bzip.log.bz2
```

## Verification

Verify the following:

- `grep` searches the contents of files.
- `grep -n` displays matching lines with line numbers.
- `grep -v` displays lines that do not match a pattern.
- `grep -i` performs case-insensitive matching.
- `grep -c` counts matching lines.
- `^` matches the beginning of a line.
- `$` matches the end of a line.
- `find` searches for files and directories based on specified conditions.
- Multiple `find` expressions can narrow search results.
- `tar` can create, inspect, and extract archive files.
- `gzip` creates `.gz` compressed files.
- `gunzip` decompresses `.gz` files.
- `bzip2` creates `.bz2` compressed files.
- `bunzip2` decompresses `.bz2` files.

## What I Learned

- `grep` is used to search text inside files and command output.
- Regular expressions make text searches more flexible by defining matching patterns.
- `find` searches the file system using conditions such as name, type, owner, modification time, size, and permissions.
- `grep` and `find` solve different problems: `grep` searches file contents, while `find` locates files and directories.
- `tar` combines files and directories into an archive.
- Archiving and compression are separate concepts.
- Search utilities are fundamental tools for Linux system administration and troubleshooting.
- Archive and compression tools are useful for configuration backups, file transfer, and system maintenance.
