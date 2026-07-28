@echo off

:: Clear preexisting value
set MY_VAR=

:: Prompt for the password securely
ECHO Enter your SSH password. If blank, hit enter:
:: Batch doesn't support quiet passwords by default, use Powershell to retrieve the value securely.
for /f "delims=" %%i in ('powershell -Command "$p = Read-Host -AsSecureString; [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($p))"') do set "SSH_PASSWORD=%%i"

ssh-keygen -y -P "%SSH_PASSWORD%" -f "%USERPROFILE%\.ssh\id_pv" >nul 2>&1

:: Check the exit code (0 = Correct passphrase, 1 = Incorrect)
if %errorlevel% equ 0 (
    ECHO.
    ECHO Success: Passphrase is correct for this private key.
) else (
    ECHO Failure: Incorrect passphrase or invalid private key file.
    exit /b 1
)

mkdir pv 2>nul

docker rm -f the-local-setup

docker build ^
    --secret "id=ssh,src=%USERPROFILE%\.ssh\id_pv" --secret "id=sshpub,src=%USERPROFILE%\.ssh\id_pv.pub" ^
    --tag the-local-setup:latest --no-cache .
IF %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

docker run ^
    -e SSH_PASSPHRASE="${SSH_PASSWORD}" ^
    -p 3000:3000 -p 3001:3001 -p 3306:3306 -p 6006:6006 -p 8080:8080 ^
    -v "%~dp0\pv:/home/pv/pv" -dit ^
    --name the-local-setup the-local-setup:latest
IF %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

ECHO Container is running! Run ./attach.sh (or attach.bat) to start a terminal in the container.
