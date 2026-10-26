@echo off

:: Manual Windows Updates only (option: manual-updates)
:: Belt-and-suspenders: !registryValue on the WindowsUpdate policy key has been
:: observed to silently not apply, so enforce it here via reg.exe as SYSTEM.
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 2 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f

:: Pause updates until end of 2036 (shows "paused" in Settings > Windows Update)
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v FlightSettingsMaxPauseDays /t REG_DWORD /d 5000 /f
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseFeatureUpdatesStartTime /t REG_SZ /d "2026-01-01T00:00:00Z" /f
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseFeatureUpdatesEndTime /t REG_SZ /d "2036-12-31T00:00:00Z" /f
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseQualityUpdatesStartTime /t REG_SZ /d "2026-01-01T00:00:00Z" /f
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseQualityUpdatesEndTime /t REG_SZ /d "2036-12-31T00:00:00Z" /f
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseUpdatesExpiryTime /t REG_SZ /d "2036-12-31T00:00:00Z" /f

:: "Scheduled Start" is protected against deletion on newer builds - disable instead
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start" /Disable > NUL 2>&1

exit /b 0
