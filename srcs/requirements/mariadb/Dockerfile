FROM debian:bookworm

RUN apt-get update && apt-get install -y \
	mariadb-client \
	mariadb-server \
	gettext-base

COPY ./tools/conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf.template

COPY ./tools/entrypoint.sh .

RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]

CMD ["sh", "-c", "mysqld --user=mysql"]
