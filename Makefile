ifeq ($(shell uname -m), arm64)
    TAG := arm64
else
	TAG := amd64
endif

.PHONY: default
default: run

build:
	docker build --build-arg TAG=$(TAG) --build-arg VCS_REF=$(shell git rev-parse HEAD) --tag catbyte/codespace:$(TAG) .

depends:
	pip3 install docker-squash

rebuild:
	docker build --build-arg TAG=$(TAG) --build-arg VCS_REF=$(shell git rev-parse HEAD) --no-cache --tag catbyte/codespace:$(TAG) .

run:
	docker run --interactive --publish 8080:8080 --rm --security-opt seccomp=unconfined --tty --volume "$(PWD)":/mnt catbyte/codespace || true

squash: depends
	docker-squash --tag catbyte/codespace:$(TAG) catbyte/codespace:$(TAG)
