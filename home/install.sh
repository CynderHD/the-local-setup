#!/usr/bin/bash

eval $(ssh-agent -s)
echo "$SSH_PASSPHRASE" | sshpass -P "Enter passphrase" ssh-add ~/.ssh/id_pv

### Setup repositories
./setup_repo.sh Progressive-Victory the-api
./setup_repo.sh Progressive-Victory the-discord-bot
./setup_repo.sh Progressive-Victory the-contracts
./setup_repo.sh Progressive-Victory the-website

### Uncomment and edit for forks you may have
# ./setup_repo.sh jane-doe the-discord-bot
# ./setup_repo.sh jane-doe the-website

### Start the local database
sudo service mariadb start
