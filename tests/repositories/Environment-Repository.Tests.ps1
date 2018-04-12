Import-Module '..\app\repositories\Environment-Repository.psm1' -Force

InModuleScope 'Environment-Repository' {
    Describe "Environment repositoy Tests" {
        It 'must get the .netfx info' {
            # Arrange
            Mock Get-ChildItem {return @(
                New-Object PSObject -Prop @{
                    'PSChildName' = 'v2.0.50727Test';
                    'Version' = '456';
                    'Release' = 'resda78'
                };
                New-Object PSObject -Prop @{
                    'PSChildName' = 'v2.0.50727Test';
                    'Version' = '456';
                    'Release' = 'resda78'
                }
            )}
            Mock Get-ItemProperty {return @(
                New-Object PSObject -Prop @{
                    'PSChildName' = 'v2.0.50727Test';
                    'Version' = '456';
                    'Release' = 'resda78'
                };
                New-Object PSObject -Prop @{
                    'PSChildName' = 'v2.0.50727Test';
                    'Version' = '456';
                    'Release' = 'resda78'
                }
            )}

            # Act
            $actual = GetNetFxInfo 

            # Assert
            $actual.Total() | Should Be 4
            $actual.List[0].Name | Should Be 'v2.0.50727Test'
            $actual.List[0].Version | Should Be '456'
            $actual.List[0].Release | Should Be 'resda78'
        }

        It 'must get the installed components' {
            # Arrange            
            Mock Get-ItemProperty {return @(
                New-Object PSObject -Prop @{
                   'DisplayName' = 'comp1';
                   'DisplayVersion' = 'compVer1';
                   'Publisher' = 'compPublisher1';
                   'InstallDate' = '7/5/2016';
                };
                New-Object PSObject -Prop @{
                   'DisplayName' = 'comp2';
                   'DisplayVersion' = 'compVer2';
                   'Publisher' = 'compPublisher2';
                   'InstallDate' = '7/5/2016';
                };
                New-Object PSObject -Prop @{
                   'DisplayName' = 'comp3';
                   'DisplayVersion' = 'compVer3';
                   'Publisher' = 'compPublisher3';
                   'InstallDate' = '7/5/2016';
                };
                New-Object PSObject -Prop @{
                   'DisplayName' = '';
                   'DisplayVersion' = '';
                   'Publisher' = '';
                   'InstallDate' = '';
                }
            )}

            # Act
            $actual = GetInstalledComponents

            # Assert
            $actual.Total() | Should Be 3            
            $actual.List[0].Name | Should Be 'comp1'
        }

        It 'must get the services' {
            # Arrange
            Mock Get-Service {return @(
                New-Object PSObject -Prop @{
                   'Name' = 'servName'
                   'DisplayName' = 'servDispName';
                   'ServiceName' = 'servName';
                   'Status' = 'Stopped';
                   'StartType' = 'Manual';
                };
                New-Object PSObject -Prop @{
                   'Name' = 'servName2'
                   'DisplayName' = 'servDispName2';
                   'ServiceName' = 'servName2';
                   'Status' = 'Stopped2';
                   'StartType' = 'Manual2';
                };
            )}

            Mock Get-wmiobject {return @(
                New-Object PSObject -Prop @{
                   'Name' = 'servName3'
                   'DisplayName' = 'servDispName3';
                   'ServiceName' = 'servName3';
                   'Status' = 'Stopped3';
                   'StartType' = 'Manual3';
                };
                New-Object PSObject -Prop @{
                   'Name' = 'servName4'
                   'DisplayName' = 'servDispName4';
                   'ServiceName' = 'servName4';
                   'Status' = 'Stopped4';
                   'StartType' = 'Manual4';
                };
            )}

            # Act
            $actual = GetServices

            # Assert
            $actual.Total() | Should Be 4     
            $actual.List[0].Name | Should Be 'servName'
            $actual.List[3].Name | Should Be 'Win32_servName4'
        }
    }
}