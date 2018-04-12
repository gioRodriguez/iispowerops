param(
    $renameFiles = $true
)

$cert = @(Get-ChildItem cert:\CurrentUser\My -codesigning)[0]

function SignScript ($file) {
     Set-AuthenticodeSignature $file $cert > $null
}

Del -Path '.\output' -Recurse -ErrorAction SilentlyContinue
New-Item -ItemType 'directory' -Path '.\output'

Del -Path 'C:\gbm\shared_scripts' -Recurse -ErrorAction SilentlyContinue
New-Item -ItemType 'directory' -Path 'C:\gbm\shared_scripts'

Copy-Item 'app\*' '.\output' -Container -Recurse
Copy-Item '.\restore-file-names-extensions.ps1' '.\output'
Copy-Item '.\Instrucciones.txt' '.\output'

$moduleVersion = "1.$(Get-Date -UFormat '%d%m%Y')"

$modules = Get-ChildItem -Path '.\output\*.psm1' -Recurse
$modules.ForEach({
    $moduleName = (Split-Path -Leaf $_).split('\.')[-2]
    $modulePath = Split-Path -Parent $_
    $moduleFile = "$($modulePath)\$($moduleName).psd1"
    New-ModuleManifest $moduleFile -ModuleVersion $moduleVersion -Author 'Gio' -CompanyName 'Illyum' -RootModule "$($moduleName).psm1"
    SignScript $moduleFile
    SignScript $_
})

Copy-Item '.\output\*' 'C:\gbm\shared_scripts' -Container -Recurse -Force

#rename files to be able to be sent as attachements
if($renameFiles){
    $files = Get-ChildItem -Path 'C:\gbm\shared_scripts\*.*' -Recurse
    $files.ForEach({
        Rename-Item $_ ($_ -replace '.psm1', '.renamteExtensionTo_psm1') -ErrorAction SilentlyContinue
        Rename-Item $_ ($_ -replace '.ps1', '.renamteExtensionTo_ps1') -ErrorAction SilentlyContinue
        Rename-Item $_ ($_ -replace '.psd1', '.renamteExtensionTo_psd1') -ErrorAction SilentlyContinue
    })
}