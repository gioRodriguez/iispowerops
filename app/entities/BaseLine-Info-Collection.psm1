$baseLineInfoItems = New-Object System.Collections.ArrayList

function AddBaseLineInfoItem ($baseLineInfoItem) {
    $baseLineInfoItems.Add($baseLineInfoItem) > $null
}

function GetTotalBaseLineItems {
    return $baseLineInfoItems.Count
}

function GetBaseLineItemAt ($idx) {
    return $baseLineInfoItems[$idx]
}

function SaveBaseLineAsCSV {
    $baseLineInfoItems | Select-Object -Property Server,Category,Attribute,Value,Description | Export-Csv -Path "$($env:computername)_IIS-BaseLineInfo.csv"
}

Export-ModuleMember -Function 'AddBaseLineInfoItem'
Export-ModuleMember -Function 'SaveBaseLineAsCSV'
Export-ModuleMember -Function 'Get*'