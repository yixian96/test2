param (
    [string]$Target = "192.168.1.1",
    [int]$TimeoutMs = 200
)

Write-Host "[*] Full TCP port scan started against $Target"
Write-Host "[*] Ports: 1-65535"
Write-Host "[*] Timeout per port: $TimeoutMs ms"

$openPorts = @()

foreach ($port in 1..65535) {
    try {
        $client = New-Object System.Net.Sockets.TcpClient
        $async  = $client.BeginConnect($Target, $port, $null, $null)
        $wait   = $async.AsyncWaitHandle.WaitOne($TimeoutMs, $false)

        if ($wait -and $client.Connected) {
            Write-Host "[OPEN ] $port"
            $openPorts += $port
        }

        $client.Close()
    } catch {}
}

Write-Host "`n[+] Open ports found:"
$openPorts
