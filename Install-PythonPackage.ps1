# Install-PythonPackage.ps1
<#
.SYNOPSIS
Installs a specified Python package using pip.

.DESCRIPTION
The `Install-PythonPackage` function installs a specified Python package using pip. It attempts to install the package
and logs a message if the installation fails.

.PARAMETER PackageName
The name of the Python package to install.

.EXAMPLE
Install-PythonPackage -PackageName "requests"

This example installs the `requests` Python package.

.EXAMPLE
Install-PythonPackage -PackageName "numpy"

This example installs the `numpy` Python package.

.NOTES
Author: Your Name
Date: YYYY-MM-DD
#>
function Install-PythonPackage {
    param (
        [string]$PackageName
    )
    try {
        py -m pip install $PackageName -U -i https://mvhlab:pswd@intelpypi.intel.com/pythonsv/production
    } catch {
        Write-Message "Installing package $PackageName failed"
    }
}
