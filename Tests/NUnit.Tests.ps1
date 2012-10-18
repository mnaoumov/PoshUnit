#requires -version 2.0

[CmdletBinding()]
param
(
)

$script:ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$PSScriptRoot = $MyInvocation.MyCommand.Path | Split-Path

Import-Module "$PSScriptRoot\..\PoshUnit.psm1"

function Increment
{
    param
    (
        [int] $Value
    )

    $Value + 1
}

Test-Fixture "NUnit tests" `
    -TestFixtureSetUp `
    {
        $a = "TestFixtureSetUp"
    } `
    -TestFixtureTearDown `
    {
        $a += " TestFixtureTearDown"
    } `
    -SetUp `
    {
        $a += " SetUp"
    } `
    -TearDown `
    {
        $a += " TearDown"
    } `
    -Tests `
    (
        Test "2 + 2 = 4" `
        {
            $Assert::That(2 + 2, $Is::EqualTo(4))
        }
    ),
    (
        Test "Failing test 2 + 2 = 5" `
        {
            $Assert::That(2 + 2, $Is::EqualTo(5))
        }
    ),
    (
        Test "Invoke Helper Function" `
        {
            $Assert::That((Increment 123), $Is::EqualTo(124))
        }
    ),
    (
        Test "Test SetUp & TearDown" `
        {
            $Assert::That($a, $Is::EqualTo("TestFixtureSetUp SetUp TearDown SetUp TearDown SetUp TearDown SetUp"))
        }
    )