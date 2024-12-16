# Import the script to be tested
BeforeAll {
    . "$PSScriptRoot/../Set-EnvVar.ps1"
    . "$PSScriptRoot/../Write-Message.ps1"
}


Describe "Set-EnvVar Function Tests" {
    BeforeAll {
        Mock Write-Message
    }

    Context "When setting a new environment variable" {
        It "Should create a new machine-level environment variable" {
            # Arrange

            class _CEnvironmentStub
            {
                static [string] $_envVarValue = $null;
            
                static [string] GetEnvironmentVariable([string]$Name)
                {
                    return [_CEnvironmentStub]::_envVarValue;
                }
                static [string] SetEnvironmentVariable([string]$Name, [string]$Value)
                {
                    return [_CEnvironmentStub]::_envVarValue = $Value;
                }
            }
            
            $envName = "TestEnvVar"
            $envValue = "TestValue"
            $EnvironmentClass = [_CEnvironmentStub]
            $EnvironmentClass::SetEnvironmentVariable($envName, $null)
            # Act
            Set-EnvVar -Name $envName -Value $envValue

            # Assert
            Should -Invoke Write-Message #-ParameterFilter  { $message -eq "Setting environment variable $envName to $envValue" }
        }
    }

#    Context "When updating an existing environment variable" {
#        It "Should update the machine-level environment variable" {
#            # Arrange
#            $envName = "TestEnvVar"
#            $initialValue = "InitialValue"
#            $updatedValue = "UpdatedValue"
#            Mock -CommandName '[System.Environment]::GetEnvironmentVariable' -MockWith { return $initialValue }
#
#            # Act
#            Set-EnvVar -Name $envName -Value $updatedValue
#
#            # Assert
#            Should -Invoke [System.Environment]::SetEnvironmentVariable -Times 1 -Exactly -ParameterFilter {
#                $args[0] -eq $envName -and
#                $args[1] -eq $updatedValue -and
#                $args[2] -eq [System.EnvironmentVariableTarget]::Machine
#            }
#        }
#    }
}
