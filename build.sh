#!/usr/bin/bash

if [ ! -f "./pv/.ssh/id_pv" ] || [ ! -f "./pv/.ssh/id_pv.pub" ]; then
    echo "ERROR: Misconfigured ssh key! See ./pv/.ssh/README.md for more details."
    exit 1
fi

if [ ! -f "./.env" ]; then
    echo "ERROR: No .env file! See ./README.md for more details."
    exit 1
fi

docker compose build --no-cache
