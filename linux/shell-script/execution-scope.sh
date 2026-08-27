#!/bin/bash

# Demonstrates shell variable scope during script execution.

LAB_VAR="created-inside-script"

echo "Current script PID: $$"
echo "LAB_VAR inside script: $LAB_VAR"
