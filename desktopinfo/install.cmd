@echo off
cd /d "%~dp0"

:::::::: Package configuration

set exe_name=DesktopInfo.exe
set program_title=Desktop Info

:::::::: Environment

:: Paths to Start Menu
for /f "tokens=3*" %%G in ('REG QUERY "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "Start Menu" ^|Find "REG_"') do call set _startmenu=%%H

if "%1"=="uninstall" goto :uninstall

:::::::: Install

cls
echo Installing %program_title%
echo.
echo This script will allow you to:
echo    * Install %program_title% in your Start Menu\Startup folder
echo.
echo NOTE: This will only be installed for the current user. To make this
echo effective for all users, move the shortcut to the appropriate All Users folder
echo after you install it.
echo.
choice /M Continue
if errorlevel 2 goto :eof
echo.

echo.
choice /M "Create Start Menu\Startup shortcut"
if errorlevel 2 goto :done

echo.
echo Creating Start Menu shortcut...

md "%_startmenu%\Startup" 2>NUL
echo Set a = WScript.CreateObject("WScript.Shell")>shortcut.vbs
echo Set b = a.CreateShortcut("%_startmenu%\Startup\%program_title%.lnk")>>shortcut.vbs
echo b.TargetPath="%~dp0%exe_name%">>shortcut.vbs
echo b.Save>>shortcut.vbs
cscript //B //NoLogo shortcut.vbs
del shortcut.vbs

echo Done.
goto :done

:::::::: Uninstall

:uninstall

cls
echo Uninstalling %program_title%
echo.
echo This script will allow you to:
echo    * Remove %program_title% from your Start Menu\Startup folder
echo.
choice /M Continue
if errorlevel 2 goto :eof
echo.

echo Removing Start Menu\Startup shortcut...
del /q "%_startmenu%\Startup\%program_title%.lnk">NUL
echo Done.

:::::::: Exit

:done
echo.
pause
