@echo off
setlocal enabledelayedexpansion

echo Aegisub Scripts Installer for Windows
echo ===================================
echo.

set "DEST_DIR=%APPDATA%\Aegisub\automation\autoload"
set "SRC_DIR=%~dp0..\scripts"

if not exist "%SRC_DIR%" (
    echo Error: Scripts folder not found!
    echo Looking for: %SRC_DIR%
    echo Please make sure all .lua scripts are placed in a 'scripts' folder.
    goto :end
)

echo Checking if Aegisub autoload directory exists...
if not exist "%DEST_DIR%" (
    echo Creating directory %DEST_DIR%
    mkdir "%DEST_DIR%"
)

echo.
echo Copying scripts to %DEST_DIR%...
for %%F in ("%SRC_DIR%\*.lua") do (
    echo Installing: %%~nxF
    copy "%%F" "%DEST_DIR%" > nul
)

echo.
echo Installation complete!
echo.
echo All scripts have been installed to your Aegisub autoload directory.
echo Please restart Aegisub if it's currently running.

:end
echo.
pause
