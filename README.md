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
In `srcs`, you need to make a .env file. 
Replace the values in ** with your own. 
```
# GLOBAL
DOMAIN = *the website you want to redirect localhost to*
USER = *your name for the certificate*

# MDB 
MDB_DATABASE = *the name of the mariadb database*
MDB_USER = *the login of the mariadb user*

# WP
WP_USER = *the login of the wordpress user*
WP_USER_MAIL = *the email of the wordpress user*
WP_ADMIN_USER = *the login of the wordpress admin
WP_ADMIN_MAIL = *the email of the wordpress admin (do not input the same as the user's)*

# PORTS
WP_PORT = *which port to reach wordpress*
MDB_PORT = *which ports to reach mariadb*
NGINX_PORT = *which ports for nginx*

# VOLUMES
MDB_VOLUME = *where the mariadb database will be stored on your machine*
WP_VOLUME = *where the wordpress website files data will be stored on your machine*
```

## Secrets
Credentials (all of the passwords) are to be stored in the `secrets` folder in `srcs`, each in their own 
```
  WP_USER_PASSWORD:
    file: ./secrets/wp_user_pwd.txt
  WP_ADMIN_PASSWORD:
    file: ./secrets/wp_admn_pwd.txt
  MDB_USER_PASSWORD:
    file: ./secrets/mdb_user_pwd.txt
  MDB_ROOT_PASSWORD:
    file: ./secrets/mdb_root_pwd.txt
```
In the file, there should be only the password present. 
```
my_super_wp_user_pwd
```
For example, this could be the content of `wp_user_pwd.txt`. 
## Starting the docker compose, interrupting it...
```bash
~/inception$ make
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
## Design choices 
### Sources
Here is a quick look at the architecture of the projec:
```
inception
├── DEV_DOC.md - Documentation for developpers
├── Makefile
├── README.md 
├── srcs
│   ├── docker-compose.yml - Brings all the containers together
│   ├── *.env - Where environment variables are stored and configured
│   ├── requirements
│   │   ├── mariadb
│   │   │   ├── Dockerfile - Dockerfiles configure containers 
│   │   │   └── tools
│   │   │       ├── conf
│   │   │       │   └── 50-server.cnf - Conf file for mariadb
│   │   │       └── entrypoint.sh
│   │   ├── nginx
│   │   │   ├── Dockerfile
│   │   │   └── tools
│   │   │       ├── conf
│   │   │       │   └── nginx.conf - Conf file for NGINX
│   │   │       └── entrypoint.sh - Edits the conf file
│   │   └── wordpress
│   │       ├── Dockerfile
│   │       └── tools
│   │           └── entrypoint.sh - Sets up WordPress with WordPress CLI
│   └── secrets - Where every password is stored 
│       ├── *mdb_root_pwd.txt
│       ├── *mdb_user_pwd.txt
│       ├── *wp_admn_pwd.txt
│       └── *wp_user_pwd.txt
└── USER_DOC.md - Documentation for Users
```
Files with * are to be created, they are not pushed. 

### Using Docker
Docker offers a more lightweight alternative to VMs, and their scripting helps us debug more easily, and change our build quicker, instead of having to go through the entire WordPress set up manually for example. We can reproduce our project identically every time. 

### Making our own images 
Making our own images lets us see the possibilities in configuration offered by Dockerfile, and how custom everything can be. 

### Using Debian bookworm
Using Debian bookworm helps guarantee a stable version where the package versions of our services are no longer updated. 

### One process per container
Having a container for each of our services in this project prevents us from having multiple services interfering with one another and having trouble debugging them. It gives the opportunity to use specific versions of services in their own environments. 

On top of that, it helps with stopping and starting each service, since they are PID 1 with `exec "$@"` and SIGTERM signals reaches them directly. Docker only supervises PID 1, meaning by having only one process per container, services are checked and crashes are reported right away. 

### Self-signed TLS 1.2/1.3 on port 443 only
Makes sure there is a single entry point into the project, and prevents us from using deprecated protocols with known weaknesses. 

### Templates
Using `envsubst` to modify configuration files helps with consistency throughout the project. It helps prevent human error when trying to change a particular variable (for example, ports) by making sure all files concerned will have the right data. 

## Virtual Machines vs Docker
Containers are lightweight, easy to reproduce en masse, portable - they only contain the bare minimum to make their service work. Virtual machines take more resources, and their boot time is usually longer. That makes containers more scalable, more malleable for application purposes. 

Virtual Machines find their use in having an environment divorced from the machine's kernel. Docker is more of a security risk in that regard: it shares the host's kernel.

## Secrets vs Environment Variables
Environment variables are less secure than secrets, and therefore should not store credentials. Secrets are less likely to leak via logs than environnement variables - they aren't baked in image layers and won't appear in `docker inspect`. The `.env` is reserved for non-sensitive info.

## Docker Network vs Host Network
Docker network helps control which ports from each container will be open, and keeps the host's ports safe by not using them. Containers get their own network namespace and can reach each other by their service name. NGINX being the only one to publish a port, MariaDB and WordPress aren't reachable from the outside. 

Host networking would mean the container shares the host's network's stack, so ports could collide with host services. 

## Docker Volumes vs Bind Mounts
Docker volumes are handled by docker, while bind mounts are handled by the user. Bind mounts map host path directly and are independent of Docker's volume management. 

# Resources
## Docker

[Docker Compose](https://docs.docker.com/compose/gettingstarted/#step-1-set-up-the-project), [Docker Files](https://docs.docker.com/get-started/docker-concepts/building-images/writing-a-dockerfile/)

## Services
[Wordpress CLI](https://make.wordpress.org/cli/handbook/guides/quick-start/), [tuto](https://www.akamai.com/cloud/guides/how-to-install-wordpress-using-wp-cli-on-debian-10/), MariaDB SQL - [user management](https://mariadb.com/docs/server/reference/sql-statements/account-management-sql-statements), [database management](https://mariadb.com/docs/server/reference/sql-statements/data-definition/create/create-database), [configuration file](https://mariadb.com/docs/server/server-management/install-and-upgrade-mariadb/configuring-mariadb/configuring-mariadb-with-option-files), [NGINX](https://nginx.org/en/docs/http/configuring_https_servers.html)

## Additional

[envsubst](https://manpages.debian.org/stretch/gettext-base/envsubst.1.en.html)

## Help
Thank you vmurat, lperis, jnauroy for their help. 

AI was used as a guide map, to put some light on core concepts and to help debug. 
