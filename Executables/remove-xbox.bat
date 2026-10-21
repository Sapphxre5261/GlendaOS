@echo off

:: Check Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Please run this script with Administrator privileges!
    exit /b 1
)

echo Removing all Xbox apps and services...

:: 1. Remove all Xbox packages for all users and from the provisioned image
::    (AppX removal requires PowerShell)
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-AppxPackage -AllUsers -Name '*Xbox*' -ErrorAction SilentlyContinue | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue; Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like '*Xbox*' | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue"

:: 2. Remove GamingApp packages (not all start with 'Xbox')
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-AppxPackage -AllUsers -Name '*GamingApp*' -ErrorAction SilentlyContinue | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue; Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like '*GamingApp*' | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue"

:: 3. Stop and disable all Xbox background services
for %%S in (XblAuthManager XblGameSave XboxNetApiSvc XboxGipSvc GamingServices GamingServicesNet) do (
    sc query %%S >nul 2>&1 && (
        sc stop %%S >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%S" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
    )
)

echo Removed Xbox apps and services successfully!
exit /b 0
