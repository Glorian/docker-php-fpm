FROM glorian/php-fpm:base

# Install sury repo, PHP and selected extensions
# Sury source
RUN echo "deb https://packages.sury.org/php/ stretch main" > /etc/apt/sources.list.d/sury.list \
    && curl -sS https://packages.sury.org/php/apt.gpg | apt-key add - \
    && apt-get update

# Installing php packages
RUN apt-get -y --no-install-recommends install php-apcu php-apcu-bc php-imagick \
    php7.1-cli php7.1-gd php7.1-mbstring php7.1-redis php7.1-zip php7.1-ldap \
    php7.1-apcu php7.1-apcu-bc php7.1-mysql php7.1-sqlite3 php7.1-curl php7.1-json \
    php7.1-mcrypt php7.1-opcache php7.1-readline php7.1-memcached php7.1-intl php7.1-xml

# Setup composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Composer parallel install plugin
RUN export COMPOSER_ALLOW_SUPERUSER=1 && composer global require hirak/prestissimo

# Cleaning
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* ~/.composer/cache/*

CMD ["php", "-a"]
