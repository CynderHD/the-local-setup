@ECHO OFF

docker push ghcr.io/progressive-victory/the-local-setup:latest
IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%

docker push ghcr.io/progressive-victory/the-local-setup-public:latest
