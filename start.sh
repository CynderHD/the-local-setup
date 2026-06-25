#!/usr/bin/bash

docker rm -f progressive-victory || true

docker compose up -d

echo "Container is running! Run ./attach.sh (or attach.bat) to start a terminal in the container."
