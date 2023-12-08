#!/bin/bash

find . -type f -path "*.py" | grep -v migrations | xargs pylint --disable=django-not-configured --load-plugins pylint_django