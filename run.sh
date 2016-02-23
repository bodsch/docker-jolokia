#!/bin/bash

sudo docker run \
  --tty=false \
  --interactive=false \
  --publish=8080:8080 \
  --memory=512M \
  --detach=true \
  --add-host blueprint-box:192.168.252.100 \
  --read-only=false \
  --name jolokia \
  --hostname=${USER}-jolokia.coremedia.vm  \
  ${USER}-docker-jolokia

# EOF
