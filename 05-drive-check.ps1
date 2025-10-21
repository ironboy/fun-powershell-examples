1..5 | ForEach-Object {
  $drives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -gt 0 }

  foreach ($drive in $drives) {
    [PSCustomObject]@{
      Timestamp   = Get-Date -Format "HH:mm:ss"
      Drive       = $drive.Name
      UsedGB      = [math]::Round($drive.Used / 1GB, 2)
      FreeGB      = [math]::Round($drive.Free / 1GB, 2)
      PercentUsed = [math]::Round(($drive.Used / ($drive.Used + $drive.Free)) * 100, 1)
    }
  }

  Start-Sleep -Seconds 5
}