Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\IIS-OperationsTasks.psm1" -Force
Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\Get-IIS-BaseLine.psm1" -Force

CheckIIS

GetIISBaseLine

$nl = [Environment]::NewLine
Write-Output "$nl Done :)$nl"
Write-Output " Do not forget the files $nl    $env:computername-BaseLineInfo.csv $nl    $env:computername-Findings.csv$nl"