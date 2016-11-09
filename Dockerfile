FROM debian:jessie

# Fix terminal (clean ...)
ENV TERM=linux

# Default Timezone
ENV TIMEZONE=UTC

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates zip unzip git \

    # Dependencies for pdf-genertor
    libxrender1 libxext6 \

    # Cleaning
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
