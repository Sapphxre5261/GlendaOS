@echo off
:: Pre-creates the Brave profile/first-run caches so the first user launch is
:: fast. Brave installs per-user to LocalAppData via chocolatey - check all
:: known locations since no shim is created on PATH.
set "BRAVE=%LOCALAPPDATA%\BraveSoftware\Brave-Browser\Application\brave.exe"
if not exist "%BRAVE%" set "BRAVE=%ProgramFiles%\BraveSoftware\Brave-Browser\Application\brave.exe"
if not exist "%BRAVE%" set "BRAVE=%ProgramFiles(x86)%\BraveSoftware\Brave-Browser\Application\brave.exe"
if not exist "%BRAVE%" exit /b 0
start "" "%BRAVE%" --no-first-run
exit /b 0
