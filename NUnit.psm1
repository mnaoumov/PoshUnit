#requires -version 2.0

[CmdletBinding()]
param
(
)

$script:ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$nunitAssembly = "$PSScriptRoot\packages\NUnit.2.6.1\lib\nunit.framework.dll"
Import-Module $nunitAssembly

Add-Type -Language CSharp -ReferencedAssemblies $nunitAssembly `
@"
using System;
using System.Management.Automation;
using NUnit.Framework;

namespace PoshUnit
{
    public static class NUnitHelper
    {
        public static TestDelegate ToTestDelegate(ScriptBlock block)
        {
            return () =>
                { 
                    try
                    {
                        block.Invoke();
                    }
                    catch (RuntimeException e)
                    {
                        throw e.InnerException;
                    }
                };
        }
    }
}
"@

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

    [PoshUnit.NUnitHelper]::ToTestDelegate($ScriptBlock)
}

Export-ModuleMember -Variable Assert, Is, Has, Throws
Export-ModuleMember Test-Delegate