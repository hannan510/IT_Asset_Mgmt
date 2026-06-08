@echo off
setlocal enabledelayedexpansion
title IT Asset Mgmt - GitHub Push Setup
color 0B

echo ==================================================
echo    GitHub Push Setup  -  IT_Asset_Mgmt
echo ==================================================
echo.

REM Work from the folder this script lives in
cd /d "%~dp0"

REM --- Make sure git is available ---
where git >nul 2>nul
if errorlevel 1 (
    echo [ERROR] Git is not installed or not on PATH.
    echo Install Git for Windows from https://git-scm.com/download/win then re-run.
    pause
    exit /b 1
)

REM --- Ensure the .ssh folder exists ---
if not exist "%USERPROFILE%\.ssh" mkdir "%USERPROFILE%\.ssh"

REM --- [1] Generate SSH keys (ed25519 if missing, RSA regenerated fresh) ---
if not exist "%USERPROFILE%\.ssh\id_ed25519" (
    echo [1/6] Generating a new ED25519 key...
    ssh-keygen -t ed25519 -C "hannan510@gmail.com" -f "%USERPROFILE%\.ssh\id_ed25519" -N ""
) else (
    echo [1/6] ED25519 key already exists - reusing it.
)
echo       Regenerating a fresh RSA 4096-bit key...
if exist "%USERPROFILE%\.ssh\id_rsa" del /f /q "%USERPROFILE%\.ssh\id_rsa" "%USERPROFILE%\.ssh\id_rsa.pub" >nul 2>nul
ssh-keygen -t rsa -b 4096 -C "hannan510@gmail.com" -f "%USERPROFILE%\.ssh\id_rsa" -N ""
echo.

REM --- [2] Show both public keys; copy the RSA key to the clipboard ---
echo [2/6] Your PUBLIC keys:
echo.
echo --- ED25519 -------------------------------------
type "%USERPROFILE%\.ssh\id_ed25519.pub"
echo.
echo --- RSA (this one is copied to your clipboard) ---
type "%USERPROFILE%\.ssh\id_rsa.pub"
echo --------------------------------------------------
type "%USERPROFILE%\.ssh\id_rsa.pub" | clip
echo (The RSA key is now on your clipboard - press Ctrl+V on GitHub.)
echo  You can add either key; adding both is fine too.
echo.

REM --- [3] Open the GitHub "add SSH key" page ---
echo [3/6] Opening GitHub in your browser...
start "" "https://github.com/settings/ssh/new"
echo.
echo     On that page:
echo        - Title: anything (e.g. My Laptop)
echo        - Key type: Authentication Key
echo        - Key: paste with Ctrl+V
echo        - Click "Add SSH key"
echo.
echo     When you have added the key, come back here and press a key...
pause

REM --- [4] Test the SSH connection ---
echo.
echo [4/6] Testing the GitHub connection...
ssh -o StrictHostKeyChecking=accept-new -T git@github.com
echo  (A "successfully authenticated" message above means it worked.)
echo.

REM --- [5] Initialise the repo and make a commit ---
echo [5/6] Preparing the local repository...
if not exist ".git" git init
git branch -M main
git add .
git commit -m "IT Asset Management app: dashboard, CRUD, employee ID/phone, AED, exports" 2>nul || echo     (Nothing new to commit - continuing.)
echo.

REM --- [6] Point the remote at SSH and push ---
echo [6/6] Pushing to GitHub...
git remote remove origin 2>nul
git remote add origin git@github.com:hannan510/IT_Asset_Mgmt.git
git push -u origin main
if errorlevel 1 (
    echo.
    echo [!] Push did not complete. If the repo already has commits on GitHub
    echo     (for example a README), run these two lines, then re-run this file:
    echo.
    echo         git pull origin main --allow-unrelated-histories
    echo         git push -u origin main
)

echo.
echo ==================================================
echo    Finished. Review the messages above.
echo ==================================================
pause
endlocal
