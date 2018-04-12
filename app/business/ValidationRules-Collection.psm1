Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\..\entities\Validation-Error-Collection.psm1" -Force

$validationRules = New-Object System.Collections.ArrayList

function AddValidationRule ($validationRule) {
    $validationRules.Add($validationRule) > $null
}

function GetValidationRulesTotal {
    return $validationRules.Count
}

function CheckValidationRules ($object) {
    $validationRules | ForEach-Object {
        $error = & $_ $object
        AddError $error
    }
}

Export-ModuleMember -Function 'AddValidationRule'
Export-ModuleMember -Function 'GetValidationRulesTotal'
Export-ModuleMember -Function 'CheckValidationRules'
Export-ModuleMember -Function 'SaveErrorsAsCSV'