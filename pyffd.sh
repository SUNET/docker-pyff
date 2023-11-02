#!/bin/bash

if [ -z "${DATADIR}" ]; then
   export DATADIR="/tmp/pyff"
fi

mkdir -p ${DATADIR} && cd ${DATADIR}

. ${VENV}/bin/activate

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

CMD="pyffd -f --frequency=${UPDATE_FREQUENCY:-300} --loglevel=${LOGLEVEL} -H 0.0.0.0 -P ${PORT} -p /var/run/pyffd.pid --dir=${DATADIR} -C ${EXTRA_ARGS} ${PIPELINE}"

if [ $# -gt 0 ]; then
   exec $*
else
   exec ${CMD}
fi
