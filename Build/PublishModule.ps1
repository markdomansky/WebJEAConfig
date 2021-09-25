$config = gc config.json | convertfrom-json
$ModuleRoot = resolve-path "$psscriptroot\..\Module"
$outpath = resolve-path "$psscriptroot\..\Release"
$srcdata = Import-LocalizedData -basedirectory $srcpath -FileName "webjeaconfig.psd1"
$ver = $srcdata.ModuleVersion
$name = 'WebJEAConfig'
if ($env:psmodulepath -notlike "*$outpath*" ) {$env:PSModulePath = $env:PSModulePath + ";$outpath"}
$targetpath = "$outpath\$name\$ver"

if ((test-path $targetpath)) {remove-item $targetpath -recurse -force}

new-item $targetpath -ItemType Directory
robocopy /mir $srcpath $targetpath

#publish-module -name $name -nugetapikey $apikey -repository PSGallery
#-path "C:\Dropbox\Scripts\VB.NET\WebJEA\WebJEAConfig\Module"
#
publish-module -path $targetpath -NuGetApiKey $config.psgalleryapikey -Verbose -Repository PSGallery
