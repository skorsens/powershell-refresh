param (
    [switch]$silent = $false
)

[string]$logFile = ".\nga-wizard.log"
#[switch]$silent = $false


function Write-Message {
    param (
        [string]$message
    )
    if (-not $silent) {
        Write-Host $message
    }
    Add-Content -Path $logFile -Value $message
}
