#!/bin/bash

docker compose down
docker system prune --all --force
docker image prune
docker volume prune
sudo rm -rf /home/me/data/mariadb/* && echo "youpi"
echo "check"
ls -lRa /home/me/data/mariadb
