param (
    [string]$Target = "192.168.1.1",
    [int[]]$Ports = @(21,22,25,53,80,110,135,139,143,443,445,3389),
    [int]$TimeoutMs = 200
)

Write-Host "[*] In-memory TCP scan started"
Write-Host "[*] Target: $Target"
Write-Host "[*] No external tools used"

$results = foreach ($port in $Ports) {
    try {
        $client = New-Object System.Net.Sockets.TcpClient
        $async  = $client.BeginConnect($Target, $port, $null, $null)
        $wait   = $async.AsyncWaitHandle.WaitOne($TimeoutMs, $false)

        if ($wait -and $client.Connected) {
            $client.Close()
            [PSCustomObject]@{
                Port   = $port
                Status = "Open"
            }
        } else {
            $client.Close()
        }
    } catch {}
}

$results | Format-Table -AutoSize