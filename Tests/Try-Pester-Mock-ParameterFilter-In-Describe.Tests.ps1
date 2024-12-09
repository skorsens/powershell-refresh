BeforeDiscovery {
    Import-Module .\ServiceState.psm1
}
Describe "Try using Mock <_>" -ForEach @(
    @{
        Name = "service1"
        CurrentStatus = "Running"
        ExpectedStatus = "Running"
    }
    @{
        Name = "service2"
        CurrentStatus = "Running"
        ExpectedStatus = "Stopped"
    }
    @{
        Name = "service3"
        CurrentStatus = "Stopped"
        ExpectedStatus = "Running"
    }
    @{
        Name = "service4"
        CurrentStatus = "Stopped"
        ExpectedStatus = "Stopped"
    }
){
    BeforeAll {
        $module = @{ ModuleName = 'ServiceState' }

        Mock Start-Service @module
        Mock Stop-Service @module
    }

    It "When current and expected status are <_>"{
        Mock Import-Csv @module {
            [PSCustomObject]@{
                Name = $_.Name
                ExpectedStatus = $_.ExpectedStatus
            }
        }

        Mock Get-Service @module {
            [PSCustomObject]@{
                Name = $_.Name
                Status = $_.CurrentStatus
            }
        }
        Set-ServiceState -Path file.csv

        if ($_.CurrentStatus -eq "Running" -and $_.ExpectedStatus -eq "Running") {
            Should -Not -Invoke Start-Service @module
            Should -Not -Invoke Stop-Service @module
        }
        elseif ($_.CurrentStatus -eq "Running" -and $_.ExpectedStatus -eq "Stopped") {
            Should -Invoke Stop-Service @module -ParameterFilter { $Name -eq 'service2' }
        }
        elseif ($_.CurrentStatus -eq "Stopped" -and $_.ExpectedStatus -eq "Running") {
            Should -Invoke Start-Service @module -ParameterFilter { $Name -eq 'service3' }
        }
        elseif ($_.CurrentStatus -eq "Stopped" -and $_.ExpectedStatus -eq "Stopped") {
            Should -Not -Invoke Start-Service @module -ParameterFilter { $Name -eq 'service4' }
            Should -Not -Invoke Stop-Service @module -ParameterFilter { $Name -eq 'service4' }
        }
        else {
            Assert-Fail -Message "This test shall get here." 
        }
    }
}
