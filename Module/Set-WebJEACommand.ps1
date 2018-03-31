function Set-WebJEACommand {
<#
.SYNOPSIS
Modify a command in the current, in-memory configuration.

.DESCRIPTION
modify a script in the config, specifying name, script path, optional id, permittedgroups, onload script, and if the parameters should be logged during execution.

.EXAMPLE
set-webjeacommand -commandid X -displayname 'new script' -script 'c:\webjea\script.ps1' -permittedgroups @('domain\group1')

.EXAMPLE
set-webjeacommand -commandid X -newcommandid Y -displayname 'new script' -script 'c:\webjea\script.ps1' -permittedgroups @('domain\group1') -onloadscript 'c:\webjea\onload.ps1' 

.PARAMETER CommandId
Required. This is the id of the command you want to modify.

.PARAMETER NewCommandId
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
The synopsis, when parsed or specified, can contain straight html code.  This is by design.

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
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, HelpMessage='What Command do you want to modify?')]
    [ValidateNotNullOrEmpty()]
    [Alias('Id')]
    [string]$CommandID, 
		
    [Parameter(HelpMessage='What is the new CommandId?')]
    [ValidateNotNullOrEmpty()]
    [string]$NewCommandID, 
		
    [Parameter(ValueFromPipelineByPropertyName, HelpMessage='What do you want the DisplayName to be?')]
    [ValidateNotNullOrEmpty()]
    [string]$DisplayName, 
				
    [Parameter(ValueFromPipelineByPropertyName, HelpMessage='What do you want the Onload Script to be?')]
    [string]$OnloadScript, 
		
    [Parameter(ValueFromPipelineByPropertyName, HelpMessage='What do you want the Script to be?')]
    [string]$Script, 
		
    [Parameter(ValueFromPipelineByPropertyName, HelpMessage='What do you want the Synopsis to be?')]
    [ValidateNotNullOrEmpty()]
    [string]$Synopsis, 
		
    [Parameter(ValueFromPipelineByPropertyName, HelpMessage='Do you want to log parameters? (if not specified, will inherit from config)')]
    [ValidateNotNullOrEmpty()]
    [boolean]$LogParameters, 
		
    [Parameter(ValueFromPipelineByPropertyName, HelpMessage='What do you want the Permitted Groups to be? (domain\usergroup)')]
    [string[]]$PermittedGroups
		
) #/param

begin {
    #do pre script checks, etc
    $WJConfig = get-WJPrivateData -key "WJConfig"
} #/begin

process {
    $ErrorActionPreference = "Stop"
    
    #check if commandid exists
    $cmds = $null
    $cmds = $WJConfig.commands | where-object -FilterScript {$_.id -eq $CommandId}

    #error out if not exist
    if (($cmds | measure).count -ne 1) {
        if (($cmds | measure).count -gt 1) {
            write-error "CommandId returned multiple results.  Cannot continue."
        } else {#not exist
            write-error "CommandId was not found.  Cannot continue."
        }
    }

    $cmd = $cmds | select -first 1 #convenience cmdlet
    New-WJCommandObject -cmd $cmd

    if ($PSBoundParameters.ContainsKey('NewCommandID')) {
        #check if new name exists
        $test = Get-WebJEACommand -CommandId $NewCommandID
        #if exist and different -ne commandid
        if (($test | measure).count -gt 0 -and $test.id -ne $CommandID) {
            write-error "Cannot rename command to existing command.  Cannot continue."
        } else {
            #else set new name
            $cmd.id = $NewCommandID
        }
        #if defaultcmdid eq commandid, set defaultcmdidd = newcommandid
        if ($wjconfig.defaultcommandid -eq $CommandID) {
            $WJConfig.defaultcommandid = $NewCommandID
        }
    }

    if ($PSBoundParameters.ContainsKey("DisplayName")) {$cmd.DisplayName = $displayname}
    if ($PSBoundParameters.ContainsKey("OnloadScript")) {$cmd.OnloadScript = $OnloadScript}
    if ($PSBoundParameters.ContainsKey("Script")) {$cmd.Script = $Script}
    if ($PSBoundParameters.ContainsKey("Synopsis")) {set-psobjproperty -pscustomobject $cmd -property 'Synopsis' -value $synopsis}
    if ($PSBoundParameters.ContainsKey("LogParameters")) {set-psobjproperty -pscustomobject $cmd -property 'LogParameters' -value $LogParameters}
    if ($PSBoundParameters.ContainsKey("PermittedGroups")) {$cmd.PermittedGroups = $PermittedGroups}

} #/process

end {
    Set-WJPrivateData -key "WJConfig" -value $WJConfig
} #/end
} #/function