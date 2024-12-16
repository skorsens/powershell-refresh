# Import the script to be tested
BeforeAll {
    . "$PSScriptRoot/../Test-Connectivity.ps1"
    . "$PSScriptRoot/../Write-Message.ps1"
}


Describe "Test-Connectivity" {
    BeforeAll {
        Mock Write-Message
    }

    Context "When running on Windows" -Skip:(-not $IsWindows) {
        BeforeAll {
            Mock Test-NetConnection {
                return @{ TcpTestSucceeded = $true }
            }
        }

        It "Should return true when connectivity is successful" {
            $result = Test-Connectivity -url "example.com" -port 80

            $result | Should -Be $true
            Should -Invoke Test-NetConnection -ParameterFilter { $ComputerName -eq "example.com" -and $Port -eq 80 }
            Should -Invoke Write-Message -ParameterFilter { "Testing connectivity to example.com on port 80." }
            Should -Invoke Write-Message -ParameterFilter { "Testing connectivity to example.com on port 80 succeeded." }
        }

        It "Should return false when connectivity fails" {
            Mock Test-NetConnection {
                return @{ TcpTestSucceeded = $false }
            }
            $result = Test-Connectivity -url "example.com" -port 80

            $result | Should -Be $false
            Should -Invoke Test-NetConnection -ParameterFilter { $ComputerName -eq "example.com" -and $Port -eq 80 }
            Should -Invoke Write-Message -ParameterFilter { "Testing connectivity to example.com on port 80." }
            Should -Invoke Write-Message -ParameterFilter { "Testing connectivity to example.com on port 80 failed." }
            Should -Invoke Write-Message -ParameterFilter { "Please verify the port $port is open (see https://wiki.ith.intel.com/display/firstaidkit/Open+firewall+ports+in+Restricted+Network)." }
        }
    }
}
