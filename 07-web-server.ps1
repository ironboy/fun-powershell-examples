# Enkel webbserver i PowerShell - servera JSON-filer!

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:8080/")
$listener.Start()

Write-Host "Webbserver körs på http://localhost:8080/" -ForegroundColor Green
Write-Host "Tryck Ctrl+C för att stoppa`n" -ForegroundColor Yellow

try {
  while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response

    Write-Host "[$([DateTime]::Now.ToString('HH:mm:ss'))] $($request.HttpMethod) $($request.Url.AbsolutePath)" -ForegroundColor Cyan

    # Servera disk-monitor.csv som JSON
    if ($request.Url.AbsolutePath -eq "/status") {
      if (Test-Path "disk-monitor.csv") {
        $data = Import-Csv "disk-monitor.csv" | Select-Object -Last 5
        $json = $data | ConvertTo-Json

        $buffer = [System.Text.Encoding]::UTF8.GetBytes($json)
        $response.ContentType = "application/json"
        $response.ContentLength64 = $buffer.Length
        $response.OutputStream.Write($buffer, 0, $buffer.Length)
      }
    }
    else {
      $html = "<h1>PowerShell Web Server</h1><p>Try <a href='/status'>/status</a></p>"
      $buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
      $response.ContentType = "text/html"
      $response.ContentLength64 = $buffer.Length
      $response.OutputStream.Write($buffer, 0, $buffer.Length)
    }

    $response.Close()
  }
}
finally {
  $listener.Stop()
}