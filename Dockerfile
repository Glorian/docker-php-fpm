FROM glorian/php-fpm:base

# Install sury repo, PHP and selected extensions
# Sury source
RUN echo "deb https://packages.sury.org/php/ stretch main" > /etc/apt/sources.list.d/sury.list \
    && curl -sS https://packages.sury.org/php/apt.gpg | apt-key add -
    
# Installing php packages
RUN apt-get update \
    && apt-get -y --no-install-recommends install php7.0-cli php7.0-gd \
    	php7.0-mbstring php7.0-apcu php7.0-apcu-bc php7.0-redis php7.0-zip \
        php7.0-mysql php7.0-curl php7.0-json php7.0-intl php7.0-xml \
        php7.0-mcrypt php7.0-opcache php7.0-readline php7.0-memcached \

    # Setup composer
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    
     # Composer parallel install plugin.
    && composer global require hirak/prestissimo \

    # Cleaning
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* ~/.composer/cache/*

CMD ["php", "-a"]
