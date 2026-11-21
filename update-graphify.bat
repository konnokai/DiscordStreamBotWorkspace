@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

set "ROOT=%~dp0"
if not "%~1"=="" set "ROOT=%~1"
if not "%ROOT:~-1%"=="\" set "ROOT=%ROOT%\"

echo ============================================
echo  Graphify Update All - %ROOT%
echo ============================================
echo.

set "SUCCESS=0"
set "FAILED=0"
set "SKIPPED=0"

for /d %%D in ("%ROOT%*") do if exist "%%D\.git" (
    echo [%%~nD]
    pushd "%%D"
    call graphify update . 2>&1
    if errorlevel 1 (
        set /a FAILED+=1 >nul
        echo   ^<^< FAILED
    ) else (
        set /a SUCCESS+=1 >nul
    )
    popd
    echo.
)

echo ============================================
echo  Done   Success: %SUCCESS%   Failed: %FAILED%   Skipped: %SKIPPED%
echo ============================================
pause
