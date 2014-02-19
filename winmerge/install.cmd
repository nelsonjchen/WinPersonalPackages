@echo off
cd /d "%~dp0"

:::::::: Package configuration

set exe_name=WinMergePortable.exe
set program_title=WinMerge Portable

:::::::: Environment

:: Paths to SendTo and Start Menu
for /f "tokens=3*" %%G in ('REG QUERY "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "Start Menu" ^|Find "REG_"') do call set _startmenu=%%H
for /f "tokens=2*" %%G in ('REG QUERY "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "SendTo" ^|Find "REG_"') do call set _sendto=%%H

if "%1"=="uninstall" goto :uninstall

:::::::: Install

cls
echo Installing %program_title%
echo.
echo This script will allow you to:
echo    * Install %program_title% in your SendTo Menu
echo    * Install %program_title% in your Start Menu
echo.
choice /M Continue
if errorlevel 2 goto :eof
echo.

echo.
choice /M "1) Create SendTo Menu shortcut"
if errorlevel 2 goto :install_startmenu

echo.
echo Creating SendTo shortcut...

echo Set a = WScript.CreateObject("WScript.Shell")>shortcut.vbs
echo Set b = a.CreateShortcut("%_sendto%\%program_title%.lnk")>>shortcut.vbs
echo b.TargetPath="%~dp0%exe_name%">>shortcut.vbs
echo b.Save>>shortcut.vbs
cscript //B //NoLogo shortcut.vbs
del shortcut.vbs

echo Done.

:install_startmenu

echo.
choice /M "2) Create Start Menu shortcut"
if errorlevel 2 goto :done

echo.
echo Creating Start Menu shortcut...

echo Set a = WScript.CreateObject("WScript.Shell")>shortcut.vbs
echo Set b = a.CreateShortcut("%_startmenu%\%program_title%.lnk")>>shortcut.vbs
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
echo    * Remove %program_title% from your SendTo Menu
echo    * Remove %program_title% from your Start Menu
echo.
choice /M Continue
if errorlevel 2 goto :eof
echo.

echo Removing SendTo shortcut...
del /q "%_sendto%\%program_title%.lnk">NUL
echo Removing Start Menu shortcut...
del /q "%_startmenu%\%program_title%.lnk">NUL
echo Done.

:::::::: Exit

:done
echo.
pause
