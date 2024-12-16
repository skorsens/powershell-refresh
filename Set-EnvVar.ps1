<#
.SYNOPSIS
Sets a machine-level environment variable.

.DESCRIPTION
The Set-EnvVar function sets a machine-level environment variable with the specified name and value.
If the environment variable does not already exist, it will be created.

.PARAMETER Name
The name of the environment variable to set.

.PARAMETER Value
The value of the environment variable to set.

.EXAMPLE
Set-EnvVar -Name "MyVariable" -Value "MyValue"
This command sets the machine-level environment variable "MyVariable" to "MyValue".

.EXAMPLE
Set-EnvVar -Name "Path" -Value "C:\MyPath"
This command sets the machine-level environment variable "Path" to "C:\MyPath".

.NOTES
Author: Your Name
Date: Today's Date
#>

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
    $CurrValue = $EnvironmentClass::GetEnvironmentVariable($Name)

    if ($CurrValue -ne $Value) {
        if ("" -eq $CurrValue) {
            Write-Message -message "Setting environment variable $Name to $Value"
        }
        else {
            Write-Message -message "Updating environment variable $Name from $CurrValue to $Value"
        }

        try {
            $EnvironmentClass::SetEnvironmentVariable($Name, $Value)
            Write-Message -message "Setting environment variable $Name to $Value succeeded"
        }
        catch {
            Write-Message -message "Failed to set environment variable $Name to $Value. Exception: $_"
            Write-Message -message "Please make sure you are running as an administrator"
            throw
        }
    } 
    else {
        Write-Message -Message "Environment variable $Name is already set to $Value"
    }
}
