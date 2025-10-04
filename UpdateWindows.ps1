$StartTime = Get-Date; Write-Host "Start Time: $($StartTime.ToString("hh:mm:ss"))"
Start-Sleep -Seconds 10
Start-Transcript -Path 'C:\OSDCloud\Logs\UpdateWindows.log' -ErrorAction Ignore

$ModulePath = (Get-ChildItem -Path "$($Env:ProgramFiles)\WindowsPowerShell\Modules\osd" | Where-Object {$_.Attributes -match "Directory"} | select -Last 1).fullname
Import-Module "$ModulePath\OSD.psd1" -Force
iex (irm functions.osdcloud.com)
UpdateWindows

$EndTime = Get-date; Write-Host "End Time: $($EndTime.ToString("hh:mm:ss"))"
$TotalTime = New-TimeSpan -Start $StartTime -End $EndTime; $RunTimeMinutes = [math]::round($TotalTime.TotalMinutes,0); Write-Host "Run Time: $RunTimeMinutes Minutes"
Stop-Transcript
Restart-Computer -Force
