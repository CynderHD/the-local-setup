@ECHO OFF

IF "%~1"=="" (
    ECHO You have to pass your github username!
    EXIT /B 1
)

IF NOT EXIST ".access-token" (
    ECHO No .access-token file found! Follow the README to create one.
    EXIT /B 1
)

TYPE .access-token | docker login "ghcr.io" -u "$1" --password-stdin
