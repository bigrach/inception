FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
	gettext-base

COPY ./tools/conf/nginx.conf /etc/nginx/nginx.conf.template

COPY ./tools/entrypoint.sh .

RUN chmod +x entrypoint.sh

RUN mkdir -p /etc/nginx/certs && \
    openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/certs/server.key \
    -out /etc/nginx/certs/server.crt \
    -subj	"/CN=$DOMAIN/C=FR/ST=NA/L=Angouleme/O=42/OU=42/UID=$USER"

ENTRYPOINT ["./entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
