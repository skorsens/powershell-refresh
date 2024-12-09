BeforeDiscovery {
    Import-Module .\ServiceState.psm1
}
Describe "Try using Mock" {
    BeforeAll {
        $module = @{ ModuleName = 'ServiceState' }

        Mock Start-Service @module
        Mock Stop-Service @module
    }

    It "When current status is Stopped and expected status is Running, starts the service"{
        Mock Import-Csv @module {
            [PSCustomObject]@{
                Name = 'service1'
                ExpectedStatus = 'Running'
            }
        }

        Mock Get-Service @module {
            [PSCustomObject]@{
                Name = $Name
                Status = 'Stopped'
            }
        }
        Set-ServiceState -Path file.csv
        Should -Invoke Start-Service @module
    }

    It "When current status is Stopped and expected status is Stopped, does nothing"{
        Mock Import-Csv @module {
            [PSCustomObject]@{
                Name = 'service1'
                ExpectedStatus = 'Stopped'
            }
        }

        Mock Get-Service @module {
            [PSCustomObject]@{
                Name = $Name
                Status = 'Stopped'
            }
        }
        Set-ServiceState -Path file.csv
        Should -Not -Invoke Start-Service @module
        Should -Not -Invoke Stop-Service @module
    }

    It "When current status is Running and expected status is Running, does nothing"{
        Mock Import-Csv @module {
            [PSCustomObject]@{
                Name = 'service1'
                ExpectedStatus = 'Running'
            }
        }

        Mock Get-Service @module {
            [PSCustomObject]@{
                Name = $Name
                Status = 'Running'
            }
        }
        Set-ServiceState -Path file.csv
        Should -Not -Invoke Start-Service @module
        Should -Not -Invoke Stop-Service @module
    }
    It "When current status is Runnint and expected status is Stopped, stops the service"{
        Mock Import-Csv @module {
            [PSCustomObject]@{
                Name = 'service1'
                ExpectedStatus = 'Stopped'
            }
        }

        Mock Get-Service @module {
            [PSCustomObject]@{
                Name = $Name
                Status = 'Running'
            }
        }
        Set-ServiceState -Path file.csv
        Should -Invoke Stop-Service @module
        Should -Not -Invoke Start-Service @module
    }
}
