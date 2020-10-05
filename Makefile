VERSION:=1.0.1
VERSIONS:=1.0.1 1.1.2 1.1.4
STABLE=1.0.1
LATEST=1.1.4
TARGETS:=std eidas
VARIANT:=
IMAGE_TAG:=$(VERSION)$(VARIANT)$(SUBTAG)
NAME=pyff
NOCACHE:=true
REGISTRY:=docker.sunet.se
PACKAGE:=pyFF==$(VERSION)
ENTRYPOINT=pyffd

.PHONY: Dockerfile

all: std

dist: versions stable testing testing-eidas

versions:
	@for ver in $(VERSIONS); do for target in $(TARGETS); do $(MAKE) VERSION=$$ver SUBTAG="" ENTRYPOINT=pyffd $$target push;  done; done
	@for ver in $(VERSIONS); do for target in $(TARGETS); do $(MAKE) VERSION=$$ver SUBTAG="-api" ENTRYPOINT=api $$target push;  done; done	

clean:
	rm -f Dockerfile

Dockerfile: Dockerfile.in
	env PACKAGE=$(PACKAGE) VERSION=$(VERSION) IMAGE_TAG=$(IMAGE_TAG) ENTRYPOINT=$(ENTRYPOINT) EXTRA_PACKAGES=$(EXTRA_PACKAGES) envsubst < $< > $@

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
	$(MAKE) PAKAGE=$(PACKAGE) VARIANT="-eidas" ENTRYPOINT=$(ENTRYPOINT) EXTRA_PACKAGES=git+git://github.com/IdentityPython/pyXMLSecurity.git@pyff-eidas#egg=pyXMLSecurity build push

testing: 
	$(MAKE) VERSION=testing IMAGE_TAG=testing PACKAGE=git+git://github.com/IdentityPython/pyFF.git#egg=pyFF build push
	$(MAKE) VERSION=testing-api IMAGE_TAG=testing-api ENTRYPOINT=api PACKAGE=git+git://github.com/IdentityPython/pyFF.git#egg=pyFF build push

testing-eidas:
	$(MAKE) VERSION=testing IMAGE_TAG=eidas-testing PACKAGE=git+git://github.com/IdentityPython/pyFF.git#egg=pyFF EXTRA_PACKAGES=git+git://github.com/IdentityPython/pyXMLSecurity.git@pyff-eidas#egg=pyXMLSecurity build push
	$(MAKE) VERSION=testing IMAGE_TAG=eidas-testing ENTRYPOINT=api PACKAGE=git+git://github.com/IdentityPython/pyFF.git#egg=pyFF EXTRA_PACKAGES=git+git://github.com/IdentityPython/pyXMLSecurity.git@pyff-eidas#egg=pyXMLSecurity build push
