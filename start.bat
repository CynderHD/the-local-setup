@echo off

docker compose down -t 0
docker compose up --build -d

ECHO Container is running! Run ./attach.sh (or attach.bat) to start a terminal in the container.
