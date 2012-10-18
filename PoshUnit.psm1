#requires -version 2.0

[CmdletBinding()]
param
(
)

$script:ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Import-Module "$PSScriptRoot\NUnit.psm1"

function Clear-PoshUnitContext
{
    $global:PoshUnitContext = New-Object PSObject -Property `
    @{
        TestsPassed = 0;
        TestsFailed = 0;
        InsideInvokePoshUnit = $false
    }
}

function Invoke-PoshUnit
{
    [CmdletBinding()]
    param
    (
        [string] $Path = ".",
        [string] $Filter = "*Tests.ps1",
        [bool] $Recurse = $true
    )

    $global:PoshUnitContext = New-Object PSObject -Property `
    @{
        TestsPassed = 0;
        TestsFailed = 0;
        InsideInvokePoshUnit = $true
    }

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

    Write-TestsSummary

    Clear-PoshUnitContext
}

function Report-Error
{
    [CmdletBinding()]
    param
    (
        [string] $Message,
        [System.Management.Automation.ErrorRecord] $Error
    )

    [string] $errorString = $Error | Out-String

    Write-Host "$Message`n$errorString`n" -ForegroundColor Red
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

    if (-not $global:PoshUnitContext.InsideInvokePoshUnit)
    {
        Clear-PoshUnitContext
    }

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
            $global:PoshUnitContext.TestsPassed++
        }
        catch
        {
            Report-Error "    $($test.Name)" $_
            $global:PoshUnitContext.TestsFailed++
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

    if (-not $global:PoshUnitContext.InsideInvokePoshUnit)
    {
        Write-TestsSummary
        Clear-PoshUnitContext
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

function Write-TestsSummary
{
    Write-Host ("Tests completed`nPassed: {0} Failed: {1}`n" -f $global:PoshUnitContext.TestsPassed, $global:PoshUnitContext.TestsFailed)
}

Clear-PoshUnitContext

Export-ModuleMember Invoke-PoshUnit, Test-Fixture, Test