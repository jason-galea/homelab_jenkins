#!/usr/bin/bash


echo -e "\n==> Compose down"
docker compose down


echo -e "\n==> Delete data vol"
docker volume rm jenkins_data


echo -e "\n==> Build new Jenkins image"
docker compose build --no-cache


echo -e "\n==> Compose up"
docker compose up -d

