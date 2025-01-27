#!/usr/bin/bash

echo -e "\n==> Compose down"
docker compose down

echo -e "\n==> Delete data vol"
docker volume rm jenkins_data

# echo -e "\n==> Compose up"
# docker compose up -d
