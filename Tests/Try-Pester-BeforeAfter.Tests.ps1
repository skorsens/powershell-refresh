BeforeDiscovery {
    $Names = "Name 1", "Name 2"
    $BeforeAllCnt = 0
    $AfterAllCnt = 0
    $BeforeEachCnt = 0
    $AfterEachCnt = 0
}
Describe "Try using BeforeDiscovery <_>" -ForEach $Names {
    Write-Host "Describe: _ == $_"

    BeforeAll {
        Write-Host "BeforeAll: Names == $Names"
        Write-Host "BeforeAll: BeforeAllCnt == $BeforeAllCnt"
        Write-Host "BeforeAll: AfterAllCnt == $AfterAllCnt"
        Write-Host "BeforeAll: BeforeEachCnt == $BeforeEachCnt"
        Write-Host "BeforeAll: AfterEachCnt == $AfterEachCnt"
        $BeforeAllCnt += 1
    }
    AfterAll {
        Write-Host "AfterAll: Names == $Names"
        $AfterAllCnt += 1
        Write-Host "AfterAll: BeforeAllCnt == $BeforeAllCnt"
        Write-Host "AfterAll: AfterAllCnt == $AfterAllCnt"
        Write-Host "AfterAll: BeforeEachCnt == $BeforeEachCnt"
        Write-Host "AfterAll: AfterEachCnt == $AfterEachCnt"
    }
    BeforeEach {
        $BeforeEachCnt += 1
        Write-Host "BeforeEach: BeforeEachCnt == $BeforeEachCnt"
    }
    AfterEach {
        $AfterEachCnt += 1
        Write-Host "AfterEach: AfterEachCnt == $AfterEachCnt"
    }
    It "Element <_> in Names should be accessible" {
        Write-Host "It 1: _ == $_"
        Write-Host "It 1: Names == $Names"
        Write-Host "It 1: BeforeEachCnt == $BeforeEachCnt"
        Write-Host "It 1: AfterEachCnt == $AfterEachCnt"
        $_ | Should -Be $_
    }

    It "Try Before/AfterEach" {
        Write-Host "It 2: Names == $Names"
        Write-Host "It 2: BeforeEachCnt == $BeforeEachCnt"
        Write-Host "It 2: AfterEachCnt == $AfterEachCnt"
    }
}
