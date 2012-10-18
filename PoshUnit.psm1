#requires -version 2.0

[CmdletBinding()]
param
(
)

$script:ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Import-Module "$PSScriptRoot\NUnit.psm1"

function Invoke-PoshUnit
{
    [CmdletBinding()]
    param
    (
        [string] $Path = ".",
        [string] $Filter = "*Tests.ps1",
        [bool] $Recurse = $true
    )

    $testFixtureFiles = Get-ChildItem -Path $Path -Filter $Filter -Recurse:$Recurse

    if (-not $testFixtureFiles)
    {
        Write-Warning "No TestFixture files found"
        return
    }

    foreach ($testFixtureFile in $testFixtureFiles)
    {
        try
        {
            & $testFixtureFile.FullName
        }
        catch
        {
            Write-Host "Processing of file '$testFixtureFile' failed" -ForegroundColor Red
            $_
        }
    }
}

function Test-Fixture
{
    [CmdletBinding()]
    param
    (
        [string] $Name,
        [ScriptBlock] $TestFixtureSetUp = {},
        [ScriptBlock] $TestFixtureTearDown = {},
        [ScriptBlock] $SetUp = {},
        [ScriptBlock] $TearDown = {},
        [PSObject[]] $Tests = @()
    )

    "Processing Test Fixture '$Name'"

    try
    {
        . $TestFixtureSetUp
    }
    catch
    {
        "TestFixtureSetUp failed"
        $_
        return
    }

    foreach ($test in $Tests)
    {
        try
        {
            . $SetUp
        }
        catch
        {
            "SetUp failed"
            $_
            continue
        }

        "Runnning test '$($test.Name)'"

        try
        {
            . $test.Method
            "Test '$($test.Name)' succeded"
        }
        catch
        {
            "Test '$($test.Name)' failed"
            $_
        }
        finally
        {
            try
            {
                . $TearDown
            }
            catch
            {
                "SetUp failed"
                $_
            }
        }
    }
    
    try
    {
        . $TestFixtureTearDown
    }
    catch
    {
        "TestFixtureTearDown failed"
        $_
        return
    }
}

function Test
{
    [OutputType([PSObject])]
    [CmdletBinding()]
    param
    (
        [string] $Name,
        [ScriptBlock] $Method
    )

    New-Object PSObject -Property `
    @{
        Name = $Name;
        Method = $Method
    }
}

Export-ModuleMember Invoke-PoshUnit, Test-Fixture, Test