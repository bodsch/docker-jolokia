#!/bin/bash

sudo docker run --tty=false --interactive=false --publish=8080:8080 --memory=512M --detach=true --read-only=false --name jolokia docker-jolokia

