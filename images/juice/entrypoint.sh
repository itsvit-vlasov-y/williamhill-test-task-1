#!/usr/bin/env sh
set -e

API_KEY="${API_KEY:?error: API_KEY is not set}"
HOSTNAME="$(hostname | tr -d '[:space:]')"

sed -ri "s/RUNTIME_INSERT_API_KEY/${API_KEY}/g" /usr/share/nginx/html/index.html
sed -ri "s/RUNTIME_INSERT_HOSTNAME/${HOSTNAME}/g" /usr/share/nginx/html/index.html

nginx -g 'daemon off;'
