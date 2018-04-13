Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\repositories\IIS-Repository.psm1" -Force
Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\business\IIS-AppPool-ValidationRules.psm1" -Force
Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\business\IIS-Reports.psm1" -Force
Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\business\ValidationRules-Collection.psm1" -Force

function CheckIIS () {
    <#
    .SYNOPSIS
    Perform several IIS operative validation tasks on the current host in a single step
    .DESCRIPTION
    The CheckIIS performs the following validations
        - Recycling time not in default value
        - Idle timeout not in default value
        - Identity set in ApplicationPoolIdentity
        - At least one application in each application pool
        - No more than one application in each application pool
        - No aplications in debug mode
    .EXAMPLE
    CheckIIS
    .NOTES
    You need to run this function as an Administrator
    #>
    
    AddValidationRule CheckRecyclingTimeIntervalMustNotBeDefault
    AddValidationRule CheckIdleTimeoutMustNotBeDefault
    AddValidationRule CheckAppPoolIdentity
    AddValidationRule CheckAppPoolAtLeastOneApplicationPerPool
    AddValidationRule CheckAppPoolOnlyOneApplicationPerPool
    AddValidationRule CheckAppPoolHasApplicationsInDebug
    
    GetAppPools | ForEach-Object {
        CheckValidationRules $_
    }
    
    SaveErrorsAsCSV
}

Export-ModuleMember -Function 'Check*'