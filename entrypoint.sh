#!/usr/bin/env bash
set -e

# make custom location of /etc/cron.d if provided
if [ "${CRON_PATH}" ]; then
    echo "CRON_PATH provided: /etc/cron.d -> ${CRON_PATH}"

 	cp $CRON_PATH/* /etc/cron.d/
fi

# Set default timezone
if [ "$TIMEZONE" ]; then
    echo $TIMEZONE > /etc/timezone
    dpkg-reconfigure -f noninteractive tzdata > /dev/null 2>&1
fi

# Permissions for cron jobs
chown -R root:root /etc/cron.d
chmod -R go-w /etc/cron.d

# Start cron (silently)
service cron start > /dev/null 2>&1

# Start supervisor in daemon mode
supervisord --configuration /etc/supervisor/supervisord.conf

# Trap SIGINT and SIGTERM signals and gracefully exit
trap "service cron stop; kill \$!; exit" SIGINT SIGTERM

exec $@
