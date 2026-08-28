#!/bin/bash

# Processes positional parameters one at a time using shift.

if (( $# == 0 ))
then
    echo "Usage: $0 ARG..."
    exit 1
fi

echo "Initial argument count: $#"

while (( $# > 0 ))
do
    echo "Current argument: $1"

    shift

    echo "Remaining arguments: $#"
done

echo "All arguments have been processed."

exit 0
