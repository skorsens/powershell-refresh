# Import the script to be tested
BeforeAll {
    . "$PSScriptRoot/../Install-PythonPackage.ps1"
    . "$PSScriptRoot/../Write-Message.ps1"
}

Describe "Install-PythonPackage Function Tests" {
    BeforeAll {
        $PackageName = "test-package"
        $expectedPipParams = @('-m', 'pip', 'install', $PackageName, '-U', '-i', 'https://mvhlab:pswd@intelpypi.intel.com/pythonsv/production' )

        Mock -CommandName py -MockWith { return }
        Mock -CommandName Write-Message
    }

    It "Should call pip install with the correct package name" {
        # Arrange

        # Act
        Install-PythonPackage -PackageName $PackageName

        # Assert
        Should -Invoke py -Times 1 -Exactly -ParameterFilter { (Compare-Object $args $expectedPipParams).Count -eq 0 }
        Should -Invoke Write-Message -Times 1 -Exactly -ParameterFilter { $message -eq "Installing package $PackageName succeeded" }
    }

    It "Should log a message if pip install fails" {
        # Arrange
        Mock -CommandName py -MockWith { throw "Installation failed" }

        # Act and Assert
        { Install-PythonPackage -PackageName $PackageName } | Should -Throw "Installation failed"
        Should -Invoke py -Times 1 -Exactly -ParameterFilter { (Compare-Object $args $expectedPipParams).Count -eq 0 }
        Should -Invoke Write-Message -Times 1 -Exactly -ParameterFilter { $message -eq "Installing package $PackageName failed: Installation failed" }
    }
}
