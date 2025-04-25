FROM alpine:3.18

ARG DEBUG=0
ARG NGINX_INSTALL=1
ENV NGINX_INSTALL=$NGINX_INSTALL
ENV APP_DIR=/app
ENV NGINX_PHP_PATH=$APP_DIR

RUN apk update
RUN apk add --no-cache runit curl php82 php82-fpm dos2unix
# Install Nginx if needed
RUN if [ "$NGINX_INSTALL" == "1" ]; then apk add --no-cache nginx; fi
# Install PHP Extensions
RUN apk add --no-cache php82-iconv php82-zip php82-openssl php82-phar php82-curl php82-sodium php82-mbstring php82-pdo \
    php82-pdo_pgsql php82-pecl-redis php82-fileinfo php82-gettext php82-gd php82-pecl-ssh2 php82-xml php82-dom php82-xmlwriter
RUN ln -s /usr/bin/php82 /usr/bin/php && ln -s /usr/sbin/php-fpm82 /usr/bin/php-fpm
# Install PHP CS Fixer & XDebug
RUN if [ "$DEBUG" == "1" ]; then apk add --no-cache php82-pecl-xdebug php82-tokenizer && wget https://cs.symfony.com/download/php-cs-fixer-v3.phar -O /usr/bin/php-cs-fixer && chmod a+x /usr/bin/php-cs-fixer; fi
RUN if [ "$DEBUG" == "1" ]; then echo -e "zend_extension=xdebug.so\nxdebug.mode=debug\nxdebug.discover_client_host=1\nxdebug.client_host=host.docker.internal" > /etc/php82/conf.d/50_xdebug.ini; fi

# Copy docker files
COPY docker /

# Remove nginx configs if not installed
RUN if [ "$NGINX_INSTALL" != "1" ]; then rm -rf /etc/nginx /etc/service/nginx; fi

RUN rm -r /etc/php82/php-fpm.d && ln -s /etc/php/php-fpm.d /etc/php82/php-fpm.d
# Fix permissions for executable files
RUN chmod a+x /docker-entrypoint.sh
RUN chmod a+x /etc/service/*/run
RUN chmod a+x /docker-entrypoint-init.d/*.sh

# Fix line endings on scripts
RUN dos2unix /docker-entrypoint.sh
RUN dos2unix /docker-entrypoint-init.d/*
RUN dos2unix /etc/service/*/run


COPY --from=composer /usr/bin/composer /usr/bin/composer

WORKDIR $APP_DIR
COPY src .

# Add user for laravel
RUN adduser -D www
RUN chown -R www:www .

# Nginx Port
EXPOSE 80
# FPM Port
EXPOSE 9000

HEALTHCHECK --start-period=10s  --timeout=10s CMD curl http://127.0.0.1/fpm-ping 2> /dev/null || exit 1

ENTRYPOINT ["/docker-entrypoint.sh"]