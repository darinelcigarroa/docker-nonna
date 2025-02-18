FROM php:8.4-fpm-alpine

# Aceptar argumentos de nombre de usuario y UID
ARG USER
ARG UID

RUN apk add sudo

# Set working directory
WORKDIR /var/www

# Install system dependencies
RUN apk add --no-cache linux-headers
RUN apk update && apk add --no-cache ${PHPIZE_DEPS} \
    libxml2-dev \
    libpng-dev \
    libzip-dev \
    libxslt-dev \
    curl \
    postgresql-dev \
    zsh

# Install PHP extensions
RUN docker-php-ext-install soap pdo pdo_pgsql exif pcntl bcmath gd intl zip xsl sockets

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Clear cache
RUN rm -rf /var/cache/apk/*

# Agregar usuario y grupo con el UID proporcionado
RUN addgroup -g $UID -S $USER && \
    adduser -u $UID -S $USER -G $USER -s /bin/sh && \
    adduser $USER www-data

RUN echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Cambiar al usuario proporcionado
USER $USER
