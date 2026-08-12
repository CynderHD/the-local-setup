#!/usr/bin/env bash

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

mkdir -p pv

docker rm -f the-local-setup

docker build \
    --secret "id=ssh,src=$HOME/.ssh/id_pv" --secret "id=sshpub,src=$HOME/.ssh/id_pv.pub" \
    --tag the-local-setup:latest --no-cache . \
    || exit 1

docker run \
    -e SSH_PASSPHRASE="${SSH_PASSWORD}" \
    -p 3000:3000 -p 3001:3001 -p 3306:3306 -p 6006:6006 -p 8080:8080 \
    -v "$(dirname "$0")/pv:/home/pv/pv" -dit \
    --name the-local-setup the-local-setup:latest \
    || exit 1

echo "Container is running! Run ./attach.sh (or attach.bat) to start a terminal in the container."
