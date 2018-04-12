Import-Module '..\app\repositories\IIS-Repository.psm1' -Force

InModuleScope 'IIS-Repository' {
    Describe "IIS repositoy Tests" {

        It 'must get the iis versions' {
            # Arrange
            Mock Get-ItemProperty { return @{ MajorVersion = '20' } }

            # Act
            $actual = GetIISVersion

            # Assert
            $actual | Should Be '20'
        }

        It 'must get the iis app pools' {
            # Arrange
            Mock Get-ChildItem { return @(
                @{
                    Name = 'AppPoolName';
                    State = 'Started';
                    Recycling = @{
                        periodicRestart = @{
                            time = @{
                                TotalMinutes = 1720
                            }
                        }
                    };
                    ProcessModel = @{
                        identityType = 'ApplicationPoolIdentity';
                        idleTimeout = @{
                            TotalMinutes = 20
                        }
                    };
                    PSChildName = 'SiteNameTest'
                }, 
                @{
                    Name = "AppPoolName2";
                    PSChildName = 'SiteNameTest'
                })} `
                -ParameterFilter { $Path -eq 'IIS:\AppPools' }
            
            Mock Get-WebSite { return @(
                @{
                    Name = 'SiteNameTest';
                    physicalPath = 'physicalPathTest';
                    EnabledProtocols = 'http,net.tcp';
                    bindings = @{
                        Collection = @(
                            @{
                                protocol = 'http';
                                bindingInformation = '*:80:';
                                sslFlags = '0'
                            }
                        )
                    }
                })}
            
            Mock Get-WebConfigurationProperty {return @(
                @{
                    'Value' = '/app';
                },
                @{
                    'Value' = '/';
                }
            )}

            Mock Get-Webapplication {return @(
                @{
                    'Name' = '/app';
                    'PhysicalPath' = 'c:/app';
                    'enabledProtocols' = 'http,net.tcp';
                }
            )}

            Mock Select-Xml {return "true"}
            Mock Test-Path {return $true}
            
            # Act
            $actual = GetAppPools

            # Assert
            $actual | Should Not BeNullOrEmpty
            $actual[0].Name | Should Be 'AppPoolName'
            $actual[0].State | Should Be 'Started' 
            $actual[0].Recycling.PeriodicRestartTimeInminutes | Should Be 1720
            $actual[0].idleTimeoutInminutes | Should Be 20
            $actual[0].identity | Should Be 'ApplicationPoolIdentity'
            $actual[0].applications.Count | Should Be 2
            $actual[0].applications[0].name | Should Be '/app'
            $actual[0].applications[0].physicalPath | Should Be 'c:/app'
            $actual[0].applications[0].protocols | Should Be 'http,net.tcp'
            $actual[0].applications[0].isDebug | Should Be $true
            $actual[0].Site.Name | Should Be 'SiteNameTest'
            $actual[0].Site.EnabledProtocols | Should Be 'http,net.tcp'
            $actual[0].Site.Bindings[0].Protocol | Should Be 'http'
            $actual[0].Site.Bindings[0].bindingInformation | Should Be '*:80:'
            $actual[0].Site.Bindings[0].sslFlags | Should Be '0'

            $actual[1].Name | Should Be 'AppPoolName2'
        }    
    }
}
