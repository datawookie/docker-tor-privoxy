VERSION=0.0.4
IMAGE=datawookie/tor-privoxy

# IMAGE -----------------------------------------------------------------------

build:
	docker build -t $(IMAGE) -t $(IMAGE):$(VERSION) .

login:
	docker login

# First need to login.
#
push:
	docker push $(IMAGE)

pull:
	docker pull $(IMAGE)

# CONTAINER -------------------------------------------------------------------

run:
	docker run --rm --name tor \
    -e IP_CHANGE_SECONDS=120 \
    -e EXIT_NODE_COUNTRY=US \
    -e LOG_NOTICE_TARGET=stdout \
    -p 127.0.0.1:8888:8888 \
    -p 127.0.0.1:9050:9050 \
    $(IMAGE)