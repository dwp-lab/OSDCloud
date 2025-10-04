Start-Sleep -Seconds 10

$ModulePath = (Get-ChildItem -Path "$($Env:ProgramFiles)\WindowsPowerShell\Modules\osd" | Where-Object {$_.Attributes -match "Directory"} | select -Last 1).fullname
Import-Module "$ModulePath\OSD.psd1" -Force
iex (irm functions.osdcloud.com)
UpdateWindows # not recognized cmdlet

Restart-Computer -Force
