# PoshUnit #

Yet another PowerShell Unit testing framework

It designed to write **NUnit**-like tests.

Main features:

* NUnit Assert class
* Standard TestFixtureSetUp->SetUp->Test->TearDown->TestFixtureTearDown execution workflow

## To create test ##

Create *Tests\MyTestFixture.Tests.ps1* using snippet **Tests\TestFixture.Snippet.ps1** (see code below)

	#requires -version 2.0
	
	[CmdletBinding()]
	param
	(
	)
	
	$script:ErrorActionPreference = "Stop"
	Set-StrictMode -Version Latest
	$PSScriptRoot = $MyInvocation.MyCommand.Path | Split-Path
	
	Import-Module "$PSScriptRoot\relative\path\to\PoshUnit.psm1"
	
	Test-Fixture "<Insert Test Fixture Name>" `
	    -TestFixtureSetUp `
	    {
	        # Executed once before tests
	    } `
	    -TestFixtureTearDown `
	    {
	        # Executed once after tests
	    } `
	    -SetUp `
	    {
	        # Executed before each test
	    } `
	    -TearDown `
	    {
	        # Executed after each test
	    } `
	    -Tests `
	    (
	        Test "<Insetrt Test Name>" `
	        {
	            # Write test
	            # For example
	            # $Assert::That(2 + 2, $Is::EqualTo(4))
	        }
	    ),
	    (
	        Test "<Insert Test Name 2>" `
	        {
	            # Write test
	        }
	    )

## NUnit Assert syntax ##

PoshUnit natively supports the most used NUnit classes: Assert, Is, Has, Throws

    $Assert::That(2 + 2, $Is::EqualTo(4))
    $Assert::That(3, $Is::GreaterThan(2))
    $Assert::That(3, $Is::GreaterThan(1).And.LessThan(5))
    $Assert::That(@(1, 2, 3), $Has::Length.EqualTo(3))
    $Assert::That((Test-Delegate { throw New-Object NotImplementedException }), $Throws::TypeOf([NotImplementedException])) }

## To run tests ##

Execute

    Invoke-Tests.ps1


or if you want to have more control

Import module
    
	Import-Module path\PoshUnit.psm1

Then run tests use
    
    Invoke-PoshUnit

***Optional parameters:***

**-Path**

Default value: "."
    
**-Filter**

Default value: "*.Tests.ps1"

**-Recurse**

Default value: $true

**-ShowOutput**

Default value: $false

**-ShowErrors**

Default value: $true

**-ShowStackTrace**

Default value: $false


## Known issues ##

* **-ShowOutput $false** does not hide messages written by *Write-Host*
* Source line shown for exception thrown by *Write-Error* is not correct
