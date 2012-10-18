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

Export-ModuleMember -Variable Assert, Is, Has, Throws