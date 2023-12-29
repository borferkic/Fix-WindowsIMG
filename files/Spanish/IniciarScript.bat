@echo off
set "ruta=%~dp0"
powershell.exe -ExecutionPolicy Bypass -File "%ruta%FixingWindows-ESP.ps1"
pause