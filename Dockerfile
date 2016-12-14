FROM glorian/php-fpm:php7-cli
MAINTAINER Igor Biletskiy <rjab4ik@gmail.com>

# Install dotdeb repo, PHP and selected extensions
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install nodeJS
RUN apt-get update \
    && apt-get install -y --no-install-recommends nodejs yarn build-essential \
    # Install global npm packages
    && npm i -g npm@latest gulp bower \
    # Sanitizing
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
