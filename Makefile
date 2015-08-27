VERSION=latest
all: build sunet
build:
	docker build --no-cache=true -t pyff:$(VERSION) .
sunet:
	docker tag -f pyff:$(VERSION) docker.sunet.se/pyff:$(VERSION)
	docker push docker.sunet.se/pyff:$(VERSION)
nightly:
	$(MAKE) VERSION=nightly build
	docker tag -f pyff:nightly leifj/pyff:nightly
	docker push leifj/pyff:nightly
