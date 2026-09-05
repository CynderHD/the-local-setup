#!/usr/bin/env bash

docker push ghcr.io/progressive-victory/the-local-setup:latest || exit 1
docker push ghcr.io/progressive-victory/the-local-setup-public:latest
