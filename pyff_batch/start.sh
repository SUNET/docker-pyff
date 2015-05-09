#!/bin/sh
# startup script used in entrypoint of the docker container


# invoke pyff every 10 minutes
exec="/usr/local/bin/pyff --logfile=$LOGFILE --loglevel=$LOGLEVEL $PIPELINE > /dev/null 2>&1"
echo "*/$PERIOD * * * * root $exec" > /etc/crontab

if [ -z "${LOGFILE}" ]; then
    :
else
    echo LOGFILE set
    mkdir -p $(dirname $LOGFILE)
fi

# start cron
# ubuntu/vixie cron has a starting problem in a docker container.
# Workaround: start as daemon; wait until it started, then modify /etc/crontab.
/usr/sbin/cron
sleep 10
echo "\n# touched to kickstart crond" >> /etc/crontab
tail -f /etc/crontab   # do something forever