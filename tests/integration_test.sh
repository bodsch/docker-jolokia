#!/bin/bash

JOLOKIA_MASTER=${JOLOKIA_MASTER:-"localhost"}
JOLOKIA_API_PORT=${JOLOKIA_API_PORT:-8080}
JOLOKIA_JMX_PORT=${JOLOKIA_JMX_PORT:-22222}
JOLOKIA_API_USER="jolokia"
JOLOKIA_API_PASSWORD="passed"


CURL=$(which curl 2> /dev/null)
NC=$(which ncat 2> /dev/null)
NC_OPTS="-z"

if [[ -z "${NC}" ]]
then
  NC=$(which nc 2> /dev/null)
  NC_OPTS=
fi


# wait for the Icinga2 Master
#
wait_for_jolokia() {

  echo "wait for the jolokia service"
  RETRY=35
  until [[ ${RETRY} -le 0 ]]
  do
    ${NC} ${NC_OPTS} ${JOLOKIA_MASTER} ${JOLOKIA_API_PORT} < /dev/null > /dev/null

    [[ $? -eq 0 ]] && break

    sleep 5s
    RETRY=$(expr ${RETRY} - 1)
  done

  if [[ $RETRY -le 0 ]]
  then
    echo "could not connect to the jolokia service instance '${JOLOKIA_MASTER}'"
    exit 1
  fi
}

api_request() {

  local jolokia_version=

  code=$(curl \
    --silent \
    --user ${JOLOKIA_API_USER}:${JOLOKIA_API_PASSWORD} \
    --header 'Accept: application/json' \
    --insecure \
    http://${JOLOKIA_MASTER}:${JOLOKIA_API_PORT}/jolokia/)

  if [[ $? -eq 0 ]]
  then
    echo "api request are successfull"
    jolokia_version=$(echo "${code}" | jq --raw-output '.value.agent')
  else
    echo ${code}
    echo "api request failed"
  fi

  code=$(curl \
    --silent \
    --user ${JOLOKIA_API_USER}:${JOLOKIA_API_PASSWORD} \
    --header 'Accept: application/json' \
    --insecure \
    http://${JOLOKIA_MASTER}:${JOLOKIA_API_PORT}/jolokia/list)

  if [[ $? -eq 0 ]]
  then
    echo "api request for list are successfull"
  else
    echo ${code}
    echo "api request for list failed"
  fi

  # curl --verbose --user jolokia:passed --header 'Accept: application/json' http://localhost:8080/jolokia/read/java.lang:type=Memory/HeapMemoryUsage
  # curl --verbose --user jolokia:passed --header 'Accept: application/json' --header 'Content-Type: application/json'  http://localhost:8080/jolokia/ --data '{"type" : "read","mbean" : "java.lang:type=Memory","target" : { "url" : "service:jmx:rmi:///jndi/rmi://127.0.0.1:22222/jmxrmi" }}'

  cat > memory.json << EOF
{
  "type" : "read",
  "mbean" : "java.lang:type=Memory",
  "target" : { "url" : "service:jmx:rmi:///jndi/rmi://${JOLOKIA_MASTER}:${JOLOKIA_JMX_PORT}/jmxrmi", }
}
EOF

  code=$(curl \
    --silent \
    --user ${JOLOKIA_API_USER}:${JOLOKIA_API_PASSWORD} \
    --header 'Accept: application/json' \
    --header 'Content-Type: application/json' \
    --insecure \
    --data @memory.json \
    http://${JOLOKIA_MASTER}:${JOLOKIA_API_PORT}/jolokia/)

  if [[ $? -eq 0 ]]
  then
    echo "api request for post request are successfull"
    jolokia_used_heap_memory=$(echo "${code}" | jq --raw-output '.value.HeapMemoryUsage.used')
  else
    echo ${code}
    echo "api request for post request failed"
  fi

  echo "jolokia version '${jolokia_version}'"
  echo "jolokia used heap memory '${jolokia_used_heap_memory}'"
}

check_hawtio() {

  http_response_code=$(curl \
      --write-out %{response_code} \
      --silent \
      --output /dev/null \
      http://localhost:8080/hawtio/)

  if [[ ${http_response_code} -eq 200 ]]
  then
    echo "hawtio available"
  fi
}

inspect() {

  echo ""
  echo "inspect needed containers"
  for d in $(docker ps | tail -n +2 | awk  '{print($1)}')
  do
    # docker inspect --format "{{lower .Name}}" ${d}
    c=$(docker inspect --format '{{with .State}} {{$.Name}} has pid {{.Pid}} {{end}}' "${d}")
    s=$(docker inspect --format '{{json .State.Health }}' "${d}" | jq --raw-output .Status)

    printf "%-40s - %s\n"  "${c}" "${s}"
  done
}

#echo "wait 10 seconds for start"
#sleep 10s

running_containers=$(docker ps | tail -n +2  | wc -l)

if [[ ${running_containers} -eq 1 ]] || [[ ${running_containers} -gt 1 ]]
then
#if [[ $(docker ps | tail -n +2 | wc -l) -eq 1 ]]
#then
  inspect

  wait_for_jolokia
  api_request
  check_hawtio

  exit 0
else
  echo "please run "
  echo " make start"
  echo "before"

  exit 1
fi
