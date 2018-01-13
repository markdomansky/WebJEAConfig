function Open-WebJEAFile {
<#
.SYNOPSIS
Opens the specified file for editing.

.DESCRIPTION
Loads the file specified for editing in-memory.  Changes are not active until saved.

.EXAMPLE
Open-WebJEAFile -path 'c:\webjea\config.json'

.PARAMETER Path
The path of the WebJEA config json file to open.

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
    HelpMessage='What configuration file do you want to open?')]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({Test-Path $_})] #must return $true/$false
    [string]$Path

) #/param

begin {
	$WJConfig = get-wjprivatedata -key "WJConfig"
    $WJConfigFile = get-wjprivatedata -key "WJConfigFile"
    $path = Resolve-Path $path
    if ((test-path $path) -eq $false) {write-error "Could not validate Path"}
} #/begin

process {
	$ErrorActionPreference = "Stop"

    $objdata = $null
    
    try {
        Write-Verbose "Testing File for JSON content: $path "
        $objdata = Get-Content $path -Raw | Convertfrom-Json
    } catch {
        Write-Error "File '$path' could not be parsed as JSON."
    } 

    #TODO: Add content testing of JSON config before overwriting internal variable?
    Write-Verbose "Opening Config in $path"
    new-wjconfigobject -cfg $objdata
    $WJConfig = $objdata
    $WJConfigFile = $path

	Set-WJPrivateData -key "WJConfig" -value $WJConfig
    Set-WJPrivateData -key "WJConfigFile" -value $WJConfigFile

} #/process

end {
} #/end
} #/function