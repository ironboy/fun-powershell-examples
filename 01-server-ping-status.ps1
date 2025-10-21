# Testa att en lista med servrar (ip-nummer eller domännamn är uppe/svarar på (ej specifik port ICMP)
$servers = @("google.com", "8.8.8.8", "microsoft.com")

$results = foreach ($server in $servers) {
    [PSCustomObject]@{
        Server       = $server
        Online       = Test-Connection -ComputerName $server -Count 1 -Quiet
        ResponseTime = (Test-Connection -ComputerName $server -Count 1).ResponseTime
        Timestamp    = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    }
}

$results | ConvertTo-Json | Out-File "network-status.json"
$results | Format-Table