FROM glorian/php-fpm:php7

ENV PHALCON_VERSION=3.0.3

RUN apt-get update \
    && apt-get install -y --no-install-recommends php7.0-dev libpcre3-dev gcc make

# Building Phalcon
RUN cd /tmp \
    && curl -LO https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz \
    && tar xzf v${PHALCON_VERSION}.tar.gz && cd cphalcon-${PHALCON_VERSION}/build \
    && ./install \
    && rm -rf v${PHALCON_VERSION}.tar.gz cphalcon-${PHALCON_VERSION}

# Configs
RUN cd /etc/php/7.0/ \
    && echo "extension=phalcon.so" > mods-available/phalcon.ini

# Enable phalcon extension
RUN /usr/sbin/phpenmod phalcon

# Cleaning
RUN apt-get -y purge php7.0-dev libpcre3-dev gcc make \
    && apt-get clean && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
