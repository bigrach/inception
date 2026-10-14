#!/bin/bash
set -e

# Makes znginx.conf w the right params
envsubst '${NGINX_PORT} ${DOMAIN} ${WP_PORT}' \
    < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
exec "$@"