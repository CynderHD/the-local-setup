#!/usr/bin/bash

if [ ! -f "./.env" ]; then
    echo "ERROR: No .env file! See ./README.md for more details."
    exit 1
fi

if [ ! -f "./dump.sql" ]; then
    echo "ERROR: No dump.sql file! See ./README.md for more details."
    exit 1
fi

docker build \
    --secret id=env,src=.env --secret id=sqldump,src=dump.sql \
    --tag progressive-victory:latest \
    --no-cache \
    .
