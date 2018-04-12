Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\utils\Utils.psm1" -Force
Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\business\IIS-BaseLine.psm1" -Force

function GetIISBaseLine {
    PerformIISBaseLine
    <#
    #list installed modules
    $WINDOWS_8_R2_MAJOR_VERSION = 6
    $windowsMajorVersion = [System.Environment]::OSVersion.Version.Major
    If ($windowsMajorVersion -eq $WINDOWS_8_R2_MAJOR_VERSION) {
        C:\Windows\System32\ServerManagerCmd.exe -q > installedModulesInfo.txt
    } Else {
        Get-WindowsFeature > installedModulesInfo.txt
    }

    # mode to inetsrv to run appcmd commands
    cd $env:systemroot\system32\inetsrv\

    # get modules
    .\appcmd.exe list module > iisModules.txt
    MV iisModules.txt $workingFolderPath

    # get iis config
    $env:systemroot\system32\inetsrv\appcmd.exe list config > iisConfig.txt
    MV iisConfig.txt $workingFolderPath#>
}

Export-ModuleMember -Function 'Get*'
Export-ModuleMember -Function 'Add*'