@echo off

IF NOT EXIST "./.env" (
    echo ERROR: No .env file! See ./README.md for more details.
    exit /b 1
)

IF NOT EXIST "./dump.sql" (
    echo ERROR: No dump.sql file! See ./README.md for more details.
    exit /b 1
)

docker build --secret id=env,src=.env --secret id=sqldump,src=dump.sql --tag progressive-victory:latest --no-cache .
