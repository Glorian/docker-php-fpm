FROM php:7
MAINTAINER Igor Biletskiy <rjab4ik@gmail.com>

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends build-essential git-ftp openssh-client \
       dialog apt-transport-https zip unzip git gnupg libpng-dev python python3 \
       libmagickwand-dev libmcrypt-dev libcurl4-gnutls-dev libicu-dev zlib1g-dev

RUN pecl install imagick \
    && docker-php-ext-enable imagick

# PHP extensions
RUN docker-php-ext-install mbstring mcrypt gd curl json \
    intl gd xml zip bz2 opcache pdo pdo_mysql sqlite3 readline 

# Setup composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer global require hirak/prestissimo

# Add nodeJS and yarn repos
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Update sources
RUN apt-get update -yqq

# Install soft
RUN apt-get install -yqq --no-install-recommends nodejs yarn \
    
    # Install global npm packages
    && npm i -g npm gulp bower \
    
    # Sanitizing
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
