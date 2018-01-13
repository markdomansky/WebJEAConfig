#
# This is a PowerShell Unit Test file.
# You need a unit test framework such as Pester to run PowerShell Unit tests. 
# You can download Pester from http://go.microsoft.com/fwlink/?LinkID=534084
#

Describe "Testing WebJEA Module" {

	Describe "Open-WebJEAFile" {
		Context "Function Exists" {
			It "Should Return Null" {
				Open-WebJEAFile -path ".\test1.input.json"
			}
			InModuleScope "WebJEAConfig" {
				It "WJConfigFile Should be .\test1.input.json " {
					Get-WJPrivateData "WJConfigFile" | should be "D:\Dropbox\Scripts\VB.NET\WebJEA\WebJEAConfig\Tests\test1.input.json"
				}
				It "WJConfig Should have content" {
					$WJConfig = Get-WJPrivateData "WJConfig"
					$WJConfig.title | should be "WebJEA Demo"
					$WJConfig.basePath | should be "c:\dropbox\scripts\vb.net\webjea\demo"
					$WJConfig.LogParameters | should be $true
					$WJConfig.defaultcommandid | should be "testParser"
					$WJConfig.commands.count | should be 9
				}
				#$MyInvocation.MyCommand.Module.PrivateData["WJConfigFile"] | should be $null
			}
		}
	}

	Describe "Save-WebJEAFile" {
		Context "Function Exists" {
		    It "Should Produce matching output" {
                remove-item .\test1.output.json -ea 0 -confirm:$false #remove the file before we output
                Save-WebJEAFile -file ".\test1.output.json" 
                (get-filehash ".\test1.output.json").hash  | should be (get-filehash ".\test1.input.json").hash
                #remove-item .\test1.output.json -ea 0 -confirm:$false #remove the file before we output
            }
            InModuleScope "WebJEAConfig" {
                It "WJConfigFile is now test1.output.json" {
                    Get-WJPrivateData "WJConfigFile" | should be "D:\Dropbox\scripts\vb.net\webjea\webjeaconfig\tests\test1.output.json"
                }
            }
		}
	}

    Describe "Get-WebJEACommand" {
        Context "Function Exists" {
            It "Returns All" {
                $cmds = Get-WebJEACommand
                #write-host ($cmds | fl | out-string)
                $cmds.count | should be 9
            }
            It "Returns One" {
                $cmd = Get-WebJEACommand -CommandId "overview"
                $cmd -ne $null | should be $true
                $cmd.id | should be "overview"
            }
        }
    }

    Describe "Set-WebJEAConfig" {
        Context "Function Exists" {
            It "Modify Title" {
                Set-WebJEAConfig -title "New WebJEA Title" | should be $null
            }
            It "Modify LogParameters" {
                Set-WebJEAConfig -LogParameters $false | should be $null
            }
            It "Modify BasePath" {
                Set-WebJEAConfig -basepath "C:\Working" | should be $null
            }
            It "Modify DefaultCommandId" {
                Set-WebJEAConfig -defaultcommandid "test1" | should be $null
            }
            It "Modify Global Permissions" {
                Set-WebJEAConfig -permittedgroups "user\domain" | should be $null
                Set-WebJEAConfig -permittedgroups @("domain\user1","domain\user2") | should be $null
            }
            InModuleScope "WebJEAConfig" {
                $WJConfig = Get-WJPrivateData "WJConfig"
                It "Modified Title" {
                    $WJConfig.title -eq "New WebJEA Title" | should be $true
                }
                It "Modified LogParameters" {
                    $WJConfig.LogParameters -eq $false | should be $true
                }
                It "Modified BasePath" {
                    $WJConfig.BasePath -eq "C:\Working" | should be $true
                }
                It "Modified DefaultCommandId" {
                    $WJConfig.defaultcommandid -eq "test1" | should be $true
                }
                It "Modified Global Permissions" {
                    $WJConfig.Permittedgroups -icontains "domain\user1" | should be $true
                    $WJConfig.Permittedgroups -icontains "domain\user2" | should be $true
                }
            }
        }
    }

    Describe "Get-WebJEAConfig" {
        Context "Function Exists" {
            It "Returned data" {
                $data = Get-WebJEAConfig
                $data.title -eq "New WebJEA Title" | should be $true
                $data.LogParameters -eq $false | should be $true
                $data.BasePath -eq "C:\Working" | should be $true
                $data.defaultcommandid -eq "test1" | should be $true
                $data.Permittedgroups -icontains "domain\user1" | should be $true
                $data.Permittedgroups -icontains "domain\user2" | should be $true
            }
        }
    }

    Describe "Get-WebJEACommand" {
        Context "Function Exists" {
            It "Returns All" {
                (Get-WebJEACommand |Measure-object).count | should be 9
            }
            It "Returns Nothing" {
                Get-WebJEACommand -commandid "36f3c386-5622-4209-8477-2de66742d17d" | should be $null
            }
            It "Returns testListBox" {
                $data = Get-WebJEACommand -commandid "testListBox"
                $data | should not be $null
                $data.id | should be "testListBox"
                $data.displayname | should be "testListbox"
                $data.script | should be "testListbox.ps1"
                $data.permittedgroups | should be "*"
            }
        }
    }

#    Describe "Get-WebJEAParameter" {
#        Context "Function Exists" {
#            It "Returns All" {
#                (get-webjeaparameter -commandid "test1"|measure-object).count | should be 3
#            }
#        }
#    }


    Describe "Remove-WebJEACommand" {
        Context "Function Exists" {
            It "Removes Nothing" {
                Remove-WebJEACommand -commandId "36f3c386-5622-4209-8477-2de66742d17d" -wa 0 #something unique that won't be found, suppress warning intentionally
                InModuleScope "WebJEAConfig" {
                    $WJConfig = Get-WJPrivateData "WJConfig"
                    $WJConfig.commands.count | should be 9
                }
            }
            It "Removes sample4" {
                Remove-WebJEACommand -commandId "sample4"
                InModuleScope "WebJEAConfig" {
                    $WJConfig = Get-WJPrivateData "WJConfig"
                    $WJConfig.commands.count | should be 8
                    #TODO needs to verify it removed the CORRECT commandid, for that matter, check it existed before
                }
            }
        }
    }


#    #remove parameter
#    Describe "Remove-WebJEAParameter" {
#        Context "Function Exists" {
#            It "Removes Nothing from non-existent command" {
#                Remove-WebJEAParameter -commandId "36f3c386-5622-4209-8477-2de66742d17d" -ParameterName "36f3c386-5622-4209-8477-2de66742d17d" -wa 0 #something unique that won't be found, suppress warning intentionally
#                InModuleScope "WebJEAConfig" {
#                    $WJConfig = Get-WJPrivateData "WJConfig"
#                    $WJConfig.commands[1].parameters.count | should be 3
#                }
#            }
#            It "Removes Nothing when non-existent parameter" {
#                Remove-WebJEAParameter -commandId "test1" -ParameterName "36f3c386-5622-4209-8477-2de66742d17d" -wa 0 #something unique that won't be found, suppress warning intentionally
#                InModuleScope "WebJEAConfig" {
#                    $WJConfig = Get-WJPrivateData "WJConfig"
#                    $WJConfig.commands[1].parameters.count | should be 3
#                }
#            }
#            It "Removes webjeaupn" {
#                Remove-WebJEAParameter -commandId "test1" -ParameterName "webjeaupn"
#                InModuleScope "WebJEAConfig" {
#                    $WJConfig = Get-WJPrivateData "WJConfig"
#                    $WJConfig.commands[1].parameters.count | should be 2
#                    #TODO needs to verify it removed the CORRECT parameter, for that matter, check it existed before
#                }
#            }
#        }
#    }


    Describe "New-WebJEACommand" {
        Context "Function Exists" {
            It "Returns testNew" {
                $data = New-WebJEACommand -commandid "testNew" -displayname "testNewDisplay" -onloadscript "somescript.ps1" -script "somescript2.ps1" -logparameters $false -permittedgroups "a\b","abcd1\a b c"
                $data | should not be $null
                $data.id | should be "testNew"
                $data.displayname | should be "testNewDisplay"
                $data.script | should be "somescript2.ps1"
                $data.onloadscript | should be "somescript.ps1"
                $data.logparameters | should be $false
                $data.permittedgroups | should be @("a\b","abcd1\a b c")
            }
        }
    }

    Describe "Set-WebJEACommand" {
        Context "Function Exists" {
            It "Returns testNew2" {
                Set-WebJEACommand -commandid "testNew" -NewCommandID "testNew2" -displayname "testNewDisplay2" -onloadscript "somescript3.ps1" -script "somescript4.ps1" -logparameters $true -permittedgroups "*"
                $data = Get-WEBJEACommand -commandid "testnew2"
                $data | should not be $null
                $data.id | should be "testNew2"
                $data.displayname | should be "testNewDisplay2"
                $data.script | should be "somescript4.ps1"
                $data.onloadscript | should be "somescript3.ps1"
                $data.logparameters | should be $true
                $data.permittedgroups | should be @("*")
            }
        }
    }

    

    
	Describe "Save-WebJEAFile" {
		Context "Function Exists" {
		    It "Should Produce matching output" {
                remove-item .\test1.output2.json -ea 0 -confirm:$false #remove the file before we output
                Save-WebJEAFile -file ".\test1.output2.json" 
                (get-filehash ".\test1.output2.json").hash  | should be (get-filehash ".\test1.expectedoutput2.json").hash
                #remove-item .\test1.output.json -ea 0 -confirm:$false #remove the file before we output
            }
            InModuleScope "WebJEAConfig" {
                It "WJConfigFile is now test1.output2.json" {
                    Get-WJPrivateData "WJConfigFile" | should be "d:\Dropbox\scripts\vb.net\webjea\webjeaconfig\tests\test1.output2.json"
                }
            }
		}
	}



	Describe "New-WebJEAFile" {
		Context "Function Exists" {
			It "Should Return Null" {
				New-WebJEAFile | Should Be $null
			}
			InModuleScope "WebJEAConfig" {
				It "WJConfigFile Should be Null" {
					Get-WJPrivateData "WJConfigFile" | should be $null
				}
				It "WJConfig Should be empty" {
					$WJConfig = Get-WJPrivateData "WJConfig"
					$WJConfig.BasePath | should be $null
					$WJConfig.defaultcommandid | should be $null
					$WJConfig.title | should be "WebJEA"
					$WJConfig.commands.count | should be 0
				}
			}
		}
	}




}