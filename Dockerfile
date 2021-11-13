FROM php:7.4-apache


RUN apt update && apt install -y --no-install-recommends \
        git \
        zip \
        curl \
        libzip-dev \
        zlib1g-dev \
        unzip \
        libonig-dev \
        graphviz \
        libxml2-dev \
        libcurl4-openssl-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libwebp-dev \
        libpng-dev && \
    rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype --with-webp --with-jpeg && \
    docker-php-ext-install gd

RUN docker-php-ext-install pdo_mysql zip dom curl mbstring intl

RUN useradd -rm -d /home/php -s /bin/bash -g root -G sudo -u 1001 php


RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY . /var/www/html

WORKDIR /var/www/html

RUN chown -R 1001:0 /var/www/html


USER 1001

RUN composer install --no-interaction --no-dev --prefer-dist

USER root

RUN chmod -R 777 /var/www/html
RUN a2enmod rewrite
RUN service apache2 restart

USER 1001


