FROM glorian/php-fpm:latest
MAINTAINER Igor Biletskiy <rjab4ik@gmail.com>

# Install dotdeb repo, PHP and selected extensions
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -

# Install nodeJS
RUN apt-get install -y nodejs build-essential git\
    # Install global npm packages
    && npm i -g npm@latest gulp bower \
    # Install Composer
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === '070854512ef404f16bac87071a6db9fd9721da1684cd4589b1196c3faf71b9a2682e2311b36a5079825e155ac7ce150d') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');" \
    # Sanitizing
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*