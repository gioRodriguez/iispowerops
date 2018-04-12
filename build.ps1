param(
    $renameFiles = $true
)

#$cert = @(Get-ChildItem cert:\CurrentUser\My -codesigning)[0]

function SignScript ($file) {
     Set-AuthenticodeSignature $file $cert > $null
}

Del -Path '.\output' -Recurse -ErrorAction SilentlyContinue
New-Item -ItemType 'directory' -Path '.\output'

Copy-Item 'app\*' '.\output' -Container -Recurse

$moduleVersion = "1.$(Get-Date -UFormat '%d%m%Y')"

$modules = Get-ChildItem -Path '.\output\*.psm1' -Recurse
$modules.ForEach({
    $moduleName = (Split-Path -Leaf $_).split('\.')[-2]
    $modulePath = Split-Path -Parent $_
    $moduleFile = "$($modulePath)\$($moduleName).psd1"
    New-ModuleManifest $moduleFile -ModuleVersion $moduleVersion -Author 'Gio' -CompanyName 'Illyum' -RootModule "$($moduleName).psm1"
    #SignScript $moduleFile
    #SignScript $_
})