FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    nginx \
    openssl

COPY ./tools/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /etc/nginx/certs && \
    openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/certs/server.key \
    -out /etc/nginx/certs/server.crt \
    -subj	"/CN=localhost/C=FR/ST=NA/L=Angouleme/O=42/OU=42/CN=$DOMAIN/UID=$USER"

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
