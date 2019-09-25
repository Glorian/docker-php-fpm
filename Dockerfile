FROM php:7.1

LABEL maintainer="rjab4ik@gmail.com"

RUN apt-get update -yqq \
    && apt-get install -yqq --no-install-recommends build-essential openssh-client \
    dialog apt-transport-https zip unzip git gnupg libpng-dev python python3 \
    libmagickwand-dev libmcrypt-dev libcurl4-gnutls-dev libicu-dev zlib1g-dev \
    libsqlite3-dev libldap2-dev libedit-dev rsync lftp sshpass

# Imagic extension
RUN pecl install imagick \
    && docker-php-ext-enable imagick \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-configure bcmath --enable-bcmath \
    && docker-php-ext-install mbstring \
        mcrypt \
        bcmath \
        gd \
        curl \
        json \
        exif \
        intl \
        xml \
        zip \
        bz2 \
        opcache \
        pdo \
        pdo_mysql \
        pdo_sqlite \
        mysqli \
        iconv \
        fileinfo \
        readline \
        session \
        dom \
        ldap \
    # Setup composer
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer global require hirak/prestissimo \
    # Latest git-ftp
    && git clone https://github.com/git-ftp/git-ftp.git ~/git-ftp && cd ~/git-ftp \
    # choose the newest release
    # && tag="$(git tag | grep '^[0-9]*\.[0-9]*\.[0-9]*$' | tail -1)" \
    # checkout the latest tag
    # && git checkout "$tag" \
    && git checkout "1.5.2" \
    && make install \
    # Add nodeJS and yarn repos
    && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    # Update sources
    && apt-get update -yqq \
    # Install soft
    && apt-get install -yqq --no-install-recommends nodejs yarn \
    # Install global npm packages
    && npm i -g npm@latest gulp bower \
    # Sanitizing
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* ~/git-ftp

COPY scripts/git_copy.sh /scripts/git_copy.sh

RUN find /scripts -type f -exec chmod +x {} \;
