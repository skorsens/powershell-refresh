BeforeDiscovery {
    Import-Module .\ServiceState.psm1
}
Describe "Try using Mock" {
    BeforeAll {
        $module = @{ ModuleName = 'ServiceState' }

        Mock Import-Csv @module {
            [PSCustomObject]@{
                Name = 'service1'
                ExpectedStatus = 'Running'
            }
            [PSCustomObject]@{
                Name = 'service2'
                ExpectedStatus = 'Running'
            }
            [PSCustomObject]@{
                Name = 'service3'
                ExpectedStatus = 'Stopped'
            }
        }

        Mock Get-Service @module -ParameterFilter {
            $Name -eq 'service1'
        }{
            [PSCustomObject]@{
                Name = $Name
                Status = 'Stopped'
            }
        }
        Mock Get-Service @module -ParameterFilter {
            $Name -eq 'service2'
        }{
            [PSCustomObject]@{
                Name = $Name
                Status = 'Running'
            }
        }
        Mock Get-Service @module -ParameterFilter {
            $Name -eq 'service3'
        }{
            [PSCustomObject]@{
                Name = $Name
                Status = 'Running'
            }
        }
        Mock Start-Service @module
        Mock Stop-Service @module
    }

    It "When expected status is running, starts the service"{
        Set-ServiceState -Path file.csv
        Should -Invoke Start-Service -Times 1 -Exactly @module
        Should -Invoke Stop-Service  -Times 1 -Exactly @module
    }
}
