FROM glorian/php-fpm:base

# Install dotdeb repo, PHP, composer and selected extensions
RUN apt-get update \
    && apt-get -y --no-install-recommends install php5-cli php5-gd php5-mysqlnd \
        php5-memcache php5-redis php5-apcu php5-curl php-pclzip php5-imagick \
        php5-json php5-mcrypt php5-readline php5-intl \

    # Setup composer
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    
    # Composer parallel install plugin.
    && composer global require hirak/prestissimo \

    # Clean
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

CMD ["php", "-a"]
