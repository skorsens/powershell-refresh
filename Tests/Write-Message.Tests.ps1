BeforeAll {
    . $PSScriptRoot/../Write-Message.ps1
}

Describe "Write-Host Tests" {

    BeforeAll {
        $testLogFile = ".\test-nga-wizard.log"
        $logFile = $testLogFile

        Mock Write-Host {}
        Mock Add-Content {}
    }

    It "should output the message to console and to file" {
        # Arrange
        $Message = "Hello, World!"
        $silent = $false
        Write-Message $Message

        Should -Invoke Write-Host -ParameterFilter { $message -eq $Message }
        Should -Invoke Add-Content -ParameterFilter { $Path -eq $testLogFile -and $message -eq $Message}
    }
    It "should output the message to file only" {
        # Arrange
        $Message = "Hello, World!"
        $silent = $true
        Write-Message $Message

        Should -Not -Invoke Write-Host
        Should -Invoke Add-Content -ParameterFilter { $Path -eq $testLogFile -and $message -eq $Message}
    }
}
