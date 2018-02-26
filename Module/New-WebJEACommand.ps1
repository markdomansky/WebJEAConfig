function New-WebJEACommand {
<#
.SYNOPSIS
Create a new command in the current, in-memory configuration.

.DESCRIPTION
Add a new script to the config, specifying name, script path, optional id, permittedgroups, onload script, and if the parameters should be logged during execution.

.EXAMPLE
new-webjeacommand -displayname 'new script' -script 'c:\webjea\script.ps1' -permittedgroups @('domain\group1')

.EXAMPLE
new-webjeacommand -displayname 'new script' -script 'c:\webjea\script.ps1' -permittedgroups @('domain\group1') -onloadscript 'c:\webjea\onload.ps1' 

.PARAMETER CommandId
Optional. Assign a custom id to this command.  Useful for linking to this command directly via url (?id=<value>)

.PARAMETER DisplayName
Optional. This is the friendly name presented to users. Not technically required, as a default value will be generated if not specified.

.PARAMETER OnloadScript
Optional. If specified, this script will execute on page load.
Notes: This script should not require any parameters.  This script should also run quickly as long running scripts will impact the user's experience.

.PARAMETER Script
Optional. Not technically required, this is the script that will be parsed to generate the form and eventually executed.
Notes: This can be omitted to run only an onloadscript.  It is also possible to have no script or onloadscript and specify a synopsis.

.PARAMETER Synopsis
Optional. This should only be specified if no script or onloadscript is specified and is intended for use on the default script as a landing page. It will override the parsed value from script.

.PARAMETER LogParameters
Optional. This will override the Config setting on this command.  When true, the parameters will be logged to the usage log.  When false, this script will only log the script run and not the parameters and their values.

.PARAMETER PermittedGroups
Optional. This is the list of domain users and groups that will see and can execute this script.  Machine local groups work as well, but aren't recommended.  Users/Groups specified at the config level always have access.
Groups and users should be specified in winnt format (domain\group).

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
    #id, displayname, description, synopsis, onloadscript, script, permittedgroups, parameters
    [Parameter(Position=0, HelpMessage='What CommandId do you want to use?')]
    [ValidateNotNullOrEmpty()]
    [Alias('Id')]
    [string]$CommandId = (new-guid).tostring(), 

    [Parameter(Mandatory, HelpMessage='What do you want the DisplayName to be?')]
    [ValidateNotNullOrEmpty()]
    [Alias('Name')]
    [string]$DisplayName, 
		
    [Parameter(HelpMessage='What do you want the Onload Script to be?')]
    [ValidateNotNullOrEmpty()]
    [string]$OnloadScript, 
		
    [Parameter(HelpMessage='What do you want the Script to be?')]
    [ValidateNotNullOrEmpty()]
    [string]$Script, 
	
    [Parameter(HelpMessage='What do you want the Synopsis to be?')]
    [ValidateNotNullOrEmpty()]
    [string]$Synopsis, 
	
    [Parameter(HelpMessage='Do you want to log parameters? (if not specified, will inherit from config)')]
    [ValidateNotNullOrEmpty()]
    [boolean]$LogParameters, 
		
    [Parameter(HelpMessage='What do you want the Permitted Groups to be? (domain\usergroup)')]
    [ValidateNotNullOrEmpty()]
    [string[]]$PermittedGroups
		
) #/param

begin {
    #do pre script checks, etc
    $WJConfig = Get-WJPrivateData -key "WJConfig"

} #/begin

process {
    $ErrorActionPreference = "Stop"

    $cmds = $null
    $cmds = $WJConfig.commands | where-object -FilterScript {$_.id -eq $CommandId}

    if (($cmds | measure).count -eq 0) {
        $newcmd = New-WJCommandObject
        $newcmd.id = $CommandId

        [pscustomobject[]]$wjconfig.commands += $newcmd
        Set-WJPrivateData -Key "WJConfig" -Value $WJConfig

        Set-WebJEACommand @PSBoundParameters

    } elseif (($cmds | measure).count -ge 1) {
        write-error "CommandId already exists.  Cannot continue."
    }

    return Get-WebJEACommand -CommandId $CommandId
    
} #/process

end {

} #/end
} #/function