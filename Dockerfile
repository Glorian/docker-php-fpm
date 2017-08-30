FROM glorian/php-fpm:php7.1-cli
MAINTAINER Igor Biletskiy <rjab4ik@gmail.com>

# Install dotdeb repo, PHP and selected extensions
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Update sources
RUN apt-get update

# Install soft
RUN apt-get install -y --no-install-recommends nodejs yarn build-essential git-ftp \
    
    # Install global npm packages
    && npm i -g npm gulp bower \
    
    # Sanitizing
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
