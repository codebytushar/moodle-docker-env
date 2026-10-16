FROM php:8.3-apache

# Install helper script for installing PHP extensions
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Install system dependencies and required PHP extensions for Moodle 5.3
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    unzip \
    zip \
    curl \
    ghostscript \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

RUN install-php-extensions \
    bcmath \
    curl \
    exif \
    gd \
    intl \
    mbstring \
    mysqli \
    opcache \
    soap \
    sodium \
    xml \
    zip \
    xdebug

# Enable Apache modules
RUN a2enmod rewrite headers expires

# Copy Apache virtual host config and PHP custom settings
COPY docker/apache-moodle.conf /etc/apache2/sites-available/000-default.conf
COPY docker/php.ini $PHP_INI_DIR/conf.d/moodle.ini

# Ensure proper permissions for www-data
WORKDIR /var/www/html

EXPOSE 80
