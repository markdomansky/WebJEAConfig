function Set-WebJEAConfig {
<#
.SYNOPSIS
Sets global parameters for the in-memory WebJEA Configuration.

.DESCRIPTION
Modify global and default parameters for the WebJEA Configuration.

.EXAMPLE
Set-WebJEAConfig -title "NewTitle"

.PARAMETER Title
Optional. The Title you want displayed.

.PARAMETER BasePath
Optional. Default path for all scripts that have relative paths.

.PARAMETER DefaultCommandId
Optional. Default Command to run when no command is specified in the GET/POST.

.PARAMETER LogParameters
Optional. Show the parameters entered in the form in the log file.  Can be overridden per command.

.PARAMETER SendTelemetry
Optional. Sends anonymized data to report overall usage.

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
    [Parameter(HelpMessage='What would you like the page title to display?')]
    [ValidateNotNullOrEmpty()]
    [string]$Title, 
		
    [Parameter(HelpMessage='What is the starting folder for scripts without paths specified?')]
    [ValidateNotNullOrEmpty()]
    #[ValidateScript({Test-path $_})] #must return $true/$false #can't do this as the path may not exist on the current system.
    [string]$BasePath, 
		
    [Parameter(HelpMessage='What command do you want to be default?')]
    [ValidateNotNullOrEmpty()]
    [string]$DefaultCommandId,

    [Parameter(HelpMessage='Do you want to log the inputs entered in a form to the log file? (This can be overridden per command)')]
    [ValidateNotNullOrEmpty()]
    [boolean]$LogParameters,
		
    [Parameter(HelpMessage='Do you want to send telemetry to improve WebJEA?')]
    [ValidateNotNullOrEmpty()]
    [boolean]$SendTelemetry,
		
    [Parameter(HelpMessage='List groups or users you to have access to all entries (domain\group)?')]
    [ValidateNotNullOrEmpty()]
    #[ValidatePattern("\w+\\\w+")]
    [string[]]$PermittedGroups
		
) #/param

begin {
    #do pre script checks, etc
    $WJConfig = get-WJPrivateData -key "WJConfig"
} #/begin

process {
    New-WJConfigObject -cfg $WJConfig

    if ($PSBoundParameters.ContainsKey("Title")) {$WJConfig.Title = $title}
    if ($PSBoundParameters.ContainsKey("BasePath")) {$WJConfig.basepath = $basepath}
    if ($PSBoundParameters.ContainsKey("LogParameters")) {$WJConfig.LogParameters = $LogParameters}
    if ($PSBoundParameters.ContainsKey("PermittedGroups")) {$WJConfig.PermittedGroups = $PermittedGroups}
    if ($PSBoundParameters.ContainsKey("SendTelemetry")) {$WJConfig.SendTelemetry = $SendTelemetry}

    if ($PSBoundParameters.ContainsKey("DefaultCommandId")) {
        $foundcmd = $null
        foreach ($cmd in $WJConfig.commands) {
            if ($DefaultCommandId -eq $cmd.id) { #found it, save it for more verification
                $foundcmd = $cmd
                break
            }
        }
        if ($foundcmd -ne $null) {
            if ($foundcmd.permittedgroups -notcontains "*") {
                Write-Warning "DefaultCommandId found, but does not permit all users."
            }
            $WJConfig.DefaultCommandId = $DefaultCommandId
        } else {
            write-error "DefaultCommandId specified was not found in available commands"
        }
    }

} #/process

end {
    Set-WJPrivateData -key "WJConfig" -value $WJConfig
} #/end
} #/function