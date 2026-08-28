#!/bin/bash

# Demonstrates Bash functions, function arguments,
# local variables, and positional parameter scope.

show_system_info()
{
    local label="System Information"

    echo "=== $label ==="
    echo "Hostname: $(hostname)"
    echo "Kernel: $(uname -r)"
    echo "Current user: $(whoami)"
}

show_argument()
{
    local value=$1

    echo "Function argument: $value"
}

echo "=== Script Argument ==="

if (( $# > 0 ))
then
    echo "Script \$1 before function call: $1"
else
    echo "No script argument was provided."
fi

echo
show_system_info

echo
show_argument "function-value"

echo

if (( $# > 0 ))
then
    echo "Script \$1 after function call: $1"
fi

exit 0
