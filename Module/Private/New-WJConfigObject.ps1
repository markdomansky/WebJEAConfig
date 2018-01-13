function New-WJConfigObject($cfg = $null) {
    $retobj = $false
    if ($cfg -eq $null) {
        $cfg = (new-object pscustomobject)
        $retobj = $true
    }

    $FullProperties = @{ 
        "Title" = "WebJEA"; 
        #"ParseScript" = $true; 
        "DefaultCommandId"=$null; 
        "BasePath" = $null; 
        "LogParameters" = $true; 
        "PermittedGroups" = @(); 
        "SendTelemetry" = $true; 
        "Commands" = @(); 
        }

    $ExistingProperties = $cfg | Get-Member -MemberType NoteProperty | select -expand name
    foreach ($prop in $FullProperties.keys) {
        if ($ExistingProperties -inotcontains $prop) {
            write-verbose "Adding property $prop"
            $cfg | Add-Member -MemberType NoteProperty -Name $prop -Value $FullProperties[$prop]
        }
    }

    if ($retobj) {write-output $cfg}

}
