DOCKER_IMAGE=dockette/varnish
DOCKER_TAG?=latest
DOCKER_PLATFORMS?=linux/amd64,linux/arm64

.PHONY: build
build:
	docker buildx build --platform ${DOCKER_PLATFORMS} -t ${DOCKER_IMAGE}:${DOCKER_TAG} .

.PHONY: test
test:
	docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG} varnishd -V
	docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG} test -x /entrypoint.sh
	docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG} test -f /etc/varnish/default.vcl
	docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG} varnishd -C -f /etc/varnish/default.vcl

.PHONY: run
run:
	docker run --rm -it -p 80:80 ${DOCKER_IMAGE}:${DOCKER_TAG}
