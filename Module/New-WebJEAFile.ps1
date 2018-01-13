function New-WebJEAFile {
<#
.SYNOPSIS
Starts a new configuration in memory

.DESCRIPTION
This creates a new in-memory configuration.  Until saved, this configuration is not active.

.EXAMPLE
New-WebJEAFile

.NOTES
Version:          1.0
Author:           Mark Domansky
Creation Date:    2018-01-13
Purpose/Change:   Initial release

#>
#requires -version 3
#r#equires -pssnapin <snapin> -version X.x
#r#equires -modules {<module-name>}
#r#equires -shellid <shellid>
#r#equires -runasadministrator

[CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]

param
(

) #/param

begin {
    
} #/begin

process {
	$ErrorActionPreference = "Stop"

    #drop all content, start over
    Set-WJPrivateData -key "WJConfigFile" -value $null
	Set-WJPrivateData -key "WJConfig" -value (new-wjconfigobject)

} #/process

end {

} #/end
} #/function