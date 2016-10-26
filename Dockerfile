FROM debian:jessie
MAINTAINER Igor Biletskiy <rjab4ik@gmail.com>

# Default user id for www-data (as default docker-machine UID)
ARG USER_ID=1000

ENV TERM=linux

# Install dotdeb repo, PHP and selected extensions
RUN apt-get update \
	&& apt-get install -y --no-install-recommends curl ca-certificates \
	# Dependencies for pdf-genertor
    libxrender1 libxext6 \

    # DotDeb source
    && echo "deb http://packages.dotdeb.org jessie all" > /etc/apt/sources.list.d/dotdeb.list \
    && echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list.d/dotdeb.list \
    && curl -sS https://www.dotdeb.org/dotdeb.gpg | apt-key add - \

    # Installing php packages
    && apt-get update \
    && apt-get -y --no-install-recommends install php7.0-cli php7.0-fpm php7.0-gd \
    	php7.0-mbstring php7.0-apcu php7.0-apcu-bc php7.0-redis \
        php7.0-mysql php7.0-curl php7.0-json php7.0-intl php7.0-xml \
        php7.0-mcrypt php7.0-opcache php7.0-readline php7.0-memcached \

    # Setup composer
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \

    # Cleaning
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* ~/.composer

RUN bin/bash -c "if [[ ! -z \"$USER_ID\" && \"$USER_ID\" -ne \"0\" ]]; then usermod -u ${USER_ID} www-data; fi"

# Configure FPM to run properly on docker
RUN sed -i "/listen = .*/c\listen = [::]:9000" /etc/php/7.0/fpm/pool.d/www.conf \
    && sed -i "/;access.log = .*/c\access.log = /proc/self/fd/2" /etc/php/7.0/fpm/pool.d/www.conf \
    && sed -i "/;clear_env = .*/c\clear_env = no" /etc/php/7.0/fpm/pool.d/www.conf \
    && sed -i "/;catch_workers_output = .*/c\catch_workers_output = yes" /etc/php/7.0/fpm/pool.d/www.conf \
    && sed -i "/pid = .*/c\;pid = /run/php/php7.0-fpm.pid" /etc/php/7.0/fpm/php-fpm.conf \
    && sed -i "/;daemonize = .*/c\daemonize = no" /etc/php/7.0/fpm/php-fpm.conf \
    && sed -i "/error_log = .*/c\error_log = /proc/self/fd/2" /etc/php/7.0/fpm/php-fpm.conf

# The following runs FPM and removes all its extraneous log output on top of what your app outputs to stdout
CMD /usr/sbin/php-fpm7.0 -F -O 2>&1 | sed -u 's,.*: \"\(.*\)$,\1,'| sed -u 's,"$,,' 1>&1

EXPOSE 9000
