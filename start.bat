@ECHO OFF

IF "%~1" == "" (
    SET "MODE=private"
) ELSE IF "%~1" == "private" (
    SET "MODE=private"
) ELSE IF "%~1" == "public" (
    SET "MODE=public"
) ELSE (
    ECHO Invalid mode %1! Must be 'public' or 'private'
    EXIT /B 1
)

:: Clear preexisting value
SET MY_VAR=

:: Prompt for the password securely
ECHO Enter your SSH password. If blank, hit enter:
:: Batch doesn't support quiet passwords by default, use Powershell to retrieve the value securely.
FOR /F "delims=" %%i IN ('powershell -Command "$p = Read-Host -AsSecureString; [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($p))"') DO SET "SSH_PASSWORD=%%i"

ssh-keygen -y -P "%SSH_PASSWORD%" -f "%USERPROFILE%\.ssh\id_pv" >nul 2>&1

:: Check the exit code (0 = Correct passphrase, 1 = Incorrect)
IF %ERRORLEVEL% EQU 0 (
    ECHO.
    ECHO Success: Passphrase is correct for this private key.
) ELSE (
    ECHO Failure: Incorrect passphrase or invalid private key file.
    EXIT /B 1
)

FOR /F "tokens=*" %%i IN ('git rev-parse --abbrev-ref HEAD 2^>nul') DO SET "BRANCH=%%i"
IF "%BRANCH%" == "main" (
    ECHO Syncing with origin...
    git stash -u
    IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
    git pull
    IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
    git stash pop
    IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
    ECHO Sync complete!
)

MKDIR pv 2>nul

docker rm -f the-local-setup

docker build ^
    --secret "id=ssh,src=%USERPROFILE%\.ssh\id_pv" ^
    --secret "id=sshpub,src=%USERPROFILE%\.ssh\id_pv.pub" ^
    --build-arg MODE=%MODE% ^
    --tag the-local-setup:latest ^
    --no-cache-filter setup-ssh ^
    .
IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%

docker run ^
    -e SSH_PASSPHRASE="${SSH_PASSWORD}" ^
    -p 3000:3000 -p 3001:3001 -p 3306:3306 -p 6006:6006 -p 8080:8080 ^
    -v "%~dp0\pv:/home/pv/pv" -dit ^
    --name the-local-setup the-local-setup:latest
IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%

ECHO Container is running! Run ./attach.sh (or attach.bat) to start a terminal in the container.
