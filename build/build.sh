#!/usr/bin/bash

docker build \
    --secret id=env,src=.env \
    --tag ghcr.io/progressive-victory/the-local-setup:latest \
    --no-cache-filter setup \
    .
