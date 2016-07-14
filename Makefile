TYPE := jolokia
IMAGE_NAME := ${USER}-docker-${TYPE}


build:
	docker build --rm --tag=$(IMAGE_NAME) .

run:
	docker run \
		--detach \
		--interactive \
		--tty \
		--hostname=${USER}-mysql \
		--name=${USER}-${TYPE} \
		$(IMAGE_NAME)

shell:
	docker run \
		--rm \
		--interactive \
		--tty \
		--hostname=${USER}-mysql \
		--name=${USER}-${TYPE} \
		$(IMAGE_NAME)

exec:
	docker exec \
		--interactive \
		--tty \
		${USER}-${TYPE} \
		/bin/sh

stop:
	docker kill \
		${USER}-${TYPE}
