function NewAppPool ($appPoolRaw, $applications, $site) {
    $appsInDebug = New-Object System.Collections.ArrayList
    $applications | Where-Object {$_.IsDebug -eq $true} | ForEach-Object {
        $appsInDebug.Add("'$($_.Name)' ") > $null
    }
    $appPoolInfo = @{            
        'Name' = $appPoolRaw.Name;
        'Enable32BitAppOnWin64' = $appPoolRaw.enable32BitAppOnWin64;
        'State' = $appPoolRaw.State;
        'Recycling' = NewRecyclingObject $appPoolRaw.Recycling;
        'IdleTimeoutInminutes' = $appPoolRaw.processModel.idleTimeout.TotalMinutes;
        'Identity' = $appPoolRaw.processModel.identityType;
        'Applications' = $applications;
        'AppsInDebug' = $appsInDebug;
        'Site' = $site
    }    
    $appPoolObject = New-Object PSObject -Prop $appPoolInfo
    $appPoolObject.PSObject.TypeNames.Insert(0,'Illyum.Operations.Entities.IIS.AppPool')
    $appPoolObject = $appPoolObject | Add-Member ScriptMethod HasPeriodicRestartTimeInDefault {return $this.Recycling.PeriodicRestartTimeInminutes -eq 1740} -PassThru
    $appPoolObject = $appPoolObject | Add-Member ScriptMethod HasDefaultIdleTimeout {return $this.idleTimeoutInminutes -eq 20} -PassThru
    $appPoolObject = $appPoolObject | Add-Member ScriptMethod HasAppPoolIdentity {return $this.identity -eq 'ApplicationPoolIdentity'} -PassThru    
    $appPoolObject = $appPoolObject | Add-Member ScriptMethod HasApplications {return $this.applications.Count -eq 0 } -PassThru
    $appPoolObject = $appPoolObject | Add-Member ScriptMethod HasMoreThatOneApplication {return $this.applications.Count -gt 1 } -PassThru
    $appPoolObject = $appPoolObject | Add-Member ScriptMethod HasApplicationsInDebug {return $this.appsInDebug.Count -gt 0 } -PassThru
    $appPoolObject = $appPoolObject | Add-Member ScriptMethod ToString {
        return ("{ `"name`": `"$($this.Name)`", `"enable32BitAppOnWin64`": `"$($this.Enable32BitAppOnWin64)`", `"state`": `"$($this.State)`", `"recycling`": { `"periodicRestartTimeInminutes`": $($this.Recycling.PeriodicRestartTimeInminutes) }, `"idleTimeoutInminutes`": $($this.idleTimeoutInminutes), `"identity`": `"$($this.identity)`", `"site`" : $($this.site), `"applications`": [$($this.applications -join ",")] }")
    } -PassThru -Force
    return $appPoolObject;
}

function NewRecyclingObject ($recyclingInfo) {
    $recycling = @{
        'PeriodicRestartTimeInminutes' = $recyclingInfo.periodicRestart.time.TotalMinutes
    }

    $recyclingObject = New-Object PSObject -Prop $recycling
    $recyclingObject.PSObject.TypeNames.Insert(0,'Illyum.Operations.Entities.IIS.AppPool.Recycling')

    return $recyclingObject
}

Export-ModuleMember -Function 'NewAppPool'