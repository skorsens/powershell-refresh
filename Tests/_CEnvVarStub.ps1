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


class _CEnvironmentWin
{
    static [string] GetEnvironmentVariable([string]$Name)
    {
        return [System.Environment]::GetEnvironmentVariable($Name, [System.EnvironmentVariableTarget]::Machine);
    }
    static [string] SetEnvironmentVariable([string]$Name, [string]$Value)
    {
        return [System.Environment]::SetEnvironmentVariable($Name, $Value, [System.EnvironmentVariableTarget]::Machine);
    }
}


function Set-EnvVar {
    param (
        [string]$Name,
        [string]$Value,
        [object]$EnvironmentClass=[_CEnvironmentWin]
    )
    if (-not $EnvironmentClass::GetEnvironmentVariable($Name)) {
        $EnvironmentClass::SetEnvironmentVariable($Name, $Value)
    }
}


$CurrVal = [_CEnvironmentStub]::GetEnvironmentVariable("TestEnvVar")
Write-Host "Current value of TestEnvVar: $CurrVal"
[_CEnvironmentStub]::SetEnvironmentVariable("TestEnvVar", "TestValue 2")
$NewVal = [_CEnvironmentStub]::GetEnvironmentVariable("TestEnvVar")
Write-Host "New value of TestEnvVar: $NewVal"
