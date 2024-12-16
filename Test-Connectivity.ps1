<#
.SYNOPSIS
    Tests connectivity to a specified URL and port.

.DESCRIPTION
    The Test-Connectivity function checks if a specified URL and port are reachable. 
    On Windows, it uses the Test-NetConnection cmdlet. On other operating systems, it uses nmap.

.PARAMETER url
    The URL or IP address to test connectivity to.

.PARAMETER port
    The port number to test connectivity on.

.EXAMPLE
    Test-Connectivity -url "example.com" -port 80
    This command tests connectivity to example.com on port 80.

.EXAMPLE
    Test-Connectivity -url "192.168.1.1" -port 22
    This command tests connectivity to the IP address 192.168.1.1 on port 22.

.NOTES
    This function uses Test-NetConnection on Windows and nmap on other operating systems.
#>

. .\Write-Message.ps1


function Test-Connectivity {
    param (
        [string]$url,
        [int]$port
    )
    Write-Message -message "Testing connectivity to $url on port $port."

    $bOk = $false

    if ($IsWindows) {
        $result = Test-NetConnection -ComputerName $url -Port $port

        $bOk = $result.TcpTestSucceeded

    } else {
        $result = nmap -p $port $url

        $bOk = $result -match "open"
    }

    if ($bOk) {
        Write-Message -message "Testing connectivity to $url on port $port succeeded."
    } else {
        Write-Message -message "Testing connectivity to $url on port $port failed."
        Write-Message -message "Please verify the port $port is open (see https://wiki.ith.intel.com/display/firstaidkit/Open+firewall+ports+in+Restricted+Network)."
    }

    return $bOk
}
