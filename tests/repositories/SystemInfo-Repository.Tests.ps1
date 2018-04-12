Import-Module '..\app\repositories\SystemInfo-Repository.psm1' -Force

InModuleScope 'SystemInfo-Repository' {
    Describe 'IIS repositoy Tests' {
        It 'must get the system info' {
            # Arrange            
            $sysinfo = @(1..100)
            $sysinfo[1] = 'Host Name:                 Gio PC Test';
            $sysinfo[2] = 'OS Name:                   Microsoft Test';
            $sysinfo[3] = 'OS Version:                00.1 Test';
            $sysinfo[12] = 'System Manufacturer:       Dell Test';
            $sysinfo[14] = 'System Type:               x64-based Test';
            $sysinfo[23] = 'Time Zone:                 Guadalajara Test';
            $sysinfo[24] = 'Total Physical Memory:     16,272 MB Test';
            $sysinfo[32] = 'Logon Server:              \\TEST';
            $sysinfo[33] = 'Hotfix(s):                 3 Hotfix(s) Installed.';            
            $sysinfo[34] = '                           [01]: KB3139907';
            $sysinfo[35] = '                           [02]: KB3140741';
            $sysinfo[36] = '                           [03]: KB3140768';
            $sysinfo[37] = 'Network Card(s):           4 NIC(s) Installed.';

            Mock GetRawSystemInfo {return $sysinfo}
            Mock Get-HotFix {return @(
                @{
                    HotFixID = 'KB3139907'
                };
                @{
                    HotFixID = 'KB3140741'
                };
                @{
                    HotFixID = 'KB3140768'
                }
            )}

            # Act
            $actual = GetSystemInfo

            # Assert
            $actual.HostName | Should Be 'Gio PC Test'
            $actual.OSName | Should Be 'Microsoft Test'
            $actual.OSVersion | Should Be '00.1 Test'
            $actual.SystemManufacturer | Should Be 'Dell Test'
            $actual.SystemType | Should Be 'x64-based Test'
            $actual.TimeZone | Should Be 'Guadalajara Test'
            $actual.Memory | Should Be '16,272 MB Test'
            $actual.Hotfix.Total() | Should Be 3
            $actual.Hotfix.List[0] | Should Be 'KB3139907'
            $actual.Hotfix.List[1] | Should Be 'KB3140741'
            $actual.Hotfix.List[2] | Should Be 'KB3140768'
        }
    }
}