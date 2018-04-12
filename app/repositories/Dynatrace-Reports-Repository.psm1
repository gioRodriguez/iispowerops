Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\..\utils\Utils.psm1" -Force

function GetHomeBrokerReport {
    Invoke-RestMethod 'http://172.18.66.5:8020/rest/management/reports/create/HB%20-%20Monitoreo%20TI?type=PDF' `
    -Headers @{ `
        'Authorization' = 'basic c2NyZWVudXNlcjpzY3JlZW51c2Vy' `
    } `
    -OutFile ("HomeBroker$(GetFormatDate).pdf")
}


Export-ModuleMember -Function 'Get*'