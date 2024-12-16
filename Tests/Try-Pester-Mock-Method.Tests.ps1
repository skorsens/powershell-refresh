# Import the script to be tested
BeforeAll {
    . "$PSScriptRoot/../Set-EnvVar.ps1"
}

Describe "Set-EnvVar Function Tests" {
    BeforeAll {
        # Create a mock object for System.Environment
        $mockEnvironment = New-MockObject -TypeName System.Environment

        # Mock the SetEnvironmentVariable and GetEnvironmentVariable methods
        Mock -MockObject $mockEnvironment -MemberName SetEnvironmentVariable -MockWith { param ($variable, $value, $target) }
        Mock -MockObject $mockEnvironment -MemberName GetEnvironmentVariable -MockWith { param ($variable, $target) return $null }

        # Replace the original methods with the mock methods
        [System.Environment]::SetEnvironmentVariable = $mockEnvironment.SetEnvironmentVariable
        [System.Environment]::GetEnvironmentVariable = $mockEnvironment.GetEnvironmentVariable
    }

    BeforeEach {
        # Reset the mock methods
        Mock -MockObject $mockEnvironment -MemberName SetEnvironmentVariable -MockWith { param ($variable, $value, $target) }
        Mock -MockObject $mockEnvironment -MemberName GetEnvironmentVariable -MockWith { param ($variable, $target) return $null }
    }

    Context "When setting a new environment variable" {
        It "Should create a new machine-level environment variable" {
            # Arrange
            $envName = "TestEnvVar"
            $envValue = "TestValue"

            # Act
            Set-EnvVar -Name $envName -Value $envValue

            # Assert
            $mockEnvironment.SetEnvironmentVariable | Should -Invoke -Times 1 -Exactly -ParameterFilter {
                $args[0] -eq $envName -and
                $args[1] -eq $envValue -and
                $args[2] -eq [System.EnvironmentVariableTarget]::Machine
            }
        }
    }

    Context "When updating an existing environment variable" {
        It "Should update the machine-level environment variable" {
            # Arrange
            $envName = "TestEnvVar"
            $initialValue = "InitialValue"
            $updatedValue = "UpdatedValue"
            Mock -MockObject $mockEnvironment -MemberName GetEnvironmentVariable -MockWith { param ($variable, $target) return $initialValue }

            # Act
            Set-EnvVar -Name $envName -Value $updatedValue

            # Assert
            $mockEnvironment.SetEnvironmentVariable | Should -Invoke -Times 1 -Exactly -ParameterFilter {
                $args[0] -eq $envName -and
                $args[1] -eq $updatedValue -and
                $args[2] -eq [System.EnvironmentVariableTarget]::Machine
            }
        }
    }
}