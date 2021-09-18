#!/bin/bash
export GIT_USERNAME=$1
export GIT_PASSWORD=$2
if [ "$1" == "" ]; then
echo "pull.sh <USER_NAME> <PASSWORD>"
elif [ "$2" == "" ]; then
echo "pull.sh <USER_NAME> <PASSWORD>"
else
    echo 'https://${GIT_USERNAME}:${GIT_PASSWORD}@git.authing.co' > /root/.git-credentials && \
    git config --global credential.helper store && \
    git config --global user.name ${GIT_USERNAME} && \
    git config --global user.email ${GIT_EMAIL} && \
    cd usr/local/authing-dev && \
    git clone https://${GIT_USERNAME}:${GIT_PASSWORD}@git.authing.co/authing-next/authing-server.git && \
    git clone https://${GIT_USERNAME}:${GIT_PASSWORD}@git.authing.co/authing-next/authing-fe-console.git && \
    git clone https://${GIT_USERNAME}:${GIT_PASSWORD}@git.authing.co/authing-next/authing-user-portal.git
fi
