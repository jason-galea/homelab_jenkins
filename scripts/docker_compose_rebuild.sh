#!/usr/bin/bash


echo -e "\n==> Compose down"
docker compose -f compose/docker-compose.yml down


echo -e "\n==> Delete data vol"
docker volume rm compose_jenkins-data


echo -e "\n==> Build new Jenkins image"
docker compose -f compose/docker-compose.yml build


echo -e "\n==> Compose up"
docker compose -f compose/docker-compose.yml up -d

