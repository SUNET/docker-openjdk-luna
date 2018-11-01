JRE=8
LUNA=6.2
VERSION=luna$(LUNA)-jre$(JRE)
NAME=openjdk-jre-luna

all: build push
build:
	docker build --no-cache=true --build-arg OPENJDK_TAG=$(JRE)-jre -t $(NAME):$(VERSION) .
	docker tag $(NAME):$(VERSION) docker.sunet.se/$(NAME):$(VERSION)
update:
	docker build -t $(NAME):$(VERSION) .
	docker tag $(NAME):$(VERSION) docker.sunet.se/$(NAME):$(VERSION)
push:
	docker push docker.sunet.se/$(NAME):$(VERSION)
