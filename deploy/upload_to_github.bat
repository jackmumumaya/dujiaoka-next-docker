@echo off
setlocal enabledelayedexpansion

echo [INFO] Check for Git installation...
where git >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Git is not installed or not in PATH.
    echo Please install Git from https://git-scm.com/download/win
    pause
    exit /b 1
)

echo [INFO] Initializing Git repository...
if not exist .git (
    git init
) else (
    echo [INFO] Git repository already initialized.
)

echo [INFO] Configuring user (if not set)...
git config user.name >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Please enter your Git user name:
    set /p "GIT_USER=Name: "
    git config user.name "!GIT_USER!"
    
    echo Please enter your Git email:
    set /p "GIT_EMAIL=Email: "
    git config user.email "!GIT_EMAIL!"
)

echo [INFO] Adding files to staging area...
git add .

echo [INFO] Committing changes...
git commit -m "Initial commit of dujiao-next deployment files"

echo [INFO] Setting up remote repository...
git remote remove origin 2>nul
git remote add origin https://github.com/jackmumumaya/dujiaoka-next-docker-

echo [INFO] Pushing to GitHub (you may need to sign in)...
git branch -M main
git push -u origin main

if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Code uploaded successfully!
) else (
    echo [ERROR] Failed to push code. Please check your network or credentials.
)

pause
