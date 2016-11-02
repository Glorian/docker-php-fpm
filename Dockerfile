FROM debian:jessie

# Fix terminal (clean ...)
ENV TERM=linux

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates zip unzip \

    # Dependencies for pdf-genertor
    libxrender1 libxext6 \

    # Cleaning
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
