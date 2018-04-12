Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\..\entities\Collection.psm1" -Force

function GetNetFxInfo {
    $netFxs = NewCollection 
    Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -recurse |
    Get-ItemProperty -name Version, Release -EA 0 |  
    Where { $_.PSChildName -match '^(?!S)\p{L}'} | 
    Select PSChildName, Version, Release |
    ForEach-Object {
        $netFx = @{            
                'Name' = $_.PSChildName;
                'Version' = $_.Version;
                'Release' = $_.Release;
            }    
        $netFxObject = New-Object PSObject -Prop $netFx
        $netFxObject.PSObject.TypeNames.Insert(0,'Illyum.Operations.Entities.NetFxInfo')
        $netFxObject = $netFxObject | Add-Member ScriptMethod ToString {
            return "{`"name`": `"$($this.Name)`", `"version`": `"$($this.Version)`", `"release`": `"$($this.Release)`"}"
        } -PassThru -Force
        $netFxs.Add($netFxObject)
    }
    
    return $netFxs
}

function GetInstalledComponents {
    $installedComponents = NewCollection 
    Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | 
    Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |
    Where-Object { $_.DisplayName } | 
    Sort-Object DisplayName |
    ForEach-Object {        
        $installedComponent = @{
            'Name' = $_.DisplayName;
            'Version' = $_.DisplayVersion;
            'Publisher' = $_.Publisher;
            'InstallDate' = $_.InstallDate
        }

        $installedComponentObject = New-Object PSObject -Prop $installedComponent
        $installedComponentObject.PSObject.TypeNames.Insert(0,'Illyum.Operations.Entities.InstalledComponentInfo')
        $installedComponentObject = $installedComponentObject | Add-Member ScriptMethod ToString {
            return "{ `"name`": `"$($this.Name)`", `"version`": `"$($this.Version)`", `"publisher`": `"$($this.Publisher)`", `"installDate`": `"$($this.InstallDate)`"}"
        } -PassThru -Force
        $installedComponents.Add($installedComponentObject)
    }
    
    return $installedComponents 
}

function GetServices {
    $services = NewCollection
    Get-Service | ForEach-Object {
        $service = NewServiceObject $_.Name $_.DisplayName $_.ServiceName $_.Status $_.StartType
        $services.Add($service) > $null
    }

    Get-wmiobject Win32_Service | ForEach-Object {
        $service = NewServiceObject "Win32_$($_.Name)" $_.DisplayName $_.Caption $_.Status $_.StartMode
        $services.Add($service) > $null
    }
    
    return $services 
}

function NewServiceObject ($name, $displayName, $serviceName, $status, $startType){
    $service = @{
            'Name' = $name;
            'DisplayName' = $displayName;
            'ServiceName' = $serviceName;
            'Status' = $status;
            'StartType' = $startType
        }
    
    $serviceObject = New-Object PSObject -Prop $service
    $serviceObject.PSObject.TypeNames.Insert(0,'Illyum.Operations.Entities.ServiceInfo')
    $serviceObject = $serviceObject | Add-Member ScriptMethod ToString {
        return "{ `"name`": `"$($this.Name)`", `"displayName`": `"$($this.Version)`", `"serviceName`": `"$($this.ServiceName)`", `"status`": `"$($this.Status)`", `"startType`": `"$($this.StartType)`"}"
        } -PassThru -Force

    return $serviceObject
}