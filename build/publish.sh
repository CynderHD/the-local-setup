#!/usr/bin/bash

set -e

if [ -z "$1" ]; then
    echo "You have to pass your github username!"
    exit 1
fi

if [ ! -f ".access-token" ]; then
    echo "No .access-token file found! Follow the README to create one."
    exit 1
fi

cat .access-token | docker login "ghcr.io" -u "$1" --password-stdin
./build.sh
docker push ghcr.io/progressive-victory/the-local-setup:latest
