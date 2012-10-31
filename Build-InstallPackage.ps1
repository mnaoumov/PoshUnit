#requires -version 2.0

[CmdletBinding()]
param
(
)

$script:ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
function PSScriptRoot { $MyInvocation.ScriptName | Split-Path }

$buildFolder = "$(PSScriptRoot)\_InstallPackage"

if (Test-Path $buildFolder)
{
    Remove-Item $buildFolder -Recurse
}

New-Item $buildFolder -ItemType Directory
New-Item "$buildFolder\packages\PoshUnit" -ItemType Directory
New-Item "$buildFolder\Tests" -ItemType Directory

Copy-Item -Path "$(PSScriptRoot)\packages\*" -Destination "$buildFolder\packages" -Recurse
Copy-Item -Path "$(PSScriptRoot)\NUnit.psm1" -Destination "$buildFolder\packages\PoshUnit"
Copy-Item -Path "$(PSScriptRoot)\PoshUnit.psm1" -Destination "$buildFolder\packages\PoshUnit"
Copy-Item -Path "$(PSScriptRoot)\Invoke-Tests.ps1" -Destination "$buildFolder"
Copy-Item -Path "$(PSScriptRoot)\Tests\TestFixture.Snippet.ps1" -Destination "$buildFolder\Tests"