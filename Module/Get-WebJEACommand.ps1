function Get-WebJEACommand {
<#
.SYNOPSIS
Get a Command from the WebJEA Config

.DESCRIPTION
Returns a selected, or all Commands from the in-memory WebJEA Config.

.EXAMPLE
Get-WebJEACommand

.EXAMPLE
Get-WebJEACommand -CommandId <commandid>

.PARAMETER CommandId
Find the specified CommandId and return it.  If not found, returns nothing

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
    [Parameter(Position=0, ValueFromPipeline, ValueFromPipelineByPropertyName,
    HelpMessage='What CommandId do you want?')]
    [ValidateNotNullOrEmpty()]
    [Alias('Id')]
    [string]$CommandId

) #/param

begin {
    #do pre script checks, etc
    $WJConfig = get-WJPrivateData -key "WJConfig"

} #/begin

process {
    
    $cmds = $WJConfig.commands
    if ($PSBoundParameters.ContainsKey("CommandID")) { #filter to selected if provided
        $cmds = $cmds | where-object -FilterScript {$_.id -eq $CommandId}
    }

    foreach ($cmd in $cmds) {
        New-WJCommandObject $cmd
        #if ($cmd.parameters -ne $null) {
            #foreach ($param in $cmd.parameters) {
            #    new-WJParameterObject $param
            #}
        #}
        write-output $cmd
    }

} #/process

end {
    
} #/end
} #/function