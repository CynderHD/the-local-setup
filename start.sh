#!/usr/bin/bash

mkdir -p pv

docker pull ghcr.io/progressive-victory/the-local-setup:latest

docker rm -f the-local-setup

docker build \
    --secret "id=ssh,src=$HOME/.ssh/id_pv" --secret "id=sshpub,src=$HOME/.ssh/id_pv.pub" \
    --tag the-local-setup:latest --no-cache . \
    || exit 1

docker run \
    -p 3000:3000 -p 3001:3001 -p 6006:6006 -p 8080:8080 \
    -v "$(dirname "$0")/pv:/home/pv/pv" -dit \
    --name the-local-setup the-local-setup:latest \
    || exit 1

echo "Container is running! Run ./attach.sh (or attach.bat) to start a terminal in the container."
