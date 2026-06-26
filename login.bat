@echo off

IF "%~1"=="" (
    echo You have to pass your github username!
    exit /b 1
)

IF NOT EXIST ".access-token" (
    echo No .access-token file found! Follow the README to create one.
    exit /b 1
)

type .access-token | docker login "ghcr.io" -u "$1" --password-stdin
