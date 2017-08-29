docker-jolokia
==============

Minimal Image with Apache Tomcat8, openjdk8-jre-base and jolokia.

# Status

[![Docker Pulls](https://img.shields.io/docker/pulls/bodsch/docker-jolokia.svg?branch=1705-01)][hub]
[![Image Size](https://images.microbadger.com/badges/image/bodsch/docker-jolokia.svg?branch=1705-01)][microbadger]
[![Build Status](https://travis-ci.org/bodsch/docker-jolokia.svg?branch=1705-01)][travis]

[hub]: https://hub.docker.com/r/bodsch/docker-jolokia/
[microbadger]: https://microbadger.com/images/bodsch/docker-jolokia
[travis]: https://travis-ci.org/bodsch/docker-jolokia

# Build

Your can use the included Makefile.

To build the Container: `make build`

To remove the builded Docker Image: `make clean`

Starts the Container: `make run`

Starts the Container with Login Shell: `make shell`

Entering the Container: `make exec`

Stop (but **not kill**): `make stop`

History `make history`


# Docker Hub

You can find the Container also at  [DockerHub](https://hub.docker.com/r/bodsch/docker-jolokia/)


# Versions

 - tomcat 8.5.14
 - jolokia 1.3.6
 - openjdk from alpine


# Test

    curl http://localhost:8080/jolokia/ | python -mjson.tool
    curl http://localhost:8080/jolokia/list | python -mjson.tool

    curl http://localhost:8080/jolokia --data @examples/memory.json | jq


# Ports

* 8080

