FROM glorian/php-fpm:base

# Install sury repo, PHP and selected extensions
# Sury source
RUN echo "deb https://packages.sury.org/php/ stretch main" > /etc/apt/sources.list.d/sury.list \
    && curl -sS https://packages.sury.org/php/apt.gpg | apt-key add - \
    && apt-get update

# Installing php packages
RUN apt-get -y --no-install-recommends install php-apcu php-apcu-bc php-imagick \
    php7.2-cli php7.2-gd php7.2-mbstring php7.2-redis php7.2-zip php7.2-ldap \
    php7.2-apcu php7.2-apcu-bc php7.2-mysql php7.2-sqlite3 php7.2-curl php7.2-json \
    php7.2-opcache php7.2-readline php7.2-memcached php7.2-intl php7.2-xml

# Setup composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Composer parallel install plugin
RUN composer global require hirak/prestissimo

# Cleaning
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* ~/.composer/cache/*

CMD ["php", "-a"]
