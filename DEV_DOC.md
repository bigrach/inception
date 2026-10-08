# Developper Documentation

## Prerequisites
You will need root permissions or a sudoer account. 



First, install [docker](https://docs.docker.com/engine/install/) & [docker compose](https://docs.docker.com/compose/install/) on your machine before anything else. Once that is done, you'll have to start the docker service. 
```bash
sudo systemctl start docker
```
Don't forget to add your user to the docker group, and to reboot.

```bash
sudo adduser user group  
sudo reboot
```

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
MDB_USER_PASSWORD = *the password of the mariadb user*
MDB_ROOT_PASSWORD = *the password of the mariadb root*

# WP
WP_USER = *the login of the wordpress user*
WP_USER_PASSWORD = *the password of the wordpress user*
WP_USER_MAIL = *the email of the wordpress user*

WP_ADMIN_USER = *the login of the wordpress admin
WP_ADMIN_PASSWORD = *the password of the wordpress admin*
WP_ADMIN_MAIL = *the email of the wordpress admin (do not input the same as the user's)*

# PORTS
WP_PORT = *which port to reach wordpress*
MDB_PORT = *which ports to reach mariadb*
NGINX_PORT = *which ports for nginx*

# VOLUMES
MDB_VOLUME = *where the mariadb database will be stored on your machine*
WP_VOLUME = *where the wordpress website files data will be stored on your machine*
```
## Starting the docker compose, interrupting it...
```bash
~/inception$ make
```
While in the root directory, use the command `make` to build the docker compose and create the directories for the persisting data.

Doing `make run` runs the docker compose, then `make go` builds the docker compose, creates the directories for the persisting data and runs it. 

For a quick break, `make stop` stops the docker compose, and `make start` starts it.

To interrupt the process, `make down` downs the docker compose, removes containers, deletes the network.

If you want to start fresh, `make clean` downs the docker compose and deletes the persisting data (the data/wordpress and data/mariadb folders). `make nuke` does the same and more - images are deleted etc. You will lose your entire website. Be careful.

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

## Data
The website files data will be stored in the `WP_VOLUME` directory, and the database's in the `MDB_VOLUME` one. Deleting those, or doing a `make nuke`, will ensure a complete reset of the website. Thread carefully. 