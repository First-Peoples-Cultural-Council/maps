#!/bin/bash

# make uploaded files accessible
umask 0000

./wait-for-it.sh ${DATABASE_HOST:=db}:5432

python3 manage.py migrate
python3 manage.py collectstatic --noinput
gunicorn web.wsgi:application -k gevent -t 300 -b :8000 --reload --max-requests 1000

