FROM glorian/php-fpm:base

# Install dotdeb repo, PHP and selected extensions
# DotDeb source
RUN echo "deb http://packages.dotdeb.org jessie all" > /etc/apt/sources.list.d/dotdeb.list \
    && echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list.d/dotdeb.list \
    && curl -sS https://www.dotdeb.org/dotdeb.gpg | apt-key add - \

    # Installing php packages
    && apt-get update \
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
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* ~/.composer

CMD ["php", "-a"]
