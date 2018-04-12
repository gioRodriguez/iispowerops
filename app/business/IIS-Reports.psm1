Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\..\repositories\IIS-Repository.psm1" -Force
Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\..\utils\Utils.psm1" -Force

function PerformIISBackup ($backupName) {
    if([string]::IsNullOrEmpty($backupName)){
        $backupName = "backup$(GetFormatDate)"
    }
    
    NewIISBackup $backupName
}

Export-ModuleMember -Function 'Perform*'