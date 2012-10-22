# PoshUnit #

Yet another PowerShell Unit testing framework

It designed to write **NUnit**-like tests.

## Main features ##

* NUnit Assert class
* Standard TestFixtureSetUp->SetUp->Test->TearDown->TestFixtureTearDown execution workflow

## Installation ##

Build using **Build-InstallPackage.ps1**.

Copy content of folder **_InstallPackage** into your project.

## To create test ##

Create *Tests\MyTestFixture.Tests.ps1* using snippet **Tests\TestFixture.Snippet.ps1**

its main part is

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
        Test "<Insert Test Name>" `
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

Just execute

    Invoke-Tests.ps1

or if you want to have more control

Import module
    
	Import-Module .\PoshUnit.psm1

Then run tests use
    
    Invoke-PoshUnit

***Optional parameters:***

**-Path**

Default value: "Tests"
    
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

* **-ShowOutput $false** does not hide messages written by *Write-Host*, *[System.Console]::WriteLine()*, *[System.Console]::Error.WriteLine()* and from standard error output of native apps
* Source line shown for exception thrown by *Write-Error* is not correct
