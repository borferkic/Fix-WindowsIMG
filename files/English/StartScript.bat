@echo off
set "ruta=%~dp0"
powershell.exe -ExecutionPolicy Bypass -File "%ruta%FixingWindows-ENG.ps1"
pause