VERSION := $(shell git describe --tags --always --dirty 2>/dev/null || echo untagged)

.PHONY: run
run: build
	docker run --rm -t $(USER)/nbench:$(VERSION)

.PHONY: build
build:
	docker build -t $(USER)/nbench:$(VERSION) .

.PHONY: push
push:
	docker push $(USER)/nbench:$(VERSION)
	docker tag  $(USER)/nbench:$(VERSION) $(USER)/nbench:latest
	docker push $(USER)/nbench:latest
