function Set-WJPrivateData {
<#
.SYNOPSIS
This just makes it easier to get/set Module PrivateData

.DESCRIPTION
Describe the function in more detail

.EXAMPLE
Set-WJPrivateData -key SomeKey -value SomeValue

.PARAMETER Key
The name of the variable you want to set the value for

.PARAMETER Value
The value you want to set.


#>
#requires -version 3

[CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
param
(
    [Parameter(Position=0, Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Key,
		
    [Parameter()]
    $Value = $null

) #/param

begin {
    #do pre script checks, etc
    
} #/begin

process {

	$MyInvocation.MyCommand.Module.PrivateData[$key] = $Value

} #/process

end {
    
} #/end
} #/function