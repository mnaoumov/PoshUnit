#requires -version 2.0

[CmdletBinding()]
param
(
)

$script:ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Import-Module "$PSScriptRoot\packages\NUnit.2.6.1\lib\nunit.framework.dll"

$Assert = [NUnit.Framework.Assert]
$Is = [NUnit.Framework.Is]
$Has = [NUnit.Framework.Has]
$Throws = [NUnit.Framework.Throws]

function Test-Delegate
{
    [OutputType([NUnit.Framework.TestDelegate])]
    [CmdletBinding()]
    param
    (
        [ScriptBlock] $ScriptBlock
    )

    [NUnit.Framework.TestDelegate] $ScriptBlock
}

Export-ModuleMember -Variable Assert, Is, Has, Throws
Export-ModuleMember Test-Delegate