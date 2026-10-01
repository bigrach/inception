include srcs/.env

all: 
	mkdir -p /home/me/data/mariadb
	mkdir -p /home/me/data/wordpress
	docker compose -f ./srcs/docker-compose.yml up --build 

re: nuke all

down: 
	docker compose -f ./srcs/docker-compose.yml down

clean: down 
	sudo rm -rf /home/me/data/mariadb && echo "youpi"
	sudo rm -rf /home/me/data/wordpress && echo "youpi2"

nuke: clean
	docker system prune --all --force
