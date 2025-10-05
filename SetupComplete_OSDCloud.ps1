Write-Output 'Starting SetupComplete Script Process'
Set-ExecutionPolicy RemoteSigned -Force -Scope CurrentUser
$StartTime = Get-Date; Write-Host "Start Time: $($StartTime.ToString("hh:mm:ss"))"
$ModulePath = (Get-ChildItem -Path "$($Env:ProgramFiles)\WindowsPowerShell\Modules\osd" | Where-Object {$_.Attributes -match "Directory"} | select -Last 1).fullname
import-module "$ModulePath\OSD.psd1" -Force
Invoke-Expression (Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/OSDeploy/OSD/master/cloud/modules/_anywhere.psm1')
Start-Sleep -Seconds 10
Start-Transcript -Path 'C:\Windows\Temp\osdcloud-logs\SetupComplete.log' -ErrorAction Ignore
Write-Output 'Setting PowerPlan to High Performance'
powercfg /setactive DED574B5-45A0-4F42-8737-46345C09C238
Write-Output 'Confirming PowerPlan [powercfg /getactivescheme]'
powercfg /getactivescheme
powercfg -x -standby-timeout-ac 0
powercfg -x -standby-timeout-dc 0
powercfg -x -hibernate-timeout-ac 0
powercfg -x -hibernate-timeout-dc 0
Set-PowerSettingSleepAfter -PowerSource AC -Minutes 0
Set-PowerSettingTurnMonitorOffAfter -PowerSource AC -Minutes 0
Write-OutPut 'Running Scripts in Custom OSDCloud SetupComplete Folder'
$SetupCompletePath = "C:\OSDCloud\Scripts\SetupComplete\SetupComplete.cmd"
if (Test-Path $SetupCompletePath){$SetupComplete = Get-ChildItem $SetupCompletePath -Filter SetupComplete.cmd}
if ($SetupComplete){cmd.exe /start /wait /c $SetupComplete.FullName}
Write-Output '-------------------------------------------------------------'
Write-Output 'Setting PowerPlan to Balanced'
Set-PowerSettingTurnMonitorOffAfter -PowerSource AC -Minutes 15
powercfg /setactive 381B4222-F694-41F0-9685-FF5BB260DF2E
$EndTime = Get-date; Write-Host "End Time: $($EndTime.ToString("hh:mm:ss"))"
$TotalTime = New-TimeSpan -Start $StartTime -End $EndTime; $RunTimeMinutes = [math]::round($TotalTime.TotalMinutes,0); Write-Host "Run Time: $RunTimeMinutes Minutes"
Stop-Transcript
Restart-Computer -Force
