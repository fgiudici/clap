CLAUDE_VERSION ?= latest
IMAGE_NAME ?= clap
IMAGE_TAG ?= latest
IMAGE ?= $(IMAGE_NAME):$(IMAGE_TAG)

PREFIX ?= $(HOME)/.local

.PHONY: build clean install setup-env

build:
	podman build --build-arg CLAUDE_VERSION=$(CLAUDE_VERSION) -t $(IMAGE) .

clean:
	podman rmi $(IMAGE)

install:
	install -d $(PREFIX)/bin
	install -m 755 clap $(PREFIX)/bin/clap

setup-env:
	mkdir -p $(HOME)/.clap
	cp -n env.example $(HOME)/.clap/env
	chmod 600 $(HOME)/.clap/env
