#!/usr/bin/env bash

export DOCKER_CLI_HINTS=false
C=""

if [ "$1" ]; then
    if [ "$1" = "website" ]; then
        C='cd pv/the-website'
    elif [ "$1" = "api" ]; then
        C='cd pv/the-api'
    elif [ "$1" = "bot" ]; then
        C='cd pv/the-discord-bot'
    fi

    if [ "$2" = "run" ]; then
        C="$C && pnpm dev"
    elif [ "$2" = "deploy" ]; then
        if [ "$1" = "bot" ]; then
            C="$C && pnpm dev-deploy"
        else
            echo "'deploy' can only be used with 'the-discord-bot'. Running 'dev'."
            C="$C && pnpm dev"
        fi
    fi
fi

if [ "$C" = "" ]; then
    docker exec -it the-local-setup /bin/bash
else
    docker exec -it the-local-setup /bin/bash -c "source ~/env.sh && $C && exec bash -i"
fi