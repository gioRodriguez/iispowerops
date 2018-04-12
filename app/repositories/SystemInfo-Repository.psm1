Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\..\entities\Driver.psm1" -Force
Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\..\entities\Collection.psm1" -Force

Set-Variable HOST_NAME -option ReadOnly -value 1
Set-Variable OS_NAME -option ReadOnly -value 2
Set-Variable OS_VERSION -option ReadOnly -value 3
Set-Variable SYS_MANUFACTURER -option ReadOnly -value 12
Set-Variable SYS_TYPE -option ReadOnly -value 14
Set-Variable SYS_TIME_ZONE -option ReadOnly -value 23
Set-Variable SYS_MEMORY -option ReadOnly -value 24

function GetRawSystemInfo {
    return Systeminfo
}

function GetSystemInfo {
    $rawInfo = GetRawSystemInfo

    $systemInfo = @{            
        'HostName' = ExtractValue $rawInfo[$HOST_NAME];
        'OSName' = ExtractValue $rawInfo[$OS_NAME];
        'OSVersion' = ExtractValue $rawInfo[$OS_VERSION];
        'SystemManufacturer' = ExtractValue $rawInfo[$SYS_MANUFACTURER];
        'SystemType' = ExtractValue $rawInfo[$SYS_TYPE];
        'TimeZone' = ExtractValue $rawInfo[$SYS_TIME_ZONE];
        'Memory' = ExtractValue $rawInfo[$SYS_MEMORY];
        'Hotfix' = ExtractHotfixes;
        'Drivers' = ExtractDrivers
    }    
    $systemInfoObject = New-Object PSObject -Prop $systemInfo
    $systemInfoObject.PSObject.TypeNames.Insert(0,'Illyum.Operations.Entities.SystemInfo')    

    return $systemInfoObject
}

function ExtractValue ($rawValue) {
    return $rawValue.split(':')[1].trim()
}

function ExtractHotfixes {
    $hotfixes = NewCollection
    $hotfixesRaw = Get-HotFix
    $hotfixesRaw | ForEach-Object {
        $hotfixes.Add($_.HotFixID)
    }
    return $hotfixes
}

function ExtractDrivers {
    $drivers = NewCollection
    Get-WmiObject Win32_PnPSignedDriver | Select DeviceName, DriverVersion, DriverDate | ForEach-Object {
        $drivers.Add((NewDriver $_.DeviceName $_.DriverVersion $_.DriverDate)) > $null
    }
    
    return $drivers
}

Export-ModuleMember -Function 'Get*'