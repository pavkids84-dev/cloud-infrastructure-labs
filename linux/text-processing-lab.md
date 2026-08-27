# Linux Text Processing Lab

## Objective

Practice Linux text processing using `grep`, `sed`, and `awk`.

The goal is to understand how command output and text files can be filtered, transformed, and processed for Linux administration and automation.

## Environment

- OS: Rocky Linux
- Shell: Bash

## Sample Data

The following data was used for the exercises:

```text
northwest NW Joel Craig 3.0 .98 3 4
western WE Sharon Kelly 5.3 .97 5 23
southwest SW Chris Foster 2.7 .8 2 18
southern SO May Chin 5.1 .95 4 15
southeast SE Derek Johnson 5.0 .70 4 17
eastern EA Susan Beal 4.4 .8 5 20
northeast NE TJ Nichols 5.1 .94 3 13
north NO Val Shultz 4.5 .89 5 9
central CT Sheri Watson 5.7 .94 5 13
```

## Extended grep

Extended regular expressions allow multiple patterns and additional repetition operators.

```bash
grep -E 'north|south' data.file
```

Fixed-string searching treats regular-expression metacharacters as literal characters.

```bash
grep -F '$' literal-test.txt
```

## sed

`sed` processes text one line at a time and writes the result to standard output.

The original file is not modified by the commands used in this lab.

### Print Selected Lines

```bash
sed -n '3,5p' data.file
```

### Print Lines Matching a Pattern

```bash
sed -n '/west/p' data.file
```

### Print a Range Between Patterns

```bash
sed -n '/west/,/southern/p' data.file
```

### Replace Text

```bash
sed 's/north/North/' data.file
```

### Replace All Matches in Each Line

```bash
sed 's/3/X/g' data.file
```

### Delete Lines

```bash
sed '4,8d' data.file
```

```bash
sed '/west/d' data.file
```

### Verification

The original file can be checked after each command:

```bash
cat data.file
```

This verifies that the commands produced transformed output without modifying the original file.

## awk

`awk` processes input as records and fields.

```text
$0
→ Entire record

$1, $2, ...
→ Individual fields

NR
→ Current record number

NF
→ Number of fields

$NF
→ Last field
```

### Rearrange Fields

```bash
awk '{print $3,$4,$2}' data.file
```

### Add Record Numbers

```bash
awk '{print NR, $0}' data.file
```

### Print the Last Field

```bash
awk '{print NR, $NF}' data.file
```

### Filter Records and Print Selected Fields

```bash
awk '/east/ {print $1,$5,$4}' data.file
```

### Change the Input Field Separator

The `/etc/passwd` file uses `:` as a field separator.

```bash
awk -F: '{print $1,$3}' /etc/passwd
```

### Calculate a Total

```bash
awk '{total = total + $8} END {print "Total:", total}' data.file
```

## Processing Linux Command Output

Text-processing utilities can also process command output through pipelines.

### Disk Information

```bash
df -h
```

```bash
df -h | awk '{print $1,$5,$6}'
```

### Memory Information

```bash
free -m
```

The command output should be inspected before selecting record and field numbers because output formats may differ between systems.

## Tool Comparison

```text
grep
→ Search for matching lines

sed
→ Select, replace, or remove text

awk
→ Process records and fields
```

## Practical Workflow

```text
Command or File
      |
      v
Text Input
      |
      v
grep / sed / awk
      |
      v
Filtered or Processed Output
      |
      v
Shell Automation
```

## What I Learned

- `grep` is useful for locating matching lines.
- Extended regular expressions support more complex pattern matching.
- Fixed-string searching prevents regular-expression interpretation.
- `sed` processes input one line at a time.
- `sed -n` suppresses default output.
- `p` prints selected lines.
- `d` removes selected lines from the output.
- `s/old/new/` performs substitution.
- Multiple `sed` actions are applied sequentially.
- `awk` treats each input line as a record.
- Records can be divided into fields.
- `NR` identifies the current record.
- `NF` contains the number of fields.
- `$NF` references the last field.
- `FS` controls the input field separator.
- `awk` can perform numerical processing as well as text processing.
- Linux command output can be piped into text-processing utilities for administration and automation.
