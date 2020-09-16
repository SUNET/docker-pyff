#!/bin/bash

if [ -z "${DATADIR}" ]; then
   export DATADIR="/tmp/pyff"
fi

mkdir -p ${DATADIR} && cd ${DATADIR}

if [ -z "${LOGLEVEL}" ]; then
   export LOGLEVEL="INFO"
fi

if [ -z "${PIPELINE}" ]; then
   export PIPELINE="mdx.fd"
fi

if [ -z "${PORT}" ]; then
   export PORT="8080"
fi

if [ ! -f "${PIPELINE}" ]; then
   cp /mdx.fd "${PIPELINE}"
   openssl genrsa 4096 > default.key
   openssl req -x509 -sha1 -new -subj "/CN=Default Metadata Signer" -key default.key -out default.crt
fi

mkdir -p /var/run

CMD="gunicorn --log-config ${LOGCONFIG:-warn.ini} --preload -e PYFF_PUBLIC_URL=$PUBLIC_URL -e PYFF_UPDATE_FREQUENCY=${UPDATE_FREQUENCY:-300} --bind 0.0.0.0:${PORT} --worker-tmp-dir=/dev/shm --worker-class=gthread --threads 10 -e PYFF_PIPELINE=${PIPELINE} --log-level ${LOGLEVEL} --timeout=600 ${EXTRA_ARGS} pyff.wsgi:app"

if [ $# -gt 0 ]; then
   exec $*
else
   exec ${CMD}
fi
