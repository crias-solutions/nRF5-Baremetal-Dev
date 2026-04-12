$ports = @(Get-WmiObject Win32_SerialPort | Where-Object { $_.PNPDeviceID -match 'VID_1366' })
if ($ports.Count -lt 2) {
    Write-Host ''
    Write-Host '============================================'
    Write-Host 'VALIDATION FAILED: Expected 2 J-Link CDC ports'
    Write-Host "Found: $($ports.Count)"
    Write-Host '============================================'
    exit 1
} else {
    $portList = $ports | ForEach-Object { $_.DeviceID }
    Write-Host "[OK] COM ports: $($portList -join ', ')"
}
exit 0
