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

    $testFixtureFiles = Get-ChildItem -Path $Path -Filter $Filter -Recurse:$Recurse | `
        Select-Object -ExpandProperty FullName

    if (-not $testFixtureFiles)
    {
        Write-Warning "No TestFixture files found"
        return
    }

    foreach ($testFixtureFile in $testFixtureFiles)
    {

        Write-Verbose "Processing file '$testFixtureFile'"
        try
        {
            & $testFixtureFile
        }
        catch
        {
            Write-Host "Processing file '$testFixtureFile' failed" -ForegroundColor Red
            $_
        }
    }
}

function Report-Error
{
    [CmdletBinding()]
    param
    (
        [string] $Message,
        [System.Automation.Management.ErrorAction] $Error
    )

    Write-Host "$Message`n$Error" -ForegroundColor Red
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

    Write-Host "Test Fixture '$Name'" -ForegroundColor Yellow

    try
    {
        . $TestFixtureSetUp | Out-Null
    }
    catch
    {
        Report-Error "TestFixtureSetUp failed" $_
        return
    }

    foreach ($test in $Tests)
    {
        try
        {
            . $SetUp | Out-Null
        }
        catch
        {
            Report-Error "    SetUp failed" $_
            continue
        }

        try
        {
            . $test.Method | Out-Null
            Write-Host "    $($test.Name)" -ForegroundColor Green
        }
        catch
        {
            Report-Error "    $($test.Name)" $_
        }
        finally
        {
            try
            {
                . $TearDown | Out-Null
            }
            catch
            {
                Report-Error "    TearDown failed" $_
            }
        }
    }
    
    try
    {
        . $TestFixtureTearDown | Out-Null
    }
    catch
    {
        Report-Error "    TestFixtureTearDown failed" $_
    }

    Write-Host ""
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