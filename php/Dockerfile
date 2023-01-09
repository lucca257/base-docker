ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm-alpine

USER root

RUN apk --update add wget \
  curl \
  git \
  build-base \
  libmcrypt-dev \
  libxml2-dev \
  pcre-dev \
  zlib-dev \
  autoconf \
  cyrus-sasl-dev \
  libgsasl-dev \
  oniguruma-dev \
  libressl \
  libressl-dev \
  supervisor

# mysqli package:
###########################################################################
RUN pecl channel-update pecl.php.net; \
    docker-php-ext-install mysqli mbstring pdo pdo_mysql xml pcntl
###########################################################################
# ZIP package:
###########################################################################
RUN apk add --no-cache \
      libzip-dev \
      zip \
    && docker-php-ext-install zip
###########################################################################
# GD package:
###########################################################################
#    apk add --update --no-cache freetype-dev libjpeg-turbo-dev jpeg-dev libpng-dev; \
RUN apk add --update \
		$PHPIZE_DEPS \
		freetype-dev \
		libjpeg-turbo-dev \
		libpng-dev \
		libxml2-dev \
		libzip-dev \
	&& docker-php-ext-configure gd --with-jpeg --with-freetype \
	&& docker-php-ext-install gd
###########################################################################
# Redis:
###########################################################################
ARG INSTALL_REDIS=false
RUN if [ ${INSTALL_REDIS} = true ]; then \
    if [ $(php -r "echo PHP_MAJOR_VERSION;") = "5" ]; then \
      printf "\n" | pecl install -o -f redis-4.3.0; \
    else \
      printf "\n" | pecl install -o -f redis; \
    fi; \
    rm -rf /tmp/pear; \
    docker-php-ext-enable redis \
;fi
###########################################################################
# KAFKA:
###########################################################################
ARG INSTALL_KAFKA=false
RUN if [ ${INSTALL_KAFKA} = true ]; then \
    apk add -qq librdkafka-dev && \
    pecl install rdkafka && \
    docker-php-ext-enable rdkafka \
;fi
###########################################################################
# Opcache:
###########################################################################
ARG INSTALL_OPCACHE=false
RUN if [ ${INSTALL_OPCACHE} = true ]; then \
    docker-php-ext-install opcache \
;fi
###########################################################################
# MySQL Client:
###########################################################################
USER root
ARG INSTALL_MYSQL_CLIENT=false
RUN if [ ${INSTALL_MYSQL_CLIENT} = true ]; then \
    docker-php-ext-install mysqli \
;fi
###########################################################################
# zookeeper
###########################################################################
ARG INSTALL_ZOOKEEPER=false
RUN set -eux; \
    if [ ${INSTALL_ZOOKEEPER} = true ]; then \
    apk add libzookeeper-dev; \
    if [ $(php -r "echo PHP_MAJOR_VERSION;") = "8" ]; then \
      curl -L -o /tmp/php-zookeeper.tar.gz https://github.com/php-zookeeper/php-zookeeper/archive/master.tar.gz; \
      mkdir -p /tmp/php-zookeeper; \
      tar -C /tmp/php-zookeeper -zxvf /tmp/php-zookeeper.tar.gz --strip 1; \
      cd /tmp/php-zookeeper; \
      phpize && ./configure && make && make install;\
    else \
      if [ $(php -r "echo PHP_MAJOR_VERSION;") = "5" ]; then \
        pecl install zookeeper-0.5.0; \
      else \
        pecl install zookeeper-0.7.2; \
      fi; \
    fi; \
    docker-php-ext-enable zookeeper; \
    php -m | grep -q 'zookeeper'; \
    fi
###########################################################################
# Exif:
###########################################################################
ARG INSTALL_EXIF=false
RUN if [ ${INSTALL_EXIF} = true ]; then \
    # Enable Exif PHP extensions requirements
    docker-php-ext-install exif \
;fi
###########################################################################
# composer:
###########################################################################
# php extentions
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
###########################################################################
# Setup working directory
WORKDIR /var/www
# Setup permissions
RUN chmod -R 777 .
# Enable projects as safe in git
RUN git config --global --add safe.directory '*'
ARG GITHUB_TOKEN
RUN composer config -g github-oauth.github.com ${GITHUB_TOKEN}
EXPOSE 9000
CMD php-fpm
