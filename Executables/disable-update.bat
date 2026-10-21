@echo off

:: Check Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Please run this script with Administrator privileges!
    exit /b 1
)

echo Pausing Windows Update for 10 years...

:: Allow pausing far into the future (default cap is ~5 weeks)
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v FlightSettingsMaxPauseDays /t REG_DWORD /d 3650 /f >nul 2>&1

:: Compute now / +10 years timestamps via PowerShell (locale-independent)
for /f %%d in ('powershell -NoProfile -C "(Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')"') do set START=%%d
for /f %%d in ('powershell -NoProfile -C "(Get-Date).AddYears(10).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')"') do set END=%%d

reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseFeatureUpdatesStartTime /t REG_SZ /d "%START%" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseFeatureUpdatesEndTime /t REG_SZ /d "%END%" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseQualityUpdatesStartTime /t REG_SZ /d "%START%" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseQualityUpdatesEndTime /t REG_SZ /d "%END%" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseUpdatesExpiryTime /t REG_SZ /d "%END%" /f >nul 2>&1

:: Status flags the Settings UI reads to display the paused state
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PausedFeatureStatus /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PausedQualityStatus /t REG_DWORD /d 1 /f >nul 2>&1

:: Remove hard-disable policies if a previous run set them, so Resume works
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /f >nul 2>&1

echo Windows Update paused until %END% - resume anytime in Settings.
exit /b 0
