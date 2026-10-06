FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    curl \
	php-fpm \
    php-mysqli

COPY ./tools/entrypoint.sh .

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN chmod +x entrypoint.sh \
    wp-cli.phar

RUN mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /run/php

RUN wp cli update

ENTRYPOINT ["./entrypoint.sh"]

CMD ["php-fpm8.2", "-F"]
