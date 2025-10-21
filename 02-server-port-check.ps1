# Testa TCP-port med .NET TcpClient

function Test-Port {
  param($Server, $Port, $Timeout = 1000)

  try {
    $client = New-Object System.Net.Sockets.TcpClient
    $result = $client.BeginConnect($Server, $Port, $null, $null)
    $success = $result.AsyncWaitHandle.WaitOne($Timeout, $false)
    $client.Close()
    return $success
  }
  catch {
    return $false
  }
}

# Testa olika tjänster
$tests = @(
  @{Server = "google.com"; Port = 443; Service = "HTTPS" }
  @{Server = "google.com"; Port = 80; Service = "HTTP" }
  @{Server = "1.1.1.1"; Port = 53; Service = "DNS" }
)

$results = foreach ($test in $tests) {
  [PSCustomObject]@{
    Server    = $test.Server
    Port      = $test.Port
    Service   = $test.Service
    Open      = Test-Port -Server $test.Server -Port $test.Port
    Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  }
}

$results | ConvertTo-Json | Out-File "port-scan.json"
$results | Format-Table