Set-ExecutionPolicy RemoteSigned -Force -Scope CurrentUser

Start-Transcript -Path "$env:SystemRoot\OSDCloud\Logs\Install-LCU.log" -Append | Out-Null

Set-ExecutionPolicy Bypass -Scope Process -Force
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Install-PackageProvider -Name NuGet -Force -Scope AllUsers | Out-Null
Install-Module PSWindowsUpdate -Force -Scope AllUsers | Out-Null

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
