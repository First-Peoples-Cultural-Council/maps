#!/bin/bash

coverage run --omit=*/migrations*,*/management*,*/tests* manage.py test "$@"
coverage report -m
coverage xml
sed -i 's/\/code/\./g' coverage.xml