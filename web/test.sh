#!/bin/bash

./wait-for-it.sh db:5432

docker-compose run web python3 manage.py test

