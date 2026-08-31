@echo off

SET "DOCKER_CLI_HINTS=false"
SET "w=/home/pv"

IF NOT "%~1" == "" (
    IF "%~1" == "website" (
        SET "w=%w%/pv/the-website"
    ) ELSE IF "%~1" == "api" (
        SET "w=%w%pv/the-api"
    ) ELSE IF "%~1" == "bot" (
        SET "w=%w%/pv/the-discord-bot"
    ) ELSE IF "%~1" == "contracts" (
        SET "w=%w%/pv/the-contracts"
    ) ELSE IF "%~1" == "db" (
        SET "c=mariadb -u root -padmin localhost"
    )

    IF NOT "%w%" == "" IF NOT "%~1" == "contracts" (
        IF "%~2" == "run" (
            SET "c=pnpm dev"
        ) ELSE IF "%~2" == "deploy" (
            IF "%~1" == "bot" (
                SET "c=pnpm dev-deploy"
            ) ELSE (
                echo 'deploy' can only be used with 'the-discord-bot'. Running 'dev'.
                SET "c=pnpm dev"
            )
        )
    )
)

IF DEFINED c (
    SET c= -i -c "%c%"
)

docker exec -it -w %w% the-local-setup /bin/bash%c%
