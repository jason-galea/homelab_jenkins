#!/usr/bin/bash


echo -e "\n==> Install docker"
apt update
apt upgrade -y
apt install -y docker docker.io docker-compose


# echo -e "\n==> Docker hello-world"
# docker run hello-world
