FROM glorian/php-fpm:php7.2-cli

# Default user id for www-data (as default docker-machine UID)
ARG USER_ID=1000
ARG XDEBUG_VERSION=2.6.1

# Install dotdeb repo, PHP and selected extensions
RUN apt-get update \
    # Installing php-fpm
    && apt-get -y --no-install-recommends install php7.2-fpm php7.2-dev \
    make wget

# Install Xdebug
RUN cd /tmp && wget https://xdebug.org/files/xdebug-${XDEBUG_VERSION}.tgz \
    && tar -xvzf xdebug* \
    && cd xdebug* \
    && phpize && ./configure && make \
    && cp modules/xdebug.so $(php-config --extension-dir)

COPY files/xdebug.ini /etc/php/7.2/mods-available/

# Cleaning
RUN apt-get purge -y php7.2-dev make wget \
    && apt-get clean && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Configure FPM to run properly on docker
RUN sed -i "/listen = .*/c\listen = [::]:9000" /etc/php/7.2/fpm/pool.d/www.conf \
    && sed -i "/;access.log = .*/c\access.log = /proc/self/fd/2" /etc/php/7.2/fpm/pool.d/www.conf \
    && sed -i "/;clear_env = .*/c\clear_env = no" /etc/php/7.2/fpm/pool.d/www.conf \
    && sed -i "/;catch_workers_output = .*/c\catch_workers_output = yes" /etc/php/7.2/fpm/pool.d/www.conf \
    && sed -i "/pid = .*/c\;pid = /run/php/php7.2-fpm.pid" /etc/php/7.2/fpm/php-fpm.conf \
    && sed -i "/;daemonize = .*/c\daemonize = no" /etc/php/7.2/fpm/php-fpm.conf \
    && sed -i "/error_log = .*/c\error_log = /proc/self/fd/2" /etc/php/7.2/fpm/php-fpm.conf

RUN bin/bash -c "if [[ ! -z \"$USER_ID\" && \"$USER_ID\" -ne \"0\" ]]; then usermod -u ${USER_ID} www-data; fi"

# The following runs FPM and removes all its extraneous log output on top of what your app outputs to stdout
CMD /usr/sbin/php-fpm7.2 -F -O 2>&1 | sed -u 's,.*: \"\(.*\)$,\1,'| sed -u 's,"$,,' 1>&1

EXPOSE 9000
