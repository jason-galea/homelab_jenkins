#!/usr/bin/bash


echo -e "\n==> [LXC] Install docker"
# apt update ### This just happened a second ago
apt upgrade -y
apt install -y git curl docker docker.io


COMPOSE_URL=""
COMPOSE_PATH="/root/.docker/cli-plugins/docker-compose"
if [[ ! -f $COMPOSE_PATH ]]; do
    echo -e "\n==> [LXC] Install docker compose"
    mkdir -p /root/.docker/cli-plugins
    curl -SL \
        https://github.com/docker/compose/releases/download/v2.32.0/docker-compose-linux-x86_64 \
        -o /root/.docker/cli-plugins/docker-compose
    chmod +x /root/.docker/cli-plugins/docker-compose
    docker compose version
else
    echo -e "\n==> [LXC] Docker compose is already installed, continuing"



echo -e "\n==> [LXC] Clone repo"
git clone https://github.com/jason-galea/homelab_jenkins.git


echo -e "\n==> [LXC] Docker compose up"
# docker compose up -d -f /root/homelab_jenkins/docker-compose.yml
(
    cd /root/homelab_jenkins
    docker compose up -d
)

