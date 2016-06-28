FROM glorian/php-fpm:latest
MAINTAINER Igor Biletskiy <rjab4ik@gmail.com>

# Install dotdeb repo, PHP and selected extensions
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -

# Install nodeJS
RUN apt-get install -y nodejs build-essential git \
    # Install global npm packages
    && npm i -g npm@latest gulp bower \
    # Install Composer
    && curl -o /usr/local/bin/composer https://getcomposer.org/composer.phar \
    && chmod +x /usr/local/bin/composer \
    # Sanitizing
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*