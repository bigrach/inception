#!/bin/bash

# Makes it so i can use env variables in nginx.conf
set -e
envsubst '${NGINX_PORT} ${DOMAIN} ${WP_PORT}' \
    < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
exec "$@"