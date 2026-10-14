#!/bin/bash
set -e 

cd /var/www/html

sed -i "s|^listen = .*|listen = 0.0.0.0:${WP_PORT}|" /etc/php/8.2/fpm/pool.d/www.conf 

# Wait for MariaDB
until (echo > /dev/tcp/mariadb/${MDB_PORT}) 2>/dev/null; do
    echo "Wordpress is waiting for mariadb..."
    sleep 1
done

# Get credentials
MDB_USER_PASSWORD=$(cat /run/secrets/MDB_USER_PASSWORD)
WP_ADMIN_PASSWORD=$(cat /run/secrets/WP_ADMIN_PASSWORD)
WP_USER_PASSWORD=$(cat /run/secrets/WP_USER_PASSWORD)

# CLI time baby
if [ ! -f wp-config.php ]; then
    echo "Wordpress init"

    wp core download --allow-root

    wp config create    --dbname=$MDB_DATABASE \
                        --dbuser=$MDB_USER \
                        --dbpass=$MDB_USER_PASSWORD \
                        --dbhost="mariadb:${MDB_PORT}" \
                        --allow-root

    wp core install     --url=${DOMAIN} \
                        --title="Inception" \
                        --admin_user=${WP_ADMIN_USER} \
                        --admin_password=${WP_ADMIN_PASSWORD} \
                        --admin_email=${WP_ADMIN_MAIL} \
                        --skip-email \
                        --allow-root

    wp user create $WP_USER $WP_USER_MAIL \
                        --role=editor \
                        --user_pass=$WP_USER_PASSWORD \
                        --allow-root

else
    echo "Wordpress already configurated"

    # In case mdb or nginx port has changed, we make sure we're set on the right ports
    wp config set DB_HOST "mariadb:${MDB_PORT}" --allow-root
    wp option update home 'https://$DOMAIN:${NGINX_PORT}' --allow-root 
    wp option update siteurl 'https://$DOMAIN:${NGINX_PORT}' --allow-root
fi

exec "$@"