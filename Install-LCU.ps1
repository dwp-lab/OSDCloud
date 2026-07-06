# Install-LCU.ps1; Location: C:\OSDCloud\Scripts\SetupComplete\Install-LCU.ps1
# Installs latest SSU/LCU + critical updates (max 3 retries). Does not auto-reboot during install; reboot handled separately.

Start-Sleep -Seconds 10
# Install-Module PSWindowsUpdate -Force
Import-Module PSWindowsUpdate -Force

# Pull latest SSU/LCU + critical updates and reboot automatically if needed
# (Retries a couple times in case network is slow at first boot)
$tries = 0
while ($tries -lt 3) {
  try {
    Get-WindowsUpdate -MicrosoftUpdate -Category "Security Updates","Critical Updates","Updates" -AcceptAll -Install -IgnoreReboot
    break
  } catch {
    $tries++
    Start-Sleep -Seconds 60
  }
}

# Trigger Microsoft Edge update (https://char.learnwebcoding.com/help/windows_versions_software_bundled.html)
try {
    Start-Process -FilePath "C:\Program Files (x86)\Microsoft\EdgeUpdate\MicrosoftEdgeUpdate.exe" `
        -ArgumentList "/silent /install appguid={56EB18F8-B008-4CBD-B6D2-8C97FE7E9062}&appname=Microsoft%20Edge&needsadmin=True" `
        -Wait -ErrorAction Stop
}
catch {}
