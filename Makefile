include srcs/.env

# colors 
COLOR = "\e[1;36m"
RESET = "\e[0m"

# rules
create:
	@mkdir -p ${MDB_VOLUME} && echo "creating mariadb data directory"
	@mkdir -p ${WP_VOLUME} && echo "creating wordpress data directory"

all: create
	docker compose -f ./srcs/docker-compose.yml build

run: 
	docker compose -f ./srcs/docker-compose.yml up

go: create
	docker compose -f ./srcs/docker-compose.yml up --build -d

start: 
	docker compose -f ./srcs/docker-compose.yml start

stop: 
	docker compose -f ./srcs/docker-compose.yml stop

re: nuke all

down: 
	docker compose -f ./srcs/docker-compose.yml down

# enter specific container
mariadb: 
	docker exec -it mariadb mariadb --user=${MDB_USER} -p

wordpress:
	docker exec -it wordpress bash

nginx:
	docker exec -it nginx bash

status:
	@echo ${COLOR}"displaying container status:"${RESET}
	@docker ps
	@echo ${COLOR}"displaying what folders are in data:"${RESET}
	@ls -l /home/rlebigre/data

# clean up
clean: down 
	@sudo rm -rf /home/me/data/mariadb && echo "mariadb data deleted"
	@sudo rm -rf /home/me/data/wordpress && echo "wordpress data deleted"

nuke: clean
	docker system prune --all --force
	docker volume rm mariadb
	docker volume rm wordpress

.PHONY: all run go start stop re down clean nuke status