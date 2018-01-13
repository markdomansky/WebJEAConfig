if(-not $PSScriptRoot) {
    #PSv2 doesn't populate the PSScriptRoot, so we do it.
    $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
}

#Import Private Scripts, but not the pester files
$Private  = Get-ChildItem $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue | Where-Object {$_.Name -notlike "*.tests.ps1"}
Foreach($import in @($Private)) {
    Try {
        #PS2 compatibility
        if($import.fullname) {
			Write-Verbose "Dot sourcing Private Function $($import.basename)"
			#import each script by dotsourcing
			. $import.fullname
        }
    } Catch { Write-Error "Failed to import function $($import.fullname): $_" }
}

#import Public scripts, but not the pester files
$Public  = Get-ChildItem $PSScriptRoot\*.ps1 -ErrorAction SilentlyContinue | Where-Object {$_.Name -notlike "*.tests.ps1"}
Foreach($import in @($Public)) {
    Try {
        #PS2 compatibility
        if($import.fullname) {
			#this is so we can run the scripts as ps1 for testing, but when imported as the module, they are turned into functions and exported
			Write-Verbose "Dot sourcing Function $($import.basename)"
			. $import.fullname
            write-verbose "Exporting"
            Export-ModuleMember -Function $import.basename
        }
    } Catch { Write-Error "Failed to import function $($import.fullname): $_" }
}

#init variables
New-WebJEAFile