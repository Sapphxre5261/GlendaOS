# GlendaOS

**[ภาษาไทย](#glendaos-ภาษาไทย)** | English

An [AME Wizard](https://ameliorated.io/) playbook for Windows focused on **gaming performance** — stable frametimes, minimal background activity, and a clean, still-manageable system.

Works on both **desktops and laptops** (power settings adapt to battery presence).

## Features

- **Custom "GlendaOS" power plan** — cloned from the best available scheme (Ultimate → High Performance → Balanced fallback) with aggressive ramp thresholds; full aggression on desktops, thermal/battery-aware on laptops
- **Gaming tweaks** — MMCSS Games profile, `Win32PrioritySeparation`, timer-resolution support, power throttling off, GameDVR off, mouse acceleration off, hibernation/Fast Startup off
- **VBS / HVCI / hypervisor disabled** and Spectre/Meltdown mitigations disabled — applied unconditionally (security-for-performance trade-off)
- **Service reduction** — ~60 non-essential services disabled or removed (telemetry, sync, sensors, remote access); all reversible via `sc`/registry
- **Windows Update paused for 10 years** — not broken: Resume works in Settings at any time
- **Registry backup first** — exported to `C:\Windows\GlendaOS\Backup\` before any changes
- **Custom wallpaper + lock screen**, dark theme, ghost taskbar pins cleaned
- **Brave browser** installed via Chocolatey

### Install-time options (checkboxes)

| Option | Effect if unchecked |
|---|---|
| Disable Windows Defender | Defender stays fully enabled |
| Remove Xbox apps & services | Xbox apps and all Xbox services stay |
| Disable Bluetooth | All Bluetooth services stay enabled |

## What stays working (by design)

- Windows Update / Insider / Windows Security pages remain **visible** in Settings
- Windows Security app renders normally (SecurityHealthService kept; Defender itself is off)
- WebView2 runtime kept — apps that embed web views keep working
- `AppXSvc` stays Manual — Microsoft Store installs still possible
- Storage Sense stays enabled

## Requirements

- AME Wizard (latest)
- Windows build **26300** (see `SupportedBuilds` in `playbook.conf` — add your build if needed)
- Internet connection (Brave install via Chocolatey)
- No pending updates / third-party AV
- If selecting **Disable Defender**: turn off **Tamper Protection** first (Windows Security → Virus & threat protection → Manage settings) — no script can bypass it by design

## Usage

1. Download AME Wizard
2. Drag the playbook folder / built `.apbx` into AME Wizard
3. Choose install options, let it run, reboot

## Reverting

- **Services**: restore from `C:\Windows\GlendaOS\Backup\services.reg`
- **Defender**: set `DisableAntiSpyware`/`DisableAntiVirus` to `0` under `HKLM\SOFTWARE\Policies\Microsoft\Windows Defender`, restore service start values
- **Windows Update**: Settings → Windows Update → Resume updates
- **Power plan**: `powercfg /s 381b4222-f694-41f0-9685-ff5bb260df2e` (Balanced), `powercfg /delete f1e2d3c4-b5a6-4c7d-8e9f-0a1b2c3d4e5f`

## Disclaimer

This playbook modifies the OS aggressively (disabled mitigations, VBS off, removed components, disabled services). **Use at your own risk** — test in a VM first. Security features are disabled in exchange for performance.

## Credits

Adapted from and inspired by:

- **[AtlasOS](https://github.com/Atlas-OS/Atlas)** — service configuration, Edge/OneDrive removal approach ([GPL-3.0](https://github.com/Atlas-OS/Atlas/blob/main/LICENSE))
- **[ReviOS](https://github.com/meetrevision/playbook)** — power plan formula (Ultimate Performance clone, ramp thresholds, core parking), `Win32PrioritySeparation`, HPET handling (licensed under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/); see [their LICENSE](https://github.com/meetrevision/playbook/blob/main/LICENSE))
- **[AME Wizard](https://ameliorated.io/)** by Ameliorated LLC — playbook framework
- Community-documented Windows techniques — Defender policy set, 10-year update pause registry values (public domain know-how, no specific author)

## License

[GPL-3.0](LICENSE) — this project is a derivative work of GPL-licensed and CC BY-SA-licensed material; see credits above.

---

# GlendaOS (ภาษาไทย)

Playbook สำหรับ [AME Wizard](https://ameliorated.io/) ที่เน้น **ประสิทธิภาพในการเล่นเกม** — เฟรมไทม์นิ่ง, ลดงานเบื้องหลัง, ระบบสะอาดแต่ยังจัดการต่อได้

ใช้ได้ทั้ง **เดสก์ท็อปและโน้ตบุ๊ก** (การตั้งค่าพลังงานปรับตามการมีแบตเตอรี่)

## ฟีเจอร์

- **Power plan "GlendaOS" เฉพาะ** — clone จาก scheme ที่ดีที่สุดที่มี (Ultimate → High Performance → Balanced สำรอง) พร้อม ramp thresholds แบบดุ บนเดสก์ท็อปเต็มสูตร / บนโน้ตบุ๊กถนอมความร้อนและแบต
- **Tweak สำหรับเกม** — MMCSS Games profile, `Win32PrioritySeparation`, รองรับ timer resolution, ปิด power throttling, ปิด GameDVR, ปิด mouse acceleration, ปิด hibernation/Fast Startup
- **ปิด VBS / HVCI / hypervisor** และปิด mitigations ของ Spectre/Meltdown — ใส่ให้เสมอไม่มีตัวเลือก (แลกความปลอดภัยกับ performance)
- **ลด services** — ปิด/ลบ service ที่ไม่จำเป็น ~60 ตัว (telemetry, sync, sensor, remote access) คืนค่าได้ผ่าน `sc`/registry
- **Windows Update ถูก Pause 10 ปี** — ไม่ได้พัง กด Resume ใน Settings ได้ทุกเมื่อ
- **สำรอง registry ก่อนแก้** — export ไว้ที่ `C:\Windows\GlendaOS\Backup\`
- **Wallpaper + lock screen ตามสั่ง**, ธีมมืด, ล้าง pin taskbar ที่ตายแล้ว
- **ติดตั้ง Brave browser** ผ่าน Chocolatey

### ตัวเลือกตอนติดตั้ง (checkbox)

| ตัวเลือก | ถ้าไม่ติ๊กจะเกิดอะไร |
|---|---|
| Disable Windows Defender | Defender ยังเปิดเต็ม |
| Remove Xbox apps & services | แอปและ service Xbox อยู่ครบ |
| Disable Bluetooth | service Bluetooth ทั้งหมดยังเปิด |

## สิ่งที่ยังใช้ได้ตามเจตนา

- หน้า Windows Update / Insider / Windows Security ยัง **เห็น** ใน Settings
- แอป Windows Security เปิดได้ปกติ (เก็บ SecurityHealthService ไว้ ส่วน Defender ปิด)
- WebView2 runtime เก็บไว้ — แอปที่ฝัง web view ใช้ได้
- `AppXSvc` คง Manual — ลงแอปจาก Microsoft Store ได้
- Storage Sense ยังเปิด

## ความต้องการ

- AME Wizard (เวอร์ชันล่าสุด)
- Windows build **26300** (ดู `SupportedBuilds` ใน `playbook.conf` — เพิ่ม build ของคุณได้ถ้าจำเป็น)
- อินเทอร์เน็ต (ติดตั้ง Brave ผ่าน Chocolatey)
- ไม่มี pending update / ไม่มี antivirus อื่น
- ถ้าเลือก **Disable Defender**: ต้องปิด **Tamper Protection** เองก่อน (Windows Security → Virus & threat protection → Manage settings) — ออกแบบมาให้สคริปต์แก้ไม่ได้โดยตรง

## วิธีใช้

1. ดาวน์โหลด AME Wizard
2. ลากโฟลเดอร์ playbook / ไฟล์ `.apbx` ที่ build แล้วลงใน AME Wizard
3. เลือก options แล้วรัน จากนั้นรีสตาร์ท

## การคืนค่า

- **Services**: คืนจาก `C:\Windows\GlendaOS\Backup\services.reg`
- **Defender**: ตั้ง `DisableAntiSpyware`/`DisableAntiVirus` เป็น `0` ใน `HKLM\SOFTWARE\Policies\Microsoft\Windows Defender` แล้วคืนค่า start ของ service
- **Windows Update**: Settings → Windows Update → Resume updates
- **Power plan**: `powercfg /s 381b4222-f694-41f0-9685-ff5bb260df2e` (Balanced) แล้ว `powercfg /delete f1e2d3c4-b5a6-4c7d-8e9f-0a1b2c3d4e5f`

## ข้อควรระวัง

Playbook นี้แก้ระบบค่อนข้างรุนแรง (ปิด mitigations, ปิด VBS, ลบ component, ปิด service จำนวนมาก) **ใช้ในความเสี่ยงของตัวเอง** — ควรทดสอบใน VM ก่อนใช้จริง แลกฟีเจอร์ความปลอดภัยเพื่อ performance

## เครดิต

ดัดแปลงและได้แรงบันดาลใจจาก:

- **[AtlasOS](https://github.com/Atlas-OS/Atlas)** — การตั้งค่า service, แนวทางลบ Edge/OneDrive ([GPL-3.0](https://github.com/Atlas-OS/Atlas/blob/main/LICENSE))
- **[ReviOS](https://github.com/meetrevision/playbook)** — สูตร power plan (clone Ultimate Performance, ramp thresholds, core parking), `Win32PrioritySeparation`, การจัดการ HPET (ภายใต้ [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/); ดู [LICENSE ของเขา](https://github.com/meetrevision/playbook/blob/main/LICENSE))
- **[AME Wizard](https://ameliorated.io/)** โดย Ameliorated LLC — framework สำหรับ playbook
- เทคนิค Windows ที่เป็นองค์ความรู้สาธารณะของ community — ชุด policy ของ Defender, ค่า registry pause update 10 ปี (ไม่มีเจ้าของเฉพาะ)

## License

[GPL-3.0](LICENSE) — โปรเจกต์นี้เป็น derivative work ของวัสดุภายใต้ GPL และ CC BY-SA ดูเครดิตด้านบน
