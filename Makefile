DOCKER := docker
PLATFORM := linux/arm64
IMAGE_PREFIX ?= vtol
IMAGE_SUFFIX ?= jetson

PLOTJUGGLER_IMAGE := $(IMAGE_PREFIX)/plotjuggler-$(IMAGE_SUFFIX):latest

.PHONY: docker-build-plotjuggler

docker-build-plotjuggler:
	$(DOCKER) run --rm --privileged tonistiigi/binfmt --install arm64 || true
	$(DOCKER) buildx build \
		--platform $(PLATFORM) \
		-f plotjuggler/plotjuggler.dockerfile \
		-t $(PLOTJUGGLER_IMAGE) \
		--load \
		plotjuggler

docker-build-all: docker-build-plotjuggler
