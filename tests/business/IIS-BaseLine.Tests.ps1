Import-Module "..\app\entities\Collection.psm1" -Force
Import-Module '..\app\business\IIS-BaseLine.psm1' -Force
Import-Module '..\app\entities\AppPool.psm1' -Force

InModuleScope 'IIS-BaseLine' {
    Describe 'IIS-BaseLine tests' {
        It 'must get the system base line info' {
            # Arrange
            $hotfixes = NewCollection
            $hotfixes.Add('hotfix1')
            $hotfixes.Add('hotfix2')
            $drivers = NewCollection
            $drivers.Add('driver1')
            $drivers.Add('driver2')
            $drivers.Add('driver3')
            $systemInfo = @{
                'HostName' = 'HostNameTest';
                'OSName' = 'OSNameTest';
                'OSVersion' = 'OSVersionTest';
                'Hotfix' = $hotfixes;
                'Drivers' = $drivers
            }
            $systemInfoObject = New-Object PSObject -Prop $systemInfo

            $appPool = @{
                Name = 'AppPoolNameTest';
                Recycling = @{
                    periodicRestart = @{
                        time = @{
                            TotalMinutes = 1740
                        }
                    }
                }
            }
            $appPoolObject = NewAppPool $appPool
            $appPoolObject2 = NewAppPool $appPool

            Mock GetSystemInfo {return $systemInfoObject}
            Mock GetAppPools {return @($appPoolObject; $appPoolObject2)}
            Mock GetIISVersion {return '5'}
            $netFxColl = NewCollection
            $netFxColl.Add(@{
                    'Name' = 'netFxTest';
                    'Version' = '7784';
                    'Release' = 'releaseTest'
                })
            Mock GetNetFxInfo {return $netFxColl}
            $components = NewCollection
            $components.Add(@{
                    'Name' = 'netFxTest';
                    'Version' = '7784';
                    'Release' = 'releaseTest'
                })
            Mock GetInstalledComponents {return $components}
            $services = NewCollection
            Mock GetServices {return $services}
            Mock SaveBaseLineAsCSV {}
            
            # Act
            PerformIISBaseLine            

            # Assert
            (GetBaseLineItemAt 0).Category | Should Be 'systemInfo'
            (GetBaseLineItemAt 0).Attribute | Should Be 'HostName'
            (GetBaseLineItemAt 0).Value | Should Be 'HostNameTest'
            (GetBaseLineItemAt 2).Category | Should Be 'systemInfo'
            (GetBaseLineItemAt 2).Attribute | Should Be 'OSVersion'
            (GetBaseLineItemAt 2).Value | Should Be 'OSVersionTest'
            (GetBaseLineItemAt 7).Category | Should Be 'systemInfo'
            (GetBaseLineItemAt 7).Attribute | Should Be 'HotfixesTotal'
            (GetBaseLineItemAt 7).Value | Should Be 2
            (GetBaseLineItemAt 8).Category | Should Be 'systemInfo'
            (GetBaseLineItemAt 8).Attribute | Should Be 'Hotfix'
            (GetBaseLineItemAt 8).Value | Should Be 'hotfix1'
            (GetBaseLineItemAt 9).Category | Should Be 'systemInfo'
            (GetBaseLineItemAt 9).Attribute | Should Be 'Hotfix'
            (GetBaseLineItemAt 9).Value | Should Be 'hotfix2'
            
            (GetBaseLineItemAt 10).Category | Should Be 'systemInfo'
            (GetBaseLineItemAt 10).Attribute | Should Be 'DriversTotal'
            (GetBaseLineItemAt 10).Value | Should Be '3'
            (GetBaseLineItemAt 11).Category | Should Be 'systemInfo'
            (GetBaseLineItemAt 11).Attribute | Should Be 'Driver'
            (GetBaseLineItemAt 11).Value | Should Be 'driver1'

            (GetBaseLineItemAt 14).Category | Should Be 'iisInfo'
            (GetBaseLineItemAt 14).Attribute | Should Be 'IISVersion'
            (GetBaseLineItemAt 14).Value | Should Be '5'
            (GetBaseLineItemAt 15).Attribute | Should Be 'AppPool'
            (GetBaseLineItemAt 15).Value | Should Be 'AppPoolNameTest'
            (GetBaseLineItemAt 17).Category | Should Be 'environmentInfo'
            (GetBaseLineItemAt 17).Attribute | Should Be 'NetFxTotalInstaled'
            (GetBaseLineItemAt 17).Value | Should Be 1
        }      
    }
}