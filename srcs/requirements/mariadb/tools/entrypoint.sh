#!/bin/bash

chown -R mysql:mysql /var/lib/mysql
echo "Adding var/lib/mysql permissions.."

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
echo "adding /run/mysqld permissions.."

echo "Checking..."
ls -la /var/lib/mysql

if [ ! -d "/var/lib/mysql/$MDB_DATABASE" ]; then
	echo "mariadb database initialization"

	mariadbd --user=mysql --skip-networking &
#	mysql_install_db --basedir=/usr \
#					--datadir=/var/lib/mysql \
#					--user=mysql
	MYPID=$!

	until mariadb-admin ping --silent; do
		sleep 1
	done

	mariadb <<EOF
CREATE DATABASE IF NOT EXISTS $MDB_DATABASE;
CREATE USER IF NOT EXISTS '$MDB_USER'@'%' IDENTIFIED BY '$MDB_USER_PASSWORD';
GRANT ALL PRIVILEGES ON $MDB_DATABASE.* TO '$MDB_USER'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MDB_ROOT_PASSWORD';
FLUSH PRIVILEGES;
EOF
	
    mariadb-admin -uroot -p"${MDB_ROOT_PASSWORD}" shutdown
    wait $MYPID
fi

echo "Starting Mariadb"

exec "$@"
