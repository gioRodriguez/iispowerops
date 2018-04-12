Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\..\entities\AppPool.psm1" -Force
Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\..\entities\Collection.psm1" -Force

Import-Module WebAdministration

function NewIISBackup ($backupName) {
    $appCmdCommand = $env:SystemDrive + "\Windows\System32\inetsrv\appcmd.exe"    
    & $appCmdCommand "add backup $backupName"
}

function GetIISVersion {
    $iisRawInfo = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\InetStp\'
    return $iisRawInfo.MajorVersion;
}

function GetAppPools {
    $iisAppPools = Get-ChildItem -Path 'IIS:\AppPools'
    $appPoolArray = New-Object System.Collections.ArrayList
    $iisAppPools | Foreach-Object {
        $applications = GetApplicationsByAppPoolName $_.Name
        $site = GetSiteByName $_.PSChildName
        $appPoolArray.Add((NewAppPool $_ $applications $site)) > $null
    }

    return $appPoolArray
}

function ExtractBindings ($bindings) {
    $bindingsArray = New-Object System.Collections.ArrayList
    $bindings | ForEach-Object {
        $bindingInfo = @{
            'Protocol' = $_.protocol;
            'BindingInformation' = $_.bindingInformation;
            'SslFlags' = $_.sslFlags
        }
        $bindingObject = New-Object PSObject -Prop $bindingInfo
        $bindingObject = $bindingObject | Add-Member ScriptMethod ToString {
            return "{ `"protocol`" : `"$($this.Protocol)`", `"bindingInformation`" : `"$($this.BindingInformation)`", `"sslFlags`" : `"$($this.SslFlags)`" }"
        } -PassThru -Force
        $bindingObject.PSObject.TypeNames.Insert(0,'Illyum.Operations.Entities.IIS.Binding')
        $bindingsArray.Add($bindingObject) > $null
    }
    return $bindingsArray
}

function GetSiteByName ($siteName) {
    $siteRaw = Get-WebSite $siteName
    $siteInfo = @{
        'Name' = $siteName;
        'PhysicalPath' = $siteRaw.physicalPath;
        'EnabledProtocols' = $siteRaw.EnabledProtocols;
    }
    
    $siteInfo.Bindings = ExtractBindings $siteRaw.Bindings.Collection
    $siteObject = New-Object PSObject -Prop $siteInfo
    $siteObject = $siteObject | Add-Member ScriptMethod ToString {
            return "{ `"name`" : `"$($this.Name)`", `"physicalPath`" : `"$($this.PhysicalPath)`", `"enabledProtocols`" : `"$($this.EnabledProtocols)`", `"bindings`" : [$($this.Bindings -join ",")] }"
        } -PassThru -Force
    $siteObject.PSObject.TypeNames.Insert(0,'Illyum.Operations.Entities.IIS.Site')
    return $siteObject
}

function CheckIfApplicationInDebug ($applicationPath) {
    if(-not $applicationPath){
        return $false
    }
    $configFile = "$applicationPath/web.config"
    if(-not(Test-Path -Path "$configFile")){
        Write-Warning "CheckIfApplicationInDebug: The specified config path does not exists $configFile"
        return $false
    }
    if(Select-Xml -Path "$configFile" -XPath '//configuration/system.web/compilation[@debug="true"]'){
        return $true
    }
    return $false
}

function GetApplicationsByAppPoolName ($appPoolName) {
    $applicationsArray = New-Object System.Collections.ArrayList
    $applicationsRaw = @(Get-WebConfigurationProperty "/system.applicationHost/sites/site/application[@applicationPool='$appPoolName']" "machine/webroot/apphost" -name path)    
    $applicationsRaw | ForEach-Object {
        $webapp = (Get-Webapplication $_.Value)
        $applicationInfo = @{
            'Name' = $_.Value;
            'PhysicalPath' = $webapp.PhysicalPath;
            'Protocols' = $webapp.enabledProtocols;
            'IsDebug' = (CheckIfApplicationInDebug $webapp.PhysicalPath)
        }        
        $appObject = New-Object PSObject -Prop $applicationInfo
        $appObject.PSObject.TypeNames.Insert(0,'Illyum.Operations.Entities.IIS.Application')
        $appObject = $appObject | Add-Member ScriptMethod ToString {
            return "{ `"name`" : `"$($this.Name)`", `"physicalPath`" : `"$($this.PhysicalPath)`", `"Protocols`" : `"$($this.Protocols)`", `"IsDebug`" : `"$($this.IsDebug)`" }"
        } -PassThru -Force
        $applicationsArray.Add($appObject) > $null
    } 

    return $applicationsArray
}

function NewRecyclingObject ($recyclingInfo) {
    $recycling = @{
        'PeriodicRestartTimeInminutes' = $recyclingInfo.periodicRestart.time.TotalMinutes
    }

    $recyclingObject = New-Object PSObject -Prop $recycling
    $recyclingObject.PSObject.TypeNames.Insert(0,'Illyum.Operations.Entities.IIS.AppPool.Recycling')

    return $recyclingObject
}

Export-ModuleMember -Function 'Get*'
Export-ModuleMember -Function 'New*'