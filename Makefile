
include env_make

NS       = bodsch
VERSION ?= latest

REPO     = docker-jolokia
NAME     = jolokia
INSTANCE = default

BUILD_DATE := $(shell date +%Y-%m-%d)
BUILD_VERSION := $(shell date +%y%m)
JOLOKIA_VERSION ?= 1.5.0
TOMCAT_VERSION ?= 9.0.6

.PHONY: build push shell run start stop rm release

default: build

params:
	@echo ""
	@echo " JOLOKIA_VERSION: ${JOLOKIA_VERSION}"
	@echo " TOMCAT_VERSION : ${TOMCAT_VERSION}"
	@echo " BUILD_DATE     : $(BUILD_DATE)"
	@echo ""

build:	params
	docker build \
		--force-rm \
		--compress \
		--build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg BUILD_VERSION=$(BUILD_VERSION) \
		--build-arg JOLOKIA_VERSION=${JOLOKIA_VERSION} \
		--build-arg TOMCAT_VERSION=${TOMCAT_VERSION} \
		--tag $(NS)/$(REPO):${JOLOKIA_VERSION} .

clean:
	docker rmi \
		--force \
		$(NS)/$(REPO):${JOLOKIA_VERSION}

history:
	docker history \
		$(NS)/$(REPO):${JOLOKIA_VERSION}

push:
	docker push \
		$(NS)/$(REPO):${JOLOKIA_VERSION}

shell:
	docker run \
		--rm \
		--name $(NAME)-$(INSTANCE) \
		--interactive \
		--tty \
		$(PORTS) \
		$(VOLUMES) \
		$(ENV) \
		$(NS)/$(REPO):${JOLOKIA_VERSION} \
		/bin/sh

run:
	docker run \
		--rm \
		--name $(NAME)-$(INSTANCE) \
		$(PORTS) \
		$(VOLUMES) \
		$(ENV) \
		$(NS)/$(REPO):${JOLOKIA_VERSION}

exec:
	docker exec \
		--interactive \
		--tty \
		$(NAME)-$(INSTANCE) \
		/bin/sh

start:
	docker run \
		--detach \
		--name $(NAME)-$(INSTANCE) \
		$(PORTS) \
		$(VOLUMES) \
		$(ENV) \
		$(NS)/$(REPO):${JOLOKIA_VERSION}

stop:
	docker stop \
		$(NAME)-$(INSTANCE)

rm:
	docker rm \
		$(NAME)-$(INSTANCE)

release: build
	make push -e VERSION=${JOLOKIA_VERSION}

default: build


