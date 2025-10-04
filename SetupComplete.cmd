:: Run the PowerShell updater silently on first boot
powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%SystemRoot%\Setup\Scripts\Install-LCU.ps1" -WindowStyle Hidden
exit /b 0
