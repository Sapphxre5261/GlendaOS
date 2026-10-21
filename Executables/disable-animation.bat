@echo off
title Disable Windows Animations and Transparency
echo กำลังปิดเอฟเฟกต์แอนิเมชันและเอฟเฟกต์กระจก กรุณารอสักครู่...

:: 1. ปิดเอฟเฟกต์แอนิเมชันในหน้าต่าง (Visual Effects)
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f

:: 2. ปิดเอฟเฟกต์การเฟดหรือเลื่อนของเมนูและหน้าต่าง
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "2" /f
reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "9012038010000000" /f

:: 3. ปิดเอฟเฟกต์ความโปร่งใส (Transparency / Acrylic Glass)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "0" /f

:: 4. รีสตาร์ท Windows Explorer เพื่อให้การตั้งค่ามีผลทันที
taskkill /f /im explorer.exe
start explorer.exe

echo Close Animations Success!
exit /b 0