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

DEFAULT_COMMAND="gunicorn --bind 0.0.0.0:${PORT} --threads 10 --env PYFF_PIPELINE=${PIPELINE} --log-level ${LOGLEVEL} --timeout=600 ${EXTRA_ARGS} pyff.wsgi:app"

if [ $# -gt 0 ]; then
   exec $*
else
   exec ${DEFAULT_COMMAND}
fi
