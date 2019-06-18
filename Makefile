VERSION:=1.0.1
IMAGE_TAG:=$(VERSION)
NAME=pyff
NOCACHE:=true
REGISTRY:=docker.sunet.se
PACKAGE:=pyFF==$(VERSION)

.PHONY: Dockerfile

all: build push

clean:
	rm -f Dockerfile

Dockerfile: Dockerfile.in
	env PACKAGE=$(PACKAGE) VERSION=$(VERSION) IMAGE_TAG=$(IMAGE_TAG) EXTRA_PACKAGES=$(EXTRA_PACKAGES) envsubst < $< > $@

build: Dockerfile
	docker build --no-cache=$(NOCACHE) -t $(NAME):$(IMAGE_TAG) .

push:
	docker tag $(NAME):$(IMAGE_TAG) $(REGISTRY)/$(NAME):$(IMAGE_TAG)
	docker push $(REGISTRY)/$(NAME):$(IMAGE_TAG)

eidas: 
	$(MAKE) NOCACHE=false PAKAGE=$(PACKAGE) IMAGE_TAG=$(VERSION)-eidas EXTRA_PACKAGES=git+git://github.com/IdentityPython/pyXMLSecurity.git@pyff-eidas#egg=pyXMLSecurity build push

dev:
	$(MAKE) NOCACHE=true IMAGE_TAG=dev PACKAGE=git+git://github.com/IdentityPython/pyFF.git#egg=pyFF build
