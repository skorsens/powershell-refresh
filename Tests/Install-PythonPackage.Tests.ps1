# Tests\Install-PythonPackage.Tests.ps1

# Import the script to be tested
BeforeAll {
    . "$PSScriptRoot/../Install-PythonPackage.ps1"
}

Describe "Install-PythonPackage Function Tests" {
    BeforeAll {
        Mock -CommandName py -MockWith { return }
    }

    It "Should call pip install with the correct package name" {
        # Arrange
        $PackageName = "test-package"

        # Act
        Install-PythonPackage -PackageName $PackageName

        # Assert
        Assert-MockCalled -CommandName py -Exactly 1 -Scope It -ParameterFilter { $args -eq @('-m', 'pip', 'install', $PackageName, '-U', '-i', 'https://mvhlab:pswd@intelpypi.intel.com/pythonsv/production') }
    }

    It "Should log a message if pip install fails" {
        # Arrange
        $PackageName = "test-package"
        Mock -CommandName py -MockWith { throw "Installation failed" }
        Mock -CommandName Write-Message

        # Act
        Install-PythonPackage -PackageName $PackageName

        # Assert
        Assert-MockCalled -CommandName Write-Message -Exactly 1 -Scope It -ParameterFilter { $args[0] -eq "Installing package $PackageName failed" }
    }
}
