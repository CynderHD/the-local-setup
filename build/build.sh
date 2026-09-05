#!/usr/bin/env bash

docker run --privileged --rm tonistiigi/binfmt --install all

docker buildx build \
    --platform linux/amd64,linux/arm64 \
    --secret id=env,src=.env \
    --tag ghcr.io/progressive-victory/the-local-setup:latest \
    --no-cache-filter setup-env \
    . || exit 1

docker buildx build \
    --platform linux/amd64,linux/arm64 \
    --secret id=env,src=public.env \
    --tag ghcr.io/progressive-victory/the-local-setup-public:latest \
    --no-cache-filter setup-env \
    .
