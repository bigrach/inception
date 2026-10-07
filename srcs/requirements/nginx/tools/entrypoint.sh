#!/bin/bash

# Makes znginx.conf w the right params
set -e
envsubst '${NGINX_PORT} ${DOMAIN} ${WP_PORT}' \
    < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
exec "$@"