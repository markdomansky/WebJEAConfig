function New-WJCommandObject($cmd = $null) {
    $retobj = $false
    if ($cmd -eq $null) {
        $cmd = (new-object pscustomobject)
        $retobj = $true
    }

    $FullProperties = @{
        "Id"=(new-guid).ToString();
        "DisplayName"="Command-$(get-random)";
        #"Synopsis"=$null;
        #"Description"=$null;
        "OnloadScript"=$null;
        "Script"=$null;
        #"LogParameters"=$true; #don't always add it, this would mess up inheritence from config.
        #"ParseScript"=$true;
        #"Parameters"=@();
        "PermittedGroups"=@();
    }
    $ExistingProperties = $cmd | Get-Member -MemberType NoteProperty | select-object -expand name
    foreach ($prop in $FullProperties.keys) {
        if ($ExistingProperties -inotcontains $prop) {
            write-verbose "Adding property $prop"
            $cmd | Add-Member -MemberType NoteProperty -Name $prop -Value $FullProperties[$prop]
        }
    }

    if ($retobj) {write-output $cmd}

}
