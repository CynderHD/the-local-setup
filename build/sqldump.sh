#!/usr/bin/env bash

mysqldump \
    -h 127.0.0.1 -P 3307 \
    -u root "-p$1" \
    --single-transaction --hex-blob --skip-ssl --routines \
    central > dump.sql
