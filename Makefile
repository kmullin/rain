REGISTRY ?=
IMAGE ?= rain
VERSION ?= $(shell git describe --tags --abbrev=0)

.PHONY: release

release:
	@test -n "$(REGISTRY)" || (echo "REGISTRY is required"; exit 1)
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--build-arg VERSION=$(VERSION) \
		--tag $(REGISTRY)/$(IMAGE):$(VERSION) \
		--tag $(REGISTRY)/$(IMAGE):latest \
		--push \
		.
