@echo off

SET "MISSING_SSH="
IF NOT EXIST "./pv/.ssh/id_pv" SET "MISSING_SSH=true"
IF NOT EXIST "./pv/.ssh/id_pv.pub" SET "MISSING_SSH=true"
IF DEFINED MISSING_SSH (
    echo ERROR: Misconfigured ssh key! See ./pv/.ssh/README.md for more details.
    exit /b 1
)

IF NOT EXIST "./.env" (
    echo ERROR: No .env file! See ./README.md for more details.
    exit /b 1
)

docker compose build --no-cache
