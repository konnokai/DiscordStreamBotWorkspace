@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

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

rem 子 repo 清單取自 .gitmodules，不掃目錄，避免把非 submodule 的資料夾當成 repo。
for /f "usebackq delims=" %%L in (`git -C "%ROOT%." config -f .gitmodules --get-regexp "submodule\..*\.path"`) do (
    for /f "tokens=1,*" %%A in ("%%L") do (
        set "SUB=%%B"
        echo [!SUB!]
        git -C "%ROOT%!SUB!" pull --ff-only
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
