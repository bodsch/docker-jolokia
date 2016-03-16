#!/bin/bash

. config.rc

if [ $(docker ps -a | grep ${CONTAINER_NAME} | awk '{print $NF}' | wc -l) -gt 0 ]
then
  docker kill ${CONTAINER_NAME} 2> /dev/null
  docker rm   ${CONTAINER_NAME} 2> /dev/null
fi

# ---------------------------------------------------------------------------------------

docker run \
  --interactive \
  --tty \
  --detach \
  --publish=8080:8080 \
  --hostname=${USER}-${TYPE} \
  --name ${CONTAINER_NAME} \
  ${TAG_NAME}

# ---------------------------------------------------------------------------------------
# EOF
