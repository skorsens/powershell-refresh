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

        Mock Get-Service @module {
            [PSCustomObject]@{
                Name = $Name
                Status = 'Stopped'
            }
        }
        Mock Start-Service @module
        Mock Stop-Service @module
    }

    It "When expected status is running, starts the service"{
        Set-ServiceState -Path file.csv
        Should -Invoke Start-Service @module -ParameterFilter { $Name -eq 'service1' }
        Should -Invoke Start-Service @module -ParameterFilter { $Name -eq 'service2' }
        Should -Not -Invoke Start-Service  @module -ParameterFilter { $Name -eq 'service3' }
        Should -Not -Invoke Stop-Service  @module -ParameterFilter { $Name -eq 'service3' }
    }
}

