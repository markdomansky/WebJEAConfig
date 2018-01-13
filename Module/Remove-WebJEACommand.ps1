function Remove-WebJEACommand {
<#
.SYNOPSIS
Removes a Command from the available set.

.DESCRIPTION
If the CommandId specified is found, it is removed from the available set in the configuration.

.EXAMPLE
Remove-WebJEACommand -CommandId "SomeID"

.PARAMETER CommandId
What CommandId you want to remove.

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
    [Parameter(Position=0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName,
    HelpMessage='What CommandId do you want to remove?')]
    [ValidateNotNullOrEmpty()]
    [Alias('Id')]
    [string]$CommandId

) #/param

begin {
    #do pre script checks, etc
    $WJConfig = Get-WJPrivateData -key "WJConfig"
} #/begin

process {
    
    $cmds = $WJConfig.commands
    $foundcmds = $cmds | where-object -FilterScript {$_.id -eq $CommandId} 
    $newcmds = $cmds | where-object -FilterScript {$_.id -ne $CommandId} 
    $WJConfig.commands = $newcmds
    if ($foundcmds -eq $null) {write-warning "The command completed successfully, but nothing was modified."}

} #/process

end {
    Set-WJPrivateData -key "WJConfig" -value $WJConfig
} #/end
} #/function