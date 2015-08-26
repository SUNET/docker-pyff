VERSION=latest
all: build push
build:
	docker build --no-cache=true -t pyff:$(VERSION) .
	docker tag -f pyff:$(VERSION) docker.sunet.se/pyff:$(VERSION)
push:
	docker push docker.sunet.se/pyff:$(VERSION)
