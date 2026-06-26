@echo off

mkdir pv 2>nul

docker rm -f the-local-setup

docker build ^
    --secret "id=ssh,src=%USERPROFILE%\.ssh\id_pv" --secret "id=sshpub,src=%USERPROFILE%\.ssh\id_pv.pub" ^
    --tag the-local-setup:latest --no-cache .
IF %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL

docker run ^
    -p 3000:3000 -p 3001:3001 -p 6006:6006 -p 8080:8080 ^
    -v "%~dp0\pv:/home/pv/pv" -dit ^
    --name the-local-setup the-local-setup:latest
IF %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL

ECHO Container is running! Run ./attach.sh (or attach.bat) to start a terminal in the container.
