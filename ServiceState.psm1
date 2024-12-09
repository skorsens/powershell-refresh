function Set-ServiceState {
    [CmdletBinding()]
    param (
        [string]
        $Path
    )
    Write-Host "Set-ServiceState: Path == $Path"

    Import-Csv $Path | ForEach-Object {
        Write-Host "Set-ServiceState: _.Name == $_.Name, _.ExpectedStatus == $_.ExpectedStatus"
        $service = Get-Service $_.Name

        Write-Host "Set-ServiceState: service.Status == $service.Status"

        if ($service.Status -ne $_.ExpectedStatus) {
            if ($_.ExpectedStatus -eq 'Stopped') {
                Stop-Service -Name $_.Name
            } else {
                Start-Service -Name $_.Name
            }
        }
    }
}
