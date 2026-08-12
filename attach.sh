#!/usr/bin/env bash

export DOCKER_CLI_HINTS=false
C=""
W="/home/pv"

if [ "$1" ]; then
    if [ "$1" = "website" ]; then
        W="$W/pv/the-website"
    elif [ "$1" = "api" ]; then
        W="$W/pv/the-api"
    elif [ "$1" = "bot" ]; then
        W="$W/pv/the-discord-bot"
    elif [ "$1" = "contracts" ]; then
        W="$W/pv/the-contracts"
    fi

    if [ "$W" != "/home/pv" ] && [ "$1" != "contracts" ]; then
        if [ "$2" = "run" ]; then
            C="pnpm dev"
        elif [ "$2" = "deploy" ]; then
            if [ "$1" = "bot" ]; then
                C="pnpm dev-deploy"
            else
                echo "'deploy' can only be used with 'the-discord-bot'. Running 'dev'."
                C="pnpm dev"
            fi
        fi
    fi
fi

if [ "$C" = "" ]; then
    docker exec -it -w "$W" the-local-setup /bin/bash
else
    docker exec -it -w "$W" the-local-setup /bin/bash -i -c "$C"
fi
