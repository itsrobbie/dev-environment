@echo off
:: Check if the script is already running as admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo "Requesting administrator privileges..."
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Set up Git Bash path (modify this if Git Bash is in a different location)
set "GIT_BASH_PATH=C:\Program Files\Git\bin\bash.exe"

:: Check if Git Bash exists
if not exist "%GIT_BASH_PATH%" (
    echo "Git Bash is not installed in the default location. Please install Git Bash or modify the script with the correct path."
    pause
    exit /b
)

:: Run the setup script with Git Bash
cd /d "%~dp0"
"%GIT_BASH_PATH%" -c "./setup_dev_env.sh"

pause
