# Import the script to be tested
BeforeAll {
    . "$PSScriptRoot/../Get-UserInput.ps1"
}

Describe "Get-UserInput Function Tests" {
    BeforeAll {
        Mock -CommandName Read-Host -MockWith { return "UserInput" }
    }
    Context "When unattended switch is set" {
        It "Should return the current value without prompting" {
            # Arrange
            $unattended = $true
            $_promptMessage = "Enter value"
            $currentValue = "DefaultValue"

            # Act
            $result = Get-UserInput -PromptMessage $_promptMessage -CurrentValue $currentValue

            # Assert
            $result | Should -Be $currentValue
            Should -Not -Invoke Read-Host
        }
    }

    Context "When unattended switch is not set" {
        It "Should return the user input if provided" {
            # Arrange
            Mock -CommandName Read-Host -MockWith { return "UserInput" }
            $unattended = $false
            $promptMessage = "Enter value"
            $currentValue = "DefaultValue"

            # Act
            $result = Get-UserInput -PromptMessage $promptMessage -CurrentValue $currentValue

            # Assert
            $result | Should -Be "UserInput"
            Should -Invoke Read-Host -ParameterFilter { $Prompt -eq "$promptMessage [$currentValue]" }
        }

        It "Should return the current value if user input is empty" {
            # Arrange
            # Mock -CommandName Read-Host -MockWith { return "" }
            Mock Read-Host -MockWith { return "" }
            $unattended = $false
            $promptMessage = "Enter value"
            $currentValue = "DefaultValue"

            # Act
            $result = Get-UserInput -PromptMessage $promptMessage -CurrentValue $currentValue

            # Assert
            $result | Should -Be $currentValue
            Should -Invoke Read-Host -ParameterFilter { $Prompt -eq "$promptMessage [$currentValue]" }
        }
    }
}
