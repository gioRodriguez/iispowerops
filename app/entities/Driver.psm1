function NewDriver ($deviceName, $driverVersion, $driverDate) {
    $driverInfo = @{
        'DeviceName' = $deviceName;
        'DriverVersion' = $driverVersion;
        'DriverDate' = $driverDate
    };
    $driverObject = New-Object PSObject -Prop $driverInfo
    $driverObject.PSObject.TypeNames.Insert(0,'Illyum.Operations.Entities.DriverInfo')
    $driverObject = $driverObject | Add-Member ScriptMethod ToString {
            return "{`"deviceName`" : `"$($this.DeviceName)`",`"driverVersion`" : `"$($this.DriverVersion)`",`"driverDate`" : `"$($this.DriverDate)`"}"
        } -PassThru -Force
    return $driverObject
}