#!/bin/bash

# Demonstrates positional parameters and the difference
# between "$*" and "$@".

echo "=== Positional Parameters ==="

echo "Script name: $0"
echo "Number of arguments: $#"

echo
echo "First argument: ${1:-<none>}"
echo "Second argument: ${2:-<none>}"

echo
echo '=== "$*" ==='

for arg in "$*"
do
    echo "[$arg]"
done

echo
echo '=== "$@" ==='

for arg in "$@"
do
    echo "[$arg]"
done

echo
echo "=== Processing Arguments with shift ==="

while (( $# > 0 ))
do
    echo "Current \$1: $1"
    shift
done

echo
echo "Remaining arguments: $#"
