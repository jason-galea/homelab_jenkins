#!/usr/bin/bash

echo -e "\n==> Build new Jenkins image"
docker compose build --no-cache
