#!/bin/bash

# Reads and processes a text file line by line.

if (( $# != 1 ))
then
    echo "Usage: $0 FILE"
    exit 1
fi

file=$1

if [[ ! -f "$file" ]]
then
    echo "Error: $file is not a regular file."
    exit 1
fi

while read line
do
    echo "Line: $line"
done < "$file"

exit 0
