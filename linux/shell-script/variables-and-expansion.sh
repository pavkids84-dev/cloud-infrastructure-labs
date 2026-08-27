#!/bin/bash

# Demonstrates shell variables, special variables,
# arithmetic expansion, and parameter expansion.

LOCAL_VAR="local-value"
export GLOBAL_VAR="global-value"

echo "=== Shell Variables ==="
echo "LOCAL_VAR: $LOCAL_VAR"
echo "GLOBAL_VAR: $GLOBAL_VAR"

echo
echo "=== Special Variables ==="
echo "Current shell PID: $$"

true
echo "Exit status after true: $?"

false
echo "Exit status after false: $?"

echo
echo "=== Arithmetic ==="

a=10
b=3

(( sum = a + b ))
(( difference = a - b ))
(( product = a * b ))
(( quotient = a / b ))
(( remainder = a % b ))

echo "a + b = $sum"
echo "a - b = $difference"
echo "a * b = $product"
echo "a / b = $quotient"
echo "a % b = $remainder"

echo
echo "=== String Pattern Removal ==="

path="/usr/bin/local/bin"

echo "Original path: $path"
echo "Remove shortest suffix: ${path%/bin}"
echo "Remove longest matching suffix: ${path%%/bin*}"
echo "Remove prefix: ${path#/usr/bin}"
echo "Last path component: ${path##*/}"

echo
echo "=== Parameter Expansion ==="

unset APP_ENV

echo "Temporary default value: ${APP_ENV:-development}"
echo "APP_ENV after :- expansion: ${APP_ENV:-<unset>}"

echo "Assign default value: ${APP_ENV:=development}"
echo "APP_ENV after := expansion: $APP_ENV"
