@echo off

:: Check Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Please run this script with Administrator privileges!
    exit /b 1
)

echo Disabling unnecessary services for gaming...

:: 1. Telemetry and Diagnostics
for %%S in (DiagTrack diagnosticshub.standardcollector.service WerSvc wercplsupport UCPD SEMgrSvc) do (
    sc query %%S >nul 2>&1 && (
        sc stop %%S >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%S" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
    )
)

:: 2. Search indexing (WSearch) and Distributed Link Tracking (TrkWks)
for %%S in (WSearch TrkWks) do (
    sc query %%S >nul 2>&1 && (
        sc stop %%S >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%S" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
    )
)

:: 3. Sync, Phone and Mobile features
for %%S in (OneSyncSvc dmwappushservice PhoneSvc icssvc MapsBroker) do (
    sc query %%S >nul 2>&1 && (
        sc stop %%S >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%S" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
    )
)

:: 4. Sensors and Geolocation
for %%S in (lfsvc SensorDataService SensrSvc SensorService) do (
    sc query %%S >nul 2>&1 && (
        sc stop %%S >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%S" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
    )
)

:: 5. Network discovery and sharing (does not affect internet or online games)
for %%S in (SharedAccess lltdsvc SSDPSRV upnphost RemoteAccess NetTcpPortSharing NetBT) do (
    sc query %%S >nul 2>&1 && (
        sc stop %%S >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%S" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
    )
)

:: 6. Miscellaneous features
for %%S in (AxInstSV CscService AppVClient QWAVE PcaSvc ShellHWDetection tzautoupdate wisvc WalletService SysMain) do (
    sc query %%S >nul 2>&1 && (
        sc stop %%S >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%S" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
    )
)

:: 7. Printing (Spooler, PrintNotify)
for %%S in (Spooler PrintNotify) do (
    sc query %%S >nul 2>&1 && (
        sc stop %%S >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%S" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
    )
)

:: 8. Bluetooth (bthserv, BTAGService, BthAvctpSvc, BluetoothUserService)
choice /c yn /n /m "Disable Bluetooth services? (y/n): "
if %errorlevel% equ 1 (
    for %%S in (bthserv BTAGService BthAvctpSvc BluetoothUserService) do (
        sc query %%S >nul 2>&1 && (
            sc stop %%S >nul 2>&1
            reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%S" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
        )
    )
)

:: 9. Xbox services (Xbox Live, Game Save, Networking, Accessory Management)
choice /c yn /n /m "Disable Xbox services? (y/n): "
if %errorlevel% equ 1 (
    for %%S in (XblAuthManager XblGameSave XboxNetApiSvc XboxGipSvc) do (
        sc query %%S >nul 2>&1 && (
            sc stop %%S >nul 2>&1
            reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%S" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
        )
    )
)

echo Disabled unnecessary services successfully! ^(Restart recommended^)
exit /b 0
