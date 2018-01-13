cd $PSScriptRoot
#remove module if to ensure we're testing the latest.
get-module WebJEAConfig -all | Remove-Module webjeaconfig -ea 0

Import-Module Pester
Import-Module ..\module\WebJEAConfig.psd1 -ErrorAction stop

#run tests
invoke-pester .\WebJEAConfig.tests.ps1 -verbose

Remove-Module WebJEAConfig