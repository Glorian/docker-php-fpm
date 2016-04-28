FROM debian:jessie
MAINTAINER Igor Biletskiy <rjab4ik@gmail.com>

# Default user id for www-data (as default docker-machine UID)
ARG USER_ID=1000

# Install dotdeb repo, PHP and selected extensions
RUN apt-get update \
    && apt-get install -y curl libxrender1 libxext6 \
    && apt-get -y --no-install-recommends install php5-cli php5-gd php5-fpm \
        php5-mysqlnd php5-memcache php5-redis php5-apcu php5-curl php5-json \
        php5-mcrypt php5-readline \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Configure FPM to run properly on docker
RUN sed -i "/listen = .*/c\listen = [::]:9000" /etc/php5/fpm/pool.d/www.conf \
    && sed -i "/;access.log = .*/c\access.log = /proc/self/fd/2" /etc/php5/fpm/pool.d/www.conf \
    && sed -i "/;clear_env = .*/c\clear_env = no" /etc/php5/fpm/pool.d/www.conf \
    && sed -i "/;catch_workers_output = .*/c\catch_workers_output = yes" /etc/php5/fpm/pool.d/www.conf \
    && sed -i "/pid = .*/c\;pid = /run/php/php5-fpm.pid" /etc/php5/fpm/php-fpm.conf \
    && sed -i "/;daemonize = .*/c\daemonize = no" /etc/php5/fpm/php-fpm.conf \
    && sed -i "/error_log = .*/c\error_log = /proc/self/fd/2" /etc/php5/fpm/php-fpm.conf

RUN bin/bash -c "if [[ ! -z \"$USER_ID\" && \"$USER_ID\" -ne \"0\" ]]; then usermod -u ${USER_ID} www-data; fi"

EXPOSE 9000
CMD ["/usr/sbin/php5-fpm"]