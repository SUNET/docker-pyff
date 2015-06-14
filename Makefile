all: build push
build:
	docker build --no-cache=true -t pyff .
	docker tag -f pyff docker.sunet.se/pyff
push:
	docker push docker.sunet.se/pyff
