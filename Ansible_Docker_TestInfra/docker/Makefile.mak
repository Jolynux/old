all: launch

PARENT_NAME=$(shell sed -r -n '/^FROM/ {s/^FROM +//;p}' Dockerfile)
CONTAINER_NAME=debian:10
PORT_SSH=$(shell ./configure.sh ssh)
PORT_WEB=$(shell ./configure.sh web)
DEFAULT_NAME=$(shell ./configure.sh name)
DOCKER_USER=root
all_cont=$(shell docker ps -qa)



distribute: .FORCE
        for b in $$(git branch --no-merged); do git merge-into $$b --no-edit; done

killall: .FORCE
        docker kill $$(docker ps | sed -r -n '/^[^ ]+ +$(CONTAINER_NAME) / {s/ .*$$//;p}')

pull: .FORCE
        docker pull $(PARENT_NAME)

build: .FORCE
        docker build -t $(CONTAINER_NAME) .

rebuild: pull .FORCE
        docker build --no-cache -t $(CONTAINER_NAME) .

debug-ssh: build .FORCE
        docker run -p $(PORT):22 -e SSH_KEY="$$(cat ~/.ssh/id_rsa.pub)" $(CONTAINER_NAME)

debug-connect: .FORCE
        ssh $(DOCKER_USER)@localhost -p $(PORT) -o "StrictHostKeyChecking=no" env

debug-connect-root: .FORCE
        ssh root@localhost -p $(PORT) -o "StrictHostKeyChecking=no" env

debug-bash: build .FORCE
        docker run -ti -u $(DOCKER_USER) $(CONTAINER_NAME) bash

debug-bash-root: build .FORCE
        docker run -ti $(CONTAINER_NAME) bash
clean: .FORCE
        docker rm -v -f $(all_cont)

launch: build .FORCE
        docker run -d -p $(PORT_SSH):22 -p $(PORT_WEB):80 --dns=192.168.1.1 --dns=1.1.1.1 --name $(DEFAULT_NAME) --hostname=$(DEFAULT_NAME) -e SSH_KEY="$$(cat ~/.ssh/id_rsa.pub)" $(CONTAINER_NAME)

.FORCE: