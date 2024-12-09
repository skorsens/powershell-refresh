Describe "Learning Pester" {
    It "Test can be outised of Context statement" {
        Get-Location | Should -Be "C:\Projects\powershell-refresh"
        Get-Location | Should -Exist
    }

    Context "Simple tests" {
        It "Check PowerShell 7 is installed" {
            $PSVersionTable.PSVersion | Should -BeGreaterOrEqual 7.0.0
        }

        It "Try -BeLike and -BeLikeExactly" {
            $ActualValue = "Actual Value"

            $ActualValue | Should -BeLike "*Ctual val*" -Because "BeLike is case insensitive"
            $ActualValue | Should -BeLikeExactly "*ctual Val*" -Because "BeLikeExactly is case sensitive"
        }

        It "Try the Throw assertion" {
            { throw "Throwing exception" } | Should -Throw "Throwing exception"
            { throw "Throwing exception" } | Should -Throw -ExpectedMessage "Throwing exception"
        }

        It "Try <Name> iteration using ForEach & hash" -ForEach @(
            @{Name = "Name 1" }
            @{Name = "Name 2" }
        ) -Test {
            $Name | Should -Match "$Name"
        }

        It "Try <_> iteration using ForEach" -ForEach @(
            "Name 1"
            "Name 2"
        ) -Test {
            $_ | Should -Match $_
        }
        It "Try <_> iteration using TestCases" -TestCases @(
            "Name 1"
            "Name 2"
        ) -Test {
            $_ | Should -Match $_
        }
    }

    Context "ForEach with Context <_>" -ForEach @(
        "Name 1"
        "Name 2"
    ){
        It "<_> Shall be equal" {
            Write-Host "Try-Pester: _ == $_"
            $_ | Should -Be $_
        }
    }

    Context "ForEach with Context and hash <Name>" -ForEach @(
        @{ Name = "Name 1" }
        @{ Name = "Name 2" }
    ){
        It "<Name> Shall be equal" {
            Write-Host "Try-Pester: Name == $Name"
            $Name | Should -Be $Name
        }
    }
}


Describe "ForEach with Describe <_>" -ForEach @(
    "Name 1"
    "Name 2"
){
    It "<_> Shall be equal" {
        $_ | Should -Be $_
    }
}
