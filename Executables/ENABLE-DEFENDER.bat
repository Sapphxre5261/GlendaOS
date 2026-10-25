@echo off
:: Re-enables Windows Defender after the GlendaOS 'defender' option disabled it.
:: Run as administrator. Reverts everything the playbook changed.

net session >nul 2>&1
if errorlevel 1 (
	echo This script must be run as administrator.
	exit /b 1
)

set "BK=%ProgramData%\GlendaOS\Backups"

:: 1. Restore original service keys exported by PROTECTED.ps1 (covers the
::    services that were actually disabled; WinDefend/WdNisSvc/WdNisDrv/
::    WdFilter/WdBoot are ELAM-protected and were never changed)
if exist "%BK%\service-*.reg" (
	for %%f in ("%BK%\service-*.reg") do reg import "%%f" >nul
)

:: Remove the extra value PROTECTED.ps1 added (not present by default)
for %%s in (WinDefend WdNisSvc Sense SecurityHealthService WdNisDrv WdFilter WdBoot) do (
	reg delete "HKLM\SYSTEM\CurrentControlSet\Services\%%s" /v "AutorunsDisabled" /f >nul 2>&1
)

:: 2. Remove Defender policies
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /f >nul 2>&1

:: 3. Re-enable the scheduled tasks disabled by the playbook
for %%t in (
	"\Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance"
	"\Microsoft\Windows\Windows Defender\Windows Defender Cleanup"
	"\Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan"
	"\Microsoft\Windows\Windows Defender\Windows Defender Verification"
) do schtasks /Change /TN %%~t /Enable >nul 2>&1

:: 4. Restore the tray icon startup entry
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SecurityHealth" /t REG_SZ /d "%%windir%%\system32\SecurityHealthSystray.exe" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "SecurityHealth" /t REG_BINARY /d "020000000000000000000000" /f

echo Defender re-enabled. Reboot recommended.
exit /b 0
