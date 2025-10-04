#Set-ExecutionPolicy RemoteSigned -Force -Scope CurrentUser
$StartTime = Get-Date; Write-Host "Start Time: $($StartTime.ToString("hh:mm:ss"))"
Start-Sleep -Seconds 10
Start-Transcript -Path 'C:\OSDCloud\Logs\Install-LCU.log' -ErrorAction Ignore

# Register and trust PSGallery for SYSTEM
$psg = Get-PSRepository -Name PSGallery -ErrorAction SilentlyContinue
if (-not $psg -or -not $psg.SourceLocation -or -not $psg.ScriptSourceLocation) {
    Unregister-PSRepository -Name PSGallery -ErrorAction SilentlyContinue
    Register-PSRepository -Name PSGallery -InstallationPolicy Trusted `
        -SourceLocation 'https://www.powershellgallery.com/api/v2' `
        -ScriptSourceLocation 'https://www.powershellgallery.com/api/v2'
} else {
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
}

Install-PackageProvider -Name NuGet -Force -Scope AllUsers
Install-Module PSWindowsUpdate -Force -Scope AllUsers

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

Stop-Transcript | Out-Null
