#!/usr/bin/env bash

if [ "$1" = "" ]; then
    MODE=private
elif [ "$1" = "private" ] || [ "$1" = "public" ]; then
    MODE=$1
else
    echo "Invalid mode $1! Must be 'public' or 'private'"
    exit 1
fi

# Clear any pre-existing value
unset -v SSH_PASSWORD

# Prompt for the password securely
# -r prevents backslash escapes, -s hides input typing
read -rs -p "Enter your SSH password. If blank, hit enter: " SSH_PASSWORD

if ssh-keygen -y -P "$SSH_PASSWORD" -f "$HOME/.ssh/id_pv" &>/dev/null; then
    echo -e "\nSuccess: Passphrase is correct for this private key."
else
    echo -e "\nFailure: Incorrect passphrase or invalid private key file."
    exit 1
fi

git stash -u || exit 1
git pull || exit 1
git stash pop || exit 1

mkdir -p pv

docker rm -f the-local-setup

docker build \
    --secret "id=ssh,src=$HOME/.ssh/id_pv" \
    --secret "id=sshpub,src=$HOME/.ssh/id_pv.pub" \
    --build-arg MODE=$MODE \
    --tag the-local-setup:latest \
    --no-cache-filter base \
    . \
    || exit 1

docker run \
    -e SSH_PASSPHRASE="${SSH_PASSWORD}" \
    -p 3000:3000 -p 3001:3001 -p 3306:3306 -p 6006:6006 -p 8080:8080 \
    -v "$(dirname "$0")/pv:/home/pv/pv" -dit \
    --name the-local-setup the-local-setup:latest \
    || exit 1

echo "Container is running! Run ./attach.sh (or attach.bat) to start a terminal in the container."
