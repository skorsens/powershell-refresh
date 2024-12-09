BeforeDiscovery {
    Import-Module .\ServiceState.psm1
}
Describe "Try using Mock" {
    BeforeAll {
        $module = @{ ModuleName = 'ServiceState' }

        Mock Import-Csv @module {
            Write-Host "Mock Import-Csv: args == $args"
            Write-Host "Mock Import-Csv: Path == $Path"
            Write-Host "Mock Import-Csv: PSBoundParameters = $PSBoundParameters"
            Write-Host "Mock Import-Csv: PesterBoundParameters = $PesterBoundParameters"

            [PSCustomObject]@{
                Name = 'service1'
                ExpectedStatus = 'Running'
            }
        }

        Mock Get-Service @module {
            Write-Host "Mock Get-Service: args == $args"
            Write-Host "Mock Get-Service: Name == $Name"

            if ($PesterBoundParameters.ContainsKey('Name')) {
                [PSCustomObject]@{
                    Name = $Name
                    Status = 'Stopped'
                }
            } else {
                [PSCustomObject]@{
                    Name = 'service 1'
                    Status = 'Stopped'
                }
            }
        }
        Mock Start-Service @module
        Mock Stop-Service @module
    }

    It "When expected status is running, starts the service"{
        Set-ServiceState -Path file.csv
        Should -Invoke Start-Service @module
    }
}
