#!/usr/bin/bash

if [ ! -f "./pv/.ssh/id_pv" ] || [ ! -f "./pv/.ssh/id_pv.pub" ]; then
    echo "ERROR: Misconfigured ssh key! See ./pv/.ssh/README.md for more details."
    exit 1
fi

docker rm -f progressive-victory || true

docker build -t progressive-victory . || exit 1

docker run \
    -p 3000:3000 -p 6006:6006 -p 8080:8080 \
    --mount "type=bind,source=$(pwd)/pv/pv,target=/home/pv/pv" \
    --name progressive-victory \
    --detach \
    progressive-victory:latest

echo "Setup complete! Run ./attach.sh (or attach.bat) to start a terminal in the container."
