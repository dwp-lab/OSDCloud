Set-ExecutionPolicy RemoteSigned -Force -Scope CurrentUser
$StartTime = Get-Date; Write-Host "Start Time: $($StartTime.ToString("hh:mm:ss"))"
Start-Sleep -Seconds 10
Start-Transcript -Path 'C:\Windows\OSDCloud\Logs\Install-LCU.log' -ErrorAction Ignore
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

$EndTime = Get-date; Write-Host "End Time: $($EndTime.ToString("hh:mm:ss"))"
$TotalTime = New-TimeSpan -Start $StartTime -End $EndTime; $RunTimeMinutes = [math]::round($TotalTime.TotalMinutes,0); Write-Host "Run Time: $RunTimeMinutes Minutes"
Stop-Transcript
Restart-Computer -Force
