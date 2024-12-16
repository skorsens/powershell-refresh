# Connectivity checks
function Test-Connectivity {
    param (
        [string]$url,
        [int]$port
    )
    if ($IsWindows) {
        $result = Test-NetConnection -ComputerName $url -Port $port
        return $result.TcpTestSucceeded
    } else {
        $result = nmap -p $port $url
        return $result -match "open"
    }
}
