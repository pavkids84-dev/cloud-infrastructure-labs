#!/bin/bash

# Processes command-line arguments using a for loop.

if (( $# == 0 ))
then
    echo "Usage: $0 ARG..."
    exit 1
fi

for arg in "$@"
do
    echo "Argument: $arg"
done

exit 0
