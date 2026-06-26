#!/usr/bin/bash

docker compose down -t 0
docker compose up -d

echo "Container is running! Run ./attach.sh (or attach.bat) to start a terminal in the container."
