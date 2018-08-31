VERSION=latest
NAME=pyff
DOCKERFILE=Dockerfile

all: build nightly
build:
	docker build -f $(DOCKERFILE) --no-cache=true -t $(NAME):$(VERSION) .
buildcache:
	docker build -f $(DOCKERFILE) --no-cache=false -t $(NAME):$(VERSION) .
sunet:
	docker tag $(NAME):$(VERSION) docker.sunet.se/$(NAME):$(VERSION)
	docker push docker.sunet.se/$(NAME):$(VERSION)

nightly:
	$(MAKE) DOCKERFILE=Dockerfile.ra21 VERSION=nightly build
	docker tag $(NAME):nightly leifj/$(NAME):nightly
	docker push leifj/$(NAME):nightly

