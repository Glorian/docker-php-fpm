FROM debian:stretch-slim

# Fix terminal (clean ...)
ENV TERM=linux

# Default Timezone
ENV TIMEZONE=UTC

RUN apt update \
    && apt dist-upgrade -y \
    && apt install -y --no-install-recommends \
        dialog cron curl apt-transport-https ca-certificates \
        zip unzip git gnupg supervisor \

        # Dependencies for pdf-genertor
        libxrender1 libxext6 \

        # Image optimization packages
        jpegoptim optipng pngquant gifsicle \

    # Cleaning
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Create named pipe for cron logs
RUN mkfifo --mode 0666 /var/log/cron.log

# make pam_loginuid.so optional for cron
# see https://github.com/docker/docker/issues/5663#issuecomment-42550548
RUN sed --regexp-extended --in-place \
    's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' \
    /etc/pam.d/cron

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

VOLUME ["/etc/supervisor/conf.d", "/var/www"]

ENTRYPOINT ["/entrypoint.sh"]
