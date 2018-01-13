function Get-WJPrivateData {
<#
.SYNOPSIS
Returns the data from PrivateData[$key]

.DESCRIPTION
Returns the value of the key found in PrivateData, if it exists.  If it doesn't, returns the defaultvalue provided

.EXAMPLE
Get-WJPrivateData -key somekey -defaultvalue $null

.PARAMETER Key
Key to look for in PrivateData

.PARAMETER DefaultValue
The value to return if PrivateData does not contain the key specified


#>
#requires -version 3

[CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
param
(
    [Parameter(Position=0, Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Key,

	[Parameter()]
	$DefaultValue = $null

) #/param

begin {
    #do pre script checks, etc
    
} #/begin

process {

    #write-verbose ($MyInvocation.MyCommand.Module.PrivateData | out-string)

	if ($MyInvocation.MyCommand.Module.PrivateData.containskey($key)) {
		Write-Output $MyInvocation.MyCommand.Module.PrivateData[$key]
	} else {
		Write-Output $DefaultValue
	}
} #/process

end {
    
} #/end
} #/function