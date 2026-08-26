#!/bin/sh

# Demonstrate how the shift command changes positional parameters.

echo "Before shift"
echo "First argument: $1"
echo "Second argument: $2"

shift

echo "After shift"
echo "First argument: $1"
echo "Second argument: $2"
