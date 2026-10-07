*This project was made as part of the 42 curriculum by rlebigre*

# Inception

Learning how to self host a website using dockers & docker compose. 

# Description

This program is an introduction to Docker, using images build by our own Dockerfiles. Read-made images are forbidden. Each image has to have the same name as the corresponding device. Each device has to run in a dedicated container - MariaDB, WordPress (with php-fpm - it must be installed and configured), NGINX (with TLSv1.2 or TLSv1.3 only).

There are two volumes: one for MariaDB (the WordPress database), one for the WordPress website files. Bind mounts are not allowed. 

All of these containers exist inside the same network called 'inception'.
Wordpress should have two users, one of them being the admin (without the name). 


# Instructions

## Prerequisites
You will need to install [docker](https://docs.docker.com/engine/install/) & [docker compose](https://docs.docker.com/compose/install/) on your machine before anything else. Once that is done, you'll have to start the docker service. 
```bash
sudo systemctl start docker
```
Don't forget to add your user to the docker group, and to reboot. 

## Env file
In ./srcs, you should make a .env file. 
Replace the // and the description with your own values. 
```
# GLOBAL
DOMAIN = // the website you want to redirect localhost to
USER = // your name for the certificate

# MDB 
MDB_DATABASE = // the name of the mariadb database
MDB_USER = // the login of the mariadb user
MDB_USER_PASSWORD = // the password of the mariadb user
MDB_ROOT_PASSWORD = // the password of the mariadb root

# WP
WP_USER = // the login of the wordpress user
WP_USER_PASSWORD = // the password of the wordpress user
WP_USER_MAIL = // the mail of the wordpress user 

WP_ADMIN_USER = // the login of the wordpress admin
WP_ADMIN_PASSWORD = // the password of the wordpress admin
WP_ADMIN_MAIL = // the mail of the wordpress admin (do not input the same as the user's)

# PORTS
WP_PORT = // which port to reach wordpress
MDB_PORT = // which ports to reach mariadb
NGINX_PORT = // which ports for nginx

# VOLUMES
MDB_VOLUME = // where the mariadb database will be stored on your machine 
WP_VOLUME = // where the wordpress website files data will be stored on your volume
```
## Starting the docker compose, interrupting it...
```bash
~/Documents/inception$ make
```
While in the root directory, use the command `make` to build the docker compose and create the directories for the persisting data.

Doing `make run` runs the docker compose, then `make go` builds the docker compose, creates the directories for the persisting data and runs it. 

For a quick break, `make stop` stops the docker compose, and `make start` starts it.

To interrupt the process, `make down` downs the docker compose, removes containers, deletes the network.

If you want to start fresh, `make clean` downs the docker compose and deletes the persisting data (the data/wordpress and data/mariadb folders). `make nuke` does the same and more - images are deleted etc.  

To know the current states of things, `make status` shows what is currently up and running, and lists what is in data. 

## Entering a container
To enter a container that is currently running, you can `make` + `container name` in a new shell. For the mariadb container, it will take you straight into the database. For example:
```bash
make wordpress --> opens the wordpress docker
```

## Editing the website
Once all services are up and running, you can go on your web browser to view the wonderful website. Make sure you access it with `https:/` in a secure manner, with `localhost` or  your domain name. 

If the domain doesn't work, make sure you've added it `127.0.0.1 <Domain>` to the `/etc/hosts` file on your machine and rebooted. 
To edit the website, you can go to `<Domain>/wp-admin` and do your thing. 

Do not write the <> caracters when doing the previous steps. 


# Project description
Using Docker for each of our services in this project prevents us from having multiple services interfering with one another and having trouble debugging them. It gives the opportunity to use specific versions of services in their own environments. 

By having every step being written down, we can debug more easily, and change our build quicker, instead of having to go through the entire WordPress set up manually, for example. 

Making our own images let us see the possilities in configuration offered by Dockerfile, and how custom everything can be. 

## Virtual Machines vs Docker
Dockers are lightweight, easy to reproduce en masse, portable - they only contain the bare minimum to make their service work. Virtual machines take more ressources, and their boot time is usually longer. That makes Dockers more scalable, more maleable for application purposes. 

Virtual Machines find their use in having an environment divorced from the machine's kernel. Docker is more of a security risk on that regards: it shares the host's ressources.

## Secrets vs Environment Variables
Environment variables are less secure than secrets, and therefore should not store credentials. Environnement variables can leak via logs, whereas secrets are stored securely by Docker. 

## Docker Network vs Host Network
Docker network helps control which ports from each container will be open, and keeps the host's ports safe by not using them. 

## Docker Volumes vs Bind Mounts
Docker volumes are handled by docker, while bind mounts are handled by the user. 

# Ressources
## Docker

[Docker Compose](https://docs.docker.com/compose/gettingstarted/#step-1-set-up-the-project), [Docker Files](https://docs.docker.com/get-started/docker-concepts/building-images/writing-a-dockerfile/)

## Services
[Wordpress CLI](https://make.wordpress.org/cli/handbook/guides/quick-start/), MariaDB SQL - [user management](https://mariadb.com/docs/server/reference/sql-statements/account-management-sql-statements), [database management](https://mariadb.com/docs/server/reference/sql-statements/data-definition/create/create-database), [configuration file](https://mariadb.com/docs/server/server-management/install-and-upgrade-mariadb/configuring-mariadb/configuring-mariadb-with-option-files), [NGINX](https://nginx.org/en/docs/http/configuring_https_servers.html)

## Additional

[envsubst](https://manpages.debian.org/stretch/gettext-base/envsubst.1.en.html)

## Help
Thank you vmurat, lperis, jnauroy for their help. 

AI was used as a guide map and to help debug. 
