# Handles registry writes that !registryValue/!service can't do on newer builds
# because the keys are ACL-protected (deny write even for SYSTEM).
# Takes ownership via SeTakeOwnershipPrivilege, grants SYSTEM full control, then writes.

param(
    [switch]$Services,
    [switch]$Policies
)

$privCode = @'
using System;
using System.Runtime.InteropServices;
public class TokenPrivileges {
    [DllImport("advapi32.dll", SetLastError = true)]
    static extern bool OpenProcessToken(IntPtr ProcessHandle, uint DesiredAccess, out IntPtr TokenHandle);
    [DllImport("advapi32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
    static extern bool LookupPrivilegeValue(string lpSystemName, string lpName, out long lpLuid);
    [DllImport("advapi32.dll", SetLastError = true)]
    static extern bool AdjustTokenPrivileges(IntPtr TokenHandle, bool DisableAllPrivileges, ref TOKEN_PRIVILEGES NewState, int BufferLength, IntPtr PreviousState, IntPtr ReturnLength);
    [StructLayout(LayoutKind.Sequential)]
    struct TOKEN_PRIVILEGES { public int PrivilegeCount; public long Luid; public int Attributes; }
    public static void Enable(string name) {
        IntPtr h;
        OpenProcessToken(System.Diagnostics.Process.GetCurrentProcess().Handle, 0x28, out h);
        TOKEN_PRIVILEGES tp = new TOKEN_PRIVILEGES { PrivilegeCount = 1, Attributes = 2 };
        LookupPrivilegeValue(null, name, out tp.Luid);
        AdjustTokenPrivileges(h, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero);
    }
}
'@
Add-Type $privCode
'SeTakeOwnershipPrivilege','SeRestorePrivilege','SeBackupPrivilege' | ForEach-Object { [TokenPrivileges]::Enable($_) }

$adminSid  = New-Object System.Security.Principal.SecurityIdentifier 'S-1-5-32-544'
$systemSid = New-Object System.Security.Principal.SecurityIdentifier 'S-1-5-18'

function Grant-RegKey([string]$Path) {
    # 1) Try writing the DACL directly - SeRestorePrivilege grants implicit
    #    WRITE_DAC so an ownership change may not be needed at all
    $acl = Get-Acl $Path
    $rule = New-Object System.Security.AccessControl.RegistryAccessRule($systemSid, 'FullControl', 'ContainerInherit', 'None', 'Allow')
    $acl.SetAccessRule($rule)
    try {
        Set-Acl -Path $Path -AclObject $acl -ErrorAction Stop
        return
    } catch {}

    # 2) Fall back to taking ownership first, then grant SYSTEM full control
    $acl = Get-Acl $Path
    $acl.SetOwner($adminSid)
    Set-Acl -Path $Path -AclObject $acl -ErrorAction Stop
    $acl = Get-Acl $Path
    $acl.SetAccessRule($rule)
    Set-Acl -Path $Path -AclObject $acl -ErrorAction Stop
}

# Defender services - SCM-based changes are denied, write Start=4 directly
# Original keys are exported to %ProgramData%\GlendaOS\Backups so a future
# re-enable tool can restore them with a plain "reg import"
if ($Services) {
    $backupDir = "$env:ProgramData\GlendaOS\Backups"
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null

    # Keep the re-enable script on the deployed machine for a future toggle tool
    Copy-Item -Path "$PSScriptRoot\ENABLE-DEFENDER.bat" -Destination "$env:ProgramData\GlendaOS\" -Force -ErrorAction SilentlyContinue

    # Note: SecurityHealthService is intentionally kept enabled - it feeds the
    # Windows Security app; disabling it leaves SecHealthUI showing a blank page.
    # Sense is also kept - disabling it isn't needed for a clean debloat.
    foreach ($s in 'WinDefend','WdNisSvc','WdNisDrv','WdFilter','WdBoot') {
        $k = "HKLM:\SYSTEM\CurrentControlSet\Services\$s"
        if (!(Test-Path $k)) { Write-Host "$s : not present, skipping"; continue }
        & reg.exe export "HKLM\SYSTEM\CurrentControlSet\Services\$s" "$backupDir\service-$s.reg" /y | Out-Null
        try {
            Grant-RegKey $k
            Set-ItemProperty -Path $k -Name 'Start' -Value 4 -Type DWord -ErrorAction Stop
            Set-ItemProperty -Path $k -Name 'AutorunsDisabled' -Value 3 -Type DWord -ErrorAction SilentlyContinue
            Write-Host "$s : disabled"
        } catch {
            Write-Host "$s : FAILED - $($_.Exception.Message)"
        }
    }
}

# ACL-protected policy keys
if ($Policies) {
    $targets = @(
        @{ Path = 'HKLM:\SOFTWARE\Policies\Microsoft\Dsh'; Name = 'AllowNewsAndInterests' },
        @{ Path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds'; Name = 'EnableFeeds' }
    )
    foreach ($t in $targets) {
        try {
            if (!(Test-Path $t.Path)) { New-Item $t.Path -Force | Out-Null }
            Grant-RegKey $t.Path
            New-ItemProperty -Path $t.Path -Name $t.Name -PropertyType DWord -Value 0 -Force -ErrorAction Stop | Out-Null
            Write-Host "$($t.Path)\$($t.Name) : set to 0"
        } catch {
            Write-Host "$($t.Path) : FAILED - $($_.Exception.Message)"
        }
    }
}
