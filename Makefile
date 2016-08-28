

build:
	docker build --rm --tag=docker-jolokia .

run:
	docker run \
		--detach \
		--interactive \
		--tty \
		--publish=8080:8080 \
		--hostname=jolokia \
		--name=jolokia \
		docker-jolokia

shell:
	docker run \
		--rm \
		--interactive \
		--tty \
		--publish=8080:8080 \
		--hostname=jolokia \
		--name=jolokia \
		docker-jolokia

exec:
	docker exec \
		--interactive \
		--tty \
		jolokia \
		/bin/sh

stop:
	docker kill \
		jolokia
