Start-Sleep -Seconds 10
Import-Module PSWindowsUpdate -Force -Scope AllUsers

# Pull latest SSU/LCU + critical updates and reboot automatically if needed
# (Retries a couple times in case network is slow at first boot)
$tries = 0
while ($tries -lt 3) {
  try {
    Get-WindowsUpdate -MicrosoftUpdate -Category "Security Updates","Critical Updates","Updates" -AcceptAll -Install -AutoReboot
    break
  } catch {
    $tries++
    Start-Sleep -Seconds 60
  }
}

Restart-Computer -Force