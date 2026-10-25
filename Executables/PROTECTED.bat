@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0PROTECTED.ps1" %*
exit /b %errorlevel%
