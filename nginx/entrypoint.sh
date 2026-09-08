#!/bin/ash
set -eu

envsubst '${CACHE_LIFE} ${SERVER_NAMES} ${REDIRECT_HOST}' \
  < /etc/nginx/conf.d/default.conf.template \
  > /etc/nginx/conf.d/default.conf

exec "$@"

