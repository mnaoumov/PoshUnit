#requires -version 2.0

[CmdletBinding()]
param
(
)

$script:ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$PSScriptRoot = $MyInvocation.MyCommand.Path | Split-Path

Import-Module "$PSScriptRoot\..\NUnit.psm1"
Import-Module "$PSScriptRoot\..\packages\NUnit.2.6.1\lib\nunit.framework.dll"

function Test-NUnit
{
    param
    (
        [ScriptBlock] $ScriptBlock
    )

    $ScriptBlock
    try
    {
        & $ScriptBlock
        "SUCCESS`n"
    }
    catch [Exception]
    {
        $_.Exception
    }
}


"Test of NUnit functions`n"

Test-NUnit { $Assert::That(2 + 2, $Is::EqualTo(4)) }
Test-NUnit { $Assert::That(2 + 2, $Is::EqualTo(5)) }
Test-NUnit { $Assert::That(3, $Is::GreaterThan(2)) }
Test-NUnit { $Assert::That(3, $Is::GreaterThan(8)) }
Test-NUnit { $Assert::That(3, $Is::GreaterThan(1).And.LessThan(5)) }
Test-NUnit { $Assert::That(3, $Is::GreaterThan(1).And.LessThan(2)) }
Test-NUnit { $Assert::That(@(1, 2, 3), $Has::Length.EqualTo(3)) }