function GetFormatDate ($dateToFormat = (Get-Date)) {
    return Get-Date -Date $dateToFormat -UFormat '_%Y-%m-%d'
}

Export-ModuleMember -Function 'Get*'
