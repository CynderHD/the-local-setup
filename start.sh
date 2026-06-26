#!/usr/bin/bash

docker pull ghcr.io/progressive-victory/the-local-setup:latest
docker tag ghcr.io/progressive-victory/the-local-setup:latest progressive-victory/the-local-setup:latest

docker compose down -t 0
docker compose up --build -d || exit 1

echo "Container is running! Run ./attach.sh (or attach.bat) to start a terminal in the container."
