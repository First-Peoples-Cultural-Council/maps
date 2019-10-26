#!/bin/ash
set -eu

envsubst '${CACHE_LIFE}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

exec "$@"

