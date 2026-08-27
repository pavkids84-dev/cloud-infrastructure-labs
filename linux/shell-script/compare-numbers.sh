#!/bin/bash

# Compares two numeric command-line arguments.

if (( $# != 2 ))
then
    echo "Usage: $0 NUM1 NUM2"
    exit 1
fi

num1=$1
num2=$2

if (( num1 > num2 ))
then
    echo "$num1 is greater than $num2"
elif (( num1 < num2 ))
then
    echo "$num1 is less than $num2"
else
    echo "$num1 is equal to $num2"
fi

exit 0
