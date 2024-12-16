# Import the script to be tested
BeforeAll {
    . "$PSScriptRoot/../Set-EnvVar.ps1"
    . "$PSScriptRoot/../Write-Message.ps1"
}


Describe "Set-EnvVar Function Tests" {
    BeforeAll {
        Mock Write-Message

        class _CEnvironmentStub
        {
            static [string] $_envVarValue = "";
        
            static [string] GetEnvironmentVariable([string]$Name)
            {
                return [_CEnvironmentStub]::_envVarValue;
            }
            static [string] SetEnvironmentVariable([string]$Name, [string]$Value)
            {
                return [_CEnvironmentStub]::_envVarValue = $Value;
            }
        }

        class _CEnvironmentStubWithException
        {
            static [string] $_envVarValue = "";
        
            static [string] GetEnvironmentVariable([string]$Name)
            {
                return [_CEnvironmentStubWithException]::_envVarValue;
            }
            static [string] SetEnvironmentVariable([string]$Name, [string]$Value)
            {
                throw "Requested registry access is not allowed."
            }
        }

    }

    Context "When setting a new environment variable" {
        It "Should create a new machine-level environment variable" {
            # Arrange

            $envName = "TestEnvVar"
            $envValue = "TestValue"
            $EnvironmentClass = [_CEnvironmentStub]
            $EnvironmentClass::SetEnvironmentVariable($envName, "")
            # Act
            Set-EnvVar -Name $envName -Value $envValue -EnvironmentClass $EnvironmentClass

            # Assert
            Should -Invoke Write-Message -ParameterFilter  { $message -eq "Setting environment variable $envName to $envValue" }
            Should -Invoke Write-Message -ParameterFilter  { $message -eq "Setting environment variable $envName to $envValue succeeded" }
        }
    }

   Context "When updating an existing environment variable" {
       It "Should update the machine-level environment variable" {
           # Arrange
           $envName = "TestEnvVar"
           $initialValue = "InitialValue"
           $updatedValue = "UpdatedValue"
           $EnvironmentClass = [_CEnvironmentStub]
           $EnvironmentClass::SetEnvironmentVariable($envName, $initialValue)

           # Act
           Set-EnvVar -Name $envName -Value $updatedValue -EnvironmentClass $EnvironmentClass

           # Assert
           Should -Invoke Write-Message -ParameterFilter  { $message -eq "Updating environment variable $envName from $initialValue to $updatedValue" } 
           Should -Invoke Write-Message -ParameterFilter  { $message -eq "Setting environment variable $envName to $updatedValue succeeded" }
        }
    }
    Context "When setting a new or updating an existing environment variable not as an administrator" {
        It "Should throw an exception" {
            # Arrange

            $envName = "TestEnvVar"
            $envValue = "TestValue"
            $EnvironmentClass = [_CEnvironmentStubWithException]
            $EnvironmentClass::_envVarValue = ""

            # Act
            $params = @{
                Name = $envName
                Value = $envValue
                EnvironmentClass = $EnvironmentClass
            }

            # Act
            { Set-EnvVar @params } | Should -Throw "Requested registry access is not allowed."

            # Assert
            Should -Invoke Write-Message -ParameterFilter  { $message -eq "Setting environment variable $envName to $envValue" }
            Should -Invoke Write-Message -ParameterFilter  { $message -eq "Failed to set environment variable $envName to $envValue. Exception: Requested registry access is not allowed." }
            Should -Invoke Write-Message -ParameterFilter  { $message -eq "Please make sure you are running as an administrator" }
        }
    }
}
