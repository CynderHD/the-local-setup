#!/usr/bin/bash

eval $(ssh-agent -s)
ssh-add ~/.ssh/id_pv

mkdir -p ~/pv
cd ~/pv

clone_or_pull() {
    if [ -d "$1" ]; then
        cd $1
        git pull
        cd ..
    else
        git clone git@github.com:Progressive-Victory/$1
    fi
}

clone_or_pull the-api
clone_or_pull the-discord-bot
clone_or_pull the-contracts
clone_or_pull the-website
