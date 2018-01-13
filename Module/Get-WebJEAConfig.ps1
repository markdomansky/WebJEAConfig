function Get-WebJEAConfig {
<#
.SYNOPSIS
Returns the site-level configuration.

.DESCRIPTION
Returns the site level configuration, including permitted groups and all commands.

.EXAMPLE
Get-WebJEAConfig

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
    #do pre script checks, etc
    $WJConfig = Get-WJPrivateData -key "WJConfig"

} #/begin

process {

    foreach ($cmd in $WJConfig.commands) {
        New-WJCommandObject $cmd
        #if ($cmd.parameters -ne $null) {
        #    foreach ($param in $cmd.parameters) {
        #        New-WJParameterObject $param
        #    }
        #}
    }
    Write-Output $WJConfig

} #/process

end {
    
    
} #/end
} #/function