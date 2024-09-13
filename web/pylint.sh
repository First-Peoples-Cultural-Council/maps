#!/bin/bash

# Check if an argument is provided, use "." (current directory) as default
target=$1
target=${target:-.}

# Run pylint on Python files, excluding migrations folder
find "$target" -type f -name "*.py" -not -path "*/migrations/*" -not -path "*/test*.py" | xargs pylint --disable=django-not-configured --load-plugins pylint_django