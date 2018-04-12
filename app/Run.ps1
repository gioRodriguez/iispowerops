Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\IIS-OperationsTasks.psm1" -Force
Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\Get-IIS-BaseLine.psm1" -Force

CheckIIS

GetIISBaseLine

$nl = [Environment]::NewLine
Write-Output "$nl Listo, muchas gracias por ejecutar los scripts :)$nl"
Write-Output " Por favor no olvide los archivos $nl    $env:computername-BaseLineInfo.csv $nl    $env:computername-Findings.csv$nl"