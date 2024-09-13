#!/bin/bash

coverage run manage.py test
coverage xml --omit=*/migrations*,*/management*
sed -i 's/\/code/\./g' coverage.xml