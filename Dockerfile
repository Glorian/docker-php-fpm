FROM debian:stretch

ENV TERM=linux
ENV PHALCON_VERSION=3.2.4

RUN apt-get -qq update \
    && apt-get install -yqq --no-install-recommends \
    dialog curl apt-transport-https ca-certificates zip unzip git gnupg

# Install sury repo, PHP and selected extensions
# Sury source
RUN echo "deb https://packages.sury.org/php/ stretch main" > /etc/apt/sources.list.d/sury.list \
    && curl -sS https://packages.sury.org/php/apt.gpg | apt-key add - \
    && apt-get -qq update

# Installing php packages
RUN apt-get -yqq --no-install-recommends install php7.1-dev libpcre3-dev gcc make \
    php-apcu php-apcu-bc php-imagick \
    php7.1-cli php7.1-gd php7.1-mbstring php7.1-redis php7.1-zip php7.1-ldap \
    php7.1-apcu php7.1-apcu-bc php7.1-mysql php7.1-sqlite3 php7.1-curl php7.1-json \
    php7.1-mcrypt php7.1-opcache php7.1-readline php7.1-memcached php7.1-intl php7.1-xml

# Setup composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Composer parallel install plugin
RUN composer global require hirak/prestissimo

# Building Phalcon
RUN cd /tmp \
    && curl -LO https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz \
    && tar xzf v${PHALCON_VERSION}.tar.gz && cd cphalcon-${PHALCON_VERSION}/build \
    && ./install \
    && rm -rf v${PHALCON_VERSION}.tar.gz cphalcon-${PHALCON_VERSION}

# Configs
RUN cd /etc/php/7.1/ \
    && echo "extension=phalcon.so" > mods-available/phalcon.ini

# Enable phalcon extension
RUN /usr/sbin/phpenmod phalcon

# Cleaning
RUN apt-get -yqq purge php7.1-dev libpcre3-dev gcc make \
    && apt-get clean && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* ~/.composer/cache/*
