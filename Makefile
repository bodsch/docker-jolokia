
CONTAINER  := jolokia
IMAGE_NAME := docker-jolokia

build:
	docker build --rm --tag=$(IMAGE_NAME) .
	@echo Image tag: ${IMAGE_NAME}

run:
	docker \
		run \
		--detach \
		--interactive \
		--tty \
		--publish=8080:8080 \
		--hostname=${CONTAINER} \
		--name=${CONTAINER} \
		${IMAGE_NAME}

shell:
	docker \
		run \
		--rm \
		--interactive \
		--tty \
		--publish=8080:8080 \
		--hostname=${CONTAINER} \
		--name=${CONTAINER} \
		${IMAGE_NAME}

exec:
	docker \
		exec \
		--interactive \
		--tty \
		${CONTAINER} \
		/bin/bash

stop:
	docker \
		kill ${CONTAINER}

history:
	docker \
		history ${IMAGE_NAME}
