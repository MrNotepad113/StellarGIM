@echo off
:: Batch file to set an environment variable using ync.exe

:: Prompt the user for debug mode using ync.exe
ync /c YN "Enable debug mode? (Y/N)"

:: Check the errorlevel returned by ync.exe
if errorlevel 2 (
    echo Debug mode is enabled.
    set DEBUG_MODE=1
) else (
    echo Debug mode is disabled.
    set DEBUG_MODE=0
)

:: Display the current debug mode setting
echo DEBUG_MODE is set to %DEBUG_MODE%

:: Example: Continue with the script using the DEBUG_MODE variable
if "%DEBUG_MODE%"=="1" (
    echo Debug mode actions go here...
) else (
    echo Normal mode actions go here...
)

pause
