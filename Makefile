VERSION=latest
all: build push
build:
	docker build --no-cache=true -t pyff:$(VERSION) .
	docker tag -f pyff:testing docker.sunet.se/pyff:$(VERSION)
push:
	docker push docker.sunet.se/pyff:$(VERSION)
