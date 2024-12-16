param (
    [switch]$unattended = $false,
    [switch]$silent = $false,
    [ValidateSet("FV", "CORE")]
    [string]$exec_env = "FV",
    [string]$nga_url = "http://nga-prod.laas.icloud.intel.com",
    [string]$sut_ip_addr = ""
)

$logFile = ".\nga-wizard.log"

function Write-Message {
    param (
        [string]$message
    )
    if (-not $silent) {
        Write-Host $message
    }
    Add-Content -Path $logFile -Value $message
}

function Get-UserInput {
    # Example usage of the function
    # $userResponse = Get-UserInput -PromptMessage "Enter your name"

    param (
        [string]$PromptMessage,
        $CurrentValue
    )

    # Display the prompt message and read the user's input
    if ($unattended)
    {
        return $CurrentValue
    }
    $PromptMessage = "$PromptMessage [$CurrentValue]"
    $userInput = Read-Host -Prompt $PromptMessage

    # Return the user's input
    return $(if ($userInput -eq ""){$CurrentValue} else {$userInput})
}

function Install-PythonPackage {
    param (
        [string]$PackageName
    )
    try {
        py -m pip install $PackageName -U -i https://mvhlab:pswd@intelpypi.intel.com/pythonsv/production
    } catch {
        Write-Message "Installing package $PackageName failed"
    }
}

function Set-EnvVar {
    param (
        [string]$Name,
        [string]$Value
    )
    if (-not [System.Environment]::GetEnvironmentVariable($Name, [System.EnvironmentVariableTarget]::Machine)) {
        [System.Environment]::SetEnvironmentVariable($Name, $Value, [System.EnvironmentVariableTarget]::Machine)
    }
}

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

function Main
{
    # Set environment variables
    Set-EnvVar -Name "EVTAR_CONFIG_DIR" -Value "C:\SVSHARE.evtar"
    Set-EnvVar -Name "no_proxy" -Value ".intel.com"

    # Install packages based on execution environment
    if ($exec_env -eq "FV")
    {
        Install-PythonPackage -PackageName "evtar-orchestrator-exec_jobs-test_run"
    }
    else
    {
        Install-PythonPackage -PackageName "evtar-orchestrator-exec_jobs-magnet"
        Install-PythonPackage -PackageName "evtar-orchestrator-plugins-agent"
    }

    if (-not (Test-Connectivity -url $nga_url -port 443))
    {
        Write-Message "Failed to connect to NGA. Please open port 443 as per https://wiki.ith.intel.com/display/firstaidkit/Open+firewall+ports+in+Restricted+Network"
    }

    if (-not (Test-Connectivity -url "127.0.0.1" -port 8001))
    {
        Write-Message "Failed to connect to Host Agent. Please open port 8001."
    }

    if ($sut_ip_addr -ne "" -and -not (Test-Connectivity -url $sut_ip_addr -port 8001))
    {
        Write-Message "Failed to connect to Target Agent. Please open port 8001."
    }

    # Start services
    py -m evtar.services.communicator_xmlrpc_server -log
    py -m evtar.orchestrator.base.startup.Orchestrator
}
