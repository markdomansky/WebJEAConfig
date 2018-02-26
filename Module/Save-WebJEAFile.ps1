function Save-WebJEAFile {
<#
.SYNOPSIS
Saves the WebJEA Config to the specified file name

.DESCRIPTION
Saves all changes to the configuration file specified. This will make all changes permanent and takes effect on the next page load.

.EXAMPLE
Save-WebJEAFile 

.EXAMPLE
Save-WebJEAFile -File "C:\ps\config.json"

.PARAMETER File
The file to save the changes to, if not specified, saves the changes to the file that was opened.

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
    HelpMessage='Where do you want to save the configuration to?')]
    [ValidateNotNullOrEmpty()]
    [string]$File

) #/param

begin {
    $WJConfig = Get-WJPrivateData -key "WJConfig"
    $WJConfigFile = Get-WJPrivateData -key "WJConfigFile"

    if ($WJConfigFile -eq $null -and -not $PSBoundParameters.ContainsKey('File')) {
        write-error "Parameter File required."
    }
} #/begin

process {
	$ErrorActionPreference = "Stop"
    write-verbose "Generating Output"
    $output = ConvertTo-Json $WJConfig -depth 6

	#determine which file to save to
	$outputfile = $null
	if ($file -ne $null) {
    	$outputfile = $file
	} elseif ($WJConfigFile -ne $null) {
        write-verbose "Overwriting Existing File"
		$outputfile = $WJConfigFile
	} else {
		#there wasn't a file in privatedata, and there wasn't one specified
		Write-Error "No File specified."
		return
	}
    write-verbose "Saving to $outputfile"

    #prefer saving to the user specified path, but save to the originally opened file, if there was one.  else error
    if ($outputfile -ne $Null) {
		Write-Verbose "Saving WJConfig to $outputfile"
        $output | out-file -FilePath $outputfile -Encoding ascii
        $outputfile = resolve-path $outputfile
    } else {
        write-error "No File specified."
    }

} #/process

end {
	#change the privatedata to the outputfile name
	Write-Verbose "Setting WJConfigFile to $Outputfile"
    Set-WJPrivateData -key "WJConfigFile" -value $outputfile
} #/end
} #/function