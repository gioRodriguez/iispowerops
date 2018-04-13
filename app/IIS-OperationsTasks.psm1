Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\repositories\IIS-Repository.psm1" -Force
Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\business\IIS-AppPool-ValidationRules.psm1" -Force
Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\business\IIS-Reports.psm1" -Force
Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\business\ValidationRules-Collection.psm1" -Force

function CheckIIS () {
    <#
    .SYNOPSIS
    Perform several operative validation tasks on the current host
    .DESCRIPTION
    The CheckIIS performs the following validations
        - Checks that the appPools does not have the default value for recycling time
        - Checks that the appPools does not have the default value for idle time
        - Checks the appPools identity
        - Checks that the appPools does have at least one application
        - Checks that the appPools does not have at more than one application
        - Checks if some app pool has aplications in debug mode
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