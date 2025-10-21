# Långkörande diskövervaking - med visuell feedback!
$logFile = "disk-monitor.csv"

# Skapa CSV-header om filen inte finns
if (-not (Test-Path $logFile)) {
  "Timestamp,Drive,UsedGB,FreeGB,PercentUsed" | Out-File $logFile
}

Write-Host "Startar långkörande diskövervaking... (Ctrl+C för att avbryta)`n" -ForegroundColor Green

while ($true) {
  $drives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -gt 0 }
  $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

  $currentSnapshot = @()

  foreach ($drive in $drives) {
    $percentUsed = [math]::Round(($drive.Used / ($drive.Used + $drive.Free)) * 100, 1)
    $usedGB = [math]::Round($drive.Used / 1GB, 2)
    $freeGB = [math]::Round($drive.Free / 1GB, 2)

    # Spara till array för display
    $currentSnapshot += [PSCustomObject]@{
      Timestamp = $timestamp
      Drive     = $drive.Name
      UsedGB    = $usedGB
      FreeGB    = $freeGB
      "Used%"   = $percentUsed
    }

    # Appenda till fil
    "$timestamp,$($drive.Name),$usedGB,$freeGB,$percentUsed" |
    Add-Content $logFile
  }

  # Visa snyggt i terminal
  $currentSnapshot | Format-Table -AutoSize

  Start-Sleep -Seconds 5  # Vänta 5 sekunder (ändra till längre vide behov)
}