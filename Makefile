VERSION=$(LATEST)
VERSIONS:=1.1.5 2.0.0 2.1.2 2.1.3 2.1.4
STABLE=1.1.5
LATEST=2.1.4
TARGETS:=std
VARIANT:=
IMAGE_TAG:=$(VERSION)$(VARIANT)$(SUBTAG)
VENV=/venv
NAME=pyff
NOCACHE:=false
REGISTRY:=docker.sunet.se
PACKAGE:=pyFF==$(VERSION)
ENTRYPOINT=pyffd
BASE_IMAGE=debian:stable

-include config/$(VERSION).mk

.PHONY: Dockerfile

all: std

dist: versions stable testing latest

versions:
	@for ver in $(VERSIONS); do for target in $(TARGETS); do $(MAKE) VERSION=$$ver SUBTAG="" ENTRYPOINT=pyffd $$target push;  done; done

clean:
	rm -f Dockerfile

Dockerfile: Dockerfile.in
	env PACKAGE=$(PACKAGE) BASE_IMAGE=$(BASE_IMAGE) VERSION=$(VERSION) IMAGE_TAG=$(IMAGE_TAG) ENTRYPOINT=$(ENTRYPOINT) EXTRA_PACKAGES=$(EXTRA_PACKAGES) VENV=$(VENV) envsubst < $< > $@

stable:
	docker tag pyff:$(STABLE) $(REGISTRY)/pyff:stable
	docker push $(REGISTRY)/pyff:stable

latest:
	docker tag pyff:$(LATEST) $(REGISTRY)/pyff:latest
	docker push $(REGISTRY)/pyff:latest

std: build

build: Dockerfile
	docker build --no-cache=$(NOCACHE) -t $(NAME):$(IMAGE_TAG) .

push:
	docker tag $(NAME):$(IMAGE_TAG) $(REGISTRY)/$(NAME):$(IMAGE_TAG)
	docker push $(REGISTRY)/$(NAME):$(IMAGE_TAG)

eidas: Dockerfile
	$(MAKE) PAKAGE=$(PACKAGE) VARIANT="-eidas" ENTRYPOINT=$(ENTRYPOINT) EXTRA_PACKAGES=git+http://github.com/IdentityPython/pyXMLSecurity.git@pyff-eidas#egg=pyXMLSecurity build push

testing:
	$(MAKE) VERSION=testing IMAGE_TAG=testing PACKAGE=git+http://github.com/IdentityPython/pyFF.git#egg=pyFF build push

testing-eidas:
	$(MAKE) VERSION=testing IMAGE_TAG=eidas-testing PACKAGE=git+http://github.com/IdentityPython/pyFF.git#egg=pyFF EXTRA_PACKAGES=git+http://github.com/IdentityPython/pyXMLSecurity.git@pyff-eidas#egg=pyXMLSecurity build push
