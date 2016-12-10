FROM debian:jessie

# Fix terminal (clean ...)
ENV TERM=linux

# Default Timezone
ENV TIMEZONE=UTC

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    dialog cron curl ca-certificates zip unzip git \

    # Dependencies for pdf-genertor
    libxrender1 libxext6 \

    # Cleaning
    && apt-get clean \
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

ENTRYPOINT ["/entrypoint.sh"]