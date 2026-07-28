@echo off

docker build ^
    --platform linux/amd64,linux/arm64 ^
    --secret id=env,src=.env ^
    --tag ghcr.io/progressive-victory/the-local-setup:latest ^
    --no-cache-filter setup ^
    .
