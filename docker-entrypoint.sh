#!/bin/sh
set -e


echo "Starting up..."
sleep 500000
if [ "${1}" = "bootstrap" ]; then
  if [ "${SSL_BASE64_ENCODED}" != 'false' ]; then
    curl -sS http://${RANCHER_API_HOST}/${RANCHER_API_VERSION}/self/service/metadata/ssl_key >> ${HAPROXY_SSL_CERT}
  fi
fi

exec $@
