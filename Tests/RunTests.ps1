cd $PSScriptRoot
#remove module if to ensure we're testing the latest.
write-host 'removing old modules'
get-module WebJEAConfig -all | Remove-Module webjeaconfig -ea 0

write-host 'importing pester'
Import-Module Pester
write-host 'importing webjeaconfig'
Import-Module ..\module\WebJEAConfig.psd1 -ErrorAction stop

#run tests
write-host 'running pester'
invoke-pester .\WebJEAConfig.tests.ps1 -verbose

write-host 'removing webjeaconfig'
Remove-Module WebJEAConfig