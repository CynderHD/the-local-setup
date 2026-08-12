#!/usr/bin/bash

eval $(ssh-agent -s)
echo "$SSH_PASSPHRASE" | sshpass -P "Enter passphrase" ssh-add ~/.ssh/id_pv

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

# Install node dependencies
cd the-api
pnpm install
cd ../the-discord-bot
pnpm install
cd ../the-contracts
pnpm install
cd ../the-website
pnpm install
cd ..

sudo service mariadb start
