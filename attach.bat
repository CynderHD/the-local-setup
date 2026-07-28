@echo off

SET "DOCKER_CLI_HINTS=false"

IF NOT "%~1" == "" (
    IF "%~1" == "website" (
        SET "a=cd pv/the-website"
    ) ELSE IF "%~1" == "api" (
        SET "a=cd pv/the-api"
    ) ELSE IF "%~1" == "bot" (
        SET "a=cd pv/the-discord-bot"
    )

    IF DEFINED a (
        IF "%~2" == "run" (
            SET "b= && pnpm dev"
        ) ELSE IF "%~2" == "deploy" (
            IF "%~1" == "bot" (
                SET "b= && pnpm dev-deploy"
            ) ELSE (
                echo 'deploy' can only be used with 'the-discord-bot'. Running 'dev'.
                SET "b= && pnpm dev"
            )
        )
    )
)

IF DEFINED a (
    SET c= -c "source ~/env.sh && %a%%b% && exec bash -i"
)

docker exec -it the-local-setup /bin/bash%c%
