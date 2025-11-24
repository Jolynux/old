#! /bin/bash

DOCKER_DIR='/Ansible_Docker_TestInfra/docker/'
ANSIBLE_DIR='/Ansible_Docker_TestInfra/ansible/'

cd $DOCKER_DIR

if [[ $1 == 'clean' ]]; then
        make clean
        exit 0
elif [[ $1 == 'build' ]]; then
        make rebuild
        exit 0

elif [[ $1 == 'ansible' ]]; then
        cd $ANSIBLE_DIR
        ansible-playbook -i inventory.yaml all

elif [[ $1 =~ [0-9] ]]; then

        for ((i = 1 ; i < $(($1 + 1)) ; i++)); do
                make
                if [[ $? != 0 ]]; then
                        make rebuild && make
                fi
        done
else
        echo 'error'
fi