VERSION=1.0.0
NAME=pyff
all: build sunet
build:
	docker build --no-cache=true -t $(NAME):$(VERSION) .

update:
	docker build --no-cache=false -t $(NAME):$(VERSION) .

sunet:
	docker tag $(NAME):$(VERSION) docker.sunet.se/$(NAME):$(VERSION)
	docker push docker.sunet.se/$(NAME):$(VERSION)

nightly:
	$(MAKE) VERSION=nightly build
	docker tag $(NAME):nightly leifj/$(NAME):nightly
	docker push leifj/$(NAME):nightly
