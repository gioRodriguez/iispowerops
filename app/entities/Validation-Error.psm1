$okResult = @{
        'HasError' = $false
    }

$okResultObject = New-Object PSObject -Prop $okResult
$okResultObject.PSObject.TypeNames.Insert(0,'Illyum.Operations.Entities.Validation.OkResult')

function NewFailedResultObject ($cause, $message) {
    $failedResult = @{
        'HasError' = $true;
        'Message' = $message;
        'Cause' =  $cause;
        'Level' = 'Error';
        'Category' = ''        
    }

    $failedResultObject = New-Object PSObject -Prop $failedResult
    $failedResultObject.PSObject.TypeNames.Insert(0,'Illyum.Operations.Entities.Validation.FailedResult')

    return $failedResultObject
}

function GetOkValidation ($cause, $message) {
    return $okResultObject
}

function NewIISValidationError ($cause, $message) {
    $failedResult = NewFailedResultObject $cause $message
    $failedResult.Category = 'IIS'
    
    return $failedResult
}

function NewIISValidationInfo ($cause, $message) {
    $failedResult = NewFailedResultObject $cause $message
    $failedResult.Level = 'Info'
    $failedResult.Category = 'IIS'
    
    return $failedResult
}

function NewIISValidationWarning ($cause, $message) {
    $failedResult = NewFailedResultObject $cause $message
    $failedResult.Level = 'Warning'
    $failedResult.Category = 'IIS'
    
    return $failedResult
}

Export-ModuleMember -Function 'GetOkValidation'
Export-ModuleMember -Function 'NewIIS*'