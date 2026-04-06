DOCKER := docker
PLATFORM := linux/amd64
IMAGE_PREFIX ?= vtol
IMAGE_SUFFIX ?= host

PLOTJUGGLER_IMAGE := $(IMAGE_PREFIX)/plotjuggler-$(IMAGE_SUFFIX):latest
FASTLIO_DEBUG_IMAGE := $(IMAGE_PREFIX)/fastlio-debug-$(IMAGE_SUFFIX):latest

RVIZ_CONFIG ?= dockerfiles/fastlio.rviz

.PHONY: docker-build-plotjuggler

docker-build-plotjuggler:
	$(DOCKER) buildx build \
		--platform $(PLATFORM) \
		-f dockerfiles/plotjuggler.dockerfile \
		-t $(PLOTJUGGLER_IMAGE) \
		--load \
		.

docker-run-plotjuggler:
	$(DOCKER) run --rm --network host --ipc host $(PLOTJUGGLER_IMAGE)

.PHONY: docker-build-fastlio-debug
docker-build-fastlio-debug:
	$(DOCKER) buildx build \
		--platform $(PLATFORM) \
		-f dockerfiles/fastlio_debugger.dockerfile \
		-t $(FASTLIO_DEBUG_IMAGE) \
		--load \
		.

.PHONY: docker-run-fastlio-debug
docker-run-fastlio-debug:
	$(DOCKER) run --rm -it \
		--net=host \
		--ipc host \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-e DISPLAY \
		-v $(CURDIR)/$(RVIZ_CONFIG):/fastlio.rviz:ro \
		$(FASTLIO_DEBUG_IMAGE) \
		rviz2 -d /fastlio.rviz

docker-build-all: docker-build-plotjuggler docker-build-fastlio-debug
