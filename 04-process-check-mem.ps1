# De 10 processer som tar mest minne på datorn just nu
Get-Process |
Sort-Object WorkingSet -Descending |
Select-Object -First 10 Name,
@{Name = "Memory(MB)"; Expression = { [math]::Round($_.WorkingSet / 1MB, 2) } } |
ConvertTo-Json | Out-File "top-processes.json"