@ECHO OFF

docker build ^
    --platform linux/amd64,linux/arm64 ^
    --secret id=env,src=.env ^
    --tag ghcr.io/progressive-victory/the-local-setup:latest ^
    --no-cache-filter setup-env ^
    .
IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%

docker build ^
    --platform linux/amd64,linux/arm64 ^
    --secret id=env,src=public.env ^
    --tag ghcr.io/progressive-victory/the-local-setup-public:latest ^
    --no-cache-filter setup-env ^
    .
