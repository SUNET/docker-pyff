VERSION=latest
NAME=pyff
all: build sunet
build:
	docker build --no-cache=true -t $(NAME):$(VERSION) .
sunet:
	docker tag -f $(NAME):$(VERSION) docker.sunet.se/$(NAME):$(VERSION)
	docker push docker.sunet.se/$(NAME):$(VERSION)

nightly:
	$(MAKE) VERSION=nightly build
	docker tag -f $(NAME):nightly leifj/$(NAME):nightly
	docker push leifj/$(NAME):nightly
