@echo off
chcp 65001 >nul
setlocal

set "ROOT=%~dp0"
if not "%~1"=="" set "ROOT=%~1"
if not "%ROOT:~-1%"=="\" set "ROOT=%ROOT%\"

echo ============================================
echo  Git Pull All - %ROOT%
echo ============================================
echo.

echo [workspace]
git -C "%ROOT%." pull
if errorlevel 1 echo   ^<^< FAILED
echo.

set "SUCCESS=0"
set "FAILED=0"

rem Submodule list comes from .gitmodules, not from scanning directories.
for /f "usebackq delims=" %%L in (`git -C "%ROOT%." config -f .gitmodules --get-regexp "submodule\..*\.path"`) do (
    for /f "tokens=1,*" %%A in ("%%L") do (
        echo [%%B]
        git -C "%ROOT%%%B" pull --ff-only
        if errorlevel 1 (
            set /a FAILED+=1 >nul
            echo   ^<^< FAILED
        ) else (
            set /a SUCCESS+=1 >nul
        )
        echo.
    )
)

echo ============================================
echo  Done   Success: %SUCCESS%   Failed: %FAILED%
echo ============================================
pause
