#!/usr/bin/bash


docker compose -f compose/docker-compose.yml down

docker volume rm compose_jenkins-data

docker compose -f compose/docker-compose.yml build

docker compose -f compose/docker-compose.yml up -d

