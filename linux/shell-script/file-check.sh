#!/bin/bash

# Inspects the existence, type, and permissions of a file or directory.

if (( $# != 1 ))
then
    echo "Usage: $0 PATH"
    exit 1
fi

target=$1

if [[ ! -e "$target" ]]
then
    echo "Error: $target does not exist."
    exit 1
fi

echo "Target: $target"

if [[ -f "$target" ]]
then
    echo "Type: Regular file"
elif [[ -d "$target" ]]
then
    echo "Type: Directory"
elif [[ -L "$target" ]]
then
    echo "Type: Symbolic link"
else
    echo "Type: Other"
fi

if [[ -r "$target" ]]
then
    echo "Readable: Yes"
else
    echo "Readable: No"
fi

if [[ -w "$target" ]]
then
    echo "Writable: Yes"
else
    echo "Writable: No"
fi

if [[ -x "$target" ]]
then
    echo "Executable: Yes"
else
    echo "Executable: No"
fi

exit 0
