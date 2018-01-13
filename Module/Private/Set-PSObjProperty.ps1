function Set-PSObjProperty {
<#
.SYNOPSIS
Sets the property of the given object to the specified value.  Adds the property if not present

.EXAMPLE
Set-WJPSObjProperty -pscustomobject $a -property "X" -value "Y"

.PARAMETER PSCustomObject
The object to modify

.PARAMETER Property
The property to modify

.PARAMETER Value
The value to set the proeprty to


#>
#requires -version 3
#r#equires -pssnapin <snapin> -version X.x
#r#equires -modules {<module-name>}
#r#equires -shellid <shellid>
#r#equires -runasadministrator
#specify specific version requirements: 3, 5.1, etc.
#the other requires are pretty straightforward, just remove the extra # in requires

[CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]

#add function Verb-Noun {} around entire script to make a function
param
(
    [Parameter(Position=0, Mandatory)]
    [Alias('Object','PSObject')]
    [ValidateNotNullOrEmpty()]
    [PSCustomObject]$PSCustomObject, 
		
    [Parameter(Position=1, Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Property, 
		
    [Parameter(Position=2)]
    $Value = $null

) #/param

begin {
    #do pre script checks, etc
    
} #/begin

process {

    $properties = $PSCustomObject | get-member -MemberType NoteProperty | Select-Object -ExpandProperty name
    if ($properties -inotcontains $Property) {
        $PSCustomObject | Add-Member -MemberType NoteProperty -Name $Property -Value $null
    }

    $PSCustomObject.$property = $value

} #/process

end {
    
} #/end
} #/function