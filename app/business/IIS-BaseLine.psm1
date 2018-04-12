Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\..\repositories\IIS-Repository.psm1" -Force
Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\..\repositories\SystemInfo-Repository.psm1" -Force
Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\..\repositories\Environment-Repository.psm1" -Force
Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\..\entities\BaseLine-Info-Collection.psm1" -Force
Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\..\entities\BaseLine-Info-Item.psm1" -Force

function PerformIISBaseLine {
    $systemInfo = GetSystemInfo
    ExtractSystemProperties $systemInfo
    ExtractHotfixProperties $systemInfo.Hotfix
    ExtractDriversProperties $systemInfo.Drivers    
    ExtractIISVersion
    ExtractIISAppPoolInfo
    ExtractNetFxInfo
    ExtractInstalledComponents    
    ExtractServicesInfo 

    SaveBaseLineAsCSV
}

function ExtractSystemProperties ($systemInfo) {
    $propToSearch = @(
        'HostName';
        'OSName';
        'OSVersion';
        'SystemManufacturer';
        'SystemType';
        'TimeZone';
        'Memory';
    )
    $propToSearch | ForEach-Object {
        AddBaseLineInfoItem (NewBaseLineInfoItem -Category 'systemInfo' -Attribute $_ -Value $systemInfo.($_))
    }
}

function ExtractHotfixProperties ($hotfixInfo) {
    AddBaseLineInfoItem (NewBaseLineInfoItem -Category 'systemInfo' -Attribute 'HotfixesTotal' -Value $hotfixInfo.Total())
    $hotfixInfo.List | ForEach-Object {
        AddBaseLineInfoItem (NewBaseLineInfoItem -Category 'systemInfo' -Attribute 'Hotfix' -Value $_)
    }
}

function ExtractDriversProperties ($drivers) {
    AddBaseLineInfoItem (NewBaseLineInfoItem -Category 'systemInfo' -Attribute 'DriversTotal' -Value $drivers.Total())
    $drivers.List | ForEach-Object {
        AddBaseLineInfoItem (NewBaseLineInfoItem -Category 'systemInfo' -Attribute 'Driver' -Value $_)
    }
}

function ExtractIISVersion {
    AddBaseLineInfoItem (NewBaseLineInfoItem -Category 'iisInfo' -Attribute 'IISVersion' -Value (GetIISVersion))
}

function ExtractIISAppPoolInfo {
    GetAppPools | ForEach-Object {
        AddBaseLineInfoItem (NewBaseLineInfoItem -Category 'iisInfo' -Attribute 'AppPool' -Value $_.Name -Description $_)
    }
}

function ExtractNetFxInfo {
    $netFxInfo = GetNetFxInfo
    AddBaseLineInfoItem (NewBaseLineInfoItem -Category 'environmentInfo' -Attribute 'NetFxTotalInstaled' -Value $netFxInfo.Total())
    $netFxInfo.List | ForEach-Object {
        AddBaseLineInfoItem (NewBaseLineInfoItem -Category 'environmentInfo' -Attribute 'NetFx' -Value $_.Name -Description $_.ToString())
    }
}

function ExtractInstalledComponents {
    $installedComponentsInfo = GetInstalledComponents
    AddBaseLineInfoItem (NewBaseLineInfoItem -Category 'environmentInfo' -Attribute 'TotalInstalledComponent' -Value $installedComponentsInfo.Total())
    $installedComponentsInfo.List | ForEach-Object {
        AddBaseLineInfoItem (NewBaseLineInfoItem -Category 'environmentInfo' -Attribute 'InstalledComponent' -Value $_.Name -Description $_.ToString())
    }
}

function ExtractServicesInfo {
    $servicesInfo = GetServices
    AddBaseLineInfoItem (NewBaseLineInfoItem -Category 'environmentInfo' -Attribute 'TotalServices' -Value $servicesInfo.Total())
    $servicesInfo.List | ForEach-Object {
        AddBaseLineInfoItem (NewBaseLineInfoItem -Category 'environmentInfo' -Attribute 'Service' -Value $_.Name -Description $_.ToString())
    }
}

Export-ModuleMember -Function 'GetBaseLineItemAt'
Export-ModuleMember -Function 'Perform*'