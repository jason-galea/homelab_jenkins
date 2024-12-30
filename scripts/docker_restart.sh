#!/usr/bin/bash

echo -e "\n==> Compose down"
docker compose down

echo -e "\n==> Compose up"
docker compose up -d
