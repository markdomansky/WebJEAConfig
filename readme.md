# WebJEA: PowerShell driven Web Forms for Secure Self-Service

WebJEA allows you to dynamically build web forms for any PowerShell script.  WebJEA automatically parses the script at page load for description, parameters and validation, then dynamically builds a form to take input and display formatted output.  You define access groups via AD and the scripts run within the AppPool user context.

**This is the PowerShell Module used to modify the configuration of a [WebJEA](../WebJEA) site.**

## Requirements

* Domain Joined server running Windows 2016 Core/Full with PowerShell 5.1 <br>_(Windows 2012 R2 or PowerShell 4.0 should work, but haven't been tested.)_

## Installation

WebJEAConfig is installed via PowerShellGallery.com.

```powershell
Install-Package WebJEAConfig
```

## Adding Scripts to WebJEA

```powershell
Import-Module WebJEAConfig
Open-WebJEAConfig "c:\webjea\config.json" 
Set-WebJEAConfig -PermittedGroups @('domain\group3') #these groups will have access to all commands
New-WebJEACommand -DisplayName "New Script" -Script "c:\webjea\newscript.ps1" -PermittedGroups @('domain\group1','domain\group2') #these groups will have access only to this commandh
Save-WebJEAConfig
```

## License

Copyright, 2018, Mark Domansky.  All rights not granted explicitly are reserved.

This code is released under the GPL v3 license.

