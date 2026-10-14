include srcs/.env

# colors 
COLOR = "\e[1;36m"
RESET = "\e[0m"

# rules
all: dircreate
	docker compose -f ./srcs/docker-compose.yml build

dircreate:
	@mkdir -p ${VOLUME_PATH} && echo "creating data directory"
	@mkdir -p ${MDB_VOLUME} && echo "creating mariadb data directory"
	@mkdir -p ${WP_VOLUME} && echo "creating wordpress data directory"

run: 
	docker compose -f ./srcs/docker-compose.yml up

go: dircreate
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
clean: 
	docker compose -f ./srcs/docker-compose.yml down --rmi all --volumes --remove-orphans
	@sudo rm -rf ${MDB_VOLUME} && echo "mariadb data deleted"
	@sudo rm -rf ${WP_VOLUME} && echo "wordpress data deleted"

nuke: clean 
	@docker images -qa | xargs -r docker rmi -f && echo  ${COLOR}"deleting ALL images"${RESET}
	@docker volume ls -q | xargs -r docker volume rm && echo ${COLOR}"deleting ALL volumes"${RESET}
	@docker system prune --all --force --volumes && echo ${COLOR}"removing ALL unused data"${RESET}

.PHONY: all run go start stop re down mariadb wordpress nginx status clean nuke dircreate