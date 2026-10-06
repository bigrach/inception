#!/bin/bash

cd /var/www/html

# Wait for MariaDB
until (echo > /dev/tcp/mariadb/3306) 2>/dev/null; do
    echo "Wordpress is waiting for mariadb..."
    sleep 1
done

# CLI time baby
if [ ! -f wp-config.php ]; then
    echo "Wordpress init"

    wp core download --allow-root

    wp config create    --dbname=$MDB_DATABASE \
                        --dbuser=$MDB_USER \
                        --dbpass=$MDB_USER_PASSWORD \
                        --dbhost=mariadb \
                        --allow-root

    wp core install     --url=${DOMAIN} \
                        --title="Inception" \
                        --admin_user=${WP_ADMIN_USER} \
                        --admin_password=${WP_ADMIN_PASSWORD} \
                        --admin_email=${WP_ADMIN_MAIL} \
                        --allow-root

    wp user create $WP_USER $WP_USER_MAIL \
                        --role=editor \
                        --user_pass=$WP_USER_PASSWORD \
                        --allow-root

else
    echo "Wordpress already configurated"
fi

exec "$@"