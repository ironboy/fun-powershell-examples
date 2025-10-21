$response = Invoke-RestMethod -Uri "https://api.open-meteo.com/v1/forecast?latitude=59.33&longitude=18.07&current_weather=true"
Write-Host "Temperatur i Stockholm: $($response.current_weather.temperature)°C"

$response | ConvertTo-Json | Out-File "weather.json"