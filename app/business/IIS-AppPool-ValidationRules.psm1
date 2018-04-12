Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\..\entities\Validation-Error.psm1" -Force

function CheckRecyclingTimeIntervalMustNotBeDefault ($appPool) {    
    if($appPool.HasPeriodicRestartTimeInDefault()){
        $message = "The application pool '$($appPool.Name)' has the default periodic restart time $($appPool.recycling.PeriodicRestartTimeInminutes) minutes"
        return NewIISValidationError 'CheckRecyclingTimeIntervalMustNotBeDefault' $message
    }
    return GetOkValidation
}

function CheckIdleTimeoutMustNotBeDefault ($appPool) {    
    if($appPool.HasDefaultIdleTimeout()){
        $message = "The application pool '$($appPool.Name)' has the default idle timeout $($appPool.idleTimeoutInminutes) minutes"
        return NewIISValidationError 'CheckIdleTimeoutMustNotBeDefault' $message
    }
    return GetOkValidation
}

function CheckAppPoolIdentity ($appPool) {
    if($appPool.HasAppPoolIdentity()){
        return GetOkValidation    
    }
    $message = "The application pool '$($appPool.Name)' has identity '$($appPool.identity)'"
    return NewIISValidationWarning 'CheckAppPoolIdentity' $message
    
}

function CheckAppPoolOnlyOneApplicationPerPool ($appPool) {
    if($appPool.HasMoreThatOneApplication()){
        $message = "The application pool '$($appPool.Name)' has more than one application $($appPool.applications)"
        return NewIISValidationError 'CheckAppPoolOnlyOneApplicationPerPool' $message
    }
    return GetOkValidation
}

function CheckAppPoolAtLeastOneApplicationPerPool ($appPool) {
    if($appPool.HasApplications()){
        $message = "The application pool '$($appPool.Name)' has not applications"
        return NewIISValidationError 'CheckAppPoolAtLeastOneApplicationPerPool' $message
    }
    return GetOkValidation
}

function CheckAppPoolHasApplicationsInDebug ($appPool) {    
    if($appPool.HasApplicationsInDebug()){
        $message = "The application pool '$($appPool.Name)' has the following application(s) in debug mode $($appPool.AppsInDebug)"
        return NewIISValidationError 'CheckAppPoolHasApplicationsInDebug' $message
    }
    return GetOkValidation
}

Export-ModuleMember -Function 'Check*'