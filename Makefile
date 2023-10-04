JRE:=8
LUNA:=6.2
BASE_IMAGE:=ubuntu:bionic
TAG:=
VERSION:=luna$(LUNA)-jre$(JRE)$(TAG)
NAME=openjdk-jre-luna


all: dist

dist:
	$(MAKE) LUNA=7.2 JRE=17 BASE_IMAGE=debian:stable build push
	$(MAKE) LUNA=7.4 JRE=17 BASE_IMAGE=debian:stable build push
	$(MAKE) LUNA=6.2 JRE=11 BASE_IMAGE:=ubuntu:bionic build push
	$(MAKE) LUNA=7.2 JRE=11 BASE_IMAGE:=ubuntu:bionic build push
	$(MAKE) LUNA=7.4 JRE=11 BASE_IMAGE:=ubuntu:bionic build push
	$(MAKE) LUNA=6.2 JRE=8 BASE_IMAGE:=ubuntu:bionic build push
	$(MAKE) LUNA=7.2 JRE=8 BASE_IMAGE:=ubuntu:bionic build push
	$(MAKE) LUNA=7.4 JRE=8 BASE_IMAGE:=ubuntu:bionic build push

.PHONY: Dockerfile

Dockerfile: Dockerfile.in
	env JRE=$(JRE) LUNA=$(LUNA) envsubst < $< > $@

build: Dockerfile
	docker build --no-cache=false -t $(NAME):$(VERSION) .
	docker tag $(NAME):$(VERSION) docker.sunet.se/$(NAME):$(VERSION)
push:
	docker push docker.sunet.se/$(NAME):$(VERSION)
