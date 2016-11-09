#!/bin/bash
set -e

if [ "$TIMEZONE" ]; then
    echo $TIMEZONE > /etc/timezone
    dpkg-reconfigure -f noninteractive tzdata > /dev/null 2>&1
fi

exec "$@"
