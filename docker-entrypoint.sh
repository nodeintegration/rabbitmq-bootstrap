#!/bin/sh
set -e


echo "Starting up..."
if [ "${1}" = "bootstrap" ]; then
  POLICIES=$(curl -sS http://${RANCHER_API_HOST}/${RANCHER_API_VERSION}/self/service/metadata/policies)
  
  if ( "${POLICIES}" = "Not found" ); then
    echo "[INFO]: cant find any policies...skipping"
  else
    for policy in $POLICIES; do
      # strip the tailing slash
      policy=$(echo "${policy}" | cut -d '/' -f 1)
      echo "[INFO]: creating policy: ${policy}"
      pattern=$(curl -sS http://${RANCHER_API_HOST}/${RANCHER_API_VERSION}/self/service/metadata/policies/$policy/pattern)
      definition=$(curl -sS http://${RANCHER_API_HOST}/${RANCHER_API_VERSION}/self/service/metadata/policies/$policy/definition)
      json=$(cat <<EOF
{
  "pattern":"${pattern}",
  "definition": ${definition}
}
EOF
)
      STATUSCODE=$(curl \
        --silent \
        --output /dev/stderr \
        --write-out "%{http_code}" \
        -X PUT \
        -H "Content-Type: application/json" \
        -H "Accept: application/json" \
        -d "${json}" \
        -i -u "guest:guest" \
        http://rabbitmq:15672/api/policies/%2f/${policy})
      echo "[INFO]: Status code: $STATUSCODE"
      if [[ $STATUSCODE -eq 204 || $STATUSCODE -eq 200 ]]; then
        echo "[INFO]: created policy: ${policy}"
      else
        echo "[ERROR]: failed to create policy: ${policy} with statuscode: ${STATUSCODE}"
        exit 1
      fi
    done
  fi

fi

exec $@
