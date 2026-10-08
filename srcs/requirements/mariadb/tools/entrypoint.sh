#!/bin/bash

# Making sure permissions and directories are OK 
chown -R mysql:mysql /var/lib/mysql
echo "Adding var/lib/mysql permissions.."

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
echo "adding /run/mysqld permissions.."

# Get credentials
MDB_USER_PASSWORD=$(cat /run/secrets/MDB_USER_PASSWORD)
MDB_ROOT_PASSWORD=$(cat /run/secrets/MDB_ROOT_PASSWORD)

# Editing .cnf with the right port from env
envsubst '${MDB_PORT}' \
    < /etc/mysql/mariadb.conf.d/50-server.cnf.template \
    > /etc/mysql/mariadb.conf.d/50-server.cnf

# SQL time my dove
if [ ! -d "/var/lib/mysql/$MDB_DATABASE" ]; then
	echo "mariadb database initialization"

	mariadbd --user=mysql --skip-networking &
	
	MYPID=$!

	until mariadb-admin ping --silent; do
		sleep 1
	done

	mariadb <<EOF
CREATE DATABASE IF NOT EXISTS $MDB_DATABASE;
CREATE USER IF NOT EXISTS '$MDB_USER'@'%' IDENTIFIED BY '$MDB_USER_PASSWORD';
GRANT ALL PRIVILEGES ON $MDB_DATABASE.* TO '$MDB_USER'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MDB_ROOT_PASSWORD';
EOF
	
    mariadb-admin -uroot -p"${MDB_ROOT_PASSWORD}" shutdown
    wait $MYPID
else 
	echo "Working on previously built mariadb database"
fi

echo "Starting Mariadb"

exec "$@"
