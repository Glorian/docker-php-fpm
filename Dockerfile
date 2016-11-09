FROM debian:jessie

# Fix terminal (clean ...)
ENV TERM=linux

# Default timezone
ENV TIME_ZONE=UTC

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates zip unzip git \

    # Dependencies for pdf-genertor
    libxrender1 libxext6 \
    
    # Set default timezone
    && echo $TIME_ZONE > /etc/timezone \
    && dpkg-reconfigure -f noniteractive tzdata \

    # Cleaning
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
