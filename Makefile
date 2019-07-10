VERSION:=1.0.1
VERSIONS:=1.0.1
TARGETS:=std eidas
IMAGE_TAG:=$(VERSION)
NAME=pyff
NOCACHE:=true
REGISTRY:=docker.sunet.se
PACKAGE:=pyFF==$(VERSION)

.PHONY: Dockerfile

all: versions dev

versions:
	@for ver in $(VERSIONS); do for target in $(TARGETS); do $(MAKE) VERSION=$$ver $$target push;  done; done

clean:
	rm -f Dockerfile

Dockerfile: Dockerfile.in
	env PACKAGE=$(PACKAGE) VERSION=$(VERSION) IMAGE_TAG=$(IMAGE_TAG) EXTRA_PACKAGES=$(EXTRA_PACKAGES) envsubst < $< > $@

std: build

build: Dockerfile
	docker build --no-cache=$(NOCACHE) -t $(NAME):$(IMAGE_TAG) .

push:
	docker tag $(NAME):$(IMAGE_TAG) $(REGISTRY)/$(NAME):$(IMAGE_TAG)
	docker push $(REGISTRY)/$(NAME):$(IMAGE_TAG)

eidas: Dockerfile
	$(MAKE) NOCACHE=false PAKAGE=$(PACKAGE) IMAGE_TAG=$(VERSION)-eidas EXTRA_PACKAGES=git+git://github.com/IdentityPython/pyXMLSecurity.git@pyff-eidas#egg=pyXMLSecurity build push

dev: Dockerfile
	$(MAKE) NOCACHE=true IMAGE_TAG=dev PACKAGE=git+git://github.com/IdentityPython/pyFF.git#egg=pyFF build push
