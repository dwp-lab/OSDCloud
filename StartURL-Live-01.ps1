Write-Host -BackgroundColor Black -ForegroundColor Green "Start OSDCloud ZTI"
Start-Sleep -Seconds 5

Add-Type -AssemblyName PresentationFramework
$bodyMessage = [PSCustomObject] @{}; Clear-Variable serialNumber -ErrorAction:SilentlyContinue
$serialNumber = Get-WmiObject -Class Win32_BIOS | Select-Object -ExpandProperty SerialNumber

if ($serialNumber) {

    $bodyMessage | Add-Member -MemberType NoteProperty -Name "serialNumber" -Value $serialNumber

} else {

    $infoMessage = "We were unable to locate the serial number of your device, so the process cannot proceed. The computer will shut down when this window is closed."
    Write-Host -BackgroundColor Black -ForegroundColor Red $infoMessage
    [System.Windows.MessageBox]::Show($infoMessage, 'OSDCloud', 'OK', 'Error')
    wpeutil shutdown
}

Write-Host -BackgroundColor Black -ForegroundColor Green "Start AutoPilot Verification"
$body = $bodyMessage | ConvertTo-Json -Depth 5; $uri = "https://prod-145.westus.logic.azure.com:443/workflows/dadfcaca1bcc4b069c998a99e82ee728/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=n0urWoGWa2OXN-4ba0U7UwfEM8i9vwTuSHx2PrSVtvU"
$result = Invoke-RestMethod -Uri $uri -Method POST -Body $body -ContentType "application/json; charset=utf-8" -UseBasicParsing    

if ($result) {

    $infoMessage = "You cannot continue because the device is not ready for Windows AutoPilot. The PowerShell script Get-WindowsAutopilotInfo.ps1 can be used to get a devices hardware hash and serial number. The computer will shut down when this window is closed."
    Write-Host -BackgroundColor Black -ForegroundColor Red $infoMessage
    [System.Windows.MessageBox]::Show($infoMessage, 'OSDCloud', 'OK', 'Error')
    wpeutil shutdown
    
} else {

    Write-Host -BackgroundColor Black -ForegroundColor Green "Update OSD PowerShell Module"
    Install-Module OSD -Force -SkippublisherCheck

    Write-Host -BackgroundColor Black -ForegroundColor Green "Import OSD PowerShell Module"
    Import-Module OSD -Force

    Write-Host -BackgroundColor Black -ForegroundColor Green "Start OSDCloud"
    Start-OSDCloud -ZTI -OSVersion 'Windows 11' -OSBuild 23H2 -OSEdition Enterprise -OSLanguage en-us -OSLicense Retail

    Write-Host -BackgroundColor Black -ForegroundColor Green "Restart in 20 seconds"
    Start-Sleep -Seconds 20
    wpeutil reboot
}