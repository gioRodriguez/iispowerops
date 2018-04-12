$errors = New-Object System.Collections.ArrayList

function AddError ($error) {
    $errors.Add($error) > $null
}

function GetTotalErrors {
    return $errors.Count
}

function GetErrors {
    return $errors | Where-Object {$_.HasError}
}

function SaveErrorsAsCSV {
    GetErrors | Select-Object -Property '*' -ExcludeProperty 'HasError' | Export-Csv -Path "$($env:computername)_IIS-Findings.csv"
}

Export-ModuleMember -Function 'AddError'
Export-ModuleMember -Function 'SaveErrorsAsCSV'
Export-ModuleMember -Function 'Get*'