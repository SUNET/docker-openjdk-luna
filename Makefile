JRE:=8
LUNA:=6.2
VERSION:=luna$(LUNA)-jre$(JRE)
NAME=openjdk-jre-luna


all: build push

dist:
	$(MAKE) LUNA=6.2 build push
	$(MAKE) LUNA=7.2 build push

.PHONY: Dockerfile

Dockerfile: Dockerfile.in
	env JRE=$(JRE) LUNA=$(LUNA) envsubst < $< > $@

build: Dockerfile
	docker build --no-cache=true -t $(NAME):$(VERSION) .
	docker tag $(NAME):$(VERSION) docker.sunet.se/$(NAME):$(VERSION)
push:
	docker push docker.sunet.se/$(NAME):$(VERSION)
