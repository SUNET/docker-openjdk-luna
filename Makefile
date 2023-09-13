JRE:=8
LUNA:=6.2
VERSION:=luna$(LUNA)-jre$(JRE)
NAME=openjdk-jre-luna


all: build push

dist:
	$(MAKE) LUNA=6.2 JRE=11 build push
	$(MAKE) LUNA=7.2 JRE=11 build push
	$(MAKE) LUNA=7.4 JRE=11 build push
	$(MAKE) LUNA=6.2 JRE=8 build push
	$(MAKE) LUNA=7.2 JRE=8 build push
	$(MAKE) LUNA=7.4 JRE=8 build push

.PHONY: Dockerfile

Dockerfile: Dockerfile.in
	env JRE=$(JRE) LUNA=$(LUNA) envsubst < $< > $@

build: Dockerfile
	docker build --no-cache=false -t $(NAME):$(VERSION) .
	docker tag $(NAME):$(VERSION) docker.sunet.se/$(NAME):$(VERSION)
push:
	docker push docker.sunet.se/$(NAME):$(VERSION)
