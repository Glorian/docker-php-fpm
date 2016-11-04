FROM glorian/php-fpm:php56

ENV PHALCON_VERSION_TAG=phalcon-v1.3.4
ENV IGBINARY_VERSION=2.0.0

RUN apt-get update \
    && apt-get install -y --no-install-recommends php5-dev libpcre3-dev gcc make

# Building Phalcon (1.*)
RUN cd /tmp \
    && curl -LO https://github.com/phalcon/cphalcon/archive/${PHALCON_VERSION_TAG}.tar.gz \
    && tar xzf ${PHALCON_VERSION_TAG}.tar.gz && cd cphalcon-${PHALCON_VERSION_TAG}/build \
    && ./install \
    && rm -rf ${PHALCON_VERSION_TAG}.tar.gz cphalcon-${PHALCON_VERSION_TAG}

# Building Igbinary PHP serializer
RUN cd /tmp \
    && curl -LO https://github.com/igbinary/igbinary/archive/${IGBINARY_VERSION}.tar.gz \
    && tar xzf ${IGBINARY_VERSION}.tar.gz && cd igbinary-${IGBINARY_VERSION} \
    && phpize \
    && ./configure CFLAGS="-O2 -g" --enable-igbinary && make && make test && make install \
    && rm -rf ${IGBINARY_VERSION}.tar.gz igbinary-${IGBINARY_VERSION}

# Configs
RUN cd /etc/php5/ \
    && echo "extension=phalcon.so" > mods-available/phalcon.ini \
    && echo "extension=igbinary.so\nsession.serialize_handler=igbinary\nigbinary.compact_strings=On" > mods-available/igbinary.ini

RUN /usr/sbin/php5enmod phalcon \
    && /usr/sbin/php5enmod igbinary

# Cleaning
RUN apt-get -y purge php5-dev libpcre3-dev gcc make \
    && apt-get clean && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
