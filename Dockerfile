FROM glorian/php-fpm:base

# Install PHP repo
RUN echo "deb https://packages.sury.org/php/ stretch main" > /etc/apt/sources.list.d/sury.list \
    && curl -sS https://packages.sury.org/php/apt.gpg | apt-key add - 

# Install dotdeb repo, PHP, composer and selected extensions
RUN apt-get update \
    && apt-get -y --no-install-recommends install php5.6-cli php5.6-gd php5.6-mysqlnd \
        php5.6-memcache php5.6-redis php5.6-apcu php5.6-curl php-pclzip php5.6-imagick \
        php5.6-json php5.6-mcrypt php5.6-readline php5.6-intl \
    # Setup composer
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    # Composer parallel install plugin.
    && composer global require hirak/prestissimo \
    # Clean
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* /root/.composer/cache/*

CMD ["php", "-a"]
